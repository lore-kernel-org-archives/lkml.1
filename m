Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZIKTaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZIKTaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZIKTay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:30:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbZIKTap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:30:45 -0400
Date: Fri, 11 Sep 2009 21:30:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: [GIT PULL] tracing/core for v2.6.32
Message-ID: <20090911193013.GA22994@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the tracing-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-core-for-linus

Highlights:

 - Lockless ring-buffer
 - Syscall tracepoints enhancements
 - Filter engine updates

 Thanks,

	Ingo

------------------>
Albin Tonnerre (1):
      tracing: Remove mentioning of legacy latency_trace file from documentation

Anirban Sinha (1):
      tracing: Eliminate code duplication in kernel/tracepoint.c

Frederic Weisbecker (13):
      tracing/function-graph-tracer: Use the %pf format
      tracing/kmemtrace: Use the %pf format
      tracing/function-graph-tracer: Drop the useless nmi protection
      tracing/core: Turn ftrace_cpu_disabled into a global var
      tracing/core: Make the stack entry helpers global
      tracing: Move sched event insertion helpers in the sched switch tracer file
      tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
      tracing/events: Only define remove_subsystem_dir() if CONFIG_MODULES
      tracing: Add ftrace event call parameter to its field descriptor handler
      tracing: Add fields format definition for syscall events
      tracing: Support for syscall events raw records in perfcounters
      tracing: Undef TRACE_EVENT_FN between trace events headers inclusion
      tracing: Fix double CPP substitution in TRACE_EVENT_FN

Hendrik Brueckner (3):
      tracing: Add syscall tracepoints - s390 arch update
      tracing: Check invalid syscall nr while tracing syscalls
      tracing: Don't trace kernel thread syscalls

Ingo Molnar (2):
      tracing: Fix syscall tracing on !HAVE_FTRACE_SYSCALLS architectures
      [S390] ftrace: update system call tracer support

Jason Baron (16):
      tracing: Map syscall name to number
      tracing: Call arch_init_ftrace_syscalls at boot
      tracing: Add DECLARE_TRACE_WITH_CALLBACK() macro
      tracing: Add syscall tracepoints
      tracing: Update FTRACE_SYSCALL_MAX
      tracing: Raw_init() bailout in trace event register fail case
      tracing: Add ftrace_event_call void * 'data' field
      tracing: Add trace events for each syscall entry/exit
      tracing: Add individual syscalls tracepoint id support
      tracing: Add perf counter support for syscalls tracing
      tracing: Add more namespace area to 'perf list' output
      tracing: Convert x86_64 mmap and uname to use DEFINE_SYSCALL
      tracing: Define NR_syscalls for x86 (32)
      tracing: Define NR_syscalls for x86_64
      tracing: Convert event tracing code to use NR_syscalls
      tracing: Remove FTRACE_SYSCALL_MAX definitions

Josh Stone (4):
      tracing: Rename FTRACE_SYSCALLS for tracepoints
      tracing: Make syscall tracepoints conditional
      tracing: Move tracepoint callbacks from declaration to definition
      tracing: Create generic syscall TRACE_EVENTs

Josh Triplett (1):
      tracing: Add vim script to enable folding for function_graph traces

Lai Jiangshan (5):
      tracing/stat: Add stat_release() callback
      tracing/workqueues: Add refcnt to struct cpu_workqueue_stats
      ring_buffer: Fix warning while ignoring cmpxchg return value
      tracing/events: add missing type info of dynamic arrays
      tracing: Simplify print_graph_cpu()

Li Zefan (21):
      tracing/events: Add trace_event boot option
      kmemtrace: Print binary output only if 'bin' option is set
      kmemtrace: Rename some functions
      tracing/events: record the size of dynamic arrays
      tracing/filters: improve subsystem filter
      tracing/events: Add module tracepoints
      tracing/syscalls: Fix to print parameter types
      trace_stat: Fix missing entry in stat file
      trace_stack: Simplify seqfile code
      ftrace: Simplify seqfile code
      tracing/syscalls: Fix fields format for enter events
      tracing/syscalls: Add fields format for exit events
      tracing/events: Add ftrace_event_call param to define_fields()
      tracing/events: Add trace_define_common_fields()
      tracing/syscalls: Add filtering support
      tracing/syscalls: Fix the output of syscalls with no arguments
      tracing/filters: Add filter_type to struct ftrace_event_field
      tracing/filters: Add __field_ext() to TRACE_EVENT
      tracing/filters: Support filtering for char * strings
      tracing/filters: Defer pred allocation
      tracing/filters: Defer pred allocation, fix memory leak

Masami Hiramatsu (1):
      kprobes: Clean up insn_pages by using list instead of hlist

Steven Rostedt (25):
      ring-buffer: make the buffer a true circular link list
      ring-buffer: make lockless
      ring-buffer: add design document
      tracing/sched: show CPU task wakes up on in trace event
      tracing: add comments to explain TRACE_EVENT out of protection
      tracing: remove legacy select of MARKERS by context switch tracing
      tracing: only show tracing_max_latency when latency tracer configured
      ring-buffer: do not reset while in a commit
      ring-buffer: do not swap buffers during a commit
      ring-buffer: remove unnecessary cpu_relax
      ring-buffer: fix ring_buffer_read crossing pages
      ring-buffer: remove ring_buffer_event_discard
      ring-buffer: do not count discarded events
      ring-buffer: disable all cpu buffers when one finds a problem
      tracing: print out start and stop in latency traces
      tracing: disable update max tracer while reading trace
      tracing: disable buffers and synchronize_sched before resetting
      tracing: remove users of tracing_reset
      tracing: use timestamp to determine start of latency traces
      tracing: make tracing_reset safe for external use
      tracing: pass around ring buffer instead of tracer
      tracing: add trace_array_printk for internal tracers to use
      tracing: report error in trace if we fail to swap latency buffer
      ring-buffer: check for swapped buffers in start of committing
      ring-buffer: only enable ring_buffer_swap_cpu when needed

Tom Zanussi (1):
      tracing/filters: Don't use pred on alloc failure

Xiao Guangrong (7):
      tracing/filter: Remove preds from struct event_subsystem
      tracing/filter: Remove empty subsystem and its directory
      tracing/function: Simplify __ftrace_replace_code()
      tracing/trace_stack: Cleanup for trace_lookup_stack()
      tracing/function: Cleanup for function tracer
      tracing: cleanup for tracing_trace_options_read()
      tracing/events: fix the include file dependencies

Zhaolei (2):
      tracing: Rename set_tracer_flags()'s local variable trace_flags
      ftrace: Move setting of clock-source out of options

jolsa@redhat.com (2):
      tracing: Remove unused fields/variables
      tracing: Remove .globl in the scripts/recordmcount.pl doc


 Documentation/kernel-parameters.txt         |    5 +
 Documentation/trace/events.txt              |    9 +
 Documentation/trace/ftrace.txt              |   68 +-
 Documentation/trace/function-graph-fold.vim |   42 +
 Documentation/trace/ring-buffer-design.txt  |  955 +++++++++++++++++++++++
 arch/s390/Kconfig                           |    2 +-
 arch/s390/defconfig                         |    2 +-
 arch/s390/include/asm/thread_info.h         |    4 +-
 arch/s390/kernel/entry.S                    |    2 +-
 arch/s390/kernel/entry64.S                  |    2 +-
 arch/s390/kernel/ftrace.c                   |   36 +-
 arch/s390/kernel/ptrace.c                   |   11 +-
 arch/x86/Kconfig                            |    2 +-
 arch/x86/configs/i386_defconfig             |    2 +-
 arch/x86/configs/x86_64_defconfig           |    2 +-
 arch/x86/include/asm/ftrace.h               |    7 -
 arch/x86/include/asm/thread_info.h          |   13 +-
 arch/x86/include/asm/unistd_32.h            |    2 +
 arch/x86/include/asm/unistd_64.h            |    6 +
 arch/x86/kernel/asm-offsets_64.c            |    1 +
 arch/x86/kernel/ftrace.c                    |   51 +-
 arch/x86/kernel/ptrace.c                    |   13 +-
 arch/x86/kernel/sys_x86_64.c                |    8 +-
 include/linux/ftrace_event.h                |   51 +-
 include/linux/module.h                      |   14 +-
 include/linux/perf_counter.h                |    2 +
 include/linux/ring_buffer.h                 |   24 +-
 include/linux/syscalls.h                    |  131 +++-
 include/linux/tracepoint.h                  |   29 +-
 include/trace/define_trace.h                |    7 +
 include/trace/events/module.h               |  126 +++
 include/trace/events/sched.h                |   12 +-
 include/trace/events/syscalls.h             |   70 ++
 include/trace/ftrace.h                      |   93 ++-
 include/trace/syscall.h                     |   48 +-
 kernel/kmod.c                               |    4 +
 kernel/kprobes.c                            |   30 +-
 kernel/module.c                             |   11 +
 kernel/trace/Kconfig                        |   13 +-
 kernel/trace/blktrace.c                     |   12 +-
 kernel/trace/ftrace.c                       |  107 +--
 kernel/trace/kmemtrace.c                    |  149 +++--
 kernel/trace/ring_buffer.c                  | 1112 +++++++++++++++++++++------
 kernel/trace/trace.c                        |  679 +++++++++--------
 kernel/trace/trace.h                        |   76 ++-
 kernel/trace/trace_boot.c                   |   16 +-
 kernel/trace/trace_events.c                 |  146 +++-
 kernel/trace/trace_events_filter.c          |  261 ++++---
 kernel/trace/trace_export.c                 |   28 +-
 kernel/trace/trace_functions.c              |    4 +-
 kernel/trace/trace_functions_graph.c        |  166 +++-
 kernel/trace/trace_irqsoff.c                |    3 +-
 kernel/trace/trace_mmiotrace.c              |   10 +-
 kernel/trace/trace_power.c                  |   22 +-
 kernel/trace/trace_sched_switch.c           |   59 ++
 kernel/trace/trace_sched_wakeup.c           |    7 +-
 kernel/trace/trace_selftest.c               |    1 +
 kernel/trace/trace_stack.c                  |   43 +-
 kernel/trace/trace_stat.c                   |   17 +-
 kernel/trace/trace_stat.h                   |    2 +
 kernel/trace/trace_syscalls.c               |  471 +++++++++---
 kernel/trace/trace_workqueue.c              |   32 +-
 kernel/tracepoint.c                         |   50 ++-
 scripts/recordmcount.pl                     |    1 -
 tools/perf/util/parse-events.c              |    8 +-
 65 files changed, 4106 insertions(+), 1286 deletions(-)
 create mode 100644 Documentation/trace/function-graph-fold.vim
 create mode 100644 Documentation/trace/ring-buffer-design.txt
 create mode 100644 include/trace/events/module.h
 create mode 100644 include/trace/events/syscalls.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7936b80..8e91863 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2480,6 +2480,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	trace_buf_size=nn[KMG]
 			[FTRACE] will set tracing buffer size.
 
+	trace_event=[event-list]
+			[FTRACE] Set and start specified trace events in order
+			to facilitate early boot debugging.
+			See also Documentation/trace/events.txt
+
 	trix=		[HW,OSS] MediaTrix AudioTrix Pro
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index f157d75..2bcc8d4 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -83,6 +83,15 @@ When reading one of these enable files, there are four results:
  X - there is a mixture of events enabled and disabled
  ? - this file does not affect any event
 
+2.3 Boot option
+---------------
+
+In order to facilitate early boot debugging, use boot option:
+
+	trace_event=[event-list]
+
+The format of this boot option is the same as described in section 2.1.
+
 3. Defining an event-enabled tracepoint
 =======================================
 
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index a39b3c7..355d0f1 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -85,26 +85,19 @@ of ftrace. Here is a list of some of the key files:
 	This file holds the output of the trace in a human
 	readable format (described below).
 
-  latency_trace:
-
-	This file shows the same trace but the information
-	is organized more to display possible latencies
-	in the system (described below).
-
   trace_pipe:
 
 	The output is the same as the "trace" file but this
 	file is meant to be streamed with live tracing.
-	Reads from this file will block until new data
-	is retrieved. Unlike the "trace" and "latency_trace"
-	files, this file is a consumer. This means reading
-	from this file causes sequential reads to display
-	more current data. Once data is read from this
-	file, it is consumed, and will not be read
-	again with a sequential read. The "trace" and
-	"latency_trace" files are static, and if the
-	tracer is not adding more data, they will display
-	the same information every time they are read.
+	Reads from this file will block until new data is
+	retrieved.  Unlike the "trace" file, this file is a
+	consumer. This means reading from this file causes
+	sequential reads to display more current data. Once
+	data is read from this file, it is consumed, and
+	will not be read again with a sequential read. The
+	"trace" file is static, and if the tracer is not
+	adding more data,they will display the same
+	information every time they are read.
 
   trace_options:
 
@@ -117,10 +110,10 @@ of ftrace. Here is a list of some of the key files:
 	Some of the tracers record the max latency.
 	For example, the time interrupts are disabled.
 	This time is saved in this file. The max trace
-	will also be stored, and displayed by either
-	"trace" or "latency_trace".  A new max trace will
-	only be recorded if the latency is greater than
-	the value in this file. (in microseconds)
+	will also be stored, and displayed by "trace".
+	A new max trace will only be recorded if the
+	latency is greater than the value in this
+	file. (in microseconds)
 
   buffer_size_kb:
 
@@ -210,7 +203,7 @@ Here is the list of current tracers that may be configured.
 	the trace with the longest max latency.
 	See tracing_max_latency. When a new max is recorded,
 	it replaces the old trace. It is best to view this
-	trace via the latency_trace file.
+	trace with the latency-format option enabled.
 
   "preemptoff"
 
@@ -307,8 +300,8 @@ the lowest priority thread (pid 0).
 Latency trace format
 --------------------
 
-For traces that display latency times, the latency_trace file
-gives somewhat more information to see why a latency happened.
+When the latency-format option is enabled, the trace file gives
+somewhat more information to see why a latency happened.
 Here is a typical trace.
 
 # tracer: irqsoff
@@ -380,9 +373,10 @@ explains which is which.
 
 The above is mostly meaningful for kernel developers.
 
-  time: This differs from the trace file output. The trace file output
-	includes an absolute timestamp. The timestamp used by the
-	latency_trace file is relative to the start of the trace.
+  time: When the latency-format option is enabled, the trace file
+	output includes a timestamp relative to the start of the
+	trace. This differs from the output when latency-format
+	is disabled, which includes an absolute timestamp.
 
   delay: This is just to help catch your eye a bit better. And
 	 needs to be fixed to be only relative to the same CPU.
@@ -440,7 +434,8 @@ Here are the available options:
   sym-addr:
    bash-4000  [01]  1477.606694: simple_strtoul <c0339346>
 
-  verbose - This deals with the latency_trace file.
+  verbose - This deals with the trace file when the
+            latency-format option is enabled.
 
     bash  4000 1 0 00000000 00010a95 [58127d26] 1720.415ms \
     (+0.000ms): simple_strtoul (strict_strtoul)
@@ -472,7 +467,7 @@ Here are the available options:
 		the app is no longer running
 
 		The lookup is performed when you read
-		trace,trace_pipe,latency_trace. Example:
+		trace,trace_pipe. Example:
 
 		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
 x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
@@ -481,6 +476,11 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
 	       every scheduling event. Will add overhead if
 	       there's a lot of tasks running at once.
 
+  latency-format - This option changes the trace. When
+                   it is enabled, the trace displays
+                   additional information about the
+                   latencies, as described in "Latency
+                   trace format".
 
 sched_switch
 ------------
@@ -596,12 +596,13 @@ To reset the maximum, echo 0 into tracing_max_latency. Here is
 an example:
 
  # echo irqsoff > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: irqsoff
 #
 irqsoff latency trace v1.1.5 on 2.6.26
@@ -703,12 +704,13 @@ which preemption was disabled. The control of preemptoff tracer
 is much like the irqsoff tracer.
 
  # echo preemptoff > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: preemptoff
 #
 preemptoff latency trace v1.1.5 on 2.6.26-rc8
@@ -850,12 +852,13 @@ Again, using this trace is much like the irqsoff and preemptoff
 tracers.
 
  # echo preemptirqsoff > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: preemptirqsoff
 #
 preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
@@ -1012,11 +1015,12 @@ Instead of performing an 'ls', we will run 'sleep 1' under
 'chrt' which changes the priority of the task.
 
  # echo wakeup > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # chrt -f 5 sleep 1
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: wakeup
 #
 wakeup latency trace v1.1.5 on 2.6.26-rc8
diff --git a/Documentation/trace/function-graph-fold.vim b/Documentation/trace/function-graph-fold.vim
new file mode 100644
index 0000000..0544b50
--- /dev/null
+++ b/Documentation/trace/function-graph-fold.vim
@@ -0,0 +1,42 @@
+" Enable folding for ftrace function_graph traces.
+"
+" To use, :source this file while viewing a function_graph trace, or use vim's
+" -S option to load from the command-line together with a trace.  You can then
+" use the usual vim fold commands, such as "za", to open and close nested
+" functions.  While closed, a fold will show the total time taken for a call,
+" as would normally appear on the line with the closing brace.  Folded
+" functions will not include finish_task_switch(), so folding should remain
+" relatively sane even through a context switch.
+"
+" Note that this will almost certainly only work well with a
+" single-CPU trace (e.g. trace-cmd report --cpu 1).
+
+function! FunctionGraphFoldExpr(lnum)
+  let line = getline(a:lnum)
+  if line[-1:] == '{'
+    if line =~ 'finish_task_switch() {$'
+      return '>1'
+    endif
+    return 'a1'
+  elseif line[-1:] == '}'
+    return 's1'
+  else
+    return '='
+  endif
+endfunction
+
+function! FunctionGraphFoldText()
+  let s = split(getline(v:foldstart), '|', 1)
+  if getline(v:foldend+1) =~ 'finish_task_switch() {$'
+    let s[2] = ' task switch  '
+  else
+    let e = split(getline(v:foldend), '|', 1)
+    let s[2] = e[2]
+  endif
+  return join(s, '|')
+endfunction
+
+setlocal foldexpr=FunctionGraphFoldExpr(v:lnum)
+setlocal foldtext=FunctionGraphFoldText()
+setlocal foldcolumn=12
+setlocal foldmethod=expr
diff --git a/Documentation/trace/ring-buffer-design.txt b/Documentation/trace/ring-buffer-design.txt
new file mode 100644
index 0000000..5b1d23d
--- /dev/null
+++ b/Documentation/trace/ring-buffer-design.txt
@@ -0,0 +1,955 @@
+		Lockless Ring Buffer Design
+		===========================
+
+Copyright 2009 Red Hat Inc.
+   Author:   Steven Rostedt <srostedt@redhat.com>
+  License:   The GNU Free Documentation License, Version 1.2
+               (dual licensed under the GPL v2)
+Reviewers:   Mathieu Desnoyers, Huang Ying, Hidetoshi Seto,
+	     and Frederic Weisbecker.
+
+
+Written for: 2.6.31
+
+Terminology used in this Document
+---------------------------------
+
+tail - where new writes happen in the ring buffer.
+
+head - where new reads happen in the ring buffer.
+
+producer - the task that writes into the ring buffer (same as writer)
+
+writer - same as producer
+
+consumer - the task that reads from the buffer (same as reader)
+
+reader - same as consumer.
+
+reader_page - A page outside the ring buffer used solely (for the most part)
+    by the reader.
+
+head_page - a pointer to the page that the reader will use next
+
+tail_page - a pointer to the page that will be written to next
+
+commit_page - a pointer to the page with the last finished non nested write.
+
+cmpxchg - hardware assisted atomic transaction that performs the following:
+
+   A = B iff previous A == C
+
+   R = cmpxchg(A, C, B) is saying that we replace A with B if and only if
+      current A is equal to C, and we put the old (current) A into R
+
+   R gets the previous A regardless if A is updated with B or not.
+
+   To see if the update was successful a compare of R == C may be used.
+
+The Generic Ring Buffer
+-----------------------
+
+The ring buffer can be used in either an overwrite mode or in
+producer/consumer mode.
+
+Producer/consumer mode is where the producer were to fill up the
+buffer before the consumer could free up anything, the producer
+will stop writing to the buffer. This will lose most recent events.
+
+Overwrite mode is where the produce were to fill up the buffer
+before the consumer could free up anything, the producer will
+overwrite the older data. This will lose the oldest events.
+
+No two writers can write at the same time (on the same per cpu buffer),
+but a writer may interrupt another writer, but it must finish writing
+before the previous writer may continue. This is very important to the
+algorithm. The writers act like a "stack". The way interrupts works
+enforces this behavior.
+
+
+  writer1 start
+     <preempted> writer2 start
+         <preempted> writer3 start
+                     writer3 finishes
+                 writer2 finishes
+  writer1 finishes
+
+This is very much like a writer being preempted by an interrupt and
+the interrupt doing a write as well.
+
+Readers can happen at any time. But no two readers may run at the
+same time, nor can a reader preempt/interrupt another reader. A reader
+can not preempt/interrupt a writer, but it may read/consume from the
+buffer at the same time as a writer is writing, but the reader must be
+on another processor to do so. A reader may read on its own processor
+and can be preempted by a writer.
+
+A writer can preempt a reader, but a reader can not preempt a writer.
+But a reader can read the buffer at the same time (on another processor)
+as a writer.
+
+The ring buffer is made up of a list of pages held together by a link list.
+
+At initialization a reader page is allocated for the reader that is not
+part of the ring buffer.
+
+The head_page, tail_page and commit_page are all initialized to point
+to the same page.
+
+The reader page is initialized to have its next pointer pointing to
+the head page, and its previous pointer pointing to a page before
+the head page.
+
+The reader has its own page to use. At start up time, this page is
+allocated but is not attached to the list. When the reader wants
+to read from the buffer, if its page is empty (like it is on start up)
+it will swap its page with the head_page. The old reader page will
+become part of the ring buffer and the head_page will be removed.
+The page after the inserted page (old reader_page) will become the
+new head page.
+
+Once the new page is given to the reader, the reader could do what
+it wants with it, as long as a writer has left that page.
+
+A sample of how the reader page is swapped: Note this does not
+show the head page in the buffer, it is for demonstrating a swap
+only.
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |
+  +------+
+                  +---+   +---+   +---+
+                  |   |-->|   |-->|   |
+                  |   |<--|   |<--|   |
+                  +---+   +---+   +---+
+                   ^ |             ^ |
+                   | +-------------+ |
+                   +-----------------+
+
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |-------------------+
+  +------+                   v
+    |             +---+   +---+   +---+
+    |             |   |-->|   |-->|   |
+    |             |   |<--|   |<--|   |<-+
+    |             +---+   +---+   +---+  |
+    |              ^ |             ^ |   |
+    |              | +-------------+ |   |
+    |              +-----------------+   |
+    +------------------------------------+
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |-------------------+
+  +------+ <---------------+ v
+    |  ^          +---+   +---+   +---+
+    |  |          |   |-->|   |-->|   |
+    |  |          |   |   |   |<--|   |<-+
+    |  |          +---+   +---+   +---+  |
+    |  |             |             ^ |   |
+    |  |             +-------------+ |   |
+    |  +-----------------------------+   |
+    +------------------------------------+
+
+  +------+
+  |buffer|          RING BUFFER
+  |page  |-------------------+
+  +------+ <---------------+ v
+    |  ^          +---+   +---+   +---+
+    |  |          |   |   |   |-->|   |
+    |  |  New     |   |   |   |<--|   |<-+
+    |  | Reader   +---+   +---+   +---+  |
+    |  |  page ----^                 |   |
+    |  |                             |   |
+    |  +-----------------------------+   |
+    +------------------------------------+
+
+
+
+It is possible that the page swapped is the commit page and the tail page,
+if what is in the ring buffer is less than what is held in a buffer page.
+
+
+          reader page    commit page   tail page
+              |              |             |
+              v              |             |
+             +---+           |             |
+             |   |<----------+             |
+             |   |<------------------------+
+             |   |------+
+             +---+      |
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+This case is still valid for this algorithm.
+When the writer leaves the page, it simply goes into the ring buffer
+since the reader page still points to the next location in the ring
+buffer.
+
+
+The main pointers:
+
+  reader page - The page used solely by the reader and is not part
+                of the ring buffer (may be swapped in)
+
+  head page - the next page in the ring buffer that will be swapped
+              with the reader page.
+
+  tail page - the page where the next write will take place.
+
+  commit page - the page that last finished a write.
+
+The commit page only is updated by the outer most writer in the
+writer stack. A writer that preempts another writer will not move the
+commit page.
+
+When data is written into the ring buffer, a position is reserved
+in the ring buffer and passed back to the writer. When the writer
+is finished writing data into that position, it commits the write.
+
+Another write (or a read) may take place at anytime during this
+transaction. If another write happens it must finish before continuing
+with the previous write.
+
+
+   Write reserve:
+
+       Buffer page
+      +---------+
+      |written  |
+      +---------+  <--- given back to writer (current commit)
+      |reserved |
+      +---------+ <--- tail pointer
+      | empty   |
+      +---------+
+
+   Write commit:
+
+       Buffer page
+      +---------+
+      |written  |
+      +---------+
+      |written  |
+      +---------+  <--- next positon for write (current commit)
+      | empty   |
+      +---------+
+
+
+ If a write happens after the first reserve:
+
+       Buffer page
+      +---------+
+      |written  |
+      +---------+  <-- current commit
+      |reserved |
+      +---------+  <--- given back to second writer
+      |reserved |
+      +---------+ <--- tail pointer
+
+  After second writer commits:
+
+
+       Buffer page
+      +---------+
+      |written  |
+      +---------+  <--(last full commit)
+      |reserved |
+      +---------+
+      |pending  |
+      |commit   |
+      +---------+ <--- tail pointer
+
+  When the first writer commits:
+
+       Buffer page
+      +---------+
+      |written  |
+      +---------+
+      |written  |
+      +---------+
+      |written  |
+      +---------+  <--(last full commit and tail pointer)
+
+
+The commit pointer points to the last write location that was
+committed without preempting another write. When a write that
+preempted another write is committed, it only becomes a pending commit
+and will not be a full commit till all writes have been committed.
+
+The commit page points to the page that has the last full commit.
+The tail page points to the page with the last write (before
+committing).
+
+The tail page is always equal to or after the commit page. It may
+be several pages ahead. If the tail page catches up to the commit
+page then no more writes may take place (regardless of the mode
+of the ring buffer: overwrite and produce/consumer).
+
+The order of pages are:
+
+ head page
+ commit page
+ tail page
+
+Possible scenario:
+                             tail page
+  head page         commit page  |
+      |                 |        |
+      v                 v        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+There is a special case that the head page is after either the commit page
+and possibly the tail page. That is when the commit (and tail) page has been
+swapped with the reader page. This is because the head page is always
+part of the ring buffer, but the reader page is not. When ever there
+has been less than a full page that has been committed inside the ring buffer,
+and a reader swaps out a page, it will be swapping out the commit page.
+
+
+          reader page    commit page   tail page
+              |              |             |
+              v              |             |
+             +---+           |             |
+             |   |<----------+             |
+             |   |<------------------------+
+             |   |------+
+             +---+      |
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+                        ^
+                        |
+                    head page
+
+
+In this case, the head page will not move when the tail and commit
+move back into the ring buffer.
+
+The reader can not swap a page into the ring buffer if the commit page
+is still on that page. If the read meets the last commit (real commit
+not pending or reserved), then there is nothing more to read.
+The buffer is considered empty until another full commit finishes.
+
+When the tail meets the head page, if the buffer is in overwrite mode,
+the head page will be pushed ahead one. If the buffer is in producer/consumer
+mode, the write will fail.
+
+Overwrite mode:
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+                        ^
+                        |
+                    head page
+
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+                                 ^
+                                 |
+                             head page
+
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+                                 ^
+                                 |
+                             head page
+
+Note, the reader page will still point to the previous head page.
+But when a swap takes place, it will use the most recent head page.
+
+
+Making the Ring Buffer Lockless:
+--------------------------------
+
+The main idea behind the lockless algorithm is to combine the moving
+of the head_page pointer with the swapping of pages with the reader.
+State flags are placed inside the pointer to the page. To do this,
+each page must be aligned in memory by 4 bytes. This will allow the 2
+least significant bits of the address to be used as flags. Since
+they will always be zero for the address. To get the address,
+simply mask out the flags.
+
+  MASK = ~3
+
+  address & MASK
+
+Two flags will be kept by these two bits:
+
+   HEADER - the page being pointed to is a head page
+
+   UPDATE - the page being pointed to is being updated by a writer
+          and was or is about to be a head page.
+
+
+          reader page
+              |
+              v
+             +---+
+             |   |------+
+             +---+      |
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-H->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+
+The above pointer "-H->" would have the HEADER flag set. That is
+the next page is the next page to be swapped out by the reader.
+This pointer means the next page is the head page.
+
+When the tail page meets the head pointer, it will use cmpxchg to
+change the pointer to the UPDATE state:
+
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-H->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+"-U->" represents a pointer in the UPDATE state.
+
+Any access to the reader will need to take some sort of lock to serialize
+the readers. But the writers will never take a lock to write to the
+ring buffer. This means we only need to worry about a single reader,
+and writes only preempt in "stack" formation.
+
+When the reader tries to swap the page with the ring buffer, it
+will also use cmpxchg. If the flag bit in the pointer to the
+head page does not have the HEADER flag set, the compare will fail
+and the reader will need to look for the new head page and try again.
+Note, the flag UPDATE and HEADER are never set at the same time.
+
+The reader swaps the reader page as follows:
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |
+  +------+
+                  +---+    +---+    +---+
+                  |   |--->|   |--->|   |
+                  |   |<---|   |<---|   |
+                  +---+    +---+    +---+
+                   ^ |               ^ |
+                   | +---------------+ |
+                   +-----H-------------+
+
+The reader sets the reader page next pointer as HEADER to the page after
+the head page.
+
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |-------H-----------+
+  +------+                   v
+    |             +---+    +---+    +---+
+    |             |   |--->|   |--->|   |
+    |             |   |<---|   |<---|   |<-+
+    |             +---+    +---+    +---+  |
+    |              ^ |               ^ |   |
+    |              | +---------------+ |   |
+    |              +-----H-------------+   |
+    +--------------------------------------+
+
+It does a cmpxchg with the pointer to the previous head page to make it
+point to the reader page. Note that the new pointer does not have the HEADER
+flag set.  This action atomically moves the head page forward.
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |-------H-----------+
+  +------+                   v
+    |  ^          +---+   +---+   +---+
+    |  |          |   |-->|   |-->|   |
+    |  |          |   |<--|   |<--|   |<-+
+    |  |          +---+   +---+   +---+  |
+    |  |             |             ^ |   |
+    |  |             +-------------+ |   |
+    |  +-----------------------------+   |
+    +------------------------------------+
+
+After the new head page is set, the previous pointer of the head page is
+updated to the reader page.
+
+  +------+
+  |reader|          RING BUFFER
+  |page  |-------H-----------+
+  +------+ <---------------+ v
+    |  ^          +---+   +---+   +---+
+    |  |          |   |-->|   |-->|   |
+    |  |          |   |   |   |<--|   |<-+
+    |  |          +---+   +---+   +---+  |
+    |  |             |             ^ |   |
+    |  |             +-------------+ |   |
+    |  +-----------------------------+   |
+    +------------------------------------+
+
+  +------+
+  |buffer|          RING BUFFER
+  |page  |-------H-----------+  <--- New head page
+  +------+ <---------------+ v
+    |  ^          +---+   +---+   +---+
+    |  |          |   |   |   |-->|   |
+    |  |  New     |   |   |   |<--|   |<-+
+    |  | Reader   +---+   +---+   +---+  |
+    |  |  page ----^                 |   |
+    |  |                             |   |
+    |  +-----------------------------+   |
+    +------------------------------------+
+
+Another important point. The page that the reader page points back to
+by its previous pointer (the one that now points to the new head page)
+never points back to the reader page. That is because the reader page is
+not part of the ring buffer. Traversing the ring buffer via the next pointers
+will always stay in the ring buffer. Traversing the ring buffer via the
+prev pointers may not.
+
+Note, the way to determine a reader page is simply by examining the previous
+pointer of the page. If the next pointer of the previous page does not
+point back to the original page, then the original page is a reader page:
+
+
+             +--------+
+             | reader |  next   +----+
+             |  page  |-------->|    |<====== (buffer page)
+             +--------+         +----+
+                 |                | ^
+                 |                v | next
+            prev |              +----+
+                 +------------->|    |
+                                +----+
+
+The way the head page moves forward:
+
+When the tail page meets the head page and the buffer is in overwrite mode
+and more writes take place, the head page must be moved forward before the
+writer may move the tail page. The way this is done is that the writer
+performs a cmpxchg to convert the pointer to the head page from the HEADER
+flag to have the UPDATE flag set. Once this is done, the reader will
+not be able to swap the head page from the buffer, nor will it be able to
+move the head page, until the writer is finished with the move.
+
+This eliminates any races that the reader can have on the writer. The reader
+must spin, and this is why the reader can not preempt the writer.
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-H->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The following page will be made into the new head page.
+
+           tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+After the new head page has been set, we can set the old head page
+pointer back to NORMAL.
+
+           tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+After the head page has been moved, the tail page may now move forward.
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+
+The above are the trivial updates. Now for the more complex scenarios.
+
+
+As stated before, if enough writes preempt the first write, the
+tail page may make it all the way around the buffer and meet the commit
+page. At this time, we must start dropping writes (usually with some kind
+of warning to the user). But what happens if the commit was still on the
+reader page? The commit page is not part of the ring buffer. The tail page
+must account for this.
+
+
+          reader page    commit page
+              |              |
+              v              |
+             +---+           |
+             |   |<----------+
+             |   |
+             |   |------+
+             +---+      |
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-H->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+               ^
+               |
+           tail page
+
+If the tail page were to simply push the head page forward, the commit when
+leaving the reader page would not be pointing to the correct page.
+
+The solution to this is to test if the commit page is on the reader page
+before pushing the head page. If it is, then it can be assumed that the
+tail page wrapped the buffer, and we must drop new writes.
+
+This is not a race condition, because the commit page can only be moved
+by the outter most writer (the writer that was preempted).
+This means that the commit will not move while a writer is moving the
+tail page. The reader can not swap the reader page if it is also being
+used as the commit page. The reader can simply check that the commit
+is off the reader page. Once the commit page leaves the reader page
+it will never go back on it unless a reader does another swap with the
+buffer page that is also the commit page.
+
+
+Nested writes
+-------------
+
+In the pushing forward of the tail page we must first push forward
+the head page if the head page is the next page. If the head page
+is not the next page, the tail page is simply updated with a cmpxchg.
+
+Only writers move the tail page. This must be done atomically to protect
+against nested writers.
+
+  temp_page = tail_page
+  next_page = temp_page->next
+  cmpxchg(tail_page, temp_page, next_page)
+
+The above will update the tail page if it is still pointing to the expected
+page. If this fails, a nested write pushed it forward, the the current write
+does not need to push it.
+
+
+           temp page
+               |
+               v
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+Nested write comes in and moves the tail page forward:
+
+                    tail page (moved by nested writer)
+            temp page   |
+               |        |
+               v        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The above would fail the cmpxchg, but since the tail page has already
+been moved forward, the writer will just try again to reserve storage
+on the new tail page.
+
+But the moving of the head page is a bit more complex.
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-H->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The write converts the head page pointer to UPDATE.
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+But if a nested writer preempts here. It will see that the next
+page is a head page, but it is also nested. It will detect that
+it is nested and will save that information. The detection is the
+fact that it sees the UPDATE flag instead of a HEADER or NORMAL
+pointer.
+
+The nested writer will set the new head page pointer.
+
+           tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+But it will not reset the update back to normal. Only the writer
+that converted a pointer from HEAD to UPDATE will convert it back
+to NORMAL.
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+After the nested writer finishes, the outer most writer will convert
+the UPDATE pointer to NORMAL.
+
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+
+It can be even more complex if several nested writes came in and moved
+the tail page ahead several pages:
+
+
+(first writer)
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-H->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The write converts the head page pointer to UPDATE.
+
+            tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+Next writer comes in, and sees the update and sets up the new
+head page.
+
+(second writer)
+
+           tail page
+               |
+               v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The nested writer moves the tail page forward. But does not set the old
+update page to NORMAL because it is not the outer most writer.
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+Another writer preempts and sees the page after the tail page is a head page.
+It changes it from HEAD to UPDATE.
+
+(third writer)
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-U->|   |--->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The writer will move the head page forward:
+
+
+(third writer)
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-U->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+But now that the third writer did change the HEAD flag to UPDATE it
+will convert it to normal:
+
+
+(third writer)
+
+                    tail page
+                        |
+                        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+
+Then it will move the tail page, and return back to the second writer.
+
+
+(second writer)
+
+                             tail page
+                                 |
+                                 v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+
+The second writer will fail to move the tail page because it was already
+moved, so it will try again and add its data to the new tail page.
+It will return to the first writer.
+
+
+(first writer)
+
+                             tail page
+                                 |
+                                 v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+The first writer can not know atomically test if the tail page moved
+while it updates the HEAD page. It will then update the head page to
+what it thinks is the new head page.
+
+
+(first writer)
+
+                             tail page
+                                 |
+                                 v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+Since the cmpxchg returns the old value of the pointer the first writer
+will see it succeeded in updating the pointer from NORMAL to HEAD.
+But as we can see, this is not good enough. It must also check to see
+if the tail page is either where it use to be or on the next page:
+
+
+(first writer)
+
+               A        B    tail page
+               |        |        |
+               v        v        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |-H->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+If tail page != A and tail page does not equal B, then it must reset the
+pointer back to NORMAL. The fact that it only needs to worry about
+nested writers, it only needs to check this after setting the HEAD page.
+
+
+(first writer)
+
+               A        B    tail page
+               |        |        |
+               v        v        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |-U->|   |--->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
+Now the writer can update the head page. This is also why the head page must
+remain in UPDATE and only reset by the outer most writer. This prevents
+the reader from seeing the incorrect head page.
+
+
+(first writer)
+
+               A        B    tail page
+               |        |        |
+               v        v        v
+    +---+    +---+    +---+    +---+
+<---|   |--->|   |--->|   |--->|   |-H->
+--->|   |<---|   |<---|   |<---|   |<---
+    +---+    +---+    +---+    +---+
+
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2ae5d72..7238ef4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -84,7 +84,7 @@ config S390
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_MCOUNT_RECORD
-	select HAVE_FTRACE_SYSCALLS
+	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_DEFAULT_NO_SPIN_MUTEXES
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index fcba206..4e91a25 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -900,7 +900,7 @@ CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_TRACING_SUPPORT=y
 CONFIG_FTRACE=y
 # CONFIG_FUNCTION_TRACER is not set
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index ba1cab9..07eb61b 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -92,7 +92,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
 #define TIF_SECCOMP		10	/* secure computing */
-#define TIF_SYSCALL_FTRACE	11	/* ftrace syscall instrumentation */
+#define TIF_SYSCALL_TRACEPOINT	11	/* syscall tracepoint instrumentation */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -111,7 +111,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_SYSCALL_FTRACE	(1<<TIF_SYSCALL_FTRACE)
+#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index c4c80a2..5d40fce 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -54,7 +54,7 @@ _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 _TIF_SYSCALL = (_TIF_SYSCALL_TRACE>>8 | _TIF_SYSCALL_AUDIT>>8 | \
-		_TIF_SECCOMP>>8 | _TIF_SYSCALL_FTRACE>>8)
+		_TIF_SECCOMP>>8 | _TIF_SYSCALL_TRACEPOINT>>8)
 
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
 STACK_SIZE  = 1 << STACK_SHIFT
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index f6618e9..3ceb53c 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -57,7 +57,7 @@ _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 _TIF_SYSCALL = (_TIF_SYSCALL_TRACE>>8 | _TIF_SYSCALL_AUDIT>>8 | \
-		_TIF_SECCOMP>>8 | _TIF_SYSCALL_FTRACE>>8)
+		_TIF_SECCOMP>>8 | _TIF_SYSCALL_TRACEPOINT>>8)
 
 #define BASED(name) name-system_call(%r13)
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 3e298e6..57bdcb1 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -220,6 +220,29 @@ struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+	for (i = 0; i < NR_syscalls; i++)
+		if (syscalls_metadata[i])
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
 	struct syscall_metadata *start;
@@ -237,24 +260,19 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 	return NULL;
 }
 
-void arch_init_ftrace_syscalls(void)
+static int __init arch_init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	int i;
-	static atomic_t refs;
-
-	if (atomic_inc_return(&refs) != 1)
-		goto out;
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
 				    GFP_KERNEL);
 	if (!syscalls_metadata)
-		goto out;
+		return -ENOMEM;
 	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
-out:
-	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 43acd73..f3ddd7a 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -51,6 +51,9 @@
 #include "compat_ptrace.h"
 #endif
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 enum s390_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
@@ -661,8 +664,8 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		ret = -1;
 	}
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_enter(regs, regs->gprs[2]);
 
 	if (unlikely(current->audit_context))
 		audit_syscall_entry(is_compat_task() ?
@@ -679,8 +682,8 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->gprs[2]),
 				   regs->gprs[2]);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_exit(regs);
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_exit(regs, regs->gprs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..071c6b0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -38,7 +38,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
-	select HAVE_FTRACE_SYSCALLS
+	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index edb992e..d28fad1 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -2355,7 +2355,7 @@ CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_HW_BRANCH_TRACER=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_RING_BUFFER=y
 CONFIG_TRACING=y
 CONFIG_TRACING_SUPPORT=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index cee1dd2..6c86acd 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -2329,7 +2329,7 @@ CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_HW_BRANCH_TRACER=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_RING_BUFFER=y
 CONFIG_TRACING=y
 CONFIG_TRACING_SUPPORT=y
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index bd2c651..db24c22 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,13 +28,6 @@
 
 #endif
 
-/* FIXME: I don't want to stay hardcoded */
-#ifdef CONFIG_X86_64
-# define FTRACE_SYSCALL_MAX     296
-#else
-# define FTRACE_SYSCALL_MAX     333
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..6f7786a 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,7 +95,7 @@ struct thread_info {
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_SYSCALL_FTRACE	28	/* for ftrace syscall instrumentation */
+#define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -118,17 +118,17 @@ struct thread_info {
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
-#define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
+#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_FTRACE |	\
-	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_FTRACE)
+	 _TIF_SYSCALL_TRACEPOINT)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -137,7 +137,8 @@ struct thread_info {
 	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
+#define _TIF_ALLWORK_MASK						\
+	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 732a307..8deaada 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -345,6 +345,8 @@
 
 #ifdef __KERNEL__
 
+#define NR_syscalls 337
+
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 900e161..b9f3c60 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 #endif	/* __NO_STUBS */
 
 #ifdef __KERNEL__
+
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#define NR_syscalls (__NR_syscall_max + 1)
+#endif
+
 /*
  * "Conditional" syscalls
  *
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 898ecc4..4a6aeed 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -3,6 +3,7 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/crypto.h>
 #include <linux/sched.h> 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d94e1ea..9dbb527 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -417,10 +417,6 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
-	/* Nmi's are currently unsupported */
-	if (unlikely(in_nmi()))
-		return;
-
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
@@ -498,37 +494,56 @@ static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
 
 struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
-	if (!syscalls_metadata || nr >= FTRACE_SYSCALL_MAX || nr < 0)
+	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
 }
 
-void arch_init_ftrace_syscalls(void)
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+
+	for (i = 0; i < NR_syscalls; i++) {
+		if (syscalls_metadata[i]) {
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+		}
+	}
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
+static int __init arch_init_ftrace_syscalls(void)
 {
 	int i;
 	struct syscall_metadata *meta;
 	unsigned long **psys_syscall_table = &sys_call_table;
-	static atomic_t refs;
-
-	if (atomic_inc_return(&refs) != 1)
-		goto end;
 
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					FTRACE_SYSCALL_MAX, GFP_KERNEL);
+					NR_syscalls, GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
-		return;
+		return -ENOMEM;
 	}
 
-	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
+	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta(psys_syscall_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
-
-	/* Paranoid: avoid overflow */
-end:
-	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 09ecbde..8d7d5c9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -35,10 +35,11 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
-#include <trace/syscall.h>
-
 #include "tls.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 enum x86_regset {
 	REGSET_GENERAL,
 	REGSET_FP,
@@ -1497,8 +1498,8 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	    tracehook_report_syscall_entry(regs))
 		ret = -1L;
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_enter(regs);
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_enter(regs, regs->orig_ax);
 
 	if (unlikely(current->audit_context)) {
 		if (IS_IA32)
@@ -1523,8 +1524,8 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
-		ftrace_syscall_exit(regs);
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_exit(regs, regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 6bc211a..45e00eb 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,9 +18,9 @@
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
 
-asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
-		unsigned long prot, unsigned long flags,
-		unsigned long fd, unsigned long off)
+SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, off)
 {
 	long error;
 	struct file *file;
@@ -226,7 +226,7 @@ bottomup:
 }
 
 
-asmlinkage long sys_uname(struct new_utsname __user *name)
+SYSCALL_DEFINE1(uname, struct new_utsname __user *, name)
 {
 	int err;
 	down_read(&uts_sem);
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index a81170d..23f7179 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -93,16 +93,22 @@ void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
 struct ring_buffer_event *
-trace_current_buffer_lock_reserve(int type, unsigned long len,
+trace_current_buffer_lock_reserve(struct ring_buffer **current_buffer,
+				  int type, unsigned long len,
 				  unsigned long flags, int pc);
-void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
+					struct ring_buffer_event *event,
 					unsigned long flags, int pc);
-void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
+void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
+				       struct ring_buffer_event *event,
 					unsigned long flags, int pc);
-void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
+void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
+					 struct ring_buffer_event *event);
 
 void tracing_record_cmdline(struct task_struct *tsk);
 
+struct event_filter;
+
 struct ftrace_event_call {
 	struct list_head	list;
 	char			*name;
@@ -110,16 +116,18 @@ struct ftrace_event_call {
 	struct dentry		*dir;
 	struct trace_event	*event;
 	int			enabled;
-	int			(*regfunc)(void);
-	void			(*unregfunc)(void);
+	int			(*regfunc)(void *);
+	void			(*unregfunc)(void *);
 	int			id;
 	int			(*raw_init)(void);
-	int			(*show_format)(struct trace_seq *s);
-	int			(*define_fields)(void);
+	int			(*show_format)(struct ftrace_event_call *call,
+					       struct trace_seq *s);
+	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
-	void			*filter;
+	struct event_filter	*filter;
 	void			*mod;
+	void			*data;
 
 	atomic_t		profile_count;
 	int			(*profile_enable)(struct ftrace_event_call *);
@@ -129,15 +137,25 @@ struct ftrace_event_call {
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	128
 
-extern int init_preds(struct ftrace_event_call *call);
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
-extern int filter_current_check_discard(struct ftrace_event_call *call,
+extern int filter_current_check_discard(struct ring_buffer *buffer,
+					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
 
-extern int trace_define_field(struct ftrace_event_call *call, char *type,
-			      char *name, int offset, int size, int is_signed);
+enum {
+	FILTER_OTHER = 0,
+	FILTER_STATIC_STRING,
+	FILTER_DYN_STRING,
+	FILTER_PTR_STRING,
+};
+
+extern int trace_define_field(struct ftrace_event_call *call,
+			      const char *type, const char *name,
+			      int offset, int size, int is_signed,
+			      int filter_type);
+extern int trace_define_common_fields(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
@@ -162,11 +180,4 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
-#define __common_field(type, item, is_signed)				\
-	ret = trace_define_field(event_call, #type, "common_" #item,	\
-				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item), is_signed);	\
-	if (ret)							\
-		return ret;
-
 #endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index 098bdb7..f8f92d0 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -17,10 +17,12 @@
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
 #include <linux/tracepoint.h>
-#include <asm/local.h>
 
+#include <asm/local.h>
 #include <asm/module.h>
 
+#include <trace/events/module.h>
+
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -462,7 +464,10 @@ static inline local_t *__module_ref_addr(struct module *mod, int cpu)
 static inline void __module_get(struct module *module)
 {
 	if (module) {
-		local_inc(__module_ref_addr(module, get_cpu()));
+		unsigned int cpu = get_cpu();
+		local_inc(__module_ref_addr(module, cpu));
+		trace_module_get(module, _THIS_IP_,
+				 local_read(__module_ref_addr(module, cpu)));
 		put_cpu();
 	}
 }
@@ -473,8 +478,11 @@ static inline int try_module_get(struct module *module)
 
 	if (module) {
 		unsigned int cpu = get_cpu();
-		if (likely(module_is_live(module)))
+		if (likely(module_is_live(module))) {
 			local_inc(__module_ref_addr(module, cpu));
+			trace_module_get(module, _THIS_IP_,
+				local_read(__module_ref_addr(module, cpu)));
+		}
 		else
 			ret = 0;
 		put_cpu();
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index b53f700..9ba1822 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -761,6 +761,8 @@ extern int sysctl_perf_counter_mlock;
 extern int sysctl_perf_counter_sample_rate;
 
 extern void perf_counter_init(void);
+extern void perf_tpcounter_event(int event_id, u64 addr, u64 count,
+				 void *record, int entry_size);
 
 #ifndef perf_misc_flags
 #define perf_misc_flags(regs)	(user_mode(regs) ? PERF_EVENT_MISC_USER : \
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 29f8599..5fcc31e 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -75,20 +75,6 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
 }
 
 /*
- * ring_buffer_event_discard can discard any event in the ring buffer.
- *   it is up to the caller to protect against a reader from
- *   consuming it or a writer from wrapping and replacing it.
- *
- * No external protection is needed if this is called before
- * the event is commited. But in that case it would be better to
- * use ring_buffer_discard_commit.
- *
- * Note, if an event that has not been committed is discarded
- * with ring_buffer_event_discard, it must still be committed.
- */
-void ring_buffer_event_discard(struct ring_buffer_event *event);
-
-/*
  * ring_buffer_discard_commit will remove an event that has not
  *   ben committed yet. If this is used, then ring_buffer_unlock_commit
  *   must not be called on the discarded event. This function
@@ -154,8 +140,17 @@ unsigned long ring_buffer_size(struct ring_buffer *buffer);
 void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_reset(struct ring_buffer *buffer);
 
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 			 struct ring_buffer *buffer_b, int cpu);
+#else
+static inline int
+ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+		     struct ring_buffer *buffer_b, int cpu)
+{
+	return -ENODEV;
+}
+#endif
 
 int ring_buffer_empty(struct ring_buffer *buffer);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
@@ -170,7 +165,6 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 80de700..a8e3782 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -64,6 +64,7 @@ struct perf_counter_attr;
 #include <linux/sem.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
+#include <linux/unistd.h>
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
@@ -97,6 +98,53 @@ struct perf_counter_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
+#ifdef CONFIG_EVENT_PROFILE
+#define TRACE_SYS_ENTER_PROFILE(sname)					       \
+static int prof_sysenter_enable_##sname(struct ftrace_event_call *event_call)  \
+{									       \
+	int ret = 0;							       \
+	if (!atomic_inc_return(&event_enter_##sname.profile_count))	       \
+		ret = reg_prof_syscall_enter("sys"#sname);		       \
+	return ret;							       \
+}									       \
+									       \
+static void prof_sysenter_disable_##sname(struct ftrace_event_call *event_call)\
+{									       \
+	if (atomic_add_negative(-1, &event_enter_##sname.profile_count))       \
+		unreg_prof_syscall_enter("sys"#sname);			       \
+}
+
+#define TRACE_SYS_EXIT_PROFILE(sname)					       \
+static int prof_sysexit_enable_##sname(struct ftrace_event_call *event_call)   \
+{									       \
+	int ret = 0;							       \
+	if (!atomic_inc_return(&event_exit_##sname.profile_count))	       \
+		ret = reg_prof_syscall_exit("sys"#sname);		       \
+	return ret;							       \
+}									       \
+									       \
+static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
+{                                                                              \
+	if (atomic_add_negative(-1, &event_exit_##sname.profile_count))	       \
+		unreg_prof_syscall_exit("sys"#sname);			       \
+}
+
+#define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
+	.profile_count = ATOMIC_INIT(-1),				       \
+	.profile_enable = prof_sysenter_enable_##sname,			       \
+	.profile_disable = prof_sysenter_disable_##sname,
+
+#define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
+	.profile_count = ATOMIC_INIT(-1),				       \
+	.profile_enable = prof_sysexit_enable_##sname,			       \
+	.profile_disable = prof_sysexit_disable_##sname,
+#else
+#define TRACE_SYS_ENTER_PROFILE(sname)
+#define TRACE_SYS_ENTER_PROFILE_INIT(sname)
+#define TRACE_SYS_EXIT_PROFILE(sname)
+#define TRACE_SYS_EXIT_PROFILE_INIT(sname)
+#endif
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
@@ -112,7 +160,81 @@ struct perf_counter_attr;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
+#define SYSCALL_TRACE_ENTER_EVENT(sname)				\
+	static struct ftrace_event_call event_enter_##sname;		\
+	struct trace_event enter_syscall_print_##sname = {		\
+		.trace                  = print_syscall_enter,		\
+	};								\
+	static int init_enter_##sname(void)				\
+	{								\
+		int num, id;						\
+		num = syscall_name_to_nr("sys"#sname);			\
+		if (num < 0)						\
+			return -ENOSYS;					\
+		id = register_ftrace_event(&enter_syscall_print_##sname);\
+		if (!id)						\
+			return -ENODEV;					\
+		event_enter_##sname.id = id;				\
+		set_syscall_enter_id(num, id);				\
+		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
+		return 0;						\
+	}								\
+	TRACE_SYS_ENTER_PROFILE(sname);					\
+	static struct ftrace_event_call __used				\
+	  __attribute__((__aligned__(4)))				\
+	  __attribute__((section("_ftrace_events")))			\
+	  event_enter_##sname = {					\
+		.name                   = "sys_enter"#sname,		\
+		.system                 = "syscalls",			\
+		.event                  = &event_syscall_enter,		\
+		.raw_init		= init_enter_##sname,		\
+		.show_format		= syscall_enter_format,		\
+		.define_fields		= syscall_enter_define_fields,	\
+		.regfunc		= reg_event_syscall_enter,	\
+		.unregfunc		= unreg_event_syscall_enter,	\
+		.data			= "sys"#sname,			\
+		TRACE_SYS_ENTER_PROFILE_INIT(sname)			\
+	}
+
+#define SYSCALL_TRACE_EXIT_EVENT(sname)					\
+	static struct ftrace_event_call event_exit_##sname;		\
+	struct trace_event exit_syscall_print_##sname = {		\
+		.trace                  = print_syscall_exit,		\
+	};								\
+	static int init_exit_##sname(void)				\
+	{								\
+		int num, id;						\
+		num = syscall_name_to_nr("sys"#sname);			\
+		if (num < 0)						\
+			return -ENOSYS;					\
+		id = register_ftrace_event(&exit_syscall_print_##sname);\
+		if (!id)						\
+			return -ENODEV;					\
+		event_exit_##sname.id = id;				\
+		set_syscall_exit_id(num, id);				\
+		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
+		return 0;						\
+	}								\
+	TRACE_SYS_EXIT_PROFILE(sname);					\
+	static struct ftrace_event_call __used				\
+	  __attribute__((__aligned__(4)))				\
+	  __attribute__((section("_ftrace_events")))			\
+	  event_exit_##sname = {					\
+		.name                   = "sys_exit"#sname,		\
+		.system                 = "syscalls",			\
+		.event                  = &event_syscall_exit,		\
+		.raw_init		= init_exit_##sname,		\
+		.show_format		= syscall_exit_format,		\
+		.define_fields		= syscall_exit_define_fields,	\
+		.regfunc		= reg_event_syscall_exit,	\
+		.unregfunc		= unreg_event_syscall_exit,	\
+		.data			= "sys"#sname,			\
+		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
+	}
+
 #define SYSCALL_METADATA(sname, nb)				\
+	SYSCALL_TRACE_ENTER_EVENT(sname);			\
+	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
@@ -121,18 +243,23 @@ struct perf_counter_attr;
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
-	}
+		.enter_event	= &event_enter_##sname,		\
+		.exit_event	= &event_exit_##sname,		\
+	};
 
 #define SYSCALL_DEFINE0(sname)					\
+	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
+	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
+		.enter_event	= &event_enter__##sname,	\
+		.exit_event	= &event_exit__##sname,		\
 	};							\
 	asmlinkage long sys_##sname(void)
-
 #else
 #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
 #endif
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index b9dc4ca..63a3f7a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -23,6 +23,8 @@ struct tracepoint;
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	int state;			/* State. */
+	void (*regfunc)(void);
+	void (*unregfunc)(void);
 	void **funcs;
 } __attribute__((aligned(32)));		/*
 					 * Aligned on 32 bytes because it is
@@ -78,12 +80,16 @@ struct tracepoint {
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
-#define DEFINE_TRACE(name)						\
+
+#define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, NULL }
+		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+
+#define DEFINE_TRACE(name)						\
+	DEFINE_TRACE_FN(name, NULL, NULL);
 
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
 	EXPORT_SYMBOL_GPL(__tracepoint_##name)
@@ -108,6 +114,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
 		return -ENOSYS;						\
 	}
 
+#define DEFINE_TRACE_FN(name, reg, unreg)
 #define DEFINE_TRACE(name)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
@@ -158,6 +165,15 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define PARAMS(args...) args
 
+#endif /* _LINUX_TRACEPOINT_H */
+
+/*
+ * Note: we keep the TRACE_EVENT outside the include file ifdef protection.
+ *  This is due to the way trace events work. If a file includes two
+ *  trace event headers under one "CREATE_TRACE_POINTS" the first include
+ *  will override the TRACE_EVENT and break the second include.
+ */
+
 #ifndef TRACE_EVENT
 /*
  * For use with the TRACE_EVENT macro:
@@ -259,10 +275,15 @@ static inline void tracepoint_synchronize_unregister(void)
  * can also by used by generic instrumentation like SystemTap), and
  * it is also used to expose a structured trace record in
  * /sys/kernel/debug/tracing/events/.
+ *
+ * A set of (un)registration functions can be passed to the variant
+ * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-#endif
+#define TRACE_EVENT_FN(name, proto, args, struct,		\
+		assign, print, reg, unreg)			\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
-#endif
+#endif /* ifdef TRACE_EVENT (see note above) */
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index f7a7ae1..2a4b3bf 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,6 +26,11 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
+#undef TRACE_EVENT_FN
+#define TRACE_EVENT_FN(name, proto, args, tstruct,		\
+		assign, print, reg, unreg)			\
+	DEFINE_TRACE_FN(name, reg, unreg)
+
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
@@ -56,6 +61,8 @@
 #include <trace/ftrace.h>
 #endif
 
+#undef TRACE_EVENT
+#undef TRACE_EVENT_FN
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
new file mode 100644
index 0000000..84160fb
--- /dev/null
+++ b/include/trace/events/module.h
@@ -0,0 +1,126 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM module
+
+#if !defined(_TRACE_MODULE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MODULE_H
+
+#include <linux/tracepoint.h>
+
+#ifdef CONFIG_MODULES
+
+struct module;
+
+#define show_module_flags(flags) __print_flags(flags, "",	\
+	{ (1UL << TAINT_PROPRIETARY_MODULE),	"P" },		\
+	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
+	{ (1UL << TAINT_CRAP),			"C" })
+
+TRACE_EVENT(module_load,
+
+	TP_PROTO(struct module *mod),
+
+	TP_ARGS(mod),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	taints		)
+		__string(	name,		mod->name	)
+	),
+
+	TP_fast_assign(
+		__entry->taints = mod->taints;
+		__assign_str(name, mod->name);
+	),
+
+	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
+);
+
+TRACE_EVENT(module_free,
+
+	TP_PROTO(struct module *mod),
+
+	TP_ARGS(mod),
+
+	TP_STRUCT__entry(
+		__string(	name,		mod->name	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, mod->name);
+	),
+
+	TP_printk("%s", __get_str(name))
+);
+
+TRACE_EVENT(module_get,
+
+	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+
+	TP_ARGS(mod, ip, refcnt),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	ip		)
+		__field(	int,		refcnt		)
+		__string(	name,		mod->name	)
+	),
+
+	TP_fast_assign(
+		__entry->ip	= ip;
+		__entry->refcnt	= refcnt;
+		__assign_str(name, mod->name);
+	),
+
+	TP_printk("%s call_site=%pf refcnt=%d",
+		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
+);
+
+TRACE_EVENT(module_put,
+
+	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+
+	TP_ARGS(mod, ip, refcnt),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	ip		)
+		__field(	int,		refcnt		)
+		__string(	name,		mod->name	)
+	),
+
+	TP_fast_assign(
+		__entry->ip	= ip;
+		__entry->refcnt	= refcnt;
+		__assign_str(name, mod->name);
+	),
+
+	TP_printk("%s call_site=%pf refcnt=%d",
+		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
+);
+
+TRACE_EVENT(module_request,
+
+	TP_PROTO(char *name, bool wait, unsigned long ip),
+
+	TP_ARGS(name, wait, ip),
+
+	TP_STRUCT__entry(
+		__field(	bool,		wait		)
+		__field(	unsigned long,	ip		)
+		__string(	name,		name		)
+	),
+
+	TP_fast_assign(
+		__entry->wait	= wait;
+		__entry->ip	= ip;
+		__assign_str(name, name);
+	),
+
+	TP_printk("%s wait=%d call_site=%pf",
+		  __get_str(name), (int)__entry->wait, (void *)__entry->ip)
+);
+
+#endif /* CONFIG_MODULES */
+
+#endif /* _TRACE_MODULE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 8949bb7..a581ef2 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -94,6 +94,7 @@ TRACE_EVENT(sched_wakeup,
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
 		__field(	int,	success			)
+		__field(	int,	cpu			)
 	),
 
 	TP_fast_assign(
@@ -101,11 +102,12 @@ TRACE_EVENT(sched_wakeup,
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
+		__entry->cpu		= task_cpu(p);
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
+	TP_printk("task %s:%d [%d] success=%d [%03d]",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
+		  __entry->success, __entry->cpu)
 );
 
 /*
@@ -125,6 +127,7 @@ TRACE_EVENT(sched_wakeup_new,
 		__field(	pid_t,	pid			)
 		__field(	int,	prio			)
 		__field(	int,	success			)
+		__field(	int,	cpu			)
 	),
 
 	TP_fast_assign(
@@ -132,11 +135,12 @@ TRACE_EVENT(sched_wakeup_new,
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
+		__entry->cpu		= task_cpu(p);
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
+	TP_printk("task %s:%d [%d] success=%d [%03d]",
 		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success)
+		  __entry->success, __entry->cpu)
 );
 
 /*
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
new file mode 100644
index 0000000..397dff2
--- /dev/null
+++ b/include/trace/events/syscalls.h
@@ -0,0 +1,70 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM syscalls
+
+#if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENTS_SYSCALLS_H
+
+#include <linux/tracepoint.h>
+
+#include <asm/ptrace.h>
+#include <asm/syscall.h>
+
+
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
+
+extern void syscall_regfunc(void);
+extern void syscall_unregfunc(void);
+
+TRACE_EVENT_FN(sys_enter,
+
+	TP_PROTO(struct pt_regs *regs, long id),
+
+	TP_ARGS(regs, id),
+
+	TP_STRUCT__entry(
+		__field(	long,		id		)
+		__array(	unsigned long,	args,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->id	= id;
+		syscall_get_arguments(current, regs, 0, 6, __entry->args);
+	),
+
+	TP_printk("NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)",
+		  __entry->id,
+		  __entry->args[0], __entry->args[1], __entry->args[2],
+		  __entry->args[3], __entry->args[4], __entry->args[5]),
+
+	syscall_regfunc, syscall_unregfunc
+);
+
+TRACE_EVENT_FN(sys_exit,
+
+	TP_PROTO(struct pt_regs *regs, long ret),
+
+	TP_ARGS(regs, ret),
+
+	TP_STRUCT__entry(
+		__field(	long,	id	)
+		__field(	long,	ret	)
+	),
+
+	TP_fast_assign(
+		__entry->id	= syscall_get_nr(current, regs);
+		__entry->ret	= ret;
+	),
+
+	TP_printk("NR %ld = %ld",
+		  __entry->id, __entry->ret),
+
+	syscall_regfunc, syscall_unregfunc
+);
+
+#endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
+
+#endif /* _TRACE_EVENTS_SYSCALLS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f64fbaa..308bafd 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -21,11 +21,14 @@
 #undef __field
 #define __field(type, item)		type	item;
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)	type	item;
+
 #undef __array
 #define __array(type, item, len)	type	item[len];
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len) unsigned short __data_loc_##item;
+#define __dynamic_array(type, item, len) u32 __data_loc_##item;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -42,6 +45,16 @@
 	};							\
 	static struct ftrace_event_call event_##name
 
+#undef __cpparg
+#define __cpparg(arg...) arg
+
+/* Callbacks are meaningless to ftrace. */
+#undef TRACE_EVENT_FN
+#define TRACE_EVENT_FN(name, proto, args, tstruct,			\
+		assign, print, reg, unreg)				\
+	TRACE_EVENT(name, __cpparg(proto), __cpparg(args),		\
+		__cpparg(tstruct), __cpparg(assign), __cpparg(print))	\
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 
@@ -51,23 +64,27 @@
  * Include the following:
  *
  * struct ftrace_data_offsets_<call> {
- *	int				<item1>;
- *	int				<item2>;
+ *	u32				<item1>;
+ *	u32				<item2>;
  *	[...]
  * };
  *
- * The __dynamic_array() macro will create each int <item>, this is
+ * The __dynamic_array() macro will create each u32 <item>, this is
  * to keep the offset of each array from the beginning of the event.
+ * The size of an array is also encoded, in the higher 16 bits of <item>.
  */
 
 #undef __field
-#define __field(type, item);
+#define __field(type, item)
+
+#undef __field_ext
+#define __field_ext(type, item, filter_type)
 
 #undef __array
 #define __array(type, item, len)
 
 #undef __dynamic_array
-#define __dynamic_array(type, item, len)	int item;
+#define __dynamic_array(type, item, len)	u32 item;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -109,6 +126,9 @@
 	if (!ret)							\
 		return 0;
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)	__field(type, item)
+
 #undef __array
 #define __array(type, item, len)						\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
@@ -120,7 +140,7 @@
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
-	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
+	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
 			       "offset:%u;\tsize:%u;\n",		       \
 			       (unsigned int)offsetof(typeof(field),	       \
 					__data_loc_##item),		       \
@@ -150,7 +170,8 @@
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
 {									\
 	struct ftrace_raw_##call field __attribute__((unused));		\
 	int ret = 0;							\
@@ -210,7 +231,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 
 #undef __get_dynamic_array
 #define __get_dynamic_array(field)	\
-		((void *)__entry + __entry->__data_loc_##field)
+		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
@@ -263,28 +284,33 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 	
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef __field
-#define __field(type, item)						\
+#undef __field_ext
+#define __field_ext(type, item, filter_type)				\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed_type(type));	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), filter_type);	\
 	if (ret)							\
 		return ret;
 
+#undef __field
+#define __field(type, item)	__field_ext(type, item, FILTER_OTHER)
+
 #undef __array
 #define __array(type, item, len)					\
 	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0);		\
+				 sizeof(field.item), 0, FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				       \
-	ret = trace_define_field(event_call, "__data_loc" "[" #type "]", #item,\
-				offsetof(typeof(field), __data_loc_##item),    \
-				 sizeof(field.__data_loc_##item), 0);
+	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
+				 offsetof(typeof(field), __data_loc_##item),   \
+				 sizeof(field.__data_loc_##item), 0,	       \
+				 FILTER_OTHER);
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
@@ -292,17 +318,14 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 int									\
-ftrace_define_fields_##call(void)					\
+ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	int ret;							\
 									\
-	__common_field(int, type, 1);					\
-	__common_field(unsigned char, flags, 0);			\
-	__common_field(unsigned char, preempt_count, 0);		\
-	__common_field(int, pid, 1);					\
-	__common_field(int, tgid, 1);					\
+	ret = trace_define_common_fields(event_call);			\
+	if (ret)							\
+		return ret;						\
 									\
 	tstruct;							\
 									\
@@ -321,6 +344,9 @@ ftrace_define_fields_##call(void)					\
 #undef __field
 #define __field(type, item)
 
+#undef __field_ext
+#define __field_ext(type, item, filter_type)
+
 #undef __array
 #define __array(type, item, len)
 
@@ -328,6 +354,7 @@ ftrace_define_fields_##call(void)					\
 #define __dynamic_array(type, item, len)				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
+	__data_offsets->item |= (len * sizeof(type)) << 16;		\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
@@ -433,13 +460,15 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  * {
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ *	struct ring_buffer *buffer;
  *	unsigned long irq_flags;
  *	int pc;
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
  *
- *	event = trace_current_buffer_lock_reserve(event_<call>.id,
+ *	event = trace_current_buffer_lock_reserve(&buffer,
+ *				  event_<call>.id,
  *				  sizeof(struct ftrace_raw_<call>),
  *				  irq_flags, pc);
  *	if (!event)
@@ -449,7 +478,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	<assign>;  <-- Here we assign the entries by the __field and
  *			__array macros.
  *
- *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
+ *	trace_current_buffer_unlock_commit(buffer, event, irq_flags, pc);
  * }
  *
  * static int ftrace_raw_reg_event_<call>(void)
@@ -541,6 +570,7 @@ static void ftrace_raw_event_##call(proto)				\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
+	struct ring_buffer *buffer;					\
 	unsigned long irq_flags;					\
 	int __data_size;						\
 	int pc;								\
@@ -550,7 +580,8 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	event = trace_current_buffer_lock_reserve(event_##call.id,	\
+	event = trace_current_buffer_lock_reserve(&buffer,		\
+				 event_##call.id,			\
 				 sizeof(*entry) + __data_size,		\
 				 irq_flags, pc);			\
 	if (!event)							\
@@ -562,11 +593,12 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	{ assign; }							\
 									\
-	if (!filter_current_check_discard(event_call, entry, event))	\
-		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
+	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
+		trace_nowake_buffer_unlock_commit(buffer,		\
+						  event, irq_flags, pc); \
 }									\
 									\
-static int ftrace_raw_reg_event_##call(void)				\
+static int ftrace_raw_reg_event_##call(void *ptr)			\
 {									\
 	int ret;							\
 									\
@@ -577,7 +609,7 @@ static int ftrace_raw_reg_event_##call(void)				\
 	return ret;							\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(void)				\
+static void ftrace_raw_unreg_event_##call(void *ptr)			\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
@@ -595,7 +627,6 @@ static int ftrace_raw_init_event_##call(void)				\
 		return -ENODEV;						\
 	event_##call.id = id;						\
 	INIT_LIST_HEAD(&event_##call.fields);				\
-	init_preds(&event_##call);					\
 	return 0;							\
 }									\
 									\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 8cfe515..5dc283b 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -1,8 +1,13 @@
 #ifndef _TRACE_SYSCALL_H
 #define _TRACE_SYSCALL_H
 
+#include <linux/tracepoint.h>
+#include <linux/unistd.h>
+#include <linux/ftrace_event.h>
+
 #include <asm/ptrace.h>
 
+
 /*
  * A syscall entry in the ftrace syscalls array.
  *
@@ -10,26 +15,49 @@
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
+ * @enter_id: associated ftrace enter event id
+ * @exit_id: associated ftrace exit event id
+ * @enter_event: associated syscall_enter trace event
+ * @exit_event: associated syscall_exit trace event
  */
 struct syscall_metadata {
 	const char	*name;
 	int		nb_args;
 	const char	**types;
 	const char	**args;
+	int		enter_id;
+	int		exit_id;
+
+	struct ftrace_event_call *enter_event;
+	struct ftrace_event_call *exit_event;
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-extern void arch_init_ftrace_syscalls(void);
 extern struct syscall_metadata *syscall_nr_to_meta(int nr);
-extern void start_ftrace_syscalls(void);
-extern void stop_ftrace_syscalls(void);
-extern void ftrace_syscall_enter(struct pt_regs *regs);
-extern void ftrace_syscall_exit(struct pt_regs *regs);
-#else
-static inline void start_ftrace_syscalls(void)			{ }
-static inline void stop_ftrace_syscalls(void)			{ }
-static inline void ftrace_syscall_enter(struct pt_regs *regs)	{ }
-static inline void ftrace_syscall_exit(struct pt_regs *regs)	{ }
+extern int syscall_name_to_nr(char *name);
+void set_syscall_enter_id(int num, int id);
+void set_syscall_exit_id(int num, int id);
+extern struct trace_event event_syscall_enter;
+extern struct trace_event event_syscall_exit;
+extern int reg_event_syscall_enter(void *ptr);
+extern void unreg_event_syscall_enter(void *ptr);
+extern int reg_event_syscall_exit(void *ptr);
+extern void unreg_event_syscall_exit(void *ptr);
+extern int syscall_enter_format(struct ftrace_event_call *call,
+				struct trace_seq *s);
+extern int syscall_exit_format(struct ftrace_event_call *call,
+				struct trace_seq *s);
+extern int syscall_enter_define_fields(struct ftrace_event_call *call);
+extern int syscall_exit_define_fields(struct ftrace_event_call *call);
+enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
+enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
+#endif
+#ifdef CONFIG_EVENT_PROFILE
+int reg_prof_syscall_enter(char *name);
+void unreg_prof_syscall_enter(char *name);
+int reg_prof_syscall_exit(char *name);
+void unreg_prof_syscall_exit(char *name);
+
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 385c31a..a922808 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -37,6 +37,8 @@
 #include <linux/suspend.h>
 #include <asm/uaccess.h>
 
+#include <trace/events/module.h>
+
 extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
@@ -108,6 +110,8 @@ int __request_module(bool wait, const char *fmt, ...)
 		return -ENOMEM;
 	}
 
+	trace_module_request(module_name, wait, _RET_IP_);
+
 	ret = call_usermodehelper(modprobe_path, argv, envp,
 			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 	atomic_dec(&kmod_concurrent);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 0540948..ef177d6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -103,7 +103,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 #define INSNS_PER_PAGE	(PAGE_SIZE/(MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
 
 struct kprobe_insn_page {
-	struct hlist_node hlist;
+	struct list_head list;
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
 	char slot_used[INSNS_PER_PAGE];
 	int nused;
@@ -117,7 +117,7 @@ enum kprobe_slot_state {
 };
 
 static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_pages */
-static struct hlist_head kprobe_insn_pages;
+static LIST_HEAD(kprobe_insn_pages);
 static int kprobe_garbage_slots;
 static int collect_garbage_slots(void);
 
@@ -152,10 +152,9 @@ loop_end:
 static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 {
 	struct kprobe_insn_page *kip;
-	struct hlist_node *pos;
 
  retry:
-	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
+	list_for_each_entry(kip, &kprobe_insn_pages, list) {
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
 			for (i = 0; i < INSNS_PER_PAGE; i++) {
@@ -189,8 +188,8 @@ static kprobe_opcode_t __kprobes *__get_insn_slot(void)
 		kfree(kip);
 		return NULL;
 	}
-	INIT_HLIST_NODE(&kip->hlist);
-	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
+	INIT_LIST_HEAD(&kip->list);
+	list_add(&kip->list, &kprobe_insn_pages);
 	memset(kip->slot_used, SLOT_CLEAN, INSNS_PER_PAGE);
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
@@ -219,12 +218,8 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 		 * so as not to have to set it up again the
 		 * next time somebody inserts a probe.
 		 */
-		hlist_del(&kip->hlist);
-		if (hlist_empty(&kprobe_insn_pages)) {
-			INIT_HLIST_NODE(&kip->hlist);
-			hlist_add_head(&kip->hlist,
-				       &kprobe_insn_pages);
-		} else {
+		if (!list_is_singular(&kprobe_insn_pages)) {
+			list_del(&kip->list);
 			module_free(NULL, kip->insns);
 			kfree(kip);
 		}
@@ -235,14 +230,13 @@ static int __kprobes collect_one_slot(struct kprobe_insn_page *kip, int idx)
 
 static int __kprobes collect_garbage_slots(void)
 {
-	struct kprobe_insn_page *kip;
-	struct hlist_node *pos, *next;
+	struct kprobe_insn_page *kip, *next;
 
 	/* Ensure no-one is preepmted on the garbages */
 	if (check_safety())
 		return -EAGAIN;
 
-	hlist_for_each_entry_safe(kip, pos, next, &kprobe_insn_pages, hlist) {
+	list_for_each_entry_safe(kip, next, &kprobe_insn_pages, list) {
 		int i;
 		if (kip->ngarbage == 0)
 			continue;
@@ -260,19 +254,17 @@ static int __kprobes collect_garbage_slots(void)
 void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
-	struct hlist_node *pos;
 
 	mutex_lock(&kprobe_insn_mutex);
-	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
+	list_for_each_entry(kip, &kprobe_insn_pages, list) {
 		if (kip->insns <= slot &&
 		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
 			int i = (slot - kip->insns) / MAX_INSN_SIZE;
 			if (dirty) {
 				kip->slot_used[i] = SLOT_DIRTY;
 				kip->ngarbage++;
-			} else {
+			} else
 				collect_one_slot(kip, i);
-			}
 			break;
 		}
 	}
diff --git a/kernel/module.c b/kernel/module.c
index 2d53718..46580ed 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,11 @@
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/module.h>
+
+EXPORT_TRACEPOINT_SYMBOL(module_get);
+
 #if 0
 #define DEBUGP printk
 #else
@@ -942,6 +947,8 @@ void module_put(struct module *module)
 	if (module) {
 		unsigned int cpu = get_cpu();
 		local_dec(__module_ref_addr(module, cpu));
+		trace_module_put(module, _RET_IP_,
+				 local_read(__module_ref_addr(module, cpu)));
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
@@ -1497,6 +1504,8 @@ static int __unlink_module(void *_mod)
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
+	trace_module_free(mod);
+
 	/* Delete from various lists */
 	stop_machine(__unlink_module, mod, NULL);
 	remove_notes_attrs(mod);
@@ -2364,6 +2373,8 @@ static noinline struct module *load_module(void __user *umod,
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
+	trace_module_load(mod);
+
 	/* Done! */
 	return mod;
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 019f380..1ea0d12 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -41,7 +41,7 @@ config HAVE_FTRACE_MCOUNT_RECORD
 config HAVE_HW_BRANCH_TRACER
 	bool
 
-config HAVE_FTRACE_SYSCALLS
+config HAVE_SYSCALL_TRACEPOINTS
 	bool
 
 config TRACER_MAX_TRACE
@@ -60,9 +60,14 @@ config EVENT_TRACING
 	bool
 
 config CONTEXT_SWITCH_TRACER
-	select MARKERS
 	bool
 
+config RING_BUFFER_ALLOW_SWAP
+	bool
+	help
+	 Allow the use of ring_buffer_swap_cpu.
+	 Adds a very slight overhead to tracing when enabled.
+
 # All tracer options should select GENERIC_TRACER. For those options that are
 # enabled by all tracers (context switch and event tracer) they select TRACING.
 # This allows those options to appear when no other tracer is selected. But the
@@ -147,6 +152,7 @@ config IRQSOFF_TRACER
 	select TRACE_IRQFLAGS
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -168,6 +174,7 @@ config PREEMPT_TRACER
 	depends on PREEMPT
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  This option measures the time spent in preemption off critical
 	  sections, with microsecond accuracy.
@@ -211,7 +218,7 @@ config ENABLE_DEFAULT_TRACERS
 
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
-	depends on HAVE_FTRACE_SYSCALLS
+	depends on HAVE_SYSCALL_TRACEPOINTS
 	select GENERIC_TRACER
 	select KALLSYMS
 	help
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7a34cb5..3eb159c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -65,13 +65,15 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 	struct ring_buffer_event *event = NULL;
+	struct ring_buffer *buffer = NULL;
 	int pc = 0;
 	int cpu = smp_processor_id();
 	bool blk_tracer = blk_tracer_enabled;
 
 	if (blk_tracer) {
+		buffer = blk_tr->buffer;
 		pc = preempt_count();
-		event = trace_buffer_lock_reserve(blk_tr, TRACE_BLK,
+		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + len,
 						  0, pc);
 		if (!event)
@@ -96,7 +98,7 @@ record_it:
 		memcpy((void *) t + sizeof(*t), data, len);
 
 		if (blk_tracer)
-			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
+			trace_buffer_unlock_commit(buffer, event, 0, pc);
 	}
 }
 
@@ -179,6 +181,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 {
 	struct task_struct *tsk = current;
 	struct ring_buffer_event *event = NULL;
+	struct ring_buffer *buffer = NULL;
 	struct blk_io_trace *t;
 	unsigned long flags = 0;
 	unsigned long *sequence;
@@ -204,8 +207,9 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (blk_tracer) {
 		tracing_record_cmdline(current);
 
+		buffer = blk_tr->buffer;
 		pc = preempt_count();
-		event = trace_buffer_lock_reserve(blk_tr, TRACE_BLK,
+		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + pdu_len,
 						  0, pc);
 		if (!event)
@@ -252,7 +256,7 @@ record_it:
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
 
 		if (blk_tracer) {
-			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
+			trace_buffer_unlock_commit(buffer, event, 0, pc);
 			return;
 		}
 	}
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 25edd5c..8c804e2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1016,71 +1016,35 @@ static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ftrace_addr;
-	unsigned long ip, fl;
+	unsigned long flag = 0UL;
 
 	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
-	ip = rec->ip;
-
 	/*
-	 * If this record is not to be traced and
-	 * it is not enabled then do nothing.
+	 * If this record is not to be traced or we want to disable it,
+	 * then disable it.
 	 *
-	 * If this record is not to be traced and
-	 * it is enabled then disable it.
+	 * If we want to enable it and filtering is off, then enable it.
 	 *
+	 * If we want to enable it and filtering is on, enable it only if
+	 * it's filtered
 	 */
-	if (rec->flags & FTRACE_FL_NOTRACE) {
-		if (rec->flags & FTRACE_FL_ENABLED)
-			rec->flags &= ~FTRACE_FL_ENABLED;
-		else
-			return 0;
-
-	} else if (ftrace_filtered && enable) {
-		/*
-		 * Filtering is on:
-		 */
-
-		fl = rec->flags & (FTRACE_FL_FILTER | FTRACE_FL_ENABLED);
-
-		/* Record is filtered and enabled, do nothing */
-		if (fl == (FTRACE_FL_FILTER | FTRACE_FL_ENABLED))
-			return 0;
-
-		/* Record is not filtered or enabled, do nothing */
-		if (!fl)
-			return 0;
-
-		/* Record is not filtered but enabled, disable it */
-		if (fl == FTRACE_FL_ENABLED)
-			rec->flags &= ~FTRACE_FL_ENABLED;
-		else
-		/* Otherwise record is filtered but not enabled, enable it */
-			rec->flags |= FTRACE_FL_ENABLED;
-	} else {
-		/* Disable or not filtered */
-
-		if (enable) {
-			/* if record is enabled, do nothing */
-			if (rec->flags & FTRACE_FL_ENABLED)
-				return 0;
-
-			rec->flags |= FTRACE_FL_ENABLED;
-
-		} else {
+	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
+		if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
+			flag = FTRACE_FL_ENABLED;
+	}
 
-			/* if record is not enabled, do nothing */
-			if (!(rec->flags & FTRACE_FL_ENABLED))
-				return 0;
+	/* If the state of this record hasn't changed, then do nothing */
+	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
+		return 0;
 
-			rec->flags &= ~FTRACE_FL_ENABLED;
-		}
+	if (flag) {
+		rec->flags |= FTRACE_FL_ENABLED;
+		return ftrace_make_call(rec, ftrace_addr);
 	}
 
-	if (rec->flags & FTRACE_FL_ENABLED)
-		return ftrace_make_call(rec, ftrace_addr);
-	else
-		return ftrace_make_nop(NULL, rec, ftrace_addr);
+	rec->flags &= ~FTRACE_FL_ENABLED;
+	return ftrace_make_nop(NULL, rec, ftrace_addr);
 }
 
 static void ftrace_replace_code(int enable)
@@ -1375,7 +1339,6 @@ struct ftrace_iterator {
 	unsigned		flags;
 	unsigned char		buffer[FTRACE_BUFF_MAX+1];
 	unsigned		buffer_idx;
-	unsigned		filtered;
 };
 
 static void *
@@ -1438,18 +1401,13 @@ static int t_hash_show(struct seq_file *m, void *v)
 {
 	struct ftrace_func_probe *rec;
 	struct hlist_node *hnd = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	rec = hlist_entry(hnd, struct ftrace_func_probe, node);
 
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-	seq_printf(m, "%s:", str);
-
-	kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
-	seq_printf(m, "%s", str);
+	seq_printf(m, "%pf:%pf", (void *)rec->ip, (void *)rec->ops->func);
 
 	if (rec->data)
 		seq_printf(m, ":%p", rec->data);
@@ -1547,7 +1505,6 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
 	struct dyn_ftrace *rec = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_show(m, v);
@@ -1560,9 +1517,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
-
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%pf\n", (void *)rec->ip);
 
 	return 0;
 }
@@ -1601,17 +1556,6 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-int ftrace_avail_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct ftrace_iterator *iter = m->private;
-
-	seq_release(inode, file);
-	kfree(iter);
-
-	return 0;
-}
-
 static int
 ftrace_failures_open(struct inode *inode, struct file *file)
 {
@@ -2317,7 +2261,6 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (isspace(ch)) {
-		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
 		ret = ftrace_process_regex(iter->buffer,
 					   iter->buffer_idx, enable);
@@ -2448,7 +2391,6 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		iter = file->private_data;
 
 	if (iter->buffer_idx) {
-		iter->filtered++;
 		iter->buffer[iter->buffer_idx] = 0;
 		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
 	}
@@ -2479,14 +2421,14 @@ static const struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = ftrace_avail_release,
+	.release = seq_release_private,
 };
 
 static const struct file_operations ftrace_failures_fops = {
 	.open = ftrace_failures_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = ftrace_avail_release,
+	.release = seq_release_private,
 };
 
 static const struct file_operations ftrace_filter_fops = {
@@ -2548,7 +2490,6 @@ static void g_stop(struct seq_file *m, void *p)
 static int g_show(struct seq_file *m, void *v)
 {
 	unsigned long *ptr = v;
-	char str[KSYM_SYMBOL_LEN];
 
 	if (!ptr)
 		return 0;
@@ -2558,9 +2499,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
-
-	seq_printf(m, "%s\n", str);
+	seq_printf(m, "%pf\n", v);
 
 	return 0;
 }
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 1edaa95..81b1645 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -183,11 +183,9 @@ static void kmemtrace_stop_probes(void)
 
 static int kmem_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	kmemtrace_array = tr;
 
-	for_each_cpu(cpu, cpu_possible_mask)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 
 	kmemtrace_start_probes();
 
@@ -239,12 +237,52 @@ struct kmemtrace_user_event_alloc {
 };
 
 static enum print_line_t
-kmemtrace_print_alloc_user(struct trace_iterator *iter,
-			   struct kmemtrace_alloc_entry *entry)
+kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
 {
-	struct kmemtrace_user_event_alloc *ev_alloc;
 	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_alloc_entry *entry;
+	int ret;
+
+	trace_assign_type(entry, iter->ent);
+
+	ret = trace_seq_printf(s, "type_id %d call_site %pF ptr %lu "
+	    "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
+	    entry->type_id, (void *)entry->call_site, (unsigned long)entry->ptr,
+	    (unsigned long)entry->bytes_req, (unsigned long)entry->bytes_alloc,
+	    (unsigned long)entry->gfp_flags, entry->node);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_free(struct trace_iterator *iter, int flags)
+{
+	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_free_entry *entry;
+	int ret;
+
+	trace_assign_type(entry, iter->ent);
+
+	ret = trace_seq_printf(s, "type_id %d call_site %pF ptr %lu\n",
+			       entry->type_id, (void *)entry->call_site,
+			       (unsigned long)entry->ptr);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
+{
+	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_alloc_entry *entry;
 	struct kmemtrace_user_event *ev;
+	struct kmemtrace_user_event_alloc *ev_alloc;
+
+	trace_assign_type(entry, iter->ent);
 
 	ev = trace_seq_reserve(s, sizeof(*ev));
 	if (!ev)
@@ -271,12 +309,14 @@ kmemtrace_print_alloc_user(struct trace_iterator *iter,
 }
 
 static enum print_line_t
-kmemtrace_print_free_user(struct trace_iterator *iter,
-			  struct kmemtrace_free_entry *entry)
+kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
 {
 	struct trace_seq *s = &iter->seq;
+	struct kmemtrace_free_entry *entry;
 	struct kmemtrace_user_event *ev;
 
+	trace_assign_type(entry, iter->ent);
+
 	ev = trace_seq_reserve(s, sizeof(*ev));
 	if (!ev)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -294,12 +334,14 @@ kmemtrace_print_free_user(struct trace_iterator *iter,
 
 /* The two other following provide a more minimalistic output */
 static enum print_line_t
-kmemtrace_print_alloc_compress(struct trace_iterator *iter,
-					struct kmemtrace_alloc_entry *entry)
+kmemtrace_print_alloc_compress(struct trace_iterator *iter)
 {
+	struct kmemtrace_alloc_entry *entry;
 	struct trace_seq *s = &iter->seq;
 	int ret;
 
+	trace_assign_type(entry, iter->ent);
+
 	/* Alloc entry */
 	ret = trace_seq_printf(s, "  +      ");
 	if (!ret)
@@ -345,29 +387,24 @@ kmemtrace_print_alloc_compress(struct trace_iterator *iter,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Node */
-	ret = trace_seq_printf(s, "%4d   ", entry->node);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	/* Call site */
-	ret = seq_print_ip_sym(s, entry->call_site, 0);
+	/* Node and call site*/
+	ret = trace_seq_printf(s, "%4d   %pf\n", entry->node,
+						 (void *)entry->call_site);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (!trace_seq_printf(s, "\n"))
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	return TRACE_TYPE_HANDLED;
 }
 
 static enum print_line_t
-kmemtrace_print_free_compress(struct trace_iterator *iter,
-			      struct kmemtrace_free_entry *entry)
+kmemtrace_print_free_compress(struct trace_iterator *iter)
 {
+	struct kmemtrace_free_entry *entry;
 	struct trace_seq *s = &iter->seq;
 	int ret;
 
+	trace_assign_type(entry, iter->ent);
+
 	/* Free entry */
 	ret = trace_seq_printf(s, "  -      ");
 	if (!ret)
@@ -401,19 +438,11 @@ kmemtrace_print_free_compress(struct trace_iterator *iter,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Skip node */
-	ret = trace_seq_printf(s, "       ");
+	/* Skip node and print call site*/
+	ret = trace_seq_printf(s, "       %pf\n", (void *)entry->call_site);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Call site */
-	ret = seq_print_ip_sym(s, entry->call_site, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	if (!trace_seq_printf(s, "\n"))
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -421,32 +450,31 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 
-	switch (entry->type) {
-	case TRACE_KMEM_ALLOC: {
-		struct kmemtrace_alloc_entry *field;
-
-		trace_assign_type(field, entry);
-		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
-			return kmemtrace_print_alloc_compress(iter, field);
-		else
-			return kmemtrace_print_alloc_user(iter, field);
-	}
-
-	case TRACE_KMEM_FREE: {
-		struct kmemtrace_free_entry *field;
-
-		trace_assign_type(field, entry);
-		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
-			return kmemtrace_print_free_compress(iter, field);
-		else
-			return kmemtrace_print_free_user(iter, field);
-	}
+	if (!(kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL))
+		return TRACE_TYPE_UNHANDLED;
 
+	switch (entry->type) {
+	case TRACE_KMEM_ALLOC:
+		return kmemtrace_print_alloc_compress(iter);
+	case TRACE_KMEM_FREE:
+		return kmemtrace_print_free_compress(iter);
 	default:
 		return TRACE_TYPE_UNHANDLED;
 	}
 }
 
+static struct trace_event kmem_trace_alloc = {
+	.type			= TRACE_KMEM_ALLOC,
+	.trace			= kmemtrace_print_alloc,
+	.binary			= kmemtrace_print_alloc_user,
+};
+
+static struct trace_event kmem_trace_free = {
+	.type			= TRACE_KMEM_FREE,
+	.trace			= kmemtrace_print_free,
+	.binary			= kmemtrace_print_free_user,
+};
+
 static struct tracer kmem_tracer __read_mostly = {
 	.name			= "kmemtrace",
 	.init			= kmem_trace_init,
@@ -463,6 +491,21 @@ void kmemtrace_init(void)
 
 static int __init init_kmem_tracer(void)
 {
-	return register_tracer(&kmem_tracer);
+	if (!register_ftrace_event(&kmem_trace_alloc)) {
+		pr_warning("Warning: could not register kmem events\n");
+		return 1;
+	}
+
+	if (!register_ftrace_event(&kmem_trace_free)) {
+		pr_warning("Warning: could not register kmem events\n");
+		return 1;
+	}
+
+	if (!register_tracer(&kmem_tracer)) {
+		pr_warning("Warning: could not register the kmem tracer\n");
+		return 1;
+	}
+
+	return 0;
 }
 device_initcall(init_kmem_tracer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a330513..454e74e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -218,17 +218,12 @@ enum {
 
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
-	return event->type_len == RINGBUF_TYPE_PADDING
-			&& event->time_delta == 0;
-}
-
-static inline int rb_discarded_event(struct ring_buffer_event *event)
-{
-	return event->type_len == RINGBUF_TYPE_PADDING && event->time_delta;
+	return event->type_len == RINGBUF_TYPE_PADDING && !event->time_delta;
 }
 
 static void rb_event_set_padding(struct ring_buffer_event *event)
 {
+	/* padding has a NULL time_delta */
 	event->type_len = RINGBUF_TYPE_PADDING;
 	event->time_delta = 0;
 }
@@ -322,6 +317,14 @@ struct buffer_data_page {
 	unsigned char	 data[];	/* data of buffer page */
 };
 
+/*
+ * Note, the buffer_page list must be first. The buffer pages
+ * are allocated in cache lines, which means that each buffer
+ * page will be at the beginning of a cache line, and thus
+ * the least significant bits will be zero. We use this to
+ * add flags in the list struct pointers, to make the ring buffer
+ * lockless.
+ */
 struct buffer_page {
 	struct list_head list;		/* list of buffer pages */
 	local_t		 write;		/* index for next write */
@@ -330,6 +333,21 @@ struct buffer_page {
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
+/*
+ * The buffer page counters, write and entries, must be reset
+ * atomically when crossing page boundaries. To synchronize this
+ * update, two counters are inserted into the number. One is
+ * the actual counter for the write position or count on the page.
+ *
+ * The other is a counter of updaters. Before an update happens
+ * the update partition of the counter is incremented. This will
+ * allow the updater to update the counter atomically.
+ *
+ * The counter is 20 bits, and the state data is 12.
+ */
+#define RB_WRITE_MASK		0xfffff
+#define RB_WRITE_INTCNT		(1 << 20)
+
 static void rb_init_page(struct buffer_data_page *bpage)
 {
 	local_set(&bpage->commit, 0);
@@ -403,21 +421,20 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
-	spinlock_t			reader_lock; /* serialize readers */
+	spinlock_t			reader_lock;	/* serialize readers */
 	raw_spinlock_t			lock;
 	struct lock_class_key		lock_key;
-	struct list_head		pages;
+	struct list_head		*pages;
 	struct buffer_page		*head_page;	/* read from head */
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
-	unsigned long			nmi_dropped;
-	unsigned long			commit_overrun;
-	unsigned long			overrun;
-	unsigned long			read;
+	local_t				commit_overrun;
+	local_t				overrun;
 	local_t				entries;
 	local_t				committing;
 	local_t				commits;
+	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -450,14 +467,19 @@ struct ring_buffer_iter {
 };
 
 /* buffer may be either ring_buffer or ring_buffer_per_cpu */
-#define RB_WARN_ON(buffer, cond)				\
-	({							\
-		int _____ret = unlikely(cond);			\
-		if (_____ret) {					\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-		}						\
-		_____ret;					\
+#define RB_WARN_ON(b, cond)						\
+	({								\
+		int _____ret = unlikely(cond);				\
+		if (_____ret) {						\
+			if (__same_type(*(b), struct ring_buffer_per_cpu)) { \
+				struct ring_buffer_per_cpu *__b =	\
+					(void *)b;			\
+				atomic_inc(&__b->buffer->record_disabled); \
+			} else						\
+				atomic_inc(&b->record_disabled);	\
+			WARN_ON(1);					\
+		}							\
+		_____ret;						\
 	})
 
 /* Up this if you want to test the TIME_EXTENTS and normalization */
@@ -489,6 +511,390 @@ void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 
+/*
+ * Making the ring buffer lockless makes things tricky.
+ * Although writes only happen on the CPU that they are on,
+ * and they only need to worry about interrupts. Reads can
+ * happen on any CPU.
+ *
+ * The reader page is always off the ring buffer, but when the
+ * reader finishes with a page, it needs to swap its page with
+ * a new one from the buffer. The reader needs to take from
+ * the head (writes go to the tail). But if a writer is in overwrite
+ * mode and wraps, it must push the head page forward.
+ *
+ * Here lies the problem.
+ *
+ * The reader must be careful to replace only the head page, and
+ * not another one. As described at the top of the file in the
+ * ASCII art, the reader sets its old page to point to the next
+ * page after head. It then sets the page after head to point to
+ * the old reader page. But if the writer moves the head page
+ * during this operation, the reader could end up with the tail.
+ *
+ * We use cmpxchg to help prevent this race. We also do something
+ * special with the page before head. We set the LSB to 1.
+ *
+ * When the writer must push the page forward, it will clear the
+ * bit that points to the head page, move the head, and then set
+ * the bit that points to the new head page.
+ *
+ * We also don't want an interrupt coming in and moving the head
+ * page on another writer. Thus we use the second LSB to catch
+ * that too. Thus:
+ *
+ * head->list->prev->next        bit 1          bit 0
+ *                              -------        -------
+ * Normal page                     0              0
+ * Points to head page             0              1
+ * New head page                   1              0
+ *
+ * Note we can not trust the prev pointer of the head page, because:
+ *
+ * +----+       +-----+        +-----+
+ * |    |------>|  T  |---X--->|  N  |
+ * |    |<------|     |        |     |
+ * +----+       +-----+        +-----+
+ *   ^                           ^ |
+ *   |          +-----+          | |
+ *   +----------|  R  |----------+ |
+ *              |     |<-----------+
+ *              +-----+
+ *
+ * Key:  ---X-->  HEAD flag set in pointer
+ *         T      Tail page
+ *         R      Reader page
+ *         N      Next page
+ *
+ * (see __rb_reserve_next() to see where this happens)
+ *
+ *  What the above shows is that the reader just swapped out
+ *  the reader page with a page in the buffer, but before it
+ *  could make the new header point back to the new page added
+ *  it was preempted by a writer. The writer moved forward onto
+ *  the new page added by the reader and is about to move forward
+ *  again.
+ *
+ *  You can see, it is legitimate for the previous pointer of
+ *  the head (or any page) not to point back to itself. But only
+ *  temporarially.
+ */
+
+#define RB_PAGE_NORMAL		0UL
+#define RB_PAGE_HEAD		1UL
+#define RB_PAGE_UPDATE		2UL
+
+
+#define RB_FLAG_MASK		3UL
+
+/* PAGE_MOVED is not part of the mask */
+#define RB_PAGE_MOVED		4UL
+
+/*
+ * rb_list_head - remove any bit
+ */
+static struct list_head *rb_list_head(struct list_head *list)
+{
+	unsigned long val = (unsigned long)list;
+
+	return (struct list_head *)(val & ~RB_FLAG_MASK);
+}
+
+/*
+ * rb_is_head_page - test if the give page is the head page
+ *
+ * Because the reader may move the head_page pointer, we can
+ * not trust what the head page is (it may be pointing to
+ * the reader page). But if the next page is a header page,
+ * its flags will be non zero.
+ */
+static int inline
+rb_is_head_page(struct ring_buffer_per_cpu *cpu_buffer,
+		struct buffer_page *page, struct list_head *list)
+{
+	unsigned long val;
+
+	val = (unsigned long)list->next;
+
+	if ((val & ~RB_FLAG_MASK) != (unsigned long)&page->list)
+		return RB_PAGE_MOVED;
+
+	return val & RB_FLAG_MASK;
+}
+
+/*
+ * rb_is_reader_page
+ *
+ * The unique thing about the reader page, is that, if the
+ * writer is ever on it, the previous pointer never points
+ * back to the reader page.
+ */
+static int rb_is_reader_page(struct buffer_page *page)
+{
+	struct list_head *list = page->list.prev;
+
+	return rb_list_head(list->next) != &page->list;
+}
+
+/*
+ * rb_set_list_to_head - set a list_head to be pointing to head.
+ */
+static void rb_set_list_to_head(struct ring_buffer_per_cpu *cpu_buffer,
+				struct list_head *list)
+{
+	unsigned long *ptr;
+
+	ptr = (unsigned long *)&list->next;
+	*ptr |= RB_PAGE_HEAD;
+	*ptr &= ~RB_PAGE_UPDATE;
+}
+
+/*
+ * rb_head_page_activate - sets up head page
+ */
+static void rb_head_page_activate(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *head;
+
+	head = cpu_buffer->head_page;
+	if (!head)
+		return;
+
+	/*
+	 * Set the previous list pointer to have the HEAD flag.
+	 */
+	rb_set_list_to_head(cpu_buffer, head->list.prev);
+}
+
+static void rb_list_head_clear(struct list_head *list)
+{
+	unsigned long *ptr = (unsigned long *)&list->next;
+
+	*ptr &= ~RB_FLAG_MASK;
+}
+
+/*
+ * rb_head_page_dactivate - clears head page ptr (for free list)
+ */
+static void
+rb_head_page_deactivate(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct list_head *hd;
+
+	/* Go through the whole list and clear any pointers found. */
+	rb_list_head_clear(cpu_buffer->pages);
+
+	list_for_each(hd, cpu_buffer->pages)
+		rb_list_head_clear(hd);
+}
+
+static int rb_head_page_set(struct ring_buffer_per_cpu *cpu_buffer,
+			    struct buffer_page *head,
+			    struct buffer_page *prev,
+			    int old_flag, int new_flag)
+{
+	struct list_head *list;
+	unsigned long val = (unsigned long)&head->list;
+	unsigned long ret;
+
+	list = &prev->list;
+
+	val &= ~RB_FLAG_MASK;
+
+	ret = (unsigned long)cmpxchg(&list->next,
+				     val | old_flag, val | new_flag);
+
+	/* check if the reader took the page */
+	if ((ret & ~RB_FLAG_MASK) != val)
+		return RB_PAGE_MOVED;
+
+	return ret & RB_FLAG_MASK;
+}
+
+static int rb_head_page_set_update(struct ring_buffer_per_cpu *cpu_buffer,
+				   struct buffer_page *head,
+				   struct buffer_page *prev,
+				   int old_flag)
+{
+	return rb_head_page_set(cpu_buffer, head, prev,
+				old_flag, RB_PAGE_UPDATE);
+}
+
+static int rb_head_page_set_head(struct ring_buffer_per_cpu *cpu_buffer,
+				 struct buffer_page *head,
+				 struct buffer_page *prev,
+				 int old_flag)
+{
+	return rb_head_page_set(cpu_buffer, head, prev,
+				old_flag, RB_PAGE_HEAD);
+}
+
+static int rb_head_page_set_normal(struct ring_buffer_per_cpu *cpu_buffer,
+				   struct buffer_page *head,
+				   struct buffer_page *prev,
+				   int old_flag)
+{
+	return rb_head_page_set(cpu_buffer, head, prev,
+				old_flag, RB_PAGE_NORMAL);
+}
+
+static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
+			       struct buffer_page **bpage)
+{
+	struct list_head *p = rb_list_head((*bpage)->list.next);
+
+	*bpage = list_entry(p, struct buffer_page, list);
+}
+
+static struct buffer_page *
+rb_set_head_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *head;
+	struct buffer_page *page;
+	struct list_head *list;
+	int i;
+
+	if (RB_WARN_ON(cpu_buffer, !cpu_buffer->head_page))
+		return NULL;
+
+	/* sanity check */
+	list = cpu_buffer->pages;
+	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev->next) != list))
+		return NULL;
+
+	page = head = cpu_buffer->head_page;
+	/*
+	 * It is possible that the writer moves the header behind
+	 * where we started, and we miss in one loop.
+	 * A second loop should grab the header, but we'll do
+	 * three loops just because I'm paranoid.
+	 */
+	for (i = 0; i < 3; i++) {
+		do {
+			if (rb_is_head_page(cpu_buffer, page, page->list.prev)) {
+				cpu_buffer->head_page = page;
+				return page;
+			}
+			rb_inc_page(cpu_buffer, &page);
+		} while (page != head);
+	}
+
+	RB_WARN_ON(cpu_buffer, 1);
+
+	return NULL;
+}
+
+static int rb_head_page_replace(struct buffer_page *old,
+				struct buffer_page *new)
+{
+	unsigned long *ptr = (unsigned long *)&old->list.prev->next;
+	unsigned long val;
+	unsigned long ret;
+
+	val = *ptr & ~RB_FLAG_MASK;
+	val |= RB_PAGE_HEAD;
+
+	ret = cmpxchg(ptr, val, &new->list);
+
+	return ret == val;
+}
+
+/*
+ * rb_tail_page_update - move the tail page forward
+ *
+ * Returns 1 if moved tail page, 0 if someone else did.
+ */
+static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
+			       struct buffer_page *tail_page,
+			       struct buffer_page *next_page)
+{
+	struct buffer_page *old_tail;
+	unsigned long old_entries;
+	unsigned long old_write;
+	int ret = 0;
+
+	/*
+	 * The tail page now needs to be moved forward.
+	 *
+	 * We need to reset the tail page, but without messing
+	 * with possible erasing of data brought in by interrupts
+	 * that have moved the tail page and are currently on it.
+	 *
+	 * We add a counter to the write field to denote this.
+	 */
+	old_write = local_add_return(RB_WRITE_INTCNT, &next_page->write);
+	old_entries = local_add_return(RB_WRITE_INTCNT, &next_page->entries);
+
+	/*
+	 * Just make sure we have seen our old_write and synchronize
+	 * with any interrupts that come in.
+	 */
+	barrier();
+
+	/*
+	 * If the tail page is still the same as what we think
+	 * it is, then it is up to us to update the tail
+	 * pointer.
+	 */
+	if (tail_page == cpu_buffer->tail_page) {
+		/* Zero the write counter */
+		unsigned long val = old_write & ~RB_WRITE_MASK;
+		unsigned long eval = old_entries & ~RB_WRITE_MASK;
+
+		/*
+		 * This will only succeed if an interrupt did
+		 * not come in and change it. In which case, we
+		 * do not want to modify it.
+		 *
+		 * We add (void) to let the compiler know that we do not care
+		 * about the return value of these functions. We use the
+		 * cmpxchg to only update if an interrupt did not already
+		 * do it for us. If the cmpxchg fails, we don't care.
+		 */
+		(void)local_cmpxchg(&next_page->write, old_write, val);
+		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
+
+		/*
+		 * No need to worry about races with clearing out the commit.
+		 * it only can increment when a commit takes place. But that
+		 * only happens in the outer most nested commit.
+		 */
+		local_set(&next_page->page->commit, 0);
+
+		old_tail = cmpxchg(&cpu_buffer->tail_page,
+				   tail_page, next_page);
+
+		if (old_tail == tail_page)
+			ret = 1;
+	}
+
+	return ret;
+}
+
+static int rb_check_bpage(struct ring_buffer_per_cpu *cpu_buffer,
+			  struct buffer_page *bpage)
+{
+	unsigned long val = (unsigned long)bpage;
+
+	if (RB_WARN_ON(cpu_buffer, val & RB_FLAG_MASK))
+		return 1;
+
+	return 0;
+}
+
+/**
+ * rb_check_list - make sure a pointer to a list has the last bits zero
+ */
+static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
+			 struct list_head *list)
+{
+	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev) != list->prev))
+		return 1;
+	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->next) != list->next))
+		return 1;
+	return 0;
+}
+
 /**
  * check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
@@ -498,14 +904,19 @@ EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
  */
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = &cpu_buffer->pages;
+	struct list_head *head = cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 
+	rb_head_page_deactivate(cpu_buffer);
+
 	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
 		return -1;
 	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
 		return -1;
 
+	if (rb_check_list(cpu_buffer, head))
+		return -1;
+
 	list_for_each_entry_safe(bpage, tmp, head, list) {
 		if (RB_WARN_ON(cpu_buffer,
 			       bpage->list.next->prev != &bpage->list))
@@ -513,25 +924,33 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 		if (RB_WARN_ON(cpu_buffer,
 			       bpage->list.prev->next != &bpage->list))
 			return -1;
+		if (rb_check_list(cpu_buffer, &bpage->list))
+			return -1;
 	}
 
+	rb_head_page_activate(cpu_buffer);
+
 	return 0;
 }
 
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned nr_pages)
 {
-	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 	unsigned long addr;
 	LIST_HEAD(pages);
 	unsigned i;
 
+	WARN_ON(!nr_pages);
+
 	for (i = 0; i < nr_pages; i++) {
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
 			goto free_pages;
+
+		rb_check_bpage(cpu_buffer, bpage);
+
 		list_add(&bpage->list, &pages);
 
 		addr = __get_free_page(GFP_KERNEL);
@@ -541,7 +960,13 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		rb_init_page(bpage->page);
 	}
 
-	list_splice(&pages, head);
+	/*
+	 * The ring buffer page list is a circular list that does not
+	 * start and end with a list head. All page list items point to
+	 * other pages.
+	 */
+	cpu_buffer->pages = pages.next;
+	list_del(&pages);
 
 	rb_check_pages(cpu_buffer);
 
@@ -573,13 +998,14 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-	INIT_LIST_HEAD(&cpu_buffer->pages);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
 	if (!bpage)
 		goto fail_free_buffer;
 
+	rb_check_bpage(cpu_buffer, bpage);
+
 	cpu_buffer->reader_page = bpage;
 	addr = __get_free_page(GFP_KERNEL);
 	if (!addr)
@@ -594,9 +1020,11 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 		goto fail_free_reader;
 
 	cpu_buffer->head_page
-		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+		= list_entry(cpu_buffer->pages, struct buffer_page, list);
 	cpu_buffer->tail_page = cpu_buffer->commit_page = cpu_buffer->head_page;
 
+	rb_head_page_activate(cpu_buffer);
+
 	return cpu_buffer;
 
  fail_free_reader:
@@ -609,15 +1037,22 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = &cpu_buffer->pages;
+	struct list_head *head = cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 
 	free_buffer_page(cpu_buffer->reader_page);
 
-	list_for_each_entry_safe(bpage, tmp, head, list) {
-		list_del_init(&bpage->list);
+	rb_head_page_deactivate(cpu_buffer);
+
+	if (head) {
+		list_for_each_entry_safe(bpage, tmp, head, list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
+		bpage = list_entry(head, struct buffer_page, list);
 		free_buffer_page(bpage);
 	}
+
 	kfree(cpu_buffer);
 }
 
@@ -760,15 +1195,17 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	rb_head_page_deactivate(cpu_buffer);
+
 	for (i = 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
+		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
 			return;
-		p = cpu_buffer->pages.next;
+		p = cpu_buffer->pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
 		free_buffer_page(bpage);
 	}
-	if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
+	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
 		return;
 
 	rb_reset_cpu(cpu_buffer);
@@ -790,15 +1227,19 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	spin_lock_irq(&cpu_buffer->reader_lock);
+	rb_head_page_deactivate(cpu_buffer);
+
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
 			return;
 		p = pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
-		list_add_tail(&bpage->list, &cpu_buffer->pages);
+		list_add_tail(&bpage->list, cpu_buffer->pages);
 	}
 	rb_reset_cpu(cpu_buffer);
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
 
@@ -949,21 +1390,14 @@ rb_reader_event(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static inline struct ring_buffer_event *
-rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return __rb_page_index(cpu_buffer->head_page,
-			       cpu_buffer->head_page->read);
-}
-
-static inline struct ring_buffer_event *
 rb_iter_head_event(struct ring_buffer_iter *iter)
 {
 	return __rb_page_index(iter->head_page, iter->head);
 }
 
-static inline unsigned rb_page_write(struct buffer_page *bpage)
+static inline unsigned long rb_page_write(struct buffer_page *bpage)
 {
-	return local_read(&bpage->write);
+	return local_read(&bpage->write) & RB_WRITE_MASK;
 }
 
 static inline unsigned rb_page_commit(struct buffer_page *bpage)
@@ -971,6 +1405,11 @@ static inline unsigned rb_page_commit(struct buffer_page *bpage)
 	return local_read(&bpage->page->commit);
 }
 
+static inline unsigned long rb_page_entries(struct buffer_page *bpage)
+{
+	return local_read(&bpage->entries) & RB_WRITE_MASK;
+}
+
 /* Size is determined by what has been commited */
 static inline unsigned rb_page_size(struct buffer_page *bpage)
 {
@@ -983,22 +1422,6 @@ rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
 	return rb_page_commit(cpu_buffer->commit_page);
 }
 
-static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return rb_page_commit(cpu_buffer->head_page);
-}
-
-static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
-			       struct buffer_page **bpage)
-{
-	struct list_head *p = (*bpage)->list.next;
-
-	if (p == &cpu_buffer->pages)
-		p = p->next;
-
-	*bpage = list_entry(p, struct buffer_page, list);
-}
-
 static inline unsigned
 rb_event_index(struct ring_buffer_event *event)
 {
@@ -1024,6 +1447,8 @@ rb_event_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 static void
 rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	unsigned long max_count;
+
 	/*
 	 * We only race with interrupts and NMIs on this CPU.
 	 * If we own the commit event, then we can commit
@@ -1033,9 +1458,16 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	 * assign the commit to the tail.
 	 */
  again:
+	max_count = cpu_buffer->buffer->pages * 100;
+
 	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
-		cpu_buffer->commit_page->page->commit =
-			cpu_buffer->commit_page->write;
+		if (RB_WARN_ON(cpu_buffer, !(--max_count)))
+			return;
+		if (RB_WARN_ON(cpu_buffer,
+			       rb_is_reader_page(cpu_buffer->tail_page)))
+			return;
+		local_set(&cpu_buffer->commit_page->page->commit,
+			  rb_page_write(cpu_buffer->commit_page));
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
 		cpu_buffer->write_stamp =
 			cpu_buffer->commit_page->page->time_stamp;
@@ -1044,8 +1476,12 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	}
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
-		cpu_buffer->commit_page->page->commit =
-			cpu_buffer->commit_page->write;
+
+		local_set(&cpu_buffer->commit_page->page->commit,
+			  rb_page_write(cpu_buffer->commit_page));
+		RB_WARN_ON(cpu_buffer,
+			   local_read(&cpu_buffer->commit_page->page->commit) &
+			   ~RB_WRITE_MASK);
 		barrier();
 	}
 
@@ -1078,7 +1514,7 @@ static void rb_inc_iter(struct ring_buffer_iter *iter)
 	 * to the head page instead of next.
 	 */
 	if (iter->head_page == cpu_buffer->reader_page)
-		iter->head_page = cpu_buffer->head_page;
+		iter->head_page = rb_set_head_page(cpu_buffer);
 	else
 		rb_inc_page(cpu_buffer, &iter->head_page);
 
@@ -1122,6 +1558,163 @@ rb_update_event(struct ring_buffer_event *event,
 	}
 }
 
+/*
+ * rb_handle_head_page - writer hit the head page
+ *
+ * Returns: +1 to retry page
+ *           0 to continue
+ *          -1 on error
+ */
+static int
+rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
+		    struct buffer_page *tail_page,
+		    struct buffer_page *next_page)
+{
+	struct buffer_page *new_head;
+	int entries;
+	int type;
+	int ret;
+
+	entries = rb_page_entries(next_page);
+
+	/*
+	 * The hard part is here. We need to move the head
+	 * forward, and protect against both readers on
+	 * other CPUs and writers coming in via interrupts.
+	 */
+	type = rb_head_page_set_update(cpu_buffer, next_page, tail_page,
+				       RB_PAGE_HEAD);
+
+	/*
+	 * type can be one of four:
+	 *  NORMAL - an interrupt already moved it for us
+	 *  HEAD   - we are the first to get here.
+	 *  UPDATE - we are the interrupt interrupting
+	 *           a current move.
+	 *  MOVED  - a reader on another CPU moved the next
+	 *           pointer to its reader page. Give up
+	 *           and try again.
+	 */
+
+	switch (type) {
+	case RB_PAGE_HEAD:
+		/*
+		 * We changed the head to UPDATE, thus
+		 * it is our responsibility to update
+		 * the counters.
+		 */
+		local_add(entries, &cpu_buffer->overrun);
+
+		/*
+		 * The entries will be zeroed out when we move the
+		 * tail page.
+		 */
+
+		/* still more to do */
+		break;
+
+	case RB_PAGE_UPDATE:
+		/*
+		 * This is an interrupt that interrupt the
+		 * previous update. Still more to do.
+		 */
+		break;
+	case RB_PAGE_NORMAL:
+		/*
+		 * An interrupt came in before the update
+		 * and processed this for us.
+		 * Nothing left to do.
+		 */
+		return 1;
+	case RB_PAGE_MOVED:
+		/*
+		 * The reader is on another CPU and just did
+		 * a swap with our next_page.
+		 * Try again.
+		 */
+		return 1;
+	default:
+		RB_WARN_ON(cpu_buffer, 1); /* WTF??? */
+		return -1;
+	}
+
+	/*
+	 * Now that we are here, the old head pointer is
+	 * set to UPDATE. This will keep the reader from
+	 * swapping the head page with the reader page.
+	 * The reader (on another CPU) will spin till
+	 * we are finished.
+	 *
+	 * We just need to protect against interrupts
+	 * doing the job. We will set the next pointer
+	 * to HEAD. After that, we set the old pointer
+	 * to NORMAL, but only if it was HEAD before.
+	 * otherwise we are an interrupt, and only
+	 * want the outer most commit to reset it.
+	 */
+	new_head = next_page;
+	rb_inc_page(cpu_buffer, &new_head);
+
+	ret = rb_head_page_set_head(cpu_buffer, new_head, next_page,
+				    RB_PAGE_NORMAL);
+
+	/*
+	 * Valid returns are:
+	 *  HEAD   - an interrupt came in and already set it.
+	 *  NORMAL - One of two things:
+	 *            1) We really set it.
+	 *            2) A bunch of interrupts came in and moved
+	 *               the page forward again.
+	 */
+	switch (ret) {
+	case RB_PAGE_HEAD:
+	case RB_PAGE_NORMAL:
+		/* OK */
+		break;
+	default:
+		RB_WARN_ON(cpu_buffer, 1);
+		return -1;
+	}
+
+	/*
+	 * It is possible that an interrupt came in,
+	 * set the head up, then more interrupts came in
+	 * and moved it again. When we get back here,
+	 * the page would have been set to NORMAL but we
+	 * just set it back to HEAD.
+	 *
+	 * How do you detect this? Well, if that happened
+	 * the tail page would have moved.
+	 */
+	if (ret == RB_PAGE_NORMAL) {
+		/*
+		 * If the tail had moved passed next, then we need
+		 * to reset the pointer.
+		 */
+		if (cpu_buffer->tail_page != tail_page &&
+		    cpu_buffer->tail_page != next_page)
+			rb_head_page_set_normal(cpu_buffer, new_head,
+						next_page,
+						RB_PAGE_HEAD);
+	}
+
+	/*
+	 * If this was the outer most commit (the one that
+	 * changed the original pointer from HEAD to UPDATE),
+	 * then it is up to us to reset it to NORMAL.
+	 */
+	if (type == RB_PAGE_HEAD) {
+		ret = rb_head_page_set_normal(cpu_buffer, next_page,
+					      tail_page,
+					      RB_PAGE_UPDATE);
+		if (RB_WARN_ON(cpu_buffer,
+			       ret != RB_PAGE_UPDATE))
+			return -1;
+	}
+
+	return 0;
+}
+
 static unsigned rb_calculate_event_length(unsigned length)
 {
 	struct ring_buffer_event event; /* Used only for sizeof array */
@@ -1185,9 +1778,6 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	event->type_len = RINGBUF_TYPE_PADDING;
 	/* time delta must be non zero */
 	event->time_delta = 1;
-	/* Account for this as an entry */
-	local_inc(&tail_page->entries);
-	local_inc(&cpu_buffer->entries);
 
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
@@ -1200,96 +1790,93 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     struct buffer_page *commit_page,
 	     struct buffer_page *tail_page, u64 *ts)
 {
-	struct buffer_page *next_page, *head_page, *reader_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
-	bool lock_taken = false;
-	unsigned long flags;
+	struct buffer_page *next_page;
+	int ret;
 
 	next_page = tail_page;
 
-	local_irq_save(flags);
-	/*
-	 * Since the write to the buffer is still not
-	 * fully lockless, we must be careful with NMIs.
-	 * The locks in the writers are taken when a write
-	 * crosses to a new page. The locks protect against
-	 * races with the readers (this will soon be fixed
-	 * with a lockless solution).
-	 *
-	 * Because we can not protect against NMIs, and we
-	 * want to keep traces reentrant, we need to manage
-	 * what happens when we are in an NMI.
-	 *
-	 * NMIs can happen after we take the lock.
-	 * If we are in an NMI, only take the lock
-	 * if it is not already taken. Otherwise
-	 * simply fail.
-	 */
-	if (unlikely(in_nmi())) {
-		if (!__raw_spin_trylock(&cpu_buffer->lock)) {
-			cpu_buffer->nmi_dropped++;
-			goto out_reset;
-		}
-	} else
-		__raw_spin_lock(&cpu_buffer->lock);
-
-	lock_taken = true;
-
 	rb_inc_page(cpu_buffer, &next_page);
 
-	head_page = cpu_buffer->head_page;
-	reader_page = cpu_buffer->reader_page;
-
-	/* we grabbed the lock before incrementing */
-	if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
-		goto out_reset;
-
 	/*
 	 * If for some reason, we had an interrupt storm that made
 	 * it all the way around the buffer, bail, and warn
 	 * about it.
 	 */
 	if (unlikely(next_page == commit_page)) {
-		cpu_buffer->commit_overrun++;
+		local_inc(&cpu_buffer->commit_overrun);
 		goto out_reset;
 	}
 
-	if (next_page == head_page) {
-		if (!(buffer->flags & RB_FL_OVERWRITE))
-			goto out_reset;
-
-		/* tail_page has not moved yet? */
-		if (tail_page == cpu_buffer->tail_page) {
-			/* count overflows */
-			cpu_buffer->overrun +=
-				local_read(&head_page->entries);
+	/*
+	 * This is where the fun begins!
+	 *
+	 * We are fighting against races between a reader that
+	 * could be on another CPU trying to swap its reader
+	 * page with the buffer head.
+	 *
+	 * We are also fighting against interrupts coming in and
+	 * moving the head or tail on us as well.
+	 *
+	 * If the next page is the head page then we have filled
+	 * the buffer, unless the commit page is still on the
+	 * reader page.
+	 */
+	if (rb_is_head_page(cpu_buffer, next_page, &tail_page->list)) {
 
-			rb_inc_page(cpu_buffer, &head_page);
-			cpu_buffer->head_page = head_page;
-			cpu_buffer->head_page->read = 0;
+		/*
+		 * If the commit is not on the reader page, then
+		 * move the header page.
+		 */
+		if (!rb_is_reader_page(cpu_buffer->commit_page)) {
+			/*
+			 * If we are not in overwrite mode,
+			 * this is easy, just stop here.
+			 */
+			if (!(buffer->flags & RB_FL_OVERWRITE))
+				goto out_reset;
+
+			ret = rb_handle_head_page(cpu_buffer,
+						  tail_page,
+						  next_page);
+			if (ret < 0)
+				goto out_reset;
+			if (ret)
+				goto out_again;
+		} else {
+			/*
+			 * We need to be careful here too. The
+			 * commit page could still be on the reader
+			 * page. We could have a small buffer, and
+			 * have filled up the buffer with events
+			 * from interrupts and such, and wrapped.
+			 *
+			 * Note, if the tail page is also the on the
+			 * reader_page, we let it move out.
+			 */
+			if (unlikely((cpu_buffer->commit_page !=
+				      cpu_buffer->tail_page) &&
+				     (cpu_buffer->commit_page ==
+				      cpu_buffer->reader_page))) {
+				local_inc(&cpu_buffer->commit_overrun);
+				goto out_reset;
+			}
 		}
 	}
 
-	/*
-	 * If the tail page is still the same as what we think
-	 * it is, then it is up to us to update the tail
-	 * pointer.
-	 */
-	if (tail_page == cpu_buffer->tail_page) {
-		local_set(&next_page->write, 0);
-		local_set(&next_page->entries, 0);
-		local_set(&next_page->page->commit, 0);
-		cpu_buffer->tail_page = next_page;
-
-		/* reread the time stamp */
+	ret = rb_tail_page_update(cpu_buffer, tail_page, next_page);
+	if (ret) {
+		/*
+		 * Nested commits always have zero deltas, so
+		 * just reread the time stamp
+		 */
 		*ts = rb_time_stamp(buffer, cpu_buffer->cpu);
-		cpu_buffer->tail_page->page->time_stamp = *ts;
+		next_page->page->time_stamp = *ts;
 	}
 
-	rb_reset_tail(cpu_buffer, tail_page, tail, length);
+ out_again:
 
-	__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
+	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
 	/* fail and let the caller try again */
 	return ERR_PTR(-EAGAIN);
@@ -1298,9 +1885,6 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	/* reset write */
 	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
-	if (likely(lock_taken))
-		__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
 	return NULL;
 }
 
@@ -1317,6 +1901,9 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
+
+	/* set write to only the index of the write */
+	write &= RB_WRITE_MASK;
 	tail = write - length;
 
 	/* See if we shot pass the end of this buffer page */
@@ -1361,12 +1948,16 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	bpage = cpu_buffer->tail_page;
 
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
+		unsigned long write_mask =
+			local_read(&bpage->write) & ~RB_WRITE_MASK;
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
 		 * and write to the next page. That is fine
 		 * because we just shorten what is on this page.
 		 */
+		old_index += write_mask;
+		new_index += write_mask;
 		index = local_cmpxchg(&bpage->write, old_index, new_index);
 		if (index == old_index)
 			return 1;
@@ -1482,7 +2073,8 @@ static void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static struct ring_buffer_event *
-rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
+rb_reserve_next_event(struct ring_buffer *buffer,
+		      struct ring_buffer_per_cpu *cpu_buffer,
 		      unsigned long length)
 {
 	struct ring_buffer_event *event;
@@ -1492,6 +2084,21 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 	rb_start_commit(cpu_buffer);
 
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
+	/*
+	 * Due to the ability to swap a cpu buffer from a buffer
+	 * it is possible it was swapped before we committed.
+	 * (committing stops a swap). We check for it here and
+	 * if it happened, we have to fail the write.
+	 */
+	barrier();
+	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
+		local_dec(&cpu_buffer->committing);
+		local_dec(&cpu_buffer->commits);
+		return NULL;
+	}
+#endif
+
 	length = rb_calculate_event_length(length);
  again:
 	/*
@@ -1652,7 +2259,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (length > BUF_MAX_DATA_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, length);
+	event = rb_reserve_next_event(buffer, cpu_buffer, length);
 	if (!event)
 		goto out;
 
@@ -1675,18 +2282,23 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
 
-static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
+static void
+rb_update_write_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	local_inc(&cpu_buffer->entries);
-
 	/*
 	 * The event first in the commit queue updates the
 	 * time stamp.
 	 */
 	if (rb_event_is_commit(cpu_buffer, event))
 		cpu_buffer->write_stamp += event->time_delta;
+}
 
+static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
+		      struct ring_buffer_event *event)
+{
+	local_inc(&cpu_buffer->entries);
+	rb_update_write_stamp(cpu_buffer, event);
 	rb_end_commit(cpu_buffer);
 }
 
@@ -1733,32 +2345,57 @@ static inline void rb_event_discard(struct ring_buffer_event *event)
 		event->time_delta = 1;
 }
 
-/**
- * ring_buffer_event_discard - discard any event in the ring buffer
- * @event: the event to discard
- *
- * Sometimes a event that is in the ring buffer needs to be ignored.
- * This function lets the user discard an event in the ring buffer
- * and then that event will not be read later.
- *
- * Note, it is up to the user to be careful with this, and protect
- * against races. If the user discards an event that has been consumed
- * it is possible that it could corrupt the ring buffer.
+/*
+ * Decrement the entries to the page that an event is on.
+ * The event does not even need to exist, only the pointer
+ * to the page it is on. This may only be called before the commit
+ * takes place.
  */
-void ring_buffer_event_discard(struct ring_buffer_event *event)
+static inline void
+rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
+		   struct ring_buffer_event *event)
 {
-	rb_event_discard(event);
+	unsigned long addr = (unsigned long)event;
+	struct buffer_page *bpage = cpu_buffer->commit_page;
+	struct buffer_page *start;
+
+	addr &= PAGE_MASK;
+
+	/* Do the likely case first */
+	if (likely(bpage->page == (void *)addr)) {
+		local_dec(&bpage->entries);
+		return;
+	}
+
+	/*
+	 * Because the commit page may be on the reader page we
+	 * start with the next page and check the end loop there.
+	 */
+	rb_inc_page(cpu_buffer, &bpage);
+	start = bpage;
+	do {
+		if (bpage->page == (void *)addr) {
+			local_dec(&bpage->entries);
+			return;
+		}
+		rb_inc_page(cpu_buffer, &bpage);
+	} while (bpage != start);
+
+	/* commit not part of this buffer?? */
+	RB_WARN_ON(cpu_buffer, 1);
 }
-EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
 
 /**
  * ring_buffer_commit_discard - discard an event that has not been committed
  * @buffer: the ring buffer
  * @event: non committed event to discard
  *
- * This is similar to ring_buffer_event_discard but must only be
- * performed on an event that has not been committed yet. The difference
- * is that this will also try to free the event from the ring buffer
+ * Sometimes an event that is in the ring buffer needs to be ignored.
+ * This function lets the user discard an event in the ring buffer
+ * and then that event will not be read later.
+ *
+ * This function only works if it is called before the the item has been
+ * committed. It will try to free the event from the ring buffer
  * if another event has not been added behind it.
  *
  * If another event has been added behind it, it will set the event
@@ -1786,14 +2423,15 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 */
 	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
 
+	rb_decrement_entry(cpu_buffer, event);
 	if (rb_try_to_discard(cpu_buffer, event))
 		goto out;
 
 	/*
 	 * The commit is still visible by the reader, so we
-	 * must increment entries.
+	 * must still update the timestamp.
 	 */
-	local_inc(&cpu_buffer->entries);
+	rb_update_write_stamp(cpu_buffer, event);
  out:
 	rb_end_commit(cpu_buffer);
 
@@ -1854,7 +2492,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (length > BUF_MAX_DATA_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, length);
+	event = rb_reserve_next_event(buffer, cpu_buffer, length);
 	if (!event)
 		goto out;
 
@@ -1875,9 +2513,13 @@ EXPORT_SYMBOL_GPL(ring_buffer_write);
 static int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = cpu_buffer->reader_page;
-	struct buffer_page *head = cpu_buffer->head_page;
+	struct buffer_page *head = rb_set_head_page(cpu_buffer);
 	struct buffer_page *commit = cpu_buffer->commit_page;
 
+	/* In case of error, head will be NULL */
+	if (unlikely(!head))
+		return 1;
+
 	return reader->read == rb_page_commit(reader) &&
 		(commit == reader ||
 		 (commit == head &&
@@ -1968,7 +2610,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = (local_read(&cpu_buffer->entries) - cpu_buffer->overrun)
+	ret = (local_read(&cpu_buffer->entries) - local_read(&cpu_buffer->overrun))
 		- cpu_buffer->read;
 
 	return ret;
@@ -1989,33 +2631,13 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->overrun;
+	ret = local_read(&cpu_buffer->overrun);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
- * ring_buffer_nmi_dropped_cpu - get the number of nmis that were dropped
- * @buffer: The ring buffer
- * @cpu: The per CPU buffer to get the number of overruns from
- */
-unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu)
-{
-	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long ret;
-
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return 0;
-
-	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->nmi_dropped;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ring_buffer_nmi_dropped_cpu);
-
-/**
  * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
@@ -2030,7 +2652,7 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->commit_overrun;
+	ret = local_read(&cpu_buffer->commit_overrun);
 
 	return ret;
 }
@@ -2053,7 +2675,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		entries += (local_read(&cpu_buffer->entries) -
-			    cpu_buffer->overrun) - cpu_buffer->read;
+			    local_read(&cpu_buffer->overrun)) - cpu_buffer->read;
 	}
 
 	return entries;
@@ -2076,7 +2698,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		overruns += cpu_buffer->overrun;
+		overruns += local_read(&cpu_buffer->overrun);
 	}
 
 	return overruns;
@@ -2089,8 +2711,10 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 
 	/* Iterator usage is expected to have record disabled */
 	if (list_empty(&cpu_buffer->reader_page->list)) {
-		iter->head_page = cpu_buffer->head_page;
-		iter->head = cpu_buffer->head_page->read;
+		iter->head_page = rb_set_head_page(cpu_buffer);
+		if (unlikely(!iter->head_page))
+			return;
+		iter->head = iter->head_page->read;
 	} else {
 		iter->head_page = cpu_buffer->reader_page;
 		iter->head = cpu_buffer->reader_page->read;
@@ -2207,6 +2831,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
 	int nr_loops = 0;
+	int ret;
 
 	local_irq_save(flags);
 	__raw_spin_lock(&cpu_buffer->lock);
@@ -2240,30 +2865,56 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 		goto out;
 
 	/*
-	 * Splice the empty reader page into the list around the head.
 	 * Reset the reader page to size zero.
 	 */
+	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->entries, 0);
+	local_set(&cpu_buffer->reader_page->page->commit, 0);
 
-	reader = cpu_buffer->head_page;
+ spin:
+	/*
+	 * Splice the empty reader page into the list around the head.
+	 */
+	reader = rb_set_head_page(cpu_buffer);
 	cpu_buffer->reader_page->list.next = reader->list.next;
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
-	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->entries, 0);
-	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	/*
+	 * cpu_buffer->pages just needs to point to the buffer, it
+	 *  has no specific buffer page to point to. Lets move it out
+	 *  of our way so we don't accidently swap it.
+	 */
+	cpu_buffer->pages = reader->list.prev;
 
-	/* Make the reader page now replace the head */
-	reader->list.prev->next = &cpu_buffer->reader_page->list;
-	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	/* The reader page will be pointing to the new head */
+	rb_set_list_to_head(cpu_buffer, &cpu_buffer->reader_page->list);
 
 	/*
-	 * If the tail is on the reader, then we must set the head
-	 * to the inserted page, otherwise we set it one before.
+	 * Here's the tricky part.
+	 *
+	 * We need to move the pointer past the header page.
+	 * But we can only do that if a writer is not currently
+	 * moving it. The page before the header page has the
+	 * flag bit '1' set if it is pointing to the page we want.
+	 * but if the writer is in the process of moving it
+	 * than it will be '2' or already moved '0'.
 	 */
-	cpu_buffer->head_page = cpu_buffer->reader_page;
 
-	if (cpu_buffer->commit_page != reader)
-		rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
+	ret = rb_head_page_replace(reader, cpu_buffer->reader_page);
+
+	/*
+	 * If we did not convert it, then we must try again.
+	 */
+	if (!ret)
+		goto spin;
+
+	/*
+	 * Yeah! We succeeded in replacing the page.
+	 *
+	 * Now make the new head point back to the reader page.
+	 */
+	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
 
 	/* Finally update the reader page to the new head */
 	cpu_buffer->reader_page = reader;
@@ -2292,8 +2943,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
-			|| rb_discarded_event(event))
+	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		cpu_buffer->read++;
 
 	rb_update_read_stamp(cpu_buffer, event);
@@ -2525,10 +3175,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
@@ -2553,10 +3201,8 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	event = rb_iter_peek(iter, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
@@ -2602,10 +3248,8 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
  out:
 	preempt_enable();
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
@@ -2685,21 +3329,19 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
- again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+ again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
 		goto out;
 
+	if (event->type_len == RINGBUF_TYPE_PADDING)
+		goto again;
+
 	rb_advance_iter(iter);
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
-		goto again;
-	}
-
 	return event;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read);
@@ -2717,8 +3359,10 @@ EXPORT_SYMBOL_GPL(ring_buffer_size);
 static void
 rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	rb_head_page_deactivate(cpu_buffer);
+
 	cpu_buffer->head_page
-		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+		= list_entry(cpu_buffer->pages, struct buffer_page, list);
 	local_set(&cpu_buffer->head_page->write, 0);
 	local_set(&cpu_buffer->head_page->entries, 0);
 	local_set(&cpu_buffer->head_page->page->commit, 0);
@@ -2734,16 +3378,17 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
-	cpu_buffer->nmi_dropped = 0;
-	cpu_buffer->commit_overrun = 0;
-	cpu_buffer->overrun = 0;
-	cpu_buffer->read = 0;
+	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->overrun, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
+	cpu_buffer->read = 0;
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
+
+	rb_head_page_activate(cpu_buffer);
 }
 
 /**
@@ -2763,12 +3408,16 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
+	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
+		goto out;
+
 	__raw_spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
 	__raw_spin_unlock(&cpu_buffer->lock);
 
+ out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
@@ -2851,6 +3500,7 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
  * @buffer_a: One buffer to swap with
@@ -2905,20 +3555,28 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	atomic_inc(&cpu_buffer_a->record_disabled);
 	atomic_inc(&cpu_buffer_b->record_disabled);
 
+	ret = -EBUSY;
+	if (local_read(&cpu_buffer_a->committing))
+		goto out_dec;
+	if (local_read(&cpu_buffer_b->committing))
+		goto out_dec;
+
 	buffer_a->buffers[cpu] = cpu_buffer_b;
 	buffer_b->buffers[cpu] = cpu_buffer_a;
 
 	cpu_buffer_b->buffer = buffer_a;
 	cpu_buffer_a->buffer = buffer_b;
 
+	ret = 0;
+
+out_dec:
 	atomic_dec(&cpu_buffer_a->record_disabled);
 	atomic_dec(&cpu_buffer_b->record_disabled);
-
-	ret = 0;
 out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
+#endif /* CONFIG_RING_BUFFER_ALLOW_SWAP */
 
 /**
  * ring_buffer_alloc_read_page - allocate a page to read from buffer
@@ -3091,7 +3749,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		read = 0;
 	} else {
 		/* update the entry counter */
-		cpu_buffer->read += local_read(&reader->entries);
+		cpu_buffer->read += rb_page_entries(reader);
 
 		/* swap the pages */
 		rb_init_page(bpage);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8c35839..5c75dee 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -43,14 +43,11 @@
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
-unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;
-
 /*
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
  */
-static int ring_buffer_expanded;
+int ring_buffer_expanded;
 
 /*
  * We need to change this state when a selftest is running.
@@ -64,7 +61,7 @@ static bool __read_mostly tracing_selftest_running;
 /*
  * If a tracer is running, we do not want to run SELFTEST.
  */
-static bool __read_mostly tracing_selftest_disabled;
+bool __read_mostly tracing_selftest_disabled;
 
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
@@ -89,7 +86,7 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
  */
 static int tracing_disabled = 1;
 
-static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 static inline void ftrace_disable_cpu(void)
 {
@@ -172,10 +169,11 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
-int filter_current_check_discard(struct ftrace_event_call *call, void *rec,
+int filter_current_check_discard(struct ring_buffer *buffer,
+				 struct ftrace_event_call *call, void *rec,
 				 struct ring_buffer_event *event)
 {
-	return filter_check_discard(call, rec, global_trace.buffer, event);
+	return filter_check_discard(call, rec, buffer, event);
 }
 EXPORT_SYMBOL_GPL(filter_current_check_discard);
 
@@ -266,6 +264,9 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
 	TRACE_ITER_GRAPH_TIME;
 
+static int trace_stop_count;
+static DEFINE_SPINLOCK(tracing_start_lock);
+
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
@@ -323,50 +324,20 @@ static const char *trace_options[] = {
 	"printk-msg-only",
 	"context-info",
 	"latency-format",
-	"global-clock",
 	"sleep-time",
 	"graph-time",
 	NULL
 };
 
-/*
- * ftrace_max_lock is used to protect the swapping of buffers
- * when taking a max snapshot. The buffers themselves are
- * protected by per_cpu spinlocks. But the action of the swap
- * needs its own lock.
- *
- * This is defined as a raw_spinlock_t in order to help
- * with performance when lockdep debugging is enabled.
- */
-static raw_spinlock_t ftrace_max_lock =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-
-/*
- * Copy the new maximum trace into the separate maximum-trace
- * structure. (this way the maximum trace is permanently saved,
- * for later retrieval via /sys/kernel/debug/tracing/latency_trace)
- */
-static void
-__update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
-{
-	struct trace_array_cpu *data = tr->data[cpu];
-
-	max_tr.cpu = cpu;
-	max_tr.time_start = data->preempt_timestamp;
+static struct {
+	u64 (*func)(void);
+	const char *name;
+} trace_clocks[] = {
+	{ trace_clock_local,	"local" },
+	{ trace_clock_global,	"global" },
+};
 
-	data = max_tr.data[cpu];
-	data->saved_latency = tracing_max_latency;
-
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
-	data->pid = tsk->pid;
-	data->uid = task_uid(tsk);
-	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-	data->policy = tsk->policy;
-	data->rt_priority = tsk->rt_priority;
-
-	/* record this tasks comm */
-	tracing_record_cmdline(tsk);
-}
+int trace_clock_id;
 
 ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 {
@@ -411,6 +382,56 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	return cnt;
 }
 
+/*
+ * ftrace_max_lock is used to protect the swapping of buffers
+ * when taking a max snapshot. The buffers themselves are
+ * protected by per_cpu spinlocks. But the action of the swap
+ * needs its own lock.
+ *
+ * This is defined as a raw_spinlock_t in order to help
+ * with performance when lockdep debugging is enabled.
+ *
+ * It is also used in other places outside the update_max_tr
+ * so it needs to be defined outside of the
+ * CONFIG_TRACER_MAX_TRACE.
+ */
+static raw_spinlock_t ftrace_max_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+unsigned long __read_mostly	tracing_max_latency;
+unsigned long __read_mostly	tracing_thresh;
+
+/*
+ * Copy the new maximum trace into the separate maximum-trace
+ * structure. (this way the maximum trace is permanently saved,
+ * for later retrieval via /sys/kernel/debug/tracing/latency_trace)
+ */
+static void
+__update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
+{
+	struct trace_array_cpu *data = tr->data[cpu];
+	struct trace_array_cpu *max_data = tr->data[cpu];
+
+	max_tr.cpu = cpu;
+	max_tr.time_start = data->preempt_timestamp;
+
+	max_data = max_tr.data[cpu];
+	max_data->saved_latency = tracing_max_latency;
+	max_data->critical_start = data->critical_start;
+	max_data->critical_end = data->critical_end;
+
+	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
+	max_data->pid = tsk->pid;
+	max_data->uid = task_uid(tsk);
+	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	max_data->policy = tsk->policy;
+	max_data->rt_priority = tsk->rt_priority;
+
+	/* record this tasks comm */
+	tracing_record_cmdline(tsk);
+}
+
 /**
  * update_max_tr - snapshot all trace buffers from global_trace to max_tr
  * @tr: tracer
@@ -425,16 +446,15 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct ring_buffer *buf = tr->buffer;
 
+	if (trace_stop_count)
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
 
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
-	ftrace_disable_cpu();
-	ring_buffer_reset(tr->buffer);
-	ftrace_enable_cpu();
-
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
 }
@@ -452,21 +472,35 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	int ret;
 
+	if (trace_stop_count)
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
 
 	ftrace_disable_cpu();
 
-	ring_buffer_reset(max_tr.buffer);
 	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
 
+	if (ret == -EBUSY) {
+		/*
+		 * We failed to swap the buffer due to a commit taking
+		 * place on this CPU. We fail to record, but we reset
+		 * the max trace buffer (no one writes directly to it)
+		 * and flag that it failed.
+		 */
+		trace_array_printk(&max_tr, _THIS_IP_,
+			"Failed to swap buffers due to commit in progress\n");
+	}
+
 	ftrace_enable_cpu();
 
-	WARN_ON_ONCE(ret && ret != -EAGAIN);
+	WARN_ON_ONCE(ret && ret != -EAGAIN && ret != -EBUSY);
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
 }
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 /**
  * register_tracer - register a tracer with the ftrace system.
@@ -523,7 +557,6 @@ __acquires(kernel_lock)
 	if (type->selftest && !tracing_selftest_disabled) {
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
-		int i;
 
 		/*
 		 * Run a selftest on this tracer.
@@ -532,8 +565,7 @@ __acquires(kernel_lock)
 		 * internal tracing to verify that everything is in order.
 		 * If we fail, we do not register this tracer.
 		 */
-		for_each_tracing_cpu(i)
-			tracing_reset(tr, i);
+		tracing_reset_online_cpus(tr);
 
 		current_trace = type;
 		/* the test is responsible for initializing and enabling */
@@ -546,8 +578,7 @@ __acquires(kernel_lock)
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
-		for_each_tracing_cpu(i)
-			tracing_reset(tr, i);
+		tracing_reset_online_cpus(tr);
 
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -622,21 +653,42 @@ void unregister_tracer(struct tracer *type)
 	mutex_unlock(&trace_types_lock);
 }
 
-void tracing_reset(struct trace_array *tr, int cpu)
+static void __tracing_reset(struct trace_array *tr, int cpu)
 {
 	ftrace_disable_cpu();
 	ring_buffer_reset_cpu(tr->buffer, cpu);
 	ftrace_enable_cpu();
 }
 
+void tracing_reset(struct trace_array *tr, int cpu)
+{
+	struct ring_buffer *buffer = tr->buffer;
+
+	ring_buffer_record_disable(buffer);
+
+	/* Make sure all commits have finished */
+	synchronize_sched();
+	__tracing_reset(tr, cpu);
+
+	ring_buffer_record_enable(buffer);
+}
+
 void tracing_reset_online_cpus(struct trace_array *tr)
 {
+	struct ring_buffer *buffer = tr->buffer;
 	int cpu;
 
+	ring_buffer_record_disable(buffer);
+
+	/* Make sure all commits have finished */
+	synchronize_sched();
+
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
+		__tracing_reset(tr, cpu);
+
+	ring_buffer_record_enable(buffer);
 }
 
 void tracing_reset_current(int cpu)
@@ -667,9 +719,6 @@ static void trace_init_cmdlines(void)
 	cmdline_idx = 0;
 }
 
-static int trace_stop_count;
-static DEFINE_SPINLOCK(tracing_start_lock);
-
 /**
  * ftrace_off_permanent - disable all ftrace code permanently
  *
@@ -850,14 +899,15 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 }
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
-struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
-						    int type,
-						    unsigned long len,
-						    unsigned long flags, int pc)
+struct ring_buffer_event *
+trace_buffer_lock_reserve(struct ring_buffer *buffer,
+			  int type,
+			  unsigned long len,
+			  unsigned long flags, int pc)
 {
 	struct ring_buffer_event *event;
 
-	event = ring_buffer_lock_reserve(tr->buffer, len);
+	event = ring_buffer_lock_reserve(buffer, len);
 	if (event != NULL) {
 		struct trace_entry *ent = ring_buffer_event_data(event);
 
@@ -867,58 +917,60 @@ struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
 
 	return event;
 }
-static void ftrace_trace_stack(struct trace_array *tr,
-			       unsigned long flags, int skip, int pc);
-static void ftrace_trace_userstack(struct trace_array *tr,
-				   unsigned long flags, int pc);
 
-static inline void __trace_buffer_unlock_commit(struct trace_array *tr,
-					struct ring_buffer_event *event,
-					unsigned long flags, int pc,
-					int wake)
+static inline void
+__trace_buffer_unlock_commit(struct ring_buffer *buffer,
+			     struct ring_buffer_event *event,
+			     unsigned long flags, int pc,
+			     int wake)
 {
-	ring_buffer_unlock_commit(tr->buffer, event);
+	ring_buffer_unlock_commit(buffer, event);
 
-	ftrace_trace_stack(tr, flags, 6, pc);
-	ftrace_trace_userstack(tr, flags, pc);
+	ftrace_trace_stack(buffer, flags, 6, pc);
+	ftrace_trace_userstack(buffer, flags, pc);
 
 	if (wake)
 		trace_wake_up();
 }
 
-void trace_buffer_unlock_commit(struct trace_array *tr,
-					struct ring_buffer_event *event,
-					unsigned long flags, int pc)
+void trace_buffer_unlock_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event,
+				unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(tr, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc, 1);
 }
 
 struct ring_buffer_event *
-trace_current_buffer_lock_reserve(int type, unsigned long len,
+trace_current_buffer_lock_reserve(struct ring_buffer **current_rb,
+				  int type, unsigned long len,
 				  unsigned long flags, int pc)
 {
-	return trace_buffer_lock_reserve(&global_trace,
+	*current_rb = global_trace.buffer;
+	return trace_buffer_lock_reserve(*current_rb,
 					 type, len, flags, pc);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_lock_reserve);
 
-void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
+					struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc, 1);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_unlock_commit);
 
-void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
-					unsigned long flags, int pc)
+void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
+				       struct ring_buffer_event *event,
+				       unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc, 0);
 }
 EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
 
-void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
+void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
+					 struct ring_buffer_event *event)
 {
-	ring_buffer_discard_commit(global_trace.buffer, event);
+	ring_buffer_discard_commit(buffer, event);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_discard_commit);
 
@@ -928,6 +980,7 @@ trace_function(struct trace_array *tr,
 	       int pc)
 {
 	struct ftrace_event_call *call = &event_function;
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -935,7 +988,7 @@ trace_function(struct trace_array *tr,
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_FN, sizeof(*entry),
+	event = trace_buffer_lock_reserve(buffer, TRACE_FN, sizeof(*entry),
 					  flags, pc);
 	if (!event)
 		return;
@@ -943,58 +996,10 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-}
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int __trace_graph_entry(struct trace_array *tr,
-				struct ftrace_graph_ent *trace,
-				unsigned long flags,
-				int pc)
-{
-	struct ftrace_event_call *call = &event_funcgraph_entry;
-	struct ring_buffer_event *event;
-	struct ftrace_graph_ent_entry *entry;
-
-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
-		return 0;
-
-	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_ENT,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return 0;
-	entry	= ring_buffer_event_data(event);
-	entry->graph_ent			= *trace;
-	if (!filter_current_check_discard(call, entry, event))
-		ring_buffer_unlock_commit(global_trace.buffer, event);
-
-	return 1;
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
-static void __trace_graph_return(struct trace_array *tr,
-				struct ftrace_graph_ret *trace,
-				unsigned long flags,
-				int pc)
-{
-	struct ftrace_event_call *call = &event_funcgraph_exit;
-	struct ring_buffer_event *event;
-	struct ftrace_graph_ret_entry *entry;
-
-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
-		return;
-
-	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_RET,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->ret				= *trace;
-	if (!filter_current_check_discard(call, entry, event))
-		ring_buffer_unlock_commit(global_trace.buffer, event);
-}
-#endif
-
 void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
        unsigned long ip, unsigned long parent_ip, unsigned long flags,
@@ -1004,17 +1009,17 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 		trace_function(tr, ip, parent_ip, flags, pc);
 }
 
-static void __ftrace_trace_stack(struct trace_array *tr,
+#ifdef CONFIG_STACKTRACE
+static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
 				 int skip, int pc)
 {
-#ifdef CONFIG_STACKTRACE
 	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_STACK,
+	event = trace_buffer_lock_reserve(buffer, TRACE_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
@@ -1027,32 +1032,28 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-#endif
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
-static void ftrace_trace_stack(struct trace_array *tr,
-			       unsigned long flags,
-			       int skip, int pc)
+void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
+			int skip, int pc)
 {
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	__ftrace_trace_stack(tr, flags, skip, pc);
+	__ftrace_trace_stack(buffer, flags, skip, pc);
 }
 
-void __trace_stack(struct trace_array *tr,
-		   unsigned long flags,
-		   int skip, int pc)
+void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
+		   int pc)
 {
-	__ftrace_trace_stack(tr, flags, skip, pc);
+	__ftrace_trace_stack(tr->buffer, flags, skip, pc);
 }
 
-static void ftrace_trace_userstack(struct trace_array *tr,
-				   unsigned long flags, int pc)
+void
+ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 {
-#ifdef CONFIG_STACKTRACE
 	struct ftrace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
@@ -1061,7 +1062,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_USER_STACK,
+	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
@@ -1075,9 +1076,8 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-#endif
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
 #ifdef UNUSED
@@ -1087,6 +1087,8 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 }
 #endif /* UNUSED */
 
+#endif /* CONFIG_STACKTRACE */
+
 static void
 ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
@@ -1094,9 +1096,10 @@ ftrace_trace_special(void *__tr,
 {
 	struct ring_buffer_event *event;
 	struct trace_array *tr = __tr;
+	struct ring_buffer *buffer = tr->buffer;
 	struct special_entry *entry;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_SPECIAL,
+	event = trace_buffer_lock_reserve(buffer, TRACE_SPECIAL,
 					  sizeof(*entry), 0, pc);
 	if (!event)
 		return;
@@ -1104,7 +1107,7 @@ ftrace_trace_special(void *__tr,
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
-	trace_buffer_unlock_commit(tr, event, 0, pc);
+	trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void
@@ -1115,62 +1118,6 @@ __trace_special(void *__tr, void *__data,
 }
 
 void
-tracing_sched_switch_trace(struct trace_array *tr,
-			   struct task_struct *prev,
-			   struct task_struct *next,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_context_switch;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_CTX,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= prev->pid;
-	entry->prev_prio		= prev->prio;
-	entry->prev_state		= prev->state;
-	entry->next_pid			= next->pid;
-	entry->next_prio		= next->prio;
-	entry->next_state		= next->state;
-	entry->next_cpu	= task_cpu(next);
-
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, flags, pc);
-}
-
-void
-tracing_sched_wakeup_trace(struct trace_array *tr,
-			   struct task_struct *wakee,
-			   struct task_struct *curr,
-			   unsigned long flags, int pc)
-{
-	struct ftrace_event_call *call = &event_wakeup;
-	struct ring_buffer_event *event;
-	struct ctx_switch_entry *entry;
-
-	event = trace_buffer_lock_reserve(tr, TRACE_WAKE,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->prev_pid			= curr->pid;
-	entry->prev_prio		= curr->prio;
-	entry->prev_state		= curr->state;
-	entry->next_pid			= wakee->pid;
-	entry->next_prio		= wakee->prio;
-	entry->next_state		= wakee->state;
-	entry->next_cpu			= task_cpu(wakee);
-
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-	ftrace_trace_stack(tr, flags, 6, pc);
-	ftrace_trace_userstack(tr, flags, pc);
-}
-
-void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
 	struct trace_array *tr = &global_trace;
@@ -1194,68 +1141,6 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-int trace_graph_entry(struct ftrace_graph_ent *trace)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int ret;
-	int cpu;
-	int pc;
-
-	if (!ftrace_trace_task(current))
-		return 0;
-
-	if (!ftrace_graph_addr(trace->func))
-		return 0;
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		ret = __trace_graph_entry(tr, trace, flags, pc);
-	} else {
-		ret = 0;
-	}
-	/* Only do the atomic if it is not already set */
-	if (!test_tsk_trace_graph(current))
-		set_tsk_trace_graph(current);
-
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-
-	return ret;
-}
-
-void trace_graph_return(struct ftrace_graph_ret *trace)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu;
-	int pc;
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		__trace_graph_return(tr, trace, flags, pc);
-	}
-	if (!trace->depth)
-		clear_tsk_trace_graph(current);
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-}
-#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-
-
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
@@ -1268,6 +1153,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
@@ -1300,7 +1186,9 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 		goto out_unlock;
 
 	size = sizeof(*entry) + sizeof(u32) * len;
-	event = trace_buffer_lock_reserve(tr, TRACE_BPRINT, size, flags, pc);
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
+					  flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
@@ -1308,8 +1196,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 
 out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
@@ -1324,14 +1212,30 @@ out:
 }
 EXPORT_SYMBOL_GPL(trace_vbprintk);
 
-int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
+int trace_array_printk(struct trace_array *tr,
+		       unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_array_vprintk(tr, ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+
+int trace_array_vprintk(struct trace_array *tr,
+			unsigned long ip, const char *fmt, va_list args)
 {
 	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
 
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
-	struct trace_array *tr = &global_trace;
+	struct ring_buffer *buffer;
 	struct trace_array_cpu *data;
 	int cpu, len = 0, size, pc;
 	struct print_entry *entry;
@@ -1359,7 +1263,9 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	trace_buf[len] = 0;
 
 	size = sizeof(*entry) + len + 1;
-	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, irq_flags, pc);
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
+					  irq_flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
@@ -1367,8 +1273,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 
  out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
@@ -1380,6 +1286,11 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	return len;
 }
+
+int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
+{
+	return trace_array_printk(&global_trace, ip, fmt, args);
+}
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
 enum trace_file_type {
@@ -1519,6 +1430,37 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 	return ent;
 }
 
+static void tracing_iter_reset(struct trace_iterator *iter, int cpu)
+{
+	struct trace_array *tr = iter->tr;
+	struct ring_buffer_event *event;
+	struct ring_buffer_iter *buf_iter;
+	unsigned long entries = 0;
+	u64 ts;
+
+	tr->data[cpu]->skipped_entries = 0;
+
+	if (!iter->buffer_iter[cpu])
+		return;
+
+	buf_iter = iter->buffer_iter[cpu];
+	ring_buffer_iter_reset(buf_iter);
+
+	/*
+	 * We could have the case with the max latency tracers
+	 * that a reset never took place on a cpu. This is evident
+	 * by the timestamp being before the start of the buffer.
+	 */
+	while ((event = ring_buffer_iter_peek(buf_iter, &ts))) {
+		if (ts >= iter->tr->time_start)
+			break;
+		entries++;
+		ring_buffer_read(buf_iter, NULL);
+	}
+
+	tr->data[cpu]->skipped_entries = entries;
+}
+
 /*
  * No necessary locking here. The worst thing which can
  * happen is loosing events consumed at the same time
@@ -1557,10 +1499,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		if (cpu_file == TRACE_PIPE_ALL_CPU) {
 			for_each_tracing_cpu(cpu)
-				ring_buffer_iter_reset(iter->buffer_iter[cpu]);
+				tracing_iter_reset(iter, cpu);
 		} else
-			ring_buffer_iter_reset(iter->buffer_iter[cpu_file]);
-
+			tracing_iter_reset(iter, cpu_file);
 
 		ftrace_enable_cpu();
 
@@ -1609,16 +1550,32 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	struct trace_array *tr = iter->tr;
 	struct trace_array_cpu *data = tr->data[tr->cpu];
 	struct tracer *type = current_trace;
-	unsigned long total;
-	unsigned long entries;
+	unsigned long entries = 0;
+	unsigned long total = 0;
+	unsigned long count;
 	const char *name = "preemption";
+	int cpu;
 
 	if (type)
 		name = type->name;
 
-	entries = ring_buffer_entries(iter->tr->buffer);
-	total = entries +
-		ring_buffer_overruns(iter->tr->buffer);
+
+	for_each_tracing_cpu(cpu) {
+		count = ring_buffer_entries_cpu(tr->buffer, cpu);
+		/*
+		 * If this buffer has skipped entries, then we hold all
+		 * entries for the trace and we need to ignore the
+		 * ones before the time stamp.
+		 */
+		if (tr->data[cpu]->skipped_entries) {
+			count -= tr->data[cpu]->skipped_entries;
+			/* total is the same as the entries */
+			total += count;
+		} else
+			total += count +
+				ring_buffer_overrun_cpu(tr->buffer, cpu);
+		entries += count;
+	}
 
 	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -1660,7 +1617,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 		seq_puts(m, "\n#  => ended at:   ");
 		seq_print_ip_sym(&iter->seq, data->critical_end, sym_flags);
 		trace_print_seq(m, &iter->seq);
-		seq_puts(m, "#\n");
+		seq_puts(m, "\n#\n");
 	}
 
 	seq_puts(m, "#\n");
@@ -1679,6 +1636,9 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	if (cpumask_test_cpu(iter->cpu, iter->started))
 		return;
 
+	if (iter->tr->data[iter->cpu]->skipped_entries)
+		return;
+
 	cpumask_set_cpu(iter->cpu, iter->started);
 
 	/* Don't print started cpu buffer for the first entry of the trace */
@@ -1941,19 +1901,23 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (ring_buffer_overruns(iter->tr->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
+	/* stop the trace while dumping */
+	tracing_stop();
+
 	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
 		for_each_tracing_cpu(cpu) {
 
 			iter->buffer_iter[cpu] =
 				ring_buffer_read_start(iter->tr->buffer, cpu);
+			tracing_iter_reset(iter, cpu);
 		}
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
 				ring_buffer_read_start(iter->tr->buffer, cpu);
+		tracing_iter_reset(iter, cpu);
 	}
 
-	/* TODO stop tracer */
 	ret = seq_open(file, &tracer_seq_ops);
 	if (ret < 0) {
 		fail_ret = ERR_PTR(ret);
@@ -1963,9 +1927,6 @@ __tracing_open(struct inode *inode, struct file *file)
 	m = file->private_data;
 	m->private = iter;
 
-	/* stop the trace while dumping */
-	tracing_stop();
-
 	mutex_unlock(&trace_types_lock);
 
 	return iter;
@@ -1976,6 +1937,7 @@ __tracing_open(struct inode *inode, struct file *file)
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
 	free_cpumask_var(iter->started);
+	tracing_start();
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
@@ -2257,8 +2219,8 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 		len += 3; /* "no" and newline */
 	}
 
-	/* +2 for \n and \0 */
-	buf = kmalloc(len + 2, GFP_KERNEL);
+	/* +1 for \0 */
+	buf = kmalloc(len + 1, GFP_KERNEL);
 	if (!buf) {
 		mutex_unlock(&trace_types_lock);
 		return -ENOMEM;
@@ -2281,7 +2243,7 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 	}
 	mutex_unlock(&trace_types_lock);
 
-	WARN_ON(r >= len + 2);
+	WARN_ON(r >= len + 1);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 
@@ -2292,23 +2254,23 @@ tracing_trace_options_read(struct file *filp, char __user *ubuf,
 /* Try to assign a tracer specific option */
 static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 {
-	struct tracer_flags *trace_flags = trace->flags;
+	struct tracer_flags *tracer_flags = trace->flags;
 	struct tracer_opt *opts = NULL;
 	int ret = 0, i = 0;
 	int len;
 
-	for (i = 0; trace_flags->opts[i].name; i++) {
-		opts = &trace_flags->opts[i];
+	for (i = 0; tracer_flags->opts[i].name; i++) {
+		opts = &tracer_flags->opts[i];
 		len = strlen(opts->name);
 
 		if (strncmp(cmp, opts->name, len) == 0) {
-			ret = trace->set_flag(trace_flags->val,
+			ret = trace->set_flag(tracer_flags->val,
 				opts->bit, !neg);
 			break;
 		}
 	}
 	/* Not found */
-	if (!trace_flags->opts[i].name)
+	if (!tracer_flags->opts[i].name)
 		return -EINVAL;
 
 	/* Refused to handle */
@@ -2316,9 +2278,9 @@ static int set_tracer_option(struct tracer *trace, char *cmp, int neg)
 		return ret;
 
 	if (neg)
-		trace_flags->val &= ~opts->bit;
+		tracer_flags->val &= ~opts->bit;
 	else
-		trace_flags->val |= opts->bit;
+		tracer_flags->val |= opts->bit;
 
 	return 0;
 }
@@ -2333,22 +2295,6 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		trace_flags |= mask;
 	else
 		trace_flags &= ~mask;
-
-	if (mask == TRACE_ITER_GLOBAL_CLK) {
-		u64 (*func)(void);
-
-		if (enabled)
-			func = trace_clock_global;
-		else
-			func = trace_clock_local;
-
-		mutex_lock(&trace_types_lock);
-		ring_buffer_set_clock(global_trace.buffer, func);
-
-		if (max_tr.buffer)
-			ring_buffer_set_clock(max_tr.buffer, func);
-		mutex_unlock(&trace_types_lock);
-	}
 }
 
 static ssize_t
@@ -3316,6 +3262,62 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int bufiter = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
+		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
+			"%s%s%s%s", i ? " " : "",
+			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
+			i == trace_clock_id ? "]" : "");
+	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
+}
+
+static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *fpos)
+{
+	char buf[64];
+	const char *clockstr;
+	int i;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	clockstr = strstrip(buf);
+
+	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++) {
+		if (strcmp(trace_clocks[i].name, clockstr) == 0)
+			break;
+	}
+	if (i == ARRAY_SIZE(trace_clocks))
+		return -EINVAL;
+
+	trace_clock_id = i;
+
+	mutex_lock(&trace_types_lock);
+
+	ring_buffer_set_clock(global_trace.buffer, trace_clocks[i].func);
+	if (max_tr.buffer)
+		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
+
+	mutex_unlock(&trace_types_lock);
+
+	*fpos += cnt;
+
+	return cnt;
+}
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -3353,6 +3355,12 @@ static const struct file_operations tracing_mark_fops = {
 	.write		= tracing_mark_write,
 };
 
+static const struct file_operations trace_clock_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_clock_read,
+	.write		= tracing_clock_write,
+};
+
 struct ftrace_buffer_info {
 	struct trace_array	*tr;
 	void			*spare;
@@ -3633,9 +3641,6 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
-	cnt = ring_buffer_nmi_dropped_cpu(tr->buffer, cpu);
-	trace_seq_printf(s, "nmi dropped: %ld\n", cnt);
-
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -4066,11 +4071,13 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("current_tracer", 0644, d_tracer,
 			&global_trace, &set_tracer_fops);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
+#endif
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
@@ -4087,6 +4094,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
+	trace_create_file("trace_clock", 0644, d_tracer, NULL,
+			  &trace_clock_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -4265,7 +4275,6 @@ void ftrace_dump(void)
 
 __init static int tracer_alloc_buffers(void)
 {
-	struct trace_array_cpu *data;
 	int ring_buf_size;
 	int i;
 	int ret = -ENOMEM;
@@ -4315,7 +4324,7 @@ __init static int tracer_alloc_buffers(void)
 
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
-		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
+		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
 		max_tr.data[i] = &per_cpu(max_data, i);
 	}
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8b9f4f6..fa1dccb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -34,8 +34,6 @@ enum trace_type {
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_HW_BRANCHES,
-	TRACE_SYSCALL_ENTER,
-	TRACE_SYSCALL_EXIT,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
@@ -236,9 +234,6 @@ struct trace_array_cpu {
 	atomic_t		disabled;
 	void			*buffer_page;	/* ring buffer spare */
 
-	/* these fields get copied into max-trace: */
-	unsigned long		trace_idx;
-	unsigned long		overrun;
 	unsigned long		saved_latency;
 	unsigned long		critical_start;
 	unsigned long		critical_end;
@@ -246,6 +241,7 @@ struct trace_array_cpu {
 	unsigned long		nice;
 	unsigned long		policy;
 	unsigned long		rt_priority;
+	unsigned long		skipped_entries;
 	cycle_t			preempt_timestamp;
 	pid_t			pid;
 	uid_t			uid;
@@ -319,10 +315,6 @@ extern void __ftrace_bad_type(void);
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
 			  TRACE_KMEM_FREE);	\
-		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
-			  TRACE_SYSCALL_ENTER);				\
-		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
-			  TRACE_SYSCALL_EXIT);				\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -423,12 +415,13 @@ void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
 struct ring_buffer_event;
 
-struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
-						    int type,
-						    unsigned long len,
-						    unsigned long flags,
-						    int pc);
-void trace_buffer_unlock_commit(struct trace_array *tr,
+struct ring_buffer_event *
+trace_buffer_lock_reserve(struct ring_buffer *buffer,
+			  int type,
+			  unsigned long len,
+			  unsigned long flags,
+			  int pc);
+void trace_buffer_unlock_commit(struct ring_buffer *buffer,
 				struct ring_buffer_event *event,
 				unsigned long flags, int pc);
 
@@ -467,6 +460,7 @@ void trace_function(struct trace_array *tr,
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
+void set_graph_array(struct trace_array *tr);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
@@ -478,16 +472,40 @@ void unregister_tracer(struct tracer *type);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
 extern unsigned long tracing_thresh;
 
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
-void __trace_stack(struct trace_array *tr,
-		   unsigned long flags,
-		   int skip, int pc);
+#ifdef CONFIG_STACKTRACE
+void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
+			int skip, int pc);
+
+void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
+			    int pc);
+
+void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
+		   int pc);
+#else
+static inline void ftrace_trace_stack(struct trace_array *tr,
+				      unsigned long flags, int skip, int pc)
+{
+}
+
+static inline void ftrace_trace_userstack(struct trace_array *tr,
+					  unsigned long flags, int pc)
+{
+}
+
+static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
+				 int skip, int pc)
+{
+}
+#endif /* CONFIG_STACKTRACE */
 
 extern cycle_t ftrace_now(int cpu);
 
@@ -513,6 +531,10 @@ extern unsigned long ftrace_update_tot_cnt;
 extern int DYN_FTRACE_TEST_NAME(void);
 #endif
 
+extern int ring_buffer_expanded;
+extern bool tracing_selftest_disabled;
+DECLARE_PER_CPU(local_t, ftrace_cpu_disabled);
+
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
@@ -544,9 +566,16 @@ extern int
 trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
 extern int
 trace_vprintk(unsigned long ip, const char *fmt, va_list args);
+extern int
+trace_array_vprintk(struct trace_array *tr,
+		    unsigned long ip, const char *fmt, va_list args);
+int trace_array_printk(struct trace_array *tr,
+		       unsigned long ip, const char *fmt, ...);
 
 extern unsigned long trace_flags;
 
+extern int trace_clock_id;
+
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern enum print_line_t print_graph_function(struct trace_iterator *iter);
@@ -635,9 +664,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
 	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
-	TRACE_ITER_GLOBAL_CLK		= 0x80000,
-	TRACE_ITER_SLEEP_TIME		= 0x100000,
-	TRACE_ITER_GRAPH_TIME		= 0x200000,
+	TRACE_ITER_SLEEP_TIME		= 0x80000,
+	TRACE_ITER_GRAPH_TIME		= 0x100000,
 };
 
 /*
@@ -734,6 +762,7 @@ struct ftrace_event_field {
 	struct list_head	link;
 	char			*name;
 	char			*type;
+	int			filter_type;
 	int			offset;
 	int			size;
 	int			is_signed;
@@ -743,13 +772,15 @@ struct event_filter {
 	int			n_preds;
 	struct filter_pred	**preds;
 	char			*filter_string;
+	bool			no_reset;
 };
 
 struct event_subsystem {
 	struct list_head	list;
 	const char		*name;
 	struct dentry		*entry;
-	void			*filter;
+	struct event_filter	*filter;
+	int			nr_events;
 };
 
 struct filter_pred;
@@ -777,6 +808,7 @@ extern int apply_subsystem_event_filter(struct event_subsystem *system,
 					char *filter_string);
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
+extern int filter_assign_type(const char *type);
 
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index a29ef23..19bfc75 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -41,14 +41,12 @@ void disable_boot_trace(void)
 
 static int boot_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	boot_trace = tr;
 
 	if (!tr)
 		return 0;
 
-	for_each_cpu(cpu, cpu_possible_mask)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 
 	tracing_sched_switch_assign_trace(tr);
 	return 0;
@@ -132,6 +130,7 @@ struct tracer boot_tracer __read_mostly =
 void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_boot_call *entry;
 	struct trace_array *tr = boot_trace;
 
@@ -144,13 +143,14 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_CALL,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BOOT_CALL,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_call = *bt;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -158,6 +158,7 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_boot_ret *entry;
 	struct trace_array *tr = boot_trace;
 
@@ -167,13 +168,14 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_RET,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BOOT_RET,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_ret = *bt;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e75276a..78b1ed2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -17,6 +17,8 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 
+#include <asm/setup.h>
+
 #include "trace_output.h"
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
@@ -25,8 +27,9 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
-int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size, int is_signed)
+int trace_define_field(struct ftrace_event_call *call, const char *type,
+		       const char *name, int offset, int size, int is_signed,
+		       int filter_type)
 {
 	struct ftrace_event_field *field;
 
@@ -42,9 +45,15 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 	if (!field->type)
 		goto err;
 
+	if (filter_type == FILTER_OTHER)
+		field->filter_type = filter_assign_type(type);
+	else
+		field->filter_type = filter_type;
+
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
+
 	list_add(&field->link, &call->fields);
 
 	return 0;
@@ -60,6 +69,29 @@ err:
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
+#define __common_field(type, item)					\
+	ret = trace_define_field(call, #type, "common_" #item,		\
+				 offsetof(typeof(ent), item),		\
+				 sizeof(ent.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
+	if (ret)							\
+		return ret;
+
+int trace_define_common_fields(struct ftrace_event_call *call)
+{
+	int ret;
+	struct trace_entry ent;
+
+	__common_field(unsigned short, type);
+	__common_field(unsigned char, flags);
+	__common_field(unsigned char, preempt_count);
+	__common_field(int, pid);
+	__common_field(int, tgid);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(trace_define_common_fields);
+
 #ifdef CONFIG_MODULES
 
 static void trace_destroy_fields(struct ftrace_event_call *call)
@@ -84,14 +116,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		if (call->enabled) {
 			call->enabled = 0;
 			tracing_stop_cmdline_record();
-			call->unregfunc();
+			call->unregfunc(call->data);
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc();
+			call->regfunc(call->data);
 		}
 		break;
 	}
@@ -574,7 +606,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_printf(s, "format:\n");
 	trace_write_header(s);
 
-	r = call->show_format(s);
+	r = call->show_format(call, s);
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
@@ -849,8 +881,10 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
-		if (strcmp(system->name, name) == 0)
+		if (strcmp(system->name, name) == 0) {
+			system->nr_events++;
 			return system->entry;
+		}
 	}
 
 	/* need to create new entry */
@@ -869,6 +903,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 		return d_events;
 	}
 
+	system->nr_events = 1;
 	system->name = kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
 		debugfs_remove(system->entry);
@@ -920,15 +955,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	if (strcmp(call->system, TRACE_SYSTEM) != 0)
 		d_events = event_subsystem_dir(call->system, d_events);
 
-	if (call->raw_init) {
-		ret = call->raw_init();
-		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", call->name);
-			return ret;
-		}
-	}
-
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
 		pr_warning("Could not create debugfs "
@@ -945,7 +971,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 					  id);
 
 	if (call->define_fields) {
-		ret = call->define_fields();
+		ret = call->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
@@ -987,6 +1013,32 @@ struct ftrace_module_file_ops {
 	struct file_operations		filter;
 };
 
+static void remove_subsystem_dir(const char *name)
+{
+	struct event_subsystem *system;
+
+	if (strcmp(name, TRACE_SYSTEM) == 0)
+		return;
+
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (strcmp(system->name, name) == 0) {
+			if (!--system->nr_events) {
+				struct event_filter *filter = system->filter;
+
+				debugfs_remove_recursive(system->entry);
+				list_del(&system->list);
+				if (filter) {
+					kfree(filter->filter_string);
+					kfree(filter);
+				}
+				kfree(system->name);
+				kfree(system);
+			}
+			break;
+		}
+	}
+}
+
 static struct ftrace_module_file_ops *
 trace_create_file_ops(struct module *mod)
 {
@@ -1027,6 +1079,7 @@ static void trace_module_add_events(struct module *mod)
 	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call *call, *start, *end;
 	struct dentry *d_events;
+	int ret;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
@@ -1042,7 +1095,15 @@ static void trace_module_add_events(struct module *mod)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-
+		if (call->raw_init) {
+			ret = call->raw_init();
+			if (ret < 0) {
+				if (ret != -ENOSYS)
+					pr_warning("Could not initialize trace "
+					"point events/%s\n", call->name);
+				continue;
+			}
+		}
 		/*
 		 * This module has events, create file ops for this module
 		 * if not already done.
@@ -1077,6 +1138,7 @@ static void trace_module_remove_events(struct module *mod)
 			list_del(&call->list);
 			trace_destroy_fields(call);
 			destroy_preds(call);
+			remove_subsystem_dir(call->system);
 		}
 	}
 
@@ -1133,6 +1195,18 @@ struct notifier_block trace_module_nb = {
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
 
+static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
+
+static __init int setup_trace_event(char *str)
+{
+	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
+	ring_buffer_expanded = 1;
+	tracing_selftest_disabled = 1;
+
+	return 1;
+}
+__setup("trace_event=", setup_trace_event);
+
 static __init int event_trace_init(void)
 {
 	struct ftrace_event_call *call;
@@ -1140,6 +1214,8 @@ static __init int event_trace_init(void)
 	struct dentry *entry;
 	struct dentry *d_events;
 	int ret;
+	char *buf = bootup_event_buf;
+	char *token;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -1179,12 +1255,34 @@ static __init int event_trace_init(void)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
+		if (call->raw_init) {
+			ret = call->raw_init();
+			if (ret < 0) {
+				if (ret != -ENOSYS)
+					pr_warning("Could not initialize trace "
+					"point events/%s\n", call->name);
+				continue;
+			}
+		}
 		list_add(&call->list, &ftrace_events);
 		event_create_dir(call, d_events, &ftrace_event_id_fops,
 				 &ftrace_enable_fops, &ftrace_event_filter_fops,
 				 &ftrace_event_format_fops);
 	}
 
+	while (true) {
+		token = strsep(&buf, ",");
+
+		if (!token)
+			break;
+		if (!*token)
+			continue;
+
+		ret = ftrace_set_clr_event(token, 1);
+		if (ret)
+			pr_warning("Failed to enable trace event: %s\n", token);
+	}
+
 	ret = register_module_notifier(&trace_module_nb);
 	if (ret)
 		pr_warning("Failed to register trace events module notifier\n");
@@ -1340,6 +1438,7 @@ static void
 function_test_events_call(unsigned long ip, unsigned long parent_ip)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct ftrace_entry *entry;
 	unsigned long flags;
 	long disabled;
@@ -1357,7 +1456,8 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 
 	local_save_flags(flags);
 
-	event = trace_current_buffer_lock_reserve(TRACE_FN, sizeof(*entry),
+	event = trace_current_buffer_lock_reserve(&buffer,
+						  TRACE_FN, sizeof(*entry),
 						  flags, pc);
 	if (!event)
 		goto out;
@@ -1365,7 +1465,7 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	trace_nowake_buffer_unlock_commit(event, flags, pc);
+	trace_nowake_buffer_unlock_commit(buffer, event, flags, pc);
 
  out:
 	atomic_dec(&per_cpu(test_event_disable, cpu));
@@ -1392,10 +1492,10 @@ static __init void event_trace_self_test_with_function(void)
 
 static __init int event_trace_self_tests_init(void)
 {
-
-	event_trace_self_tests();
-
-	event_trace_self_test_with_function();
+	if (!tracing_selftest_disabled) {
+		event_trace_self_tests();
+		event_trace_self_test_with_function();
+	}
 
 	return 0;
 }
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f32dc9d..93660fb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -163,6 +163,20 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	return match;
 }
 
+/* Filter predicate for char * pointers */
+static int filter_pred_pchar(struct filter_pred *pred, void *event,
+			     int val1, int val2)
+{
+	char **addr = (char **)(event + pred->offset);
+	int cmp, match;
+
+	cmp = strncmp(*addr, pred->str_val, pred->str_len);
+
+	match = (!cmp) ^ pred->not;
+
+	return match;
+}
+
 /*
  * Filter predicate for dynamic sized arrays of characters.
  * These are implemented through a list of strings at the end
@@ -176,11 +190,13 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 static int filter_pred_strloc(struct filter_pred *pred, void *event,
 			      int val1, int val2)
 {
-	unsigned short str_loc = *(unsigned short *)(event + pred->offset);
+	u32 str_item = *(u32 *)(event + pred->offset);
+	int str_loc = str_item & 0xffff;
+	int str_len = str_item >> 16;
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	cmp = strncmp(addr, pred->str_val, str_len);
 
 	match = (!cmp) ^ pred->not;
 
@@ -293,7 +309,7 @@ void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 	struct event_filter *filter = call->filter;
 
 	mutex_lock(&event_mutex);
-	if (filter->filter_string)
+	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
@@ -306,7 +322,7 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 	struct event_filter *filter = system->filter;
 
 	mutex_lock(&event_mutex);
-	if (filter->filter_string)
+	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
@@ -374,6 +390,9 @@ void destroy_preds(struct ftrace_event_call *call)
 	struct event_filter *filter = call->filter;
 	int i;
 
+	if (!filter)
+		return;
+
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
 		if (filter->preds[i])
 			filter_free_pred(filter->preds[i]);
@@ -384,17 +403,19 @@ void destroy_preds(struct ftrace_event_call *call)
 	call->filter = NULL;
 }
 
-int init_preds(struct ftrace_event_call *call)
+static int init_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter;
 	struct filter_pred *pred;
 	int i;
 
+	if (call->filter)
+		return 0;
+
 	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (!call->filter)
 		return -ENOMEM;
 
-	call->filter_active = 0;
 	filter->n_preds = 0;
 
 	filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
@@ -416,30 +437,55 @@ oom:
 
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(init_preds);
 
-static void filter_free_subsystem_preds(struct event_subsystem *system)
+static int init_subsystem_preds(struct event_subsystem *system)
 {
-	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
-	int i;
+	int err;
 
-	if (filter->n_preds) {
-		for (i = 0; i < filter->n_preds; i++)
-			filter_free_pred(filter->preds[i]);
-		kfree(filter->preds);
-		filter->preds = NULL;
-		filter->n_preds = 0;
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!call->define_fields)
+			continue;
+
+		if (strcmp(call->system, system->name) != 0)
+			continue;
+
+		err = init_preds(call);
+		if (err)
+			return err;
 	}
 
+	return 0;
+}
+
+enum {
+	FILTER_DISABLE_ALL,
+	FILTER_INIT_NO_RESET,
+	FILTER_SKIP_NO_RESET,
+};
+
+static void filter_free_subsystem_preds(struct event_subsystem *system,
+					int flag)
+{
+	struct ftrace_event_call *call;
+
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
 			continue;
 
-		if (!strcmp(call->system, system->name)) {
-			filter_disable_preds(call);
-			remove_filter_string(call->filter);
+		if (strcmp(call->system, system->name) != 0)
+			continue;
+
+		if (flag == FILTER_INIT_NO_RESET) {
+			call->filter->no_reset = false;
+			continue;
 		}
+
+		if (flag == FILTER_SKIP_NO_RESET && call->filter->no_reset)
+			continue;
+
+		filter_disable_preds(call);
+		remove_filter_string(call->filter);
 	}
 }
 
@@ -468,12 +514,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 	return 0;
 }
 
-enum {
-	FILTER_STATIC_STRING = 1,
-	FILTER_DYN_STRING
-};
-
-static int is_string_field(const char *type)
+int filter_assign_type(const char *type)
 {
 	if (strstr(type, "__data_loc") && strstr(type, "char"))
 		return FILTER_DYN_STRING;
@@ -481,12 +522,19 @@ static int is_string_field(const char *type)
 	if (strchr(type, '[') && strstr(type, "char"))
 		return FILTER_STATIC_STRING;
 
-	return 0;
+	return FILTER_OTHER;
+}
+
+static bool is_string_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_DYN_STRING ||
+	       field->filter_type == FILTER_STATIC_STRING ||
+	       field->filter_type == FILTER_PTR_STRING;
 }
 
 static int is_legal_op(struct ftrace_event_field *field, int op)
 {
-	if (is_string_field(field->type) && (op != OP_EQ && op != OP_NE))
+	if (is_string_field(field) && (op != OP_EQ && op != OP_NE))
 		return 0;
 
 	return 1;
@@ -537,22 +585,24 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 
 static int filter_add_pred(struct filter_parse_state *ps,
 			   struct ftrace_event_call *call,
-			   struct filter_pred *pred)
+			   struct filter_pred *pred,
+			   bool dry_run)
 {
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
 	unsigned long long val;
-	int string_type;
 	int ret;
 
 	pred->fn = filter_pred_none;
 
 	if (pred->op == OP_AND) {
 		pred->pop_n = 2;
-		return filter_add_pred_fn(ps, call, pred, filter_pred_and);
+		fn = filter_pred_and;
+		goto add_pred_fn;
 	} else if (pred->op == OP_OR) {
 		pred->pop_n = 2;
-		return filter_add_pred_fn(ps, call, pred, filter_pred_or);
+		fn = filter_pred_or;
+		goto add_pred_fn;
 	}
 
 	field = find_event_field(call, pred->field_name);
@@ -568,16 +618,17 @@ static int filter_add_pred(struct filter_parse_state *ps,
 		return -EINVAL;
 	}
 
-	string_type = is_string_field(field->type);
-	if (string_type) {
-		if (string_type == FILTER_STATIC_STRING)
+	if (is_string_field(field)) {
+		pred->str_len = field->size;
+
+		if (field->filter_type == FILTER_STATIC_STRING)
 			fn = filter_pred_string;
-		else
+		else if (field->filter_type == FILTER_DYN_STRING)
 			fn = filter_pred_strloc;
-		pred->str_len = field->size;
-		if (pred->op == OP_NE)
-			pred->not = 1;
-		return filter_add_pred_fn(ps, call, pred, fn);
+		else {
+			fn = filter_pred_pchar;
+			pred->str_len = strlen(pred->str_val);
+		}
 	} else {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->str_val, 0, &val);
@@ -588,41 +639,33 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			return -EINVAL;
 		}
 		pred->val = val;
-	}
 
-	fn = select_comparison_fn(pred->op, field->size, field->is_signed);
-	if (!fn) {
-		parse_error(ps, FILT_ERR_INVALID_OP, 0);
-		return -EINVAL;
+		fn = select_comparison_fn(pred->op, field->size,
+					  field->is_signed);
+		if (!fn) {
+			parse_error(ps, FILT_ERR_INVALID_OP, 0);
+			return -EINVAL;
+		}
 	}
 
 	if (pred->op == OP_NE)
 		pred->not = 1;
 
-	return filter_add_pred_fn(ps, call, pred, fn);
+add_pred_fn:
+	if (!dry_run)
+		return filter_add_pred_fn(ps, call, pred, fn);
+	return 0;
 }
 
 static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 				     struct event_subsystem *system,
 				     struct filter_pred *pred,
-				     char *filter_string)
+				     char *filter_string,
+				     bool dry_run)
 {
-	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 	int err = 0;
-
-	if (!filter->preds) {
-		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
-					GFP_KERNEL);
-
-		if (!filter->preds)
-			return -ENOMEM;
-	}
-
-	if (filter->n_preds == MAX_FILTER_PRED) {
-		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
-		return -ENOSPC;
-	}
+	bool fail = true;
 
 	list_for_each_entry(call, &ftrace_events, list) {
 
@@ -632,19 +675,24 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		if (strcmp(call->system, system->name))
 			continue;
 
-		err = filter_add_pred(ps, call, pred);
-		if (err) {
-			filter_free_subsystem_preds(system);
-			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
-			goto out;
-		}
-		replace_filter_string(call->filter, filter_string);
+		if (call->filter->no_reset)
+			continue;
+
+		err = filter_add_pred(ps, call, pred, dry_run);
+		if (err)
+			call->filter->no_reset = true;
+		else
+			fail = false;
+
+		if (!dry_run)
+			replace_filter_string(call->filter, filter_string);
 	}
 
-	filter->preds[filter->n_preds] = pred;
-	filter->n_preds++;
-out:
-	return err;
+	if (fail) {
+		parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
+		return err;
+	}
+	return 0;
 }
 
 static void parse_init(struct filter_parse_state *ps,
@@ -1003,12 +1051,14 @@ static int check_preds(struct filter_parse_state *ps)
 static int replace_preds(struct event_subsystem *system,
 			 struct ftrace_event_call *call,
 			 struct filter_parse_state *ps,
-			 char *filter_string)
+			 char *filter_string,
+			 bool dry_run)
 {
 	char *operand1 = NULL, *operand2 = NULL;
 	struct filter_pred *pred;
 	struct postfix_elt *elt;
 	int err;
+	int n_preds = 0;
 
 	err = check_preds(ps);
 	if (err)
@@ -1027,24 +1077,14 @@ static int replace_preds(struct event_subsystem *system,
 			continue;
 		}
 
+		if (n_preds++ == MAX_FILTER_PRED) {
+			parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
+			return -ENOSPC;
+		}
+
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
-			if (!pred)
-				return -ENOMEM;
-			if (call) {
-				err = filter_add_pred(ps, call, pred);
-				filter_free_pred(pred);
-			} else {
-				err = filter_add_subsystem_pred(ps, system,
-							pred, filter_string);
-				if (err)
-					filter_free_pred(pred);
-			}
-			if (err)
-				return err;
-
-			operand1 = operand2 = NULL;
-			continue;
+			goto add_pred;
 		}
 
 		if (!operand1 || !operand2) {
@@ -1053,17 +1093,15 @@ static int replace_preds(struct event_subsystem *system,
 		}
 
 		pred = create_pred(elt->op, operand1, operand2);
+add_pred:
 		if (!pred)
 			return -ENOMEM;
-		if (call) {
-			err = filter_add_pred(ps, call, pred);
-			filter_free_pred(pred);
-		} else {
+		if (call)
+			err = filter_add_pred(ps, call, pred, false);
+		else
 			err = filter_add_subsystem_pred(ps, system, pred,
-							filter_string);
-			if (err)
-				filter_free_pred(pred);
-		}
+						filter_string, dry_run);
+		filter_free_pred(pred);
 		if (err)
 			return err;
 
@@ -1081,6 +1119,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	mutex_lock(&event_mutex);
 
+	err = init_preds(call);
+	if (err)
+		goto out_unlock;
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable_preds(call);
 		remove_filter_string(call->filter);
@@ -1103,7 +1145,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		goto out;
 	}
 
-	err = replace_preds(NULL, call, ps, filter_string);
+	err = replace_preds(NULL, call, ps, filter_string, false);
 	if (err)
 		append_filter_err(ps, call->filter);
 
@@ -1126,8 +1168,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	mutex_lock(&event_mutex);
 
+	err = init_subsystem_preds(system);
+	if (err)
+		goto out_unlock;
+
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_free_subsystem_preds(system);
+		filter_free_subsystem_preds(system, FILTER_DISABLE_ALL);
 		remove_filter_string(system->filter);
 		mutex_unlock(&event_mutex);
 		return 0;
@@ -1138,7 +1184,6 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 	if (!ps)
 		goto out_unlock;
 
-	filter_free_subsystem_preds(system);
 	replace_filter_string(system->filter, filter_string);
 
 	parse_init(ps, filter_ops, filter_string);
@@ -1148,9 +1193,23 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		goto out;
 	}
 
-	err = replace_preds(system, NULL, ps, filter_string);
-	if (err)
+	filter_free_subsystem_preds(system, FILTER_INIT_NO_RESET);
+
+	/* try to see the filter can be applied to which events */
+	err = replace_preds(system, NULL, ps, filter_string, true);
+	if (err) {
 		append_filter_err(ps, system->filter);
+		goto out;
+	}
+
+	filter_free_subsystem_preds(system, FILTER_SKIP_NO_RESET);
+
+	/* really apply the filter to the events */
+	err = replace_preds(system, NULL, ps, filter_string, false);
+	if (err) {
+		append_filter_err(ps, system->filter);
+		filter_free_subsystem_preds(system, 2);
+	}
 
 out:
 	filter_opstack_clear(ps);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d06cf89..df1bf6e 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -60,7 +60,8 @@ extern void __bad_type_size(void);
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
 {									\
 	struct args field;						\
 	int ret;							\
@@ -76,7 +77,8 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
 				    tpfmt)				\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
 {									\
 	struct args field;						\
 	int ret;							\
@@ -117,7 +119,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int ftrace_define_fields_##call(void);					\
+int ftrace_define_fields_##call(struct ftrace_event_call *event_call);	\
 static int ftrace_raw_init_event_##call(void);				\
 									\
 struct ftrace_event_call __used						\
@@ -133,7 +135,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 static int ftrace_raw_init_event_##call(void)				\
 {									\
 	INIT_LIST_HEAD(&event_##call.fields);				\
-	init_preds(&event_##call);					\
 	return 0;							\
 }									\
 
@@ -156,7 +157,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD(type, item, assign)					\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed_type(type));	\
+				 sizeof(field.item),			\
+				 is_signed_type(type), FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -164,7 +166,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), 0);		\
+				 sizeof(field.item), 0, FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
@@ -172,7 +174,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed);	\
+				 sizeof(field.item), is_signed,		\
+				 FILTER_OTHER);				\
 	if (ret)							\
 		return ret;
 
@@ -182,17 +185,14 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 int									\
-ftrace_define_fields_##call(void)					\
+ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	struct args field;						\
 	int ret;							\
 									\
-	__common_field(unsigned char, type, 0);				\
-	__common_field(unsigned char, flags, 0);			\
-	__common_field(unsigned char, preempt_count, 0);		\
-	__common_field(int, pid, 1);					\
-	__common_field(int, tgid, 1);					\
+	ret = trace_define_common_fields(event_call);			\
+	if (ret)							\
+		return ret;						\
 									\
 	tstruct;							\
 									\
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 75ef000..5b01b94 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -288,11 +288,9 @@ static int
 ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 			 struct ftrace_probe_ops *ops, void *data)
 {
-	char str[KSYM_SYMBOL_LEN];
 	long count = (long)data;
 
-	kallsyms_lookup(ip, NULL, NULL, NULL, str);
-	seq_printf(m, "%s:", str);
+	seq_printf(m, "%pf:", (void *)ip);
 
 	if (ops == &traceon_probe_ops)
 		seq_printf(m, "traceon");
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 420ec34..b3749a2 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -52,7 +52,7 @@ static struct tracer_flags tracer_flags = {
 	.opts = trace_opts
 };
 
-/* pid on the last trace processed */
+static struct trace_array *graph_array;
 
 
 /* Add a function return address to the trace stack on thread info.*/
@@ -166,10 +166,123 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 	return ret;
 }
 
+static int __trace_graph_entry(struct trace_array *tr,
+				struct ftrace_graph_ent *trace,
+				unsigned long flags,
+				int pc)
+{
+	struct ftrace_event_call *call = &event_funcgraph_entry;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer = tr->buffer;
+	struct ftrace_graph_ent_entry *entry;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return 0;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_ENT,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return 0;
+	entry	= ring_buffer_event_data(event);
+	entry->graph_ent			= *trace;
+	if (!filter_current_check_discard(buffer, call, entry, event))
+		ring_buffer_unlock_commit(buffer, event);
+
+	return 1;
+}
+
+int trace_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = graph_array;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int ret;
+	int cpu;
+	int pc;
+
+	if (unlikely(!tr))
+		return 0;
+
+	if (!ftrace_trace_task(current))
+		return 0;
+
+	if (!ftrace_graph_addr(trace->func))
+		return 0;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		ret = __trace_graph_entry(tr, trace, flags, pc);
+	} else {
+		ret = 0;
+	}
+	/* Only do the atomic if it is not already set */
+	if (!test_tsk_trace_graph(current))
+		set_tsk_trace_graph(current);
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static void __trace_graph_return(struct trace_array *tr,
+				struct ftrace_graph_ret *trace,
+				unsigned long flags,
+				int pc)
+{
+	struct ftrace_event_call *call = &event_funcgraph_exit;
+	struct ring_buffer_event *event;
+	struct ring_buffer *buffer = tr->buffer;
+	struct ftrace_graph_ret_entry *entry;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->ret				= *trace;
+	if (!filter_current_check_discard(buffer, call, entry, event))
+		ring_buffer_unlock_commit(buffer, event);
+}
+
+void trace_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = graph_array;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_graph_return(tr, trace, flags, pc);
+	}
+	if (!trace->depth)
+		clear_tsk_trace_graph(current);
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
-	int ret = register_ftrace_graph(&trace_graph_return,
-					&trace_graph_entry);
+	int ret;
+
+	graph_array = tr;
+	ret = register_ftrace_graph(&trace_graph_return,
+				    &trace_graph_entry);
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();
@@ -177,49 +290,30 @@ static int graph_trace_init(struct trace_array *tr)
 	return 0;
 }
 
+void set_graph_array(struct trace_array *tr)
+{
+	graph_array = tr;
+}
+
 static void graph_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_cmdline_record();
 	unregister_ftrace_graph();
 }
 
-static inline int log10_cpu(int nb)
-{
-	if (nb / 100)
-		return 3;
-	if (nb / 10)
-		return 2;
-	return 1;
-}
+static int max_bytes_for_cpu;
 
 static enum print_line_t
 print_graph_cpu(struct trace_seq *s, int cpu)
 {
-	int i;
 	int ret;
-	int log10_this = log10_cpu(cpu);
-	int log10_all = log10_cpu(cpumask_weight(cpu_online_mask));
-
 
 	/*
 	 * Start with a space character - to make it stand out
 	 * to the right a bit when trace output is pasted into
 	 * email:
 	 */
-	ret = trace_seq_printf(s, " ");
-
-	/*
-	 * Tricky - we space the CPU field according to the max
-	 * number of online CPUs. On a 2-cpu system it would take
-	 * a maximum of 1 digit - on a 128 cpu system it would
-	 * take up to 3 digits:
-	 */
-	for (i = 0; i < log10_all - log10_this; i++) {
-		ret = trace_seq_printf(s, " ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-	ret = trace_seq_printf(s, "%d) ", cpu);
+	ret = trace_seq_printf(s, " %*d) ", max_bytes_for_cpu, cpu);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -565,11 +659,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = seq_print_ip_sym(s, call->func, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_printf(s, "();\n");
+	ret = trace_seq_printf(s, "%pf();\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -612,11 +702,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = seq_print_ip_sym(s, call->func, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_printf(s, "() {\n");
+	ret = trace_seq_printf(s, "%pf() {\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -934,6 +1020,8 @@ static struct tracer graph_trace __read_mostly = {
 
 static __init int init_graph_trace(void)
 {
+	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
+
 	return register_tracer(&graph_trace);
 }
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b923d13..5555b75 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -178,7 +178,6 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	tracing_reset(tr, cpu);
 	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
@@ -208,7 +207,6 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	data->critical_start = parent_ip ? : ip;
-	tracing_reset(tr, cpu);
 
 	local_save_flags(flags);
 
@@ -379,6 +377,7 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
+	tracing_reset_online_cpus(tr);
 	start_irqsoff_tracer(tr);
 }
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index d53b45e..c4c9bbd 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -307,11 +307,12 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_rw *rw)
 {
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
 	int pc = preempt_count();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_MMIO_RW,
+	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_RW,
 					  sizeof(*entry), 0, pc);
 	if (!event) {
 		atomic_inc(&dropped_count);
@@ -319,7 +320,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->rw			= *rw;
-	trace_buffer_unlock_commit(tr, event, 0, pc);
+	trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_rw(struct mmiotrace_rw *rw)
@@ -333,11 +334,12 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_map *map)
 {
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
 	int pc = preempt_count();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_MMIO_MAP,
+	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_MAP,
 					  sizeof(*entry), 0, pc);
 	if (!event) {
 		atomic_inc(&dropped_count);
@@ -345,7 +347,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->map			= *map;
-	trace_buffer_unlock_commit(tr, event, 0, pc);
+	trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_mapping(struct mmiotrace_map *map)
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 8a30d98..fe1a00f 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -38,6 +38,7 @@ static void probe_power_end(struct power_trace *it)
 {
 	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
 	struct trace_array *tr = power_trace;
@@ -45,18 +46,20 @@ static void probe_power_end(struct power_trace *it)
 	if (!trace_power_enabled)
 		return;
 
+	buffer = tr->buffer;
+
 	preempt_disable();
 	it->end = ktime_get();
 	data = tr->data[smp_processor_id()];
 
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -66,6 +69,7 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 {
 	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
 	struct trace_array *tr = power_trace;
@@ -73,6 +77,8 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 	if (!trace_power_enabled)
 		return;
 
+	buffer = tr->buffer;
+
 	memset(it, 0, sizeof(struct power_trace));
 	it->state = level;
 	it->type = type;
@@ -81,14 +87,14 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 	it->end = it->stamp;
 	data = tr->data[smp_processor_id()];
 
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -144,14 +150,12 @@ static void power_trace_reset(struct trace_array *tr)
 
 static int power_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	power_trace = tr;
 
 	trace_power_enabled = 1;
 	tracing_power_register();
 
-	for_each_cpu(cpu, cpu_possible_mask)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 	return 0;
 }
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index a98106d..5fca0f5 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -20,6 +20,35 @@ static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
 static int			sched_stopped;
 
+
+void
+tracing_sched_switch_trace(struct trace_array *tr,
+			   struct task_struct *prev,
+			   struct task_struct *next,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_context_switch;
+	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_CTX,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
+}
+
 static void
 probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 			struct task_struct *next)
@@ -49,6 +78,36 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	local_irq_restore(flags);
 }
 
+void
+tracing_sched_wakeup_trace(struct trace_array *tr,
+			   struct task_struct *wakee,
+			   struct task_struct *curr,
+			   unsigned long flags, int pc)
+{
+	struct ftrace_event_call *call = &event_wakeup;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
+	struct ring_buffer *buffer = tr->buffer;
+
+	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(tr->buffer, flags, 6, pc);
+	ftrace_trace_userstack(tr->buffer, flags, pc);
+}
+
 static void
 probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 {
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index eacb272..ad69f10 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -186,11 +186,6 @@ out:
 
 static void __wakeup_reset(struct trace_array *tr)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		tracing_reset(tr, cpu);
-
 	wakeup_cpu = -1;
 	wakeup_prio = -1;
 
@@ -204,6 +199,8 @@ static void wakeup_reset(struct trace_array *tr)
 {
 	unsigned long flags;
 
+	tracing_reset_online_cpus(tr);
+
 	local_irq_save(flags);
 	__raw_spin_lock(&wakeup_lock);
 	__wakeup_reset(tr);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 00dd648..d2cdbab 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -288,6 +288,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	 * to detect and recover from possible hangs
 	 */
 	tracing_reset_online_cpus(tr);
+	set_graph_array(tr);
 	ret = register_ftrace_graph(&trace_graph_return,
 				    &trace_graph_entry_watchdog);
 	if (ret) {
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 6a2a9d4..0f6facb 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -186,43 +186,33 @@ static const struct file_operations stack_max_size_fops = {
 };
 
 static void *
-t_next(struct seq_file *m, void *v, loff_t *pos)
+__next(struct seq_file *m, loff_t *pos)
 {
-	long i;
+	long n = *pos - 1;
 
-	(*pos)++;
-
-	if (v == SEQ_START_TOKEN)
-		i = 0;
-	else {
-		i = *(long *)v;
-		i++;
-	}
-
-	if (i >= max_stack_trace.nr_entries ||
-	    stack_dump_trace[i] == ULONG_MAX)
+	if (n >= max_stack_trace.nr_entries || stack_dump_trace[n] == ULONG_MAX)
 		return NULL;
 
-	m->private = (void *)i;
-
+	m->private = (void *)n;
 	return &m->private;
 }
 
-static void *t_start(struct seq_file *m, loff_t *pos)
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	void *t = SEQ_START_TOKEN;
-	loff_t l = 0;
+	(*pos)++;
+	return __next(m, pos);
+}
 
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
 	local_irq_disable();
 	__raw_spin_lock(&max_stack_lock);
 
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (; t && l < *pos; t = t_next(m, t, &l))
-		;
-
-	return t;
+	return __next(m, pos);
 }
 
 static void t_stop(struct seq_file *m, void *p)
@@ -234,15 +224,8 @@ static void t_stop(struct seq_file *m, void *p)
 static int trace_lookup_stack(struct seq_file *m, long i)
 {
 	unsigned long addr = stack_dump_trace[i];
-#ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(str, addr);
 
-	return seq_printf(m, "%s\n", str);
-#else
-	return seq_printf(m, "%p\n", (void*)addr);
-#endif
+	return seq_printf(m, "%pF\n", (void *)addr);
 }
 
 static void print_disabled(struct seq_file *m)
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index aea321c..a4bb239 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -49,7 +49,8 @@ static struct dentry		*stat_dir;
  * but it will at least advance closer to the next one
  * to be released.
  */
-static struct rb_node *release_next(struct rb_node *node)
+static struct rb_node *release_next(struct tracer_stat *ts,
+				    struct rb_node *node)
 {
 	struct stat_node *snode;
 	struct rb_node *parent = rb_parent(node);
@@ -67,6 +68,8 @@ static struct rb_node *release_next(struct rb_node *node)
 			parent->rb_right = NULL;
 
 		snode = container_of(node, struct stat_node, node);
+		if (ts->stat_release)
+			ts->stat_release(snode->stat);
 		kfree(snode);
 
 		return parent;
@@ -78,7 +81,7 @@ static void __reset_stat_session(struct stat_session *session)
 	struct rb_node *node = session->stat_root.rb_node;
 
 	while (node)
-		node = release_next(node);
+		node = release_next(session->ts, node);
 
 	session->stat_root = RB_ROOT;
 }
@@ -200,17 +203,21 @@ static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct stat_session *session = s->private;
 	struct rb_node *node;
+	int n = *pos;
 	int i;
 
 	/* Prevent from tracer switch or rbtree modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers)
-		return SEQ_START_TOKEN;
+	if (session->ts->stat_headers) {
+		if (n == 0)
+			return SEQ_START_TOKEN;
+		n--;
+	}
 
 	node = rb_first(&session->stat_root);
-	for (i = 0; node && i < *pos; i++)
+	for (i = 0; node && i < n; i++)
 		node = rb_next(node);
 
 	return node;
diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
index f3546a2..8f03914 100644
--- a/kernel/trace/trace_stat.h
+++ b/kernel/trace/trace_stat.h
@@ -18,6 +18,8 @@ struct tracer_stat {
 	int			(*stat_cmp)(void *p1, void *p2);
 	/* Print a stat entry */
 	int			(*stat_show)(struct seq_file *s, void *p);
+	/* Release an entry */
+	void			(*stat_release)(void *stat);
 	/* Print the headers of your stat entries */
 	int			(*stat_headers)(struct seq_file *s);
 };
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5e57964..8712ce3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,30 +1,18 @@
 #include <trace/syscall.h>
+#include <trace/events/syscalls.h>
 #include <linux/kernel.h>
+#include <linux/ftrace.h>
+#include <linux/perf_counter.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
 #include "trace.h"
 
-/* Keep a counter of the syscall tracing users */
-static int refcount;
-
-/* Prevent from races on thread flags toggling */
 static DEFINE_MUTEX(syscall_trace_lock);
-
-/* Option to display the parameters types */
-enum {
-	TRACE_SYSCALLS_OPT_TYPES = 0x1,
-};
-
-static struct tracer_opt syscalls_opts[] = {
-	{ TRACER_OPT(syscall_arg_type, TRACE_SYSCALLS_OPT_TYPES) },
-	{ }
-};
-
-static struct tracer_flags syscalls_flags = {
-	.val = 0, /* By default: no parameters types */
-	.opts = syscalls_opts
-};
+static int sys_refcount_enter;
+static int sys_refcount_exit;
+static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
@@ -35,35 +23,46 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 	struct syscall_metadata *entry;
 	int i, ret, syscall;
 
-	trace_assign_type(trace, ent);
-
+	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-
 	entry = syscall_nr_to_meta(syscall);
+
 	if (!entry)
 		goto end;
 
+	if (entry->enter_id != ent->type) {
+		WARN_ON_ONCE(1);
+		goto end;
+	}
+
 	ret = trace_seq_printf(s, "%s(", entry->name);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	for (i = 0; i < entry->nb_args; i++) {
 		/* parameter types */
-		if (syscalls_flags.val & TRACE_SYSCALLS_OPT_TYPES) {
+		if (trace_flags & TRACE_ITER_VERBOSE) {
 			ret = trace_seq_printf(s, "%s ", entry->types[i]);
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
 		/* parameter values */
-		ret = trace_seq_printf(s, "%s: %lx%s ", entry->args[i],
+		ret = trace_seq_printf(s, "%s: %lx%s", entry->args[i],
 				       trace->args[i],
-				       i == entry->nb_args - 1 ? ")" : ",");
+				       i == entry->nb_args - 1 ? "" : ", ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	ret = trace_seq_putc(s, ')');
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 end:
-	trace_seq_printf(s, "\n");
+	ret =  trace_seq_putc(s, '\n');
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -77,16 +76,20 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 	struct syscall_metadata *entry;
 	int ret;
 
-	trace_assign_type(trace, ent);
-
+	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-
 	entry = syscall_nr_to_meta(syscall);
+
 	if (!entry) {
 		trace_seq_printf(s, "\n");
 		return TRACE_TYPE_HANDLED;
 	}
 
+	if (entry->exit_id != ent->type) {
+		WARN_ON_ONCE(1);
+		return TRACE_TYPE_UNHANDLED;
+	}
+
 	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
 				trace->ret);
 	if (!ret)
@@ -95,62 +98,140 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-void start_ftrace_syscalls(void)
+extern char *__bad_type_size(void);
+
+#define SYSCALL_FIELD(type, name)					\
+	sizeof(type) != sizeof(trace.name) ?				\
+		__bad_type_size() :					\
+		#type, #name, offsetof(typeof(trace), name), sizeof(trace.name)
+
+int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 {
-	unsigned long flags;
-	struct task_struct *g, *t;
+	int i;
+	int nr;
+	int ret;
+	struct syscall_metadata *entry;
+	struct syscall_trace_enter trace;
+	int offset = offsetof(struct syscall_trace_enter, args);
 
-	mutex_lock(&syscall_trace_lock);
+	nr = syscall_name_to_nr(call->data);
+	entry = syscall_nr_to_meta(nr);
 
-	/* Don't enable the flag on the tasks twice */
-	if (++refcount != 1)
-		goto unlock;
+	if (!entry)
+		return 0;
 
-	arch_init_ftrace_syscalls();
-	read_lock_irqsave(&tasklist_lock, flags);
+	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
+			       SYSCALL_FIELD(int, nr));
+	if (!ret)
+		return 0;
 
-	do_each_thread(g, t) {
-		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
-	} while_each_thread(g, t);
+	for (i = 0; i < entry->nb_args; i++) {
+		ret = trace_seq_printf(s, "\tfield:%s %s;", entry->types[i],
+				        entry->args[i]);
+		if (!ret)
+			return 0;
+		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%zu;\n", offset,
+				       sizeof(unsigned long));
+		if (!ret)
+			return 0;
+		offset += sizeof(unsigned long);
+	}
 
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	trace_seq_puts(s, "\nprint fmt: \"");
+	for (i = 0; i < entry->nb_args; i++) {
+		ret = trace_seq_printf(s, "%s: 0x%%0%zulx%s", entry->args[i],
+				        sizeof(unsigned long),
+					i == entry->nb_args - 1 ? "" : ", ");
+		if (!ret)
+			return 0;
+	}
+	trace_seq_putc(s, '"');
 
-unlock:
-	mutex_unlock(&syscall_trace_lock);
+	for (i = 0; i < entry->nb_args; i++) {
+		ret = trace_seq_printf(s, ", ((unsigned long)(REC->%s))",
+				       entry->args[i]);
+		if (!ret)
+			return 0;
+	}
+
+	return trace_seq_putc(s, '\n');
 }
 
-void stop_ftrace_syscalls(void)
+int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 {
-	unsigned long flags;
-	struct task_struct *g, *t;
+	int ret;
+	struct syscall_trace_exit trace;
 
-	mutex_lock(&syscall_trace_lock);
+	ret = trace_seq_printf(s,
+			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
+			       SYSCALL_FIELD(int, nr),
+			       SYSCALL_FIELD(unsigned long, ret));
+	if (!ret)
+		return 0;
 
-	/* There are perhaps still some users */
-	if (--refcount)
-		goto unlock;
+	return trace_seq_printf(s, "\nprint fmt: \"0x%%lx\", REC->ret\n");
+}
 
-	read_lock_irqsave(&tasklist_lock, flags);
+int syscall_enter_define_fields(struct ftrace_event_call *call)
+{
+	struct syscall_trace_enter trace;
+	struct syscall_metadata *meta;
+	int ret;
+	int nr;
+	int i;
+	int offset = offsetof(typeof(trace), args);
+
+	nr = syscall_name_to_nr(call->data);
+	meta = syscall_nr_to_meta(nr);
+
+	if (!meta)
+		return 0;
+
+	ret = trace_define_common_fields(call);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < meta->nb_args; i++) {
+		ret = trace_define_field(call, meta->types[i],
+					 meta->args[i], offset,
+					 sizeof(unsigned long), 0,
+					 FILTER_OTHER);
+		offset += sizeof(unsigned long);
+	}
 
-	do_each_thread(g, t) {
-		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
-	} while_each_thread(g, t);
+	return ret;
+}
 
-	read_unlock_irqrestore(&tasklist_lock, flags);
+int syscall_exit_define_fields(struct ftrace_event_call *call)
+{
+	struct syscall_trace_exit trace;
+	int ret;
 
-unlock:
-	mutex_unlock(&syscall_trace_lock);
+	ret = trace_define_common_fields(call);
+	if (ret)
+		return ret;
+
+	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
+				 FILTER_OTHER);
+
+	return ret;
 }
 
-void ftrace_syscall_enter(struct pt_regs *regs)
+void ftrace_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	int size;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
+	if (!test_bit(syscall_nr, enabled_enter_syscalls))
+		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
@@ -158,8 +239,8 @@ void ftrace_syscall_enter(struct pt_regs *regs)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_ENTER, size,
-							0, 0);
+	event = trace_current_buffer_lock_reserve(&buffer, sys_data->enter_id,
+						  size, 0, 0);
 	if (!event)
 		return;
 
@@ -167,24 +248,30 @@ void ftrace_syscall_enter(struct pt_regs *regs)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
+	if (!filter_current_check_discard(buffer, sys_data->enter_event,
+					  entry, event))
+		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-void ftrace_syscall_exit(struct pt_regs *regs)
+void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
+	if (!test_bit(syscall_nr, enabled_exit_syscalls))
+		return;
 
 	sys_data = syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
-	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_EXIT,
+	event = trace_current_buffer_lock_reserve(&buffer, sys_data->exit_id,
 				sizeof(*entry), 0, 0);
 	if (!event)
 		return;
@@ -193,58 +280,244 @@ void ftrace_syscall_exit(struct pt_regs *regs)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
+	if (!filter_current_check_discard(buffer, sys_data->exit_event,
+					  entry, event))
+		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
-static int init_syscall_tracer(struct trace_array *tr)
+int reg_event_syscall_enter(void *ptr)
 {
-	start_ftrace_syscalls();
+	int ret = 0;
+	int num;
+	char *name;
+
+	name = (char *)ptr;
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return -ENOSYS;
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_refcount_enter)
+		ret = register_trace_sys_enter(ftrace_syscall_enter);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall entry trace point");
+	} else {
+		set_bit(num, enabled_enter_syscalls);
+		sys_refcount_enter++;
+	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
+}
+
+void unreg_event_syscall_enter(void *ptr)
+{
+	int num;
+	char *name;
 
-	return 0;
+	name = (char *)ptr;
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return;
+	mutex_lock(&syscall_trace_lock);
+	sys_refcount_enter--;
+	clear_bit(num, enabled_enter_syscalls);
+	if (!sys_refcount_enter)
+		unregister_trace_sys_enter(ftrace_syscall_enter);
+	mutex_unlock(&syscall_trace_lock);
 }
 
-static void reset_syscall_tracer(struct trace_array *tr)
+int reg_event_syscall_exit(void *ptr)
 {
-	stop_ftrace_syscalls();
-	tracing_reset_online_cpus(tr);
+	int ret = 0;
+	int num;
+	char *name;
+
+	name = (char *)ptr;
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return -ENOSYS;
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_refcount_exit)
+		ret = register_trace_sys_exit(ftrace_syscall_exit);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall exit trace point");
+	} else {
+		set_bit(num, enabled_exit_syscalls);
+		sys_refcount_exit++;
+	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
 }
 
-static struct trace_event syscall_enter_event = {
-	.type	 	= TRACE_SYSCALL_ENTER,
-	.trace		= print_syscall_enter,
-};
+void unreg_event_syscall_exit(void *ptr)
+{
+	int num;
+	char *name;
+
+	name = (char *)ptr;
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return;
+	mutex_lock(&syscall_trace_lock);
+	sys_refcount_exit--;
+	clear_bit(num, enabled_exit_syscalls);
+	if (!sys_refcount_exit)
+		unregister_trace_sys_exit(ftrace_syscall_exit);
+	mutex_unlock(&syscall_trace_lock);
+}
 
-static struct trace_event syscall_exit_event = {
-	.type	 	= TRACE_SYSCALL_EXIT,
-	.trace		= print_syscall_exit,
+struct trace_event event_syscall_enter = {
+	.trace			= print_syscall_enter,
 };
 
-static struct tracer syscall_tracer __read_mostly = {
-	.name	     	= "syscall",
-	.init		= init_syscall_tracer,
-	.reset		= reset_syscall_tracer,
-	.flags		= &syscalls_flags,
+struct trace_event event_syscall_exit = {
+	.trace			= print_syscall_exit,
 };
 
-__init int register_ftrace_syscalls(void)
+#ifdef CONFIG_EVENT_PROFILE
+
+static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
+static int sys_prof_refcount_enter;
+static int sys_prof_refcount_exit;
+
+static void prof_syscall_enter(struct pt_regs *regs, long id)
 {
-	int ret;
+	struct syscall_trace_enter *rec;
+	struct syscall_metadata *sys_data;
+	int syscall_nr;
+	int size;
 
-	ret = register_ftrace_event(&syscall_enter_event);
-	if (!ret) {
-		printk(KERN_WARNING "event %d failed to register\n",
-		       syscall_enter_event.type);
-		WARN_ON_ONCE(1);
+	syscall_nr = syscall_get_nr(current, regs);
+	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
+		return;
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return;
+
+	/* get the size after alignment with the u32 buffer size field */
+	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
+	size = ALIGN(size + sizeof(u32), sizeof(u64));
+	size -= sizeof(u32);
+
+	do {
+		char raw_data[size];
+
+		/* zero the dead bytes from align to not leak stack to user */
+		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+
+		rec = (struct syscall_trace_enter *) raw_data;
+		tracing_generic_entry_update(&rec->ent, 0, 0);
+		rec->ent.type = sys_data->enter_id;
+		rec->nr = syscall_nr;
+		syscall_get_arguments(current, regs, 0, sys_data->nb_args,
+				       (unsigned long *)&rec->args);
+		perf_tpcounter_event(sys_data->enter_id, 0, 1, rec, size);
+	} while(0);
+}
+
+int reg_prof_syscall_enter(char *name)
+{
+	int ret = 0;
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return -ENOSYS;
+
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_prof_refcount_enter)
+		ret = register_trace_sys_enter(prof_syscall_enter);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall entry trace point");
+	} else {
+		set_bit(num, enabled_prof_enter_syscalls);
+		sys_prof_refcount_enter++;
 	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
+}
 
-	ret = register_ftrace_event(&syscall_exit_event);
-	if (!ret) {
-		printk(KERN_WARNING "event %d failed to register\n",
-		       syscall_exit_event.type);
-		WARN_ON_ONCE(1);
+void unreg_prof_syscall_enter(char *name)
+{
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return;
+
+	mutex_lock(&syscall_trace_lock);
+	sys_prof_refcount_enter--;
+	clear_bit(num, enabled_prof_enter_syscalls);
+	if (!sys_prof_refcount_enter)
+		unregister_trace_sys_enter(prof_syscall_enter);
+	mutex_unlock(&syscall_trace_lock);
+}
+
+static void prof_syscall_exit(struct pt_regs *regs, long ret)
+{
+	struct syscall_metadata *sys_data;
+	struct syscall_trace_exit rec;
+	int syscall_nr;
+
+	syscall_nr = syscall_get_nr(current, regs);
+	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
+		return;
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return;
+
+	tracing_generic_entry_update(&rec.ent, 0, 0);
+	rec.ent.type = sys_data->exit_id;
+	rec.nr = syscall_nr;
+	rec.ret = syscall_get_return_value(current, regs);
+
+	perf_tpcounter_event(sys_data->exit_id, 0, 1, &rec, sizeof(rec));
+}
+
+int reg_prof_syscall_exit(char *name)
+{
+	int ret = 0;
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return -ENOSYS;
+
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_prof_refcount_exit)
+		ret = register_trace_sys_exit(prof_syscall_exit);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall entry trace point");
+	} else {
+		set_bit(num, enabled_prof_exit_syscalls);
+		sys_prof_refcount_exit++;
 	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
+}
 
-	return register_tracer(&syscall_tracer);
+void unreg_prof_syscall_exit(char *name)
+{
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= NR_syscalls)
+		return;
+
+	mutex_lock(&syscall_trace_lock);
+	sys_prof_refcount_exit--;
+	clear_bit(num, enabled_prof_exit_syscalls);
+	if (!sys_prof_refcount_exit)
+		unregister_trace_sys_exit(prof_syscall_exit);
+	mutex_unlock(&syscall_trace_lock);
 }
-device_initcall(register_ftrace_syscalls);
+
+#endif
+
+
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 97fcea4..40cafb0 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -9,6 +9,7 @@
 #include <trace/events/workqueue.h>
 #include <linux/list.h>
 #include <linux/percpu.h>
+#include <linux/kref.h>
 #include "trace_stat.h"
 #include "trace.h"
 
@@ -16,6 +17,7 @@
 /* A cpu workqueue thread */
 struct cpu_workqueue_stats {
 	struct list_head            list;
+	struct kref                 kref;
 	int		            cpu;
 	pid_t			    pid;
 /* Can be inserted from interrupt or user context, need to be atomic */
@@ -39,6 +41,11 @@ struct workqueue_global_stats {
 static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
 #define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
 
+static void cpu_workqueue_stat_free(struct kref *kref)
+{
+	kfree(container_of(kref, struct cpu_workqueue_stats, kref));
+}
+
 /* Insertion of a work */
 static void
 probe_workqueue_insertion(struct task_struct *wq_thread,
@@ -96,8 +103,8 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 		return;
 	}
 	INIT_LIST_HEAD(&cws->list);
+	kref_init(&cws->kref);
 	cws->cpu = cpu;
-
 	cws->pid = wq_thread->pid;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
@@ -118,7 +125,7 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 							list) {
 		if (node->pid == wq_thread->pid) {
 			list_del(&node->list);
-			kfree(node);
+			kref_put(&node->kref, cpu_workqueue_stat_free);
 			goto found;
 		}
 	}
@@ -137,9 +144,11 @@ static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 
-	if (!list_empty(&workqueue_cpu_stat(cpu)->list))
+	if (!list_empty(&workqueue_cpu_stat(cpu)->list)) {
 		ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
 				 struct cpu_workqueue_stats, list);
+		kref_get(&ret->kref);
+	}
 
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
@@ -162,9 +171,9 @@ static void *workqueue_stat_start(struct tracer_stat *trace)
 static void *workqueue_stat_next(void *prev, int idx)
 {
 	struct cpu_workqueue_stats *prev_cws = prev;
+	struct cpu_workqueue_stats *ret;
 	int cpu = prev_cws->cpu;
 	unsigned long flags;
-	void *ret = NULL;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
@@ -175,11 +184,14 @@ static void *workqueue_stat_next(void *prev, int idx)
 				return NULL;
 		} while (!(ret = workqueue_stat_start_cpu(cpu)));
 		return ret;
+	} else {
+		ret = list_entry(prev_cws->list.next,
+				 struct cpu_workqueue_stats, list);
+		kref_get(&ret->kref);
 	}
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
-	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
-			  list);
+	return ret;
 }
 
 static int workqueue_stat_show(struct seq_file *s, void *p)
@@ -203,6 +215,13 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static void workqueue_stat_release(void *stat)
+{
+	struct cpu_workqueue_stats *node = stat;
+
+	kref_put(&node->kref, cpu_workqueue_stat_free);
+}
+
 static int workqueue_stat_headers(struct seq_file *s)
 {
 	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
@@ -215,6 +234,7 @@ struct tracer_stat workqueue_stats __read_mostly = {
 	.stat_start = workqueue_stat_start,
 	.stat_next = workqueue_stat_next,
 	.stat_show = workqueue_stat_show,
+	.stat_release = workqueue_stat_release,
 	.stat_headers = workqueue_stat_headers
 };
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1ef5d3a..9489a0a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -24,6 +24,7 @@
 #include <linux/tracepoint.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -242,6 +243,11 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
+	if (elem->regfunc && !elem->state && active)
+		elem->regfunc();
+	else if (elem->unregfunc && elem->state && !active)
+		elem->unregfunc();
+
 	/*
 	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
 	 * probe callbacks array is consistent before setting a pointer to it.
@@ -261,6 +267,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
+	if (elem->unregfunc && elem->state)
+		elem->unregfunc();
+
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
@@ -554,9 +563,6 @@ int tracepoint_module_notify(struct notifier_block *self,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
-		break;
 	case MODULE_STATE_GOING:
 		tracepoint_update_probe_range(mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
@@ -577,3 +583,41 @@ static int init_tracepoints(void)
 __initcall(init_tracepoints);
 
 #endif /* CONFIG_MODULES */
+
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
+
+/* NB: reg/unreg are called while guarded with the tracepoints_mutex */
+static int sys_tracepoint_refcount;
+
+void syscall_regfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			/* Skip kernel threads. */
+			if (t->mm)
+				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	sys_tracepoint_refcount++;
+}
+
+void syscall_unregfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	sys_tracepoint_refcount--;
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+}
+#endif
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 911ba7f..090d300 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -57,7 +57,6 @@
 #        call mcount  (offset: 0x5)
 #        [...]
 #        ret
-#  .globl my_func
 #  other_func:
 #        [...]
 #        call mcount (offset: 0x1b)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0441784..4bab278 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -616,7 +616,7 @@ static void print_tracepoint_events(void)
 								evt_path, st) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			fprintf(stderr, "  %-40s [%s]\n", evt_path,
+			fprintf(stderr, "  %-42s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
 		}
 		closedir(evt_dir);
@@ -650,7 +650,7 @@ void print_events(void)
 			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
 		else
 			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
+		fprintf(stderr, "  %-42s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
@@ -664,7 +664,7 @@ void print_events(void)
 				continue;
 
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				fprintf(stderr, "  %-40s [%s]\n",
+				fprintf(stderr, "  %-42s [%s]\n",
 					event_cache_name(type, op, i),
 					event_type_descriptors[4]);
 			}
@@ -672,7 +672,7 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
+	fprintf(stderr, "  %-42s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
 
