Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbZL1KNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbZL1KNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZL1KNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:13:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:48201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZL1KNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:13:12 -0500
Date: Mon, 28 Dec 2009 10:10:08 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <20091221120117.3fb49cdc.randy.dunlap@oracle.com>
References: <20091221120117.3fb49cdc.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Kconfig spelling fixes and cleanups
Message-ID: <tip-40892367bc893f3abf6f5ca8ac2ed1c98ba26a77@git.kernel.org>
Git-Commit-ID: 40892367bc893f3abf6f5ca8ac2ed1c98ba26a77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40892367bc893f3abf6f5ca8ac2ed1c98ba26a77
Gitweb:     http://git.kernel.org/tip/40892367bc893f3abf6f5ca8ac2ed1c98ba26a77
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Mon, 21 Dec 2009 12:01:17 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:37:54 +0100

tracing: Kconfig spelling fixes and cleanups

Fix filename reference (ftrace-implementation.txt ->
ftrace-design.txt).

Fix spelling, punctuation, grammar.

Fix help text indentation and line lengths to reduce need for
horizontal scrolling or larger window sizes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091221120117.3fb49cdc.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/Kconfig |  112 +++++++++++++++++++++++++-------------------------
 1 files changed, 56 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d006554..6c22d8a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -12,17 +12,17 @@ config NOP_TRACER
 config HAVE_FTRACE_NMI_ENTER
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_TRACER
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_GRAPH_TRACER
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FUNCTION_GRAPH_FP_TEST
 	bool
@@ -34,17 +34,17 @@ config HAVE_FUNCTION_GRAPH_FP_TEST
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_DYNAMIC_FTRACE
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config HAVE_HW_BRANCH_TRACER
 	bool
@@ -52,7 +52,7 @@ config HAVE_HW_BRANCH_TRACER
 config HAVE_SYSCALL_TRACEPOINTS
 	bool
 	help
-	  See Documentation/trace/ftrace-implementation.txt
+	  See Documentation/trace/ftrace-design.txt
 
 config TRACER_MAX_TRACE
 	bool
@@ -83,7 +83,7 @@ config RING_BUFFER_ALLOW_SWAP
 # This allows those options to appear when no other tracer is selected. But the
 # options do not appear when something else selects it. We need the two options
 # GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
-# hidding of the automatic options.
+# hiding of the automatic options.
 
 config TRACING
 	bool
@@ -119,7 +119,7 @@ menuconfig FTRACE
 	bool "Tracers"
 	default y if DEBUG_KERNEL
 	help
-	 Enable the kernel tracing infrastructure.
+	  Enable the kernel tracing infrastructure.
 
 if FTRACE
 
@@ -133,7 +133,7 @@ config FUNCTION_TRACER
 	help
 	  Enable the kernel to trace every kernel function. This is done
 	  by using a compiler feature to insert a small, 5-byte No-Operation
-	  instruction to the beginning of every kernel function, which NOP
+	  instruction at the beginning of every kernel function, which NOP
 	  sequence is then dynamically patched into a tracer call when
 	  tracing is enabled by the administrator. If it's runtime disabled
 	  (the bootup default), then the overhead of the instructions is very
@@ -150,7 +150,7 @@ config FUNCTION_GRAPH_TRACER
 	  and its entry.
 	  Its first purpose is to trace the duration of functions and
 	  draw a call graph for each thread with some information like
-	  the return value. This is done by setting the current return 
+	  the return value. This is done by setting the current return
 	  address on the current task structure into a stack of calls.
 
 
@@ -173,7 +173,7 @@ config IRQSOFF_TRACER
 
 	      echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
 
-	  (Note that kernel size and overhead increases with this option
+	  (Note that kernel size and overhead increase with this option
 	  enabled. This option and the preempt-off timing option can be
 	  used together or separately.)
 
@@ -186,7 +186,7 @@ config PREEMPT_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
 	help
-	  This option measures the time spent in preemption off critical
+	  This option measures the time spent in preemption-off critical
 	  sections, with microsecond accuracy.
 
 	  The default measurement method is a maximum search, which is
@@ -195,7 +195,7 @@ config PREEMPT_TRACER
 
 	      echo 0 > /sys/kernel/debug/tracing/tracing_max_latency
 
-	  (Note that kernel size and overhead increases with this option
+	  (Note that kernel size and overhead increase with this option
 	  enabled. This option and the irqs-off timing option can be
 	  used together or separately.)
 
@@ -222,7 +222,7 @@ config ENABLE_DEFAULT_TRACERS
 	depends on !GENERIC_TRACER
 	select TRACING
 	help
-	  This tracer hooks to various trace points in the kernel
+	  This tracer hooks to various trace points in the kernel,
 	  allowing the user to pick and choose which trace point they
 	  want to trace. It also includes the sched_switch tracer plugin.
 
@@ -265,19 +265,19 @@ choice
 	 The likely/unlikely profiler only looks at the conditions that
 	 are annotated with a likely or unlikely macro.
 
-	 The "all branch" profiler will profile every if statement in the
+	 The "all branch" profiler will profile every if-statement in the
 	 kernel. This profiler will also enable the likely/unlikely
-	 profiler as well.
+	 profiler.
 
-	 Either of the above profilers add a bit of overhead to the system.
-	 If unsure choose "No branch profiling".
+	 Either of the above profilers adds a bit of overhead to the system.
+	 If unsure, choose "No branch profiling".
 
 config BRANCH_PROFILE_NONE
 	bool "No branch profiling"
 	help
-	 No branch profiling. Branch profiling adds a bit of overhead.
-	 Only enable it if you want to analyse the branching behavior.
-	 Otherwise keep it disabled.
+	  No branch profiling. Branch profiling adds a bit of overhead.
+	  Only enable it if you want to analyse the branching behavior.
+	  Otherwise keep it disabled.
 
 config PROFILE_ANNOTATED_BRANCHES
 	bool "Trace likely/unlikely profiler"
@@ -288,7 +288,7 @@ config PROFILE_ANNOTATED_BRANCHES
 
 	  /sys/kernel/debug/tracing/profile_annotated_branch
 
-	  Note: this will add a significant overhead, only turn this
+	  Note: this will add a significant overhead; only turn this
 	  on if you need to profile the system's use of these macros.
 
 config PROFILE_ALL_BRANCHES
@@ -305,7 +305,7 @@ config PROFILE_ALL_BRANCHES
 
 	  This configuration, when enabled, will impose a great overhead
 	  on the system. This should only be enabled when the system
-	  is to be analyzed
+	  is to be analyzed in much detail.
 endchoice
 
 config TRACING_BRANCHES
@@ -335,7 +335,7 @@ config POWER_TRACER
 	depends on X86
 	select GENERIC_TRACER
 	help
-	  This tracer helps developers to analyze and optimize the kernels
+	  This tracer helps developers to analyze and optimize the kernel's
 	  power management decisions, specifically the C-state and P-state
 	  behavior.
 
@@ -391,14 +391,14 @@ config HW_BRANCH_TRACER
 	select GENERIC_TRACER
 	help
 	  This tracer records all branches on the system in a circular
-	  buffer giving access to the last N branches for each cpu.
+	  buffer, giving access to the last N branches for each cpu.
 
 config KMEMTRACE
 	bool "Trace SLAB allocations"
 	select GENERIC_TRACER
 	help
 	  kmemtrace provides tracing for slab allocator functions, such as
-	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
+	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free, etc. Collected
 	  data is then fed to the userspace application in order to analyse
 	  allocation hotspots, internal fragmentation and so on, making it
 	  possible to see how well an allocator performs, as well as debug
@@ -417,15 +417,15 @@ config WORKQUEUE_TRACER
 	bool "Trace workqueues"
 	select GENERIC_TRACER
 	help
-	  The workqueue tracer provides some statistical informations
+	  The workqueue tracer provides some statistical information
           about each cpu workqueue thread such as the number of the
           works inserted and executed since their creation. It can help
-          to evaluate the amount of work each of them have to perform.
+          to evaluate the amount of work each of them has to perform.
           For example it can help a developer to decide whether he should
-          choose a per cpu workqueue instead of a singlethreaded one.
+          choose a per-cpu workqueue instead of a singlethreaded one.
 
 config BLK_DEV_IO_TRACE
-	bool "Support for tracing block io actions"
+	bool "Support for tracing block IO actions"
 	depends on SYSFS
 	depends on BLOCK
 	select RELAY
@@ -456,15 +456,15 @@ config KPROBE_EVENT
 	select TRACING
 	default y
 	help
-	  This allows the user to add tracing events (similar to tracepoints) on the fly
-	  via the ftrace interface. See Documentation/trace/kprobetrace.txt
-	  for more details.
+	  This allows the user to add tracing events (similar to tracepoints)
+	  on the fly via the ftrace interface. See
+	  Documentation/trace/kprobetrace.txt for more details.
 
 	  Those events can be inserted wherever kprobes can probe, and record
 	  various register and memory values.
 
-	  This option is also required by perf-probe subcommand of perf tools. If
-	  you want to use perf tools, this option is strongly recommended.
+	  This option is also required by perf-probe subcommand of perf tools.
+	  If you want to use perf tools, this option is strongly recommended.
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
@@ -472,32 +472,32 @@ config DYNAMIC_FTRACE
 	depends on HAVE_DYNAMIC_FTRACE
 	default y
 	help
-         This option will modify all the calls to ftrace dynamically
-	 (will patch them out of the binary image and replaces them
-	 with a No-Op instruction) as they are called. A table is
-	 created to dynamically enable them again.
+          This option will modify all the calls to ftrace dynamically
+	  (will patch them out of the binary image and replace them
+	  with a No-Op instruction) as they are called. A table is
+	  created to dynamically enable them again.
 
-	 This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but otherwise
-	 has native performance as long as no tracing is active.
+	  This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but
+	  otherwise has native performance as long as no tracing is active.
 
-	 The changes to the code are done by a kernel thread that
-	 wakes up once a second and checks to see if any ftrace calls
-	 were made. If so, it runs stop_machine (stops all CPUS)
-	 and modifies the code to jump over the call to ftrace.
+	  The changes to the code are done by a kernel thread that
+	  wakes up once a second and checks to see if any ftrace calls
+	  were made. If so, it runs stop_machine (stops all CPUS)
+	  and modifies the code to jump over the call to ftrace.
 
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
 	depends on FUNCTION_TRACER
 	default n
 	help
-	 This option enables the kernel function profiler. A file is created
-	 in debugfs called function_profile_enabled which defaults to zero.
-	 When a 1 is echoed into this file profiling begins, and when a
-	 zero is entered, profiling stops. A file in the trace_stats
-	 directory called functions, that show the list of functions that
-	 have been hit and their counters.
+	  This option enables the kernel function profiler. A file is created
+	  in debugfs called function_profile_enabled which defaults to zero.
+	  When a 1 is echoed into this file profiling begins, and when a
+	  zero is entered, profiling stops. A "functions" file is created in
+	  the trace_stats directory; this file shows the list of functions that
+	  have been hit and their counters.
 
-	 If in doubt, say N
+	  If in doubt, say N.
 
 config FTRACE_MCOUNT_RECORD
 	def_bool y
@@ -556,8 +556,8 @@ config RING_BUFFER_BENCHMARK
 	tristate "Ring buffer benchmark stress tester"
 	depends on RING_BUFFER
 	help
-	  This option creates a test to stress the ring buffer and bench mark it.
-	  It creates its own ring buffer such that it will not interfer with
+	  This option creates a test to stress the ring buffer and benchmark it.
+	  It creates its own ring buffer such that it will not interfere with
 	  any other users of the ring buffer (such as ftrace). It then creates
 	  a producer and consumer that will run for 10 seconds and sleep for
 	  10 seconds. Each interval it will print out the number of events
@@ -566,7 +566,7 @@ config RING_BUFFER_BENCHMARK
 	  It does not disable interrupts or raise its priority, so it may be
 	  affected by processes that are running.
 
-	  If unsure, say N
+	  If unsure, say N.
 
 endif # FTRACE
 
