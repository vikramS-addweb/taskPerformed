import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class CountController extends StateNotifier<AsyncValue<int>> {
  CountController(): super(const AsyncValue.loading()) {
    up();
  }

  Future<void> up() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<int>(() async {
      final current = state.value ?? 0;
      return current + 1;
    });
  }
}


final countProvider = StateNotifierProvider.autoDispose<CountController, AsyncValue<int>>((ref) {
  return CountController();
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer(
          builder: (context, ref, _) {
            AsyncValue<int> count = ref.watch(countProvider);
            // final count = ref.watch(countProvider);

            return Text(
              'Count: $count',
              style: Theme.of(context).textTheme.headline4,
            );
          },
        ),
        // Text(
        //   'Count: $count',
        //   style: Theme.of(context).textTheme.headline4,
        // ),
        ElevatedButton(
          onPressed: () => ref.watch(countProvider.notifier).up(),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
          child: const Text('up'),
        )
      ],
    );
  }
}
