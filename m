Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbYJNNle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbYJNNle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYJNNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:41:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYJNNlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:41:11 -0400
Date: Tue, 14 Oct 2008 15:40:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing updates for v2.6.28
Message-ID: <20081014134027.GA8962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest tracing-v28-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-v28-for-linus

 Thanks,

	Ingo

------------------>
Anders Kaseorg (1):
      ftrace: make ftrace_test_p6nop disassembler-friendly

Andrew Morton (1):
      kbuild: ftrace: don't assume that scripts/recordmcount.pl is executable

Arjan van de Ven (3):
      tracing/fastboot: add a script to visualize the kernel boot process / time
      tracing/fastboot: fix printk format typo in boot tracer
      tracing/fastboot: fix issues and improve output of bootgraph.pl

Arnaud Patard (1):
      tracing/fastboot: fix bootgraph.pl initcall name regexp

Frederic Weisbecker (10):
      tracing/ftrace: change the type of the print_line callback
      tracing/ftrace: adapt mmiotrace to the new type of print_line
      tracing/ftrace: adapt the boot tracer to the new print_line type
      tracing/ftrace: adapt mmiotrace to the new type of print_line, fix
      tracing/fastboot: change the printing of boot tracer according to bootgraph.pl
      tracing/fastboot: get the initcall name before it disappears
      tracing/fastboot: only trace non-module initcalls
      ftrace: return an error when setting a nonexistent tracer
      tracing/fastboot: fix initcalls disposition in bootgraph.pl
      tracing/fastboot: fix initcalls disposition in bootgraph.pl

Frédéric Weisbecker (11):
      ftrace: fix some mistakes in error messages
      tracing/ftrace: make nop tracer reset previous entries
      tracing/ftrace: tracing engine depends on Nop Tracer
      tracing/ftrace: replace none tracer by nop tracer
      x86/ftrace: use uaccess in atomic context
      tracing/ftrace: add the boot tracer
      tracing/ftrace: make tracing suitable to run the boot tracer
      tracing/ftrace: give an entry on the config for boot tracer
      tracing/ftrace: launch boot tracing after pre-smp initcalls
      ftrace/fastboot: disable tracers self-tests when boot tracer is selected
      tracing/ftrace: don't consume unhandled entries by boot tracer

Harvey Harrison (3):
      x86: suppress trivial sparse signedness warnings
      ftrace: fix hex output mode of ftrace
      trace: add build-time check to avoid overrunning hex buffer

Huang Ying (1):
      ftrace: fix incorrect comment style of __ftrace_enabled_save()

Ingo Molnar (15):
      tracing: disable tracepoints by default
      sched: clean up tracepoints
      tracing: clean up tracepoints kconfig structure
      ftrace: ignore functions that cannot be kprobe-ed
      ftrace: mark lapic_wd_event() notrace
      ftrace: build fix
      ftrace: ftrace_kill_atomic() build fix
      ftrace: scripts/recordmcount.pl cross-build hack
      ftrace: clean up macro usage
      stack tracer: depends on DEBUG_KERNEL
      ftrace: make it depend on DEBUG_KERNEL
      ring-buffer: fix build error
      tracing/fastboot: build fix
      tracing/stacktrace: improve help text
      tracing/fastboot: improve help text

Jeremy Fitzhardinge (1):
      ftrace: fix build problem with CONFIG_FTRACE

Lai Jiangshan (3):
      markers: fix unregister bug and reenter bug
      markers: fix unchecked format
      markers: bit-field is not thread-safe nor smp-safe

Mathieu Desnoyers (18):
      tracing: Kernel Tracepoints
      tracing: tracepoints, documentation
      tracing: tracepoints, samples
      tracing, sched: LTTng instrumentation - scheduler
      ftrace: port to tracepoints
      tracepoints: use TABLE_SIZE macro
      tracepoints: use rcu sched
      tracepoints: fix reentrancy
      markers: marker_synchronize_unregister()
      markers: fix unregister bug and reenter bug, cleanup
      markers: probe example, fix teardown
      markers: documentation fix for teardown
      sputrace: use marker_synchronize_unregister()
      markers: re-enable fast batch registration
      markers: turn marker_synchronize_unregister() into an inline
      markers: fix synchronize marker unregister static inline
      tracepoints: tracepoint_synchronize_unregister()
      tracepoints: synchronize unregister static inline

Michael Ellerman (1):
      ftrace: make output nicely spaced for up to 999 cpus

Pekka Paalanen (9):
      x86: fix mmiotrace 8-bit register decoding
      x86 mmiotrace: fix a rare memory leak
      ftrace: move mmiotrace functions out of trace.c
      ftrace: add trace_vprintk()
      x86 mmiotrace: implement mmiotrace_printk()
      mmiotrace: handle TRACE_PRINT entries
      mmiotrace: remove left-over marker cruft
      ftrace: inject markers via trace_marker file
      tracing/ftrace: fix pipe breaking

Peter Zijlstra (2):
      ftrace: make ftrace_printk usable with the other tracers
      ftrace: sched_switch: show the wakee's cpu

Stephen Rothwell (1):
      ftrace: fix build failure

Steven Noonan (4):
      ftrace: add nop tracer
      ftrace: mcount_addr defined but not used
      trace: remove pointless ifdefs
      ftrace: ktime.h not included in ftrace.h

Steven Rostedt (45):
      ftrace: create __mcount_loc section
      ftrace: mcount call site on boot nops core
      ftrace: enable mcount recording for modules
      ftrace: rebuild everything on change to FTRACE_MCOUNT_RECORD
      ftrace: enable using mcount recording on x86
      ftrace: x86 mcount stub
      ftrace: use only 5 byte nops for x86
      ftrace: do not show freed records in available_filter_functions
      ftrace: move notrace to compiler.h
      ftrace: remove old pointers to mcount
      ftrace: new continue entry - separate out from trace_entry
      ftrace: printk formatting infrastructure
      ftrace: ftrace_printk doc moved
      ftrace: dump out ftrace buffers to console on panic
      ftrace: do not init module on ftrace disabled
      ftrace: add necessary locking for ftrace records
      ftrace: update recordmount.pl arch changes
      ftrace: handle weak symbol functions
      ftrace: x86 use copy to and from user functions
      ftrace: objcopy version test for local symbols
      ftrace: add stack tracer
      ftrace: remove direct reference to mcount in trace code
      ftrace: remove warning of old objcopy and local functions
      ftrace: stack trace add indexes
      ftrace: binary and not logical for continue test
      ftrace: print continue index fix
      ftrace: use ftrace_release for all dynamic ftrace functions
      ftrace: fix unlocking of hash
      ftrace: warn on failure to disable mcount callers
      ftrace: give time for wakeup test to run
      tracing: unified trace buffer
      ring_buffer: add paranoid check for buffer page
      ring_buffer: reset buffer page when freeing
      ftrace: make work with new ring buffer
      ftrace: take advantage of variable length entries
      ring_buffer: remove raw from local_irq_save
      ring_buffer: implement new locking
      ftrace: type cast filter+verifier
      ring_buffer: allocate buffer page pointer
      ftrace: preempt disable over interrupt disable
      ring_buffer: map to cpu not page
      ftrace: move pc counter in irqtrace
      ring-buffer: move page indexes into page headers
      ring-buffer: make reentrant
      ftrace: make some tracers reentrant

Tim Bird (1):
      tracing/fastboot: add better resolution to initcall debug/tracing


 Documentation/markers.txt                      |   10 +-
 Documentation/tracepoints.txt                  |  101 ++
 Documentation/tracers/mmiotrace.txt            |    5 +-
 arch/powerpc/platforms/cell/spufs/sputrace.c   |    1 +
 arch/x86/Kconfig                               |    1 +
 arch/x86/kernel/cpu/perfctr-watchdog.c         |   11 +-
 arch/x86/kernel/entry_32.S                     |   14 -
 arch/x86/kernel/entry_64.S                     |   26 -
 arch/x86/kernel/ftrace.c                       |  124 +-
 arch/x86/mm/mmio-mod.c                         |   87 +-
 arch/x86/mm/pf_in.c                            |  121 +-
 arch/x86/mm/testmmiotrace.c                    |    4 +
 include/asm-generic/vmlinux.lds.h              |   14 +-
 include/asm-x86/ftrace.h                       |   10 +
 include/linux/compiler.h                       |    2 +
 include/linux/ftrace.h                         |   84 +-
 include/linux/init.h                           |    2 +-
 include/linux/kernel.h                         |    5 +
 include/linux/kprobes.h                        |    5 +-
 include/linux/linkage.h                        |    2 -
 include/linux/marker.h                         |    7 +
 include/linux/mmiotrace.h                      |   20 +-
 include/linux/module.h                         |   17 +
 include/linux/ring_buffer.h                    |  127 ++
 include/linux/tracepoint.h                     |  137 ++
 include/trace/sched.h                          |   56 +
 init/Kconfig                                   |    7 +
 init/main.c                                    |   34 +-
 kernel/Makefile                                |    1 +
 kernel/exit.c                                  |   10 +-
 kernel/fork.c                                  |    3 +
 kernel/kthread.c                               |    5 +
 kernel/marker.c                                |   36 +-
 kernel/module.c                                |   81 +-
 kernel/notifier.c                              |    2 +-
 kernel/sched.c                                 |   17 +-
 kernel/signal.c                                |    3 +
 kernel/trace/Kconfig                           |   64 +-
 kernel/trace/Makefile                          |    4 +
 kernel/trace/ftrace.c                          |  275 +++-
 kernel/trace/ring_buffer.c                     | 2014 ++++++++++++++++++++++++
 kernel/trace/trace.c                           | 1845 +++++++++++-----------
 kernel/trace/trace.h                           |  211 ++-
 kernel/trace/trace_boot.c                      |  126 ++
 kernel/trace/trace_functions.c                 |    2 +-
 kernel/trace/trace_irqsoff.c                   |   19 +-
 kernel/trace/trace_mmiotrace.c                 |  116 ++-
 kernel/trace/trace_nop.c                       |   64 +
 kernel/trace/trace_sched_switch.c              |  137 +--
 kernel/trace/trace_sched_wakeup.c              |  148 +--
 kernel/trace/trace_selftest.c                  |   83 +-
 kernel/trace/trace_stack.c                     |  310 ++++
 kernel/trace/trace_sysprof.c                   |    2 +-
 kernel/tracepoint.c                            |  477 ++++++
 samples/Kconfig                                |    6 +
 samples/Makefile                               |    2 +-
 samples/markers/probe-example.c                |    1 +
 samples/tracepoints/Makefile                   |    6 +
 samples/tracepoints/tp-samples-trace.h         |   13 +
 samples/tracepoints/tracepoint-probe-sample.c  |   55 +
 samples/tracepoints/tracepoint-probe-sample2.c |   42 +
 samples/tracepoints/tracepoint-sample.c        |   53 +
 scripts/Makefile.build                         |    7 +
 scripts/bootgraph.pl                           |  149 ++
 scripts/recordmcount.pl                        |  395 +++++
 65 files changed, 6244 insertions(+), 1574 deletions(-)
 create mode 100644 Documentation/tracepoints.txt
 create mode 100644 include/linux/ring_buffer.h
 create mode 100644 include/linux/tracepoint.h
 create mode 100644 include/trace/sched.h
 create mode 100644 kernel/trace/ring_buffer.c
 create mode 100644 kernel/trace/trace_boot.c
 create mode 100644 kernel/trace/trace_nop.c
 create mode 100644 kernel/trace/trace_stack.c
 create mode 100644 kernel/tracepoint.c
 create mode 100644 samples/tracepoints/Makefile
 create mode 100644 samples/tracepoints/tp-samples-trace.h
 create mode 100644 samples/tracepoints/tracepoint-probe-sample.c
 create mode 100644 samples/tracepoints/tracepoint-probe-sample2.c
 create mode 100644 samples/tracepoints/tracepoint-sample.c
 create mode 100644 scripts/bootgraph.pl
 create mode 100755 scripts/recordmcount.pl

diff --git a/Documentation/markers.txt b/Documentation/markers.txt
index d9f50a1..089f613 100644
--- a/Documentation/markers.txt
+++ b/Documentation/markers.txt
@@ -50,10 +50,12 @@ Connecting a function (probe) to a marker is done by providing a probe (function
 to call) for the specific marker through marker_probe_register() and can be
 activated by calling marker_arm(). Marker deactivation can be done by calling
 marker_disarm() as many times as marker_arm() has been called. Removing a probe
-is done through marker_probe_unregister(); it will disarm the probe and make
-sure there is no caller left using the probe when it returns. Probe removal is
-preempt-safe because preemption is disabled around the probe call. See the
-"Probe example" section below for a sample probe module.
+is done through marker_probe_unregister(); it will disarm the probe.
+marker_synchronize_unregister() must be called before the end of the module exit
+function to make sure there is no caller left using the probe. This, and the
+fact that preemption is disabled around the probe call, make sure that probe
+removal and module unload are safe. See the "Probe example" section below for a
+sample probe module.
 
 The marker mechanism supports inserting multiple instances of the same marker.
 Markers can be put in inline functions, inlined static functions, and
diff --git a/Documentation/tracepoints.txt b/Documentation/tracepoints.txt
new file mode 100644
index 0000000..5d354e1
--- /dev/null
+++ b/Documentation/tracepoints.txt
@@ -0,0 +1,101 @@
+	             Using the Linux Kernel Tracepoints
+
+			    Mathieu Desnoyers
+
+
+This document introduces Linux Kernel Tracepoints and their use. It provides
+examples of how to insert tracepoints in the kernel and connect probe functions
+to them and provides some examples of probe functions.
+
+
+* Purpose of tracepoints
+
+A tracepoint placed in code provides a hook to call a function (probe) that you
+can provide at runtime. A tracepoint can be "on" (a probe is connected to it) or
+"off" (no probe is attached). When a tracepoint is "off" it has no effect,
+except for adding a tiny time penalty (checking a condition for a branch) and
+space penalty (adding a few bytes for the function call at the end of the
+instrumented function and adds a data structure in a separate section).  When a
+tracepoint is "on", the function you provide is called each time the tracepoint
+is executed, in the execution context of the caller. When the function provided
+ends its execution, it returns to the caller (continuing from the tracepoint
+site).
+
+You can put tracepoints at important locations in the code. They are
+lightweight hooks that can pass an arbitrary number of parameters,
+which prototypes are described in a tracepoint declaration placed in a header
+file.
+
+They can be used for tracing and performance accounting.
+
+
+* Usage
+
+Two elements are required for tracepoints :
+
+- A tracepoint definition, placed in a header file.
+- The tracepoint statement, in C code.
+
+In order to use tracepoints, you should include linux/tracepoint.h.
+
+In include/trace/subsys.h :
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(subsys_eventname,
+	TPPTOTO(int firstarg, struct task_struct *p),
+	TPARGS(firstarg, p));
+
+In subsys/file.c (where the tracing statement must be added) :
+
+#include <trace/subsys.h>
+
+void somefct(void)
+{
+	...
+	trace_subsys_eventname(arg, task);
+	...
+}
+
+Where :
+- subsys_eventname is an identifier unique to your event
+    - subsys is the name of your subsystem.
+    - eventname is the name of the event to trace.
+- TPPTOTO(int firstarg, struct task_struct *p) is the prototype of the function
+  called by this tracepoint.
+- TPARGS(firstarg, p) are the parameters names, same as found in the prototype.
+
+Connecting a function (probe) to a tracepoint is done by providing a probe
+(function to call) for the specific tracepoint through
+register_trace_subsys_eventname().  Removing a probe is done through
+unregister_trace_subsys_eventname(); it will remove the probe sure there is no
+caller left using the probe when it returns. Probe removal is preempt-safe
+because preemption is disabled around the probe call. See the "Probe example"
+section below for a sample probe module.
+
+The tracepoint mechanism supports inserting multiple instances of the same
+tracepoint, but a single definition must be made of a given tracepoint name over
+all the kernel to make sure no type conflict will occur. Name mangling of the
+tracepoints is done using the prototypes to make sure typing is correct.
+Verification of probe type correctness is done at the registration site by the
+compiler. Tracepoints can be put in inline functions, inlined static functions,
+and unrolled loops as well as regular functions.
+
+The naming scheme "subsys_event" is suggested here as a convention intended
+to limit collisions. Tracepoint names are global to the kernel: they are
+considered as being the same whether they are in the core kernel image or in
+modules.
+
+
+* Probe / tracepoint example
+
+See the example provided in samples/tracepoints/src
+
+Compile them with your kernel.
+
+Run, as root :
+modprobe tracepoint-example (insmod order is not important)
+modprobe tracepoint-probe-example
+cat /proc/tracepoint-example (returns an expected error)
+rmmod tracepoint-example tracepoint-probe-example
+dmesg
diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index a4afb56..5bbbe20 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -36,7 +36,7 @@ $ mount -t debugfs debugfs /debug
 $ echo mmiotrace > /debug/tracing/current_tracer
 $ cat /debug/tracing/trace_pipe > mydump.txt &
 Start X or whatever.
-$ echo "X is up" > /debug/tracing/marker
+$ echo "X is up" > /debug/tracing/trace_marker
 $ echo none > /debug/tracing/current_tracer
 Check for lost events.
 
@@ -59,9 +59,8 @@ The 'cat' process should stay running (sleeping) in the background.
 Load the driver you want to trace and use it. Mmiotrace will only catch MMIO
 accesses to areas that are ioremapped while mmiotrace is active.
 
-[Unimplemented feature:]
 During tracing you can place comments (markers) into the trace by
-$ echo "X is up" > /debug/tracing/marker
+$ echo "X is up" > /debug/tracing/trace_marker
 This makes it easier to see which part of the (huge) trace corresponds to
 which action. It is recommended to place descriptive markers about what you
 do.
diff --git a/arch/powerpc/platforms/cell/spufs/sputrace.c b/arch/powerpc/platforms/cell/spufs/sputrace.c
index 92d20e9..2ece399 100644
--- a/arch/powerpc/platforms/cell/spufs/sputrace.c
+++ b/arch/powerpc/platforms/cell/spufs/sputrace.c
@@ -232,6 +232,7 @@ static void __exit sputrace_exit(void)
 
 	remove_proc_entry("sputrace", NULL);
 	kfree(sputrace_log);
+	marker_synchronize_unregister();
 }
 
 module_init(sputrace_init);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fc8351f..5a34c54 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 6bff382..9abd48b 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -17,6 +17,8 @@
 #include <linux/bitops.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <linux/kprobes.h>
+
 #include <asm/apic.h>
 #include <asm/intel_arch_perfmon.h>
 
@@ -336,7 +338,8 @@ static void single_msr_unreserve(void)
 	release_perfctr_nmi(wd_ops->perfctr);
 }
 
-static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+static void __kprobes
+single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	/* start the cycle over again */
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
@@ -401,7 +404,7 @@ static int setup_p6_watchdog(unsigned nmi_hz)
 	return 1;
 }
 
-static void p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+static void __kprobes p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	/*
 	 * P6 based Pentium M need to re-unmask
@@ -605,7 +608,7 @@ static void p4_unreserve(void)
 	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
 }
 
-static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+static void __kprobes p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
 	unsigned dummy;
 	/*
@@ -784,7 +787,7 @@ unsigned lapic_adjust_nmi_hz(unsigned hz)
 	return hz;
 }
 
-int lapic_wd_event(unsigned nmi_hz)
+int __kprobes lapic_wd_event(unsigned nmi_hz)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 	u64 ctr;
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index b21fbfa..4e4269c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1153,20 +1153,6 @@ ENDPROC(xen_failsafe_callback)
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 ENTRY(mcount)
-	pushl %eax
-	pushl %ecx
-	pushl %edx
-	movl 0xc(%esp), %eax
-	subl $MCOUNT_INSN_SIZE, %eax
-
-.globl mcount_call
-mcount_call:
-	call ftrace_stub
-
-	popl %edx
-	popl %ecx
-	popl %eax
-
 	ret
 END(mcount)
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1db6ce4..09e7145 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -64,32 +64,6 @@
 #ifdef CONFIG_FTRACE
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
-
-	subq $0x38, %rsp
-	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
-
-	movq 0x38(%rsp), %rdi
-	subq $MCOUNT_INSN_SIZE, %rdi
-
-.globl mcount_call
-mcount_call:
-	call ftrace_stub
-
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
-	movq (%rsp), %rax
-	addq $0x38, %rsp
-
 	retq
 END(mcount)
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ab115cd..d073d98 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -11,17 +11,18 @@
 
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/list.h>
 
-#include <asm/alternative.h>
 #include <asm/ftrace.h>
+#include <asm/nops.h>
 
 
 /* Long is fine, even if it is only 4 bytes ;-) */
-static long *ftrace_nop;
+static unsigned long *ftrace_nop;
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -60,11 +61,7 @@ notrace int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
-	unsigned replaced;
-	unsigned old = *(unsigned *)old_code; /* 4 bytes */
-	unsigned new = *(unsigned *)new_code; /* 4 bytes */
-	unsigned char newch = new_code[4];
-	int faulted = 0;
+	unsigned char replaced[MCOUNT_INSN_SIZE];
 
 	/*
 	 * Note: Due to modules and __init, code can
@@ -72,29 +69,20 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	 *  as well as code changing.
 	 *
 	 * No real locking needed, this code is run through
-	 * kstop_machine.
+	 * kstop_machine, or before SMP starts.
 	 */
-	asm volatile (
-		"1: lock\n"
-		"   cmpxchg %3, (%2)\n"
-		"   jnz 2f\n"
-		"   movb %b4, 4(%2)\n"
-		"2:\n"
-		".section .fixup, \"ax\"\n"
-		"3:	movl $1, %0\n"
-		"	jmp 2b\n"
-		".previous\n"
-		_ASM_EXTABLE(1b, 3b)
-		: "=r"(faulted), "=a"(replaced)
-		: "r"(ip), "r"(new), "c"(newch),
-		  "0"(faulted), "a"(old)
-		: "memory");
-	sync_core();
+	if (__copy_from_user_inatomic(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
+		return 1;
+
+	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return 2;
 
-	if (replaced != old && replaced != new)
-		faulted = 2;
+	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
+				    MCOUNT_INSN_SIZE));
 
-	return faulted;
+	sync_core();
+
+	return 0;
 }
 
 notrace int ftrace_update_ftrace_func(ftrace_func_t func)
@@ -112,30 +100,76 @@ notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 
 notrace int ftrace_mcount_set(unsigned long *data)
 {
-	unsigned long ip = (long)(&mcount_call);
-	unsigned long *addr = data;
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-
-	/*
-	 * Replace the mcount stub with a pointer to the
-	 * ip recorder function.
-	 */
-	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(ip, *addr);
-	*addr = ftrace_modify_code(ip, old, new);
-
+	/* mcount is initialized as a nop */
+	*data = 0;
 	return 0;
 }
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	const unsigned char *const *noptable = find_nop_table();
-
-	/* This is running in kstop_machine */
-
-	ftrace_mcount_set(data);
+	extern const unsigned char ftrace_test_p6nop[];
+	extern const unsigned char ftrace_test_nop5[];
+	extern const unsigned char ftrace_test_jmp[];
+	int faulted = 0;
 
-	ftrace_nop = (unsigned long *)noptable[MCOUNT_INSN_SIZE];
+	/*
+	 * There is no good nop for all x86 archs.
+	 * We will default to using the P6_NOP5, but first we
+	 * will test to make sure that the nop will actually
+	 * work on this CPU. If it faults, we will then
+	 * go to a lesser efficient 5 byte nop. If that fails
+	 * we then just use a jmp as our nop. This isn't the most
+	 * efficient nop, but we can not use a multi part nop
+	 * since we would then risk being preempted in the middle
+	 * of that nop, and if we enabled tracing then, it might
+	 * cause a system crash.
+	 *
+	 * TODO: check the cpuid to determine the best nop.
+	 */
+	asm volatile (
+		"jmp ftrace_test_jmp\n"
+		/* This code needs to stay around */
+		".section .text, \"ax\"\n"
+		"ftrace_test_jmp:"
+		"jmp ftrace_test_p6nop\n"
+		"nop\n"
+		"nop\n"
+		"nop\n"  /* 2 byte jmp + 3 bytes */
+		"ftrace_test_p6nop:"
+		P6_NOP5
+		"jmp 1f\n"
+		"ftrace_test_nop5:"
+		".byte 0x66,0x66,0x66,0x66,0x90\n"
+		"jmp 1f\n"
+		".previous\n"
+		"1:"
+		".section .fixup, \"ax\"\n"
+		"2:	movl $1, %0\n"
+		"	jmp ftrace_test_nop5\n"
+		"3:	movl $2, %0\n"
+		"	jmp 1b\n"
+		".previous\n"
+		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
+		_ASM_EXTABLE(ftrace_test_nop5, 3b)
+		: "=r"(faulted) : "0" (faulted));
+
+	switch (faulted) {
+	case 0:
+		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
+		ftrace_nop = (unsigned long *)ftrace_test_p6nop;
+		break;
+	case 1:
+		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
+		ftrace_nop = (unsigned long *)ftrace_test_nop5;
+		break;
+	case 2:
+		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
+		ftrace_nop = (unsigned long *)ftrace_test_jmp;
+		break;
+	}
+
+	/* The return code is retured via data */
+	*(unsigned long *)data = 0;
 
 	return 0;
 }
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 635b50e..2c4baa8 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -56,13 +56,6 @@ struct remap_trace {
 static DEFINE_PER_CPU(struct trap_reason, pf_reason);
 static DEFINE_PER_CPU(struct mmiotrace_rw, cpu_trace);
 
-#if 0 /* XXX: no way gather this info anymore */
-/* Access to this is not per-cpu. */
-static DEFINE_PER_CPU(atomic_t, dropped);
-#endif
-
-static struct dentry *marker_file;
-
 static DEFINE_MUTEX(mmiotrace_mutex);
 static DEFINE_SPINLOCK(trace_lock);
 static atomic_t mmiotrace_enabled;
@@ -75,7 +68,7 @@ static LIST_HEAD(trace_list);		/* struct remap_trace */
  *   and trace_lock.
  * - Routines depending on is_enabled() must take trace_lock.
  * - trace_list users must hold trace_lock.
- * - is_enabled() guarantees that mmio_trace_record is allowed.
+ * - is_enabled() guarantees that mmio_trace_{rw,mapping} are allowed.
  * - pre/post callbacks assume the effect of is_enabled() being true.
  */
 
@@ -97,44 +90,6 @@ static bool is_enabled(void)
 	return atomic_read(&mmiotrace_enabled);
 }
 
-#if 0 /* XXX: needs rewrite */
-/*
- * Write callback for the debugfs entry:
- * Read a marker and write it to the mmio trace log
- */
-static ssize_t write_marker(struct file *file, const char __user *buffer,
-						size_t count, loff_t *ppos)
-{
-	char *event = NULL;
-	struct mm_io_header *headp;
-	ssize_t len = (count > 65535) ? 65535 : count;
-
-	event = kzalloc(sizeof(*headp) + len, GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-
-	headp = (struct mm_io_header *)event;
-	headp->type = MMIO_MAGIC | (MMIO_MARKER << MMIO_OPCODE_SHIFT);
-	headp->data_len = len;
-
-	if (copy_from_user(event + sizeof(*headp), buffer, len)) {
-		kfree(event);
-		return -EFAULT;
-	}
-
-	spin_lock_irq(&trace_lock);
-#if 0 /* XXX: convert this to use tracing */
-	if (is_enabled())
-		relay_write(chan, event, sizeof(*headp) + len);
-	else
-#endif
-		len = -EINVAL;
-	spin_unlock_irq(&trace_lock);
-	kfree(event);
-	return len;
-}
-#endif
-
 static void print_pte(unsigned long address)
 {
 	unsigned int level;
@@ -307,8 +262,10 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 	map.map_id = trace->id;
 
 	spin_lock_irq(&trace_lock);
-	if (!is_enabled())
+	if (!is_enabled()) {
+		kfree(trace);
 		goto not_enabled;
+	}
 
 	mmio_trace_mapping(&map);
 	list_add_tail(&trace->list, &trace_list);
@@ -377,6 +334,23 @@ void mmiotrace_iounmap(volatile void __iomem *addr)
 		iounmap_trace_core(addr);
 }
 
+int mmiotrace_printk(const char *fmt, ...)
+{
+	int ret = 0;
+	va_list args;
+	unsigned long flags;
+	va_start(args, fmt);
+
+	spin_lock_irqsave(&trace_lock, flags);
+	if (is_enabled())
+		ret = mmio_trace_printk(fmt, args);
+	spin_unlock_irqrestore(&trace_lock, flags);
+
+	va_end(args);
+	return ret;
+}
+EXPORT_SYMBOL(mmiotrace_printk);
+
 static void clear_trace_list(void)
 {
 	struct remap_trace *trace;
@@ -462,26 +436,12 @@ static void leave_uniprocessor(void)
 }
 #endif
 
-#if 0 /* XXX: out of order */
-static struct file_operations fops_marker = {
-	.owner =	THIS_MODULE,
-	.write =	write_marker
-};
-#endif
-
 void enable_mmiotrace(void)
 {
 	mutex_lock(&mmiotrace_mutex);
 	if (is_enabled())
 		goto out;
 
-#if 0 /* XXX: tracing does not support text entries */
-	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
-								&fops_marker);
-	if (!marker_file)
-		pr_err(NAME "marker file creation failed.\n");
-#endif
-
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
 	enter_uniprocessor();
@@ -506,11 +466,6 @@ void disable_mmiotrace(void)
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
 	leave_uniprocessor();
-	if (marker_file) {
-		debugfs_remove(marker_file);
-		marker_file = NULL;
-	}
-
 	pr_info(NAME "disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index efa1911..df3d5c8 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -79,25 +79,34 @@ static unsigned int mw32[] = { 0xC7 };
 static unsigned int mw64[] = { 0x89, 0x8B };
 #endif /* not __i386__ */
 
-static int skip_prefix(unsigned char *addr, int *shorted, int *enlarged,
-								int *rexr)
+struct prefix_bits {
+	unsigned shorted:1;
+	unsigned enlarged:1;
+	unsigned rexr:1;
+	unsigned rex:1;
+};
+
+static int skip_prefix(unsigned char *addr, struct prefix_bits *prf)
 {
 	int i;
 	unsigned char *p = addr;
-	*shorted = 0;
-	*enlarged = 0;
-	*rexr = 0;
+	prf->shorted = 0;
+	prf->enlarged = 0;
+	prf->rexr = 0;
+	prf->rex = 0;
 
 restart:
 	for (i = 0; i < ARRAY_SIZE(prefix_codes); i++) {
 		if (*p == prefix_codes[i]) {
 			if (*p == 0x66)
-				*shorted = 1;
+				prf->shorted = 1;
 #ifdef __amd64__
 			if ((*p & 0xf8) == 0x48)
-				*enlarged = 1;
+				prf->enlarged = 1;
 			if ((*p & 0xf4) == 0x44)
-				*rexr = 1;
+				prf->rexr = 1;
+			if ((*p & 0xf0) == 0x40)
+				prf->rex = 1;
 #endif
 			p++;
 			goto restart;
@@ -135,12 +144,12 @@ enum reason_type get_ins_type(unsigned long ins_addr)
 {
 	unsigned int opcode;
 	unsigned char *p;
-	int shorted, enlarged, rexr;
+	struct prefix_bits prf;
 	int i;
 	enum reason_type rv = OTHERS;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 
 	CHECK_OP_TYPE(opcode, reg_rop, REG_READ);
@@ -156,10 +165,11 @@ static unsigned int get_ins_reg_width(unsigned long ins_addr)
 {
 	unsigned int opcode;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 
 	for (i = 0; i < ARRAY_SIZE(rw8); i++)
@@ -168,7 +178,7 @@ static unsigned int get_ins_reg_width(unsigned long ins_addr)
 
 	for (i = 0; i < ARRAY_SIZE(rw32); i++)
 		if (rw32[i] == opcode)
-			return (shorted ? 2 : (enlarged ? 8 : 4));
+			return prf.shorted ? 2 : (prf.enlarged ? 8 : 4);
 
 	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
 	return 0;
@@ -178,10 +188,11 @@ unsigned int get_ins_mem_width(unsigned long ins_addr)
 {
 	unsigned int opcode;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 
 	for (i = 0; i < ARRAY_SIZE(mw8); i++)
@@ -194,11 +205,11 @@ unsigned int get_ins_mem_width(unsigned long ins_addr)
 
 	for (i = 0; i < ARRAY_SIZE(mw32); i++)
 		if (mw32[i] == opcode)
-			return shorted ? 2 : 4;
+			return prf.shorted ? 2 : 4;
 
 	for (i = 0; i < ARRAY_SIZE(mw64); i++)
 		if (mw64[i] == opcode)
-			return shorted ? 2 : (enlarged ? 8 : 4);
+			return prf.shorted ? 2 : (prf.enlarged ? 8 : 4);
 
 	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
 	return 0;
@@ -238,7 +249,7 @@ enum {
 #endif
 };
 
-static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
+static unsigned char *get_reg_w8(int no, int rex, struct pt_regs *regs)
 {
 	unsigned char *rv = NULL;
 
@@ -255,18 +266,6 @@ static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
 	case arg_DL:
 		rv = (unsigned char *)&regs->dx;
 		break;
-	case arg_AH:
-		rv = 1 + (unsigned char *)&regs->ax;
-		break;
-	case arg_BH:
-		rv = 1 + (unsigned char *)&regs->bx;
-		break;
-	case arg_CH:
-		rv = 1 + (unsigned char *)&regs->cx;
-		break;
-	case arg_DH:
-		rv = 1 + (unsigned char *)&regs->dx;
-		break;
 #ifdef __amd64__
 	case arg_R8:
 		rv = (unsigned char *)&regs->r8;
@@ -294,9 +293,55 @@ static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
 		break;
 #endif
 	default:
-		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
 		break;
 	}
+
+	if (rv)
+		return rv;
+
+	if (rex) {
+		/*
+		 * If REX prefix exists, access low bytes of SI etc.
+		 * instead of AH etc.
+		 */
+		switch (no) {
+		case arg_SI:
+			rv = (unsigned char *)&regs->si;
+			break;
+		case arg_DI:
+			rv = (unsigned char *)&regs->di;
+			break;
+		case arg_BP:
+			rv = (unsigned char *)&regs->bp;
+			break;
+		case arg_SP:
+			rv = (unsigned char *)&regs->sp;
+			break;
+		default:
+			break;
+		}
+	} else {
+		switch (no) {
+		case arg_AH:
+			rv = 1 + (unsigned char *)&regs->ax;
+			break;
+		case arg_BH:
+			rv = 1 + (unsigned char *)&regs->bx;
+			break;
+		case arg_CH:
+			rv = 1 + (unsigned char *)&regs->cx;
+			break;
+		case arg_DH:
+			rv = 1 + (unsigned char *)&regs->dx;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!rv)
+		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
+
 	return rv;
 }
 
@@ -368,11 +413,12 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 	unsigned char mod_rm;
 	int reg;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(reg_rop); i++)
 		if (reg_rop[i] == opcode) {
@@ -392,10 +438,10 @@ unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
 
 do_work:
 	mod_rm = *p;
-	reg = ((mod_rm >> 3) & 0x7) | (rexr << 3);
+	reg = ((mod_rm >> 3) & 0x7) | (prf.rexr << 3);
 	switch (get_ins_reg_width(ins_addr)) {
 	case 1:
-		return *get_reg_w8(reg, regs);
+		return *get_reg_w8(reg, prf.rex, regs);
 
 	case 2:
 		return *(unsigned short *)get_reg_w32(reg, regs);
@@ -422,11 +468,12 @@ unsigned long get_ins_imm_val(unsigned long ins_addr)
 	unsigned char mod_rm;
 	unsigned char mod;
 	unsigned char *p;
-	int i, shorted, enlarged, rexr;
+	struct prefix_bits prf;
+	int i;
 	unsigned long rv;
 
 	p = (unsigned char *)ins_addr;
-	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += skip_prefix(p, &prf);
 	p += get_opcode(p, &opcode);
 	for (i = 0; i < ARRAY_SIZE(imm_wop); i++)
 		if (imm_wop[i] == opcode) {
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index d877c5b..ab50a8d 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -3,6 +3,7 @@
  */
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/mmiotrace.h>
 
 #define MODULE_NAME "testmmiotrace"
 
@@ -13,6 +14,7 @@ MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
+	mmiotrace_printk("Write test.\n");
 	for (i = 0; i < 256; i++)
 		iowrite8(i, p + i);
 	for (i = 1024; i < (5 * 1024); i += 2)
@@ -24,6 +26,7 @@ static void do_write_test(void __iomem *p)
 static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
+	mmiotrace_printk("Read test.\n");
 	for (i = 0; i < 256; i++)
 		ioread8(p + i);
 	for (i = 1024; i < (5 * 1024); i += 2)
@@ -39,6 +42,7 @@ static void do_test(void)
 		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
 		return;
 	}
+	mmiotrace_printk("ioremap returned %p.\n", p);
 	do_write_test(p);
 	do_read_test(p);
 	iounmap(p);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 7440a0d..838d9b2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -37,6 +37,13 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+#define MCOUNT_REC()	VMLINUX_SYMBOL(__start_mcount_loc) = .; \
+			*(__mcount_loc)				\
+			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
+#else
+#define MCOUNT_REC()
+#endif
 
 /* .data section */
 #define DATA_DATA							\
@@ -52,7 +59,10 @@
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
-	VMLINUX_SYMBOL(__stop___markers) = .;
+	VMLINUX_SYMBOL(__stop___markers) = .;				\
+	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
+	*(__tracepoints)						\
+	VMLINUX_SYMBOL(__stop___tracepoints) = .;
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
@@ -61,6 +71,7 @@
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
+		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
@@ -188,6 +199,7 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
+		MCOUNT_REC()						\
 		DEV_KEEP(init.rodata)					\
 		DEV_KEEP(exit.rodata)					\
 		CPU_KEEP(init.rodata)					\
diff --git a/include/asm-x86/ftrace.h b/include/asm-x86/ftrace.h
index be0e004..1bb6f9b 100644
--- a/include/asm-x86/ftrace.h
+++ b/include/asm-x86/ftrace.h
@@ -7,6 +7,16 @@
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	/*
+	 * call mcount is "e8 <4 byte offset>"
+	 * The addr points to the 4 byte offset and the caller of this
+	 * function wants the pointer to e8. Simply subtract one.
+	 */
+	return addr - 1;
+}
 #endif
 
 #endif /* CONFIG_FTRACE */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8322141..98115d9 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -44,6 +44,8 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # error Sorry, your compiler is too old/not recognized.
 #endif
 
+#define notrace __attribute__((no_instrument_function))
+
 /* Intel compiler defines __GNUC__. So we will overwrite implementations
  * coming from above header files here
  */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index bb38406..a3d4615 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -1,10 +1,14 @@
 #ifndef _LINUX_FTRACE_H
 #define _LINUX_FTRACE_H
 
-#ifdef CONFIG_FTRACE
-
 #include <linux/linkage.h>
 #include <linux/fs.h>
+#include <linux/ktime.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/kallsyms.h>
+
+#ifdef CONFIG_FTRACE
 
 extern int ftrace_enabled;
 extern int
@@ -36,6 +40,7 @@ extern void ftrace_stub(unsigned long a0, unsigned long a1);
 # define register_ftrace_function(ops) do { } while (0)
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
+static inline void ftrace_kill_atomic(void) { }
 #endif /* CONFIG_FTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -76,8 +81,10 @@ extern void mcount_call(void);
 
 extern int skip_trace(unsigned long ip);
 
-void ftrace_disable_daemon(void);
-void ftrace_enable_daemon(void);
+extern void ftrace_release(void *start, unsigned long size);
+
+extern void ftrace_disable_daemon(void);
+extern void ftrace_enable_daemon(void);
 
 #else
 # define skip_trace(ip)				({ 0; })
@@ -85,6 +92,7 @@ void ftrace_enable_daemon(void);
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
+static inline void ftrace_release(void *start, unsigned long size) { }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
@@ -98,9 +106,11 @@ static inline void tracer_disable(void)
 #endif
 }
 
-/* Ftrace disable/restore without lock. Some synchronization mechanism
+/*
+ * Ftrace disable/restore without lock. Some synchronization mechanism
  * must be used to prevent ftrace_enabled to be changed between
- * disable/restore. */
+ * disable/restore.
+ */
 static inline int __ftrace_enabled_save(void)
 {
 #ifdef CONFIG_FTRACE
@@ -157,9 +167,71 @@ static inline void __ftrace_enabled_restore(int enabled)
 #ifdef CONFIG_TRACING
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
+
+/**
+ * ftrace_printk - printf formatting in the ftrace buffer
+ * @fmt: the printf format for printing
+ *
+ * Note: __ftrace_printk is an internal function for ftrace_printk and
+ *       the @ip is passed in via the ftrace_printk macro.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please refrain from leaving ftrace_printks scattered around in
+ * your code.
+ */
+# define ftrace_printk(fmt...) __ftrace_printk(_THIS_IP_, fmt)
+extern int
+__ftrace_printk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern void ftrace_dump(void);
 #else
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
+static inline int
+ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));
+
+static inline int
+ftrace_printk(const char *fmt, ...)
+{
+	return 0;
+}
+static inline void ftrace_dump(void) { }
 #endif
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+extern void ftrace_init(void);
+extern void ftrace_init_module(unsigned long *start, unsigned long *end);
+#else
+static inline void ftrace_init(void) { }
+static inline void
+ftrace_init_module(unsigned long *start, unsigned long *end) { }
+#endif
+
+
+struct boot_trace {
+	pid_t			caller;
+	char			func[KSYM_NAME_LEN];
+	int			result;
+	unsigned long long	duration;		/* usecs */
+	ktime_t			calltime;
+	ktime_t			rettime;
+};
+
+#ifdef CONFIG_BOOT_TRACER
+extern void trace_boot(struct boot_trace *it, initcall_t fn);
+extern void start_boot_trace(void);
+extern void stop_boot_trace(void);
+#else
+static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
+static inline void start_boot_trace(void) { }
+static inline void stop_boot_trace(void) { }
+#endif
+
+
+
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/linux/init.h b/include/linux/init.h
index 93538b6..27f61f6 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -40,7 +40,7 @@
 
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
-#define __init		__section(.init.text) __cold
+#define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
 #define __initconst	__section(.init.rodata)
 #define __exitdata	__section(.exit.data)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 75d81f1..ecce4a4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -486,4 +486,9 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
+
 #endif
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 0be7795..497b1d1 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -29,6 +29,7 @@
  *		<jkenisto@us.ibm.com>  and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  */
+#include <linux/linkage.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/smp.h>
@@ -47,7 +48,7 @@
 #define KPROBE_HIT_SSDONE	0x00000008
 
 /* Attach to insert probes on any functions which should be ignored*/
-#define __kprobes	__attribute__((__section__(".kprobes.text")))
+#define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
 
 struct kprobe;
 struct pt_regs;
@@ -256,7 +257,7 @@ void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 
 #else /* CONFIG_KPROBES */
 
-#define __kprobes	/**/
+#define __kprobes	notrace
 struct jprobe;
 struct kretprobe;
 
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 56ba373..9fd1f85 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/linkage.h>
 
-#define notrace __attribute__((no_instrument_function))
-
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
diff --git a/include/linux/marker.h b/include/linux/marker.h
index 1290653..889196c 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -160,4 +160,11 @@ extern int marker_probe_unregister_private_data(marker_probe_func *probe,
 extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
 	int num);
 
+/*
+ * marker_synchronize_unregister must be called between the last marker probe
+ * unregistration and the end of module exit to make sure there is no caller
+ * executing a probe when it is freed.
+ */
+#define marker_synchronize_unregister() synchronize_sched()
+
 #endif
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 61d19e1..139d7c8 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -34,11 +34,15 @@ extern void unregister_kmmio_probe(struct kmmio_probe *p);
 /* Called from page fault handler. */
 extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
 
-/* Called from ioremap.c */
 #ifdef CONFIG_MMIOTRACE
+/* Called from ioremap.c */
 extern void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
 							void __iomem *addr);
 extern void mmiotrace_iounmap(volatile void __iomem *addr);
+
+/* For anyone to insert markers. Remember trailing newline. */
+extern int mmiotrace_printk(const char *fmt, ...)
+				__attribute__ ((format (printf, 1, 2)));
 #else
 static inline void mmiotrace_ioremap(resource_size_t offset,
 					unsigned long size, void __iomem *addr)
@@ -48,15 +52,22 @@ static inline void mmiotrace_ioremap(resource_size_t offset,
 static inline void mmiotrace_iounmap(volatile void __iomem *addr)
 {
 }
-#endif /* CONFIG_MMIOTRACE_HOOKS */
+
+static inline int mmiotrace_printk(const char *fmt, ...)
+				__attribute__ ((format (printf, 1, 0)));
+
+static inline int mmiotrace_printk(const char *fmt, ...)
+{
+	return 0;
+}
+#endif /* CONFIG_MMIOTRACE */
 
 enum mm_io_opcode {
 	MMIO_READ = 0x1,     /* struct mmiotrace_rw */
 	MMIO_WRITE = 0x2,    /* struct mmiotrace_rw */
 	MMIO_PROBE = 0x3,    /* struct mmiotrace_map */
 	MMIO_UNPROBE = 0x4,  /* struct mmiotrace_map */
-	MMIO_MARKER = 0x5,   /* raw char data */
-	MMIO_UNKNOWN_OP = 0x6, /* struct mmiotrace_rw */
+	MMIO_UNKNOWN_OP = 0x5, /* struct mmiotrace_rw */
 };
 
 struct mmiotrace_rw {
@@ -81,5 +92,6 @@ extern void enable_mmiotrace(void);
 extern void disable_mmiotrace(void);
 extern void mmio_trace_rw(struct mmiotrace_rw *rw);
 extern void mmio_trace_mapping(struct mmiotrace_map *map);
+extern int mmio_trace_printk(const char *fmt, va_list args);
 
 #endif /* MMIOTRACE_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index 68e0955..8b61135 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
+#include <linux/tracepoint.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
@@ -331,6 +332,10 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+#ifdef CONFIG_TRACEPOINTS
+	struct tracepoint *tracepoints;
+	unsigned int num_tracepoints;
+#endif
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
@@ -454,6 +459,9 @@ extern void print_modules(void);
 
 extern void module_update_markers(void);
 
+extern void module_update_tracepoints(void);
+extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -558,6 +566,15 @@ static inline void module_update_markers(void)
 {
 }
 
+static inline void module_update_tracepoints(void)
+{
+}
+
+static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MODULES */
 
 struct device_driver;
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
new file mode 100644
index 0000000..536b0ca
--- /dev/null
+++ b/include/linux/ring_buffer.h
@@ -0,0 +1,127 @@
+#ifndef _LINUX_RING_BUFFER_H
+#define _LINUX_RING_BUFFER_H
+
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+
+struct ring_buffer;
+struct ring_buffer_iter;
+
+/*
+ * Don't reference this struct directly, use functions below.
+ */
+struct ring_buffer_event {
+	u32		type:2, len:3, time_delta:27;
+	u32		array[];
+};
+
+/**
+ * enum ring_buffer_type - internal ring buffer types
+ *
+ * @RINGBUF_TYPE_PADDING:	Left over page padding
+ *				 array is ignored
+ *				 size is variable depending on how much
+ *				  padding is needed
+ *
+ * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
+ *				 array[0] = time delta (28 .. 59)
+ *				 size = 8 bytes
+ *
+ * @RINGBUF_TYPE_TIME_STAMP:	Sync time stamp with external clock
+ *				 array[0] = tv_nsec
+ *				 array[1] = tv_sec
+ *				 size = 16 bytes
+ *
+ * @RINGBUF_TYPE_DATA:		Data record
+ *				 If len is zero:
+ *				  array[0] holds the actual length
+ *				  array[1..(length+3)/4-1] holds data
+ *				 else
+ *				  length = len << 2
+ *				  array[0..(length+3)/4] holds data
+ */
+enum ring_buffer_type {
+	RINGBUF_TYPE_PADDING,
+	RINGBUF_TYPE_TIME_EXTEND,
+	/* FIXME: RINGBUF_TYPE_TIME_STAMP not implemented */
+	RINGBUF_TYPE_TIME_STAMP,
+	RINGBUF_TYPE_DATA,
+};
+
+unsigned ring_buffer_event_length(struct ring_buffer_event *event);
+void *ring_buffer_event_data(struct ring_buffer_event *event);
+
+/**
+ * ring_buffer_event_time_delta - return the delta timestamp of the event
+ * @event: the event to get the delta timestamp of
+ *
+ * The delta timestamp is the 27 bit timestamp since the last event.
+ */
+static inline unsigned
+ring_buffer_event_time_delta(struct ring_buffer_event *event)
+{
+	return event->time_delta;
+}
+
+/*
+ * size is in bytes for each per CPU buffer.
+ */
+struct ring_buffer *
+ring_buffer_alloc(unsigned long size, unsigned flags);
+void ring_buffer_free(struct ring_buffer *buffer);
+
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
+
+struct ring_buffer_event *
+ring_buffer_lock_reserve(struct ring_buffer *buffer,
+			 unsigned long length,
+			 unsigned long *flags);
+int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+			      struct ring_buffer_event *event,
+			      unsigned long flags);
+int ring_buffer_write(struct ring_buffer *buffer,
+		      unsigned long length, void *data);
+
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
+struct ring_buffer_event *
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
+
+struct ring_buffer_iter *
+ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
+void ring_buffer_read_finish(struct ring_buffer_iter *iter);
+
+struct ring_buffer_event *
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts);
+struct ring_buffer_event *
+ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
+void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
+int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
+
+unsigned long ring_buffer_size(struct ring_buffer *buffer);
+
+void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
+void ring_buffer_reset(struct ring_buffer *buffer);
+
+int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+			 struct ring_buffer *buffer_b, int cpu);
+
+int ring_buffer_empty(struct ring_buffer *buffer);
+int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
+
+void ring_buffer_record_disable(struct ring_buffer *buffer);
+void ring_buffer_record_enable(struct ring_buffer *buffer);
+void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu);
+void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
+
+unsigned long ring_buffer_entries(struct ring_buffer *buffer);
+unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
+
+u64 ring_buffer_time_stamp(int cpu);
+void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
+
+enum ring_buffer_flags {
+	RB_FL_OVERWRITE		= 1 << 0,
+};
+
+#endif /* _LINUX_RING_BUFFER_H */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
new file mode 100644
index 0000000..c5bb39c
--- /dev/null
+++ b/include/linux/tracepoint.h
@@ -0,0 +1,137 @@
+#ifndef _LINUX_TRACEPOINT_H
+#define _LINUX_TRACEPOINT_H
+
+/*
+ * Kernel Tracepoint API.
+ *
+ * See Documentation/tracepoint.txt.
+ *
+ * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * Heavily inspired from the Linux Kernel Markers.
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+
+struct module;
+struct tracepoint;
+
+struct tracepoint {
+	const char *name;		/* Tracepoint name */
+	int state;			/* State. */
+	void **funcs;
+} __attribute__((aligned(8)));
+
+
+#define TPPROTO(args...)	args
+#define TPARGS(args...)		args
+
+#ifdef CONFIG_TRACEPOINTS
+
+/*
+ * it_func[0] is never NULL because there is at least one element in the array
+ * when the array itself is non NULL.
+ */
+#define __DO_TRACE(tp, proto, args)					\
+	do {								\
+		void **it_func;						\
+									\
+		rcu_read_lock_sched();					\
+		it_func = rcu_dereference((tp)->funcs);			\
+		if (it_func) {						\
+			do {						\
+				((void(*)(proto))(*it_func))(args);	\
+			} while (*(++it_func));				\
+		}							\
+		rcu_read_unlock_sched();				\
+	} while (0)
+
+/*
+ * Make sure the alignment of the structure in the __tracepoints section will
+ * not add unwanted padding between the beginning of the section and the
+ * structure. Force alignment to the same alignment as the section start.
+ */
+#define DEFINE_TRACE(name, proto, args)					\
+	static inline void trace_##name(proto)				\
+	{								\
+		static const char __tpstrtab_##name[]			\
+		__attribute__((section("__tracepoints_strings")))	\
+		= #name ":" #proto;					\
+		static struct tracepoint __tracepoint_##name		\
+		__attribute__((section("__tracepoints"), aligned(8))) =	\
+		{ __tpstrtab_##name, 0, NULL };				\
+		if (unlikely(__tracepoint_##name.state))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TPPROTO(proto), TPARGS(args));		\
+	}								\
+	static inline int register_trace_##name(void (*probe)(proto))	\
+	{								\
+		return tracepoint_probe_register(#name ":" #proto,	\
+			(void *)probe);					\
+	}								\
+	static inline void unregister_trace_##name(void (*probe)(proto))\
+	{								\
+		tracepoint_probe_unregister(#name ":" #proto,		\
+			(void *)probe);					\
+	}
+
+extern void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end);
+
+#else /* !CONFIG_TRACEPOINTS */
+#define DEFINE_TRACE(name, proto, args)			\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{ }								\
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline int register_trace_##name(void (*probe)(proto))	\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline void unregister_trace_##name(void (*probe)(proto))\
+	{ }
+
+static inline void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{ }
+#endif /* CONFIG_TRACEPOINTS */
+
+/*
+ * Connect a probe to a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_register(const char *name, void *probe);
+
+/*
+ * Disconnect a probe from a tracepoint.
+ * Internal API, should not be used directly.
+ */
+extern int tracepoint_probe_unregister(const char *name, void *probe);
+
+struct tracepoint_iter {
+	struct module *module;
+	struct tracepoint *tracepoint;
+};
+
+extern void tracepoint_iter_start(struct tracepoint_iter *iter);
+extern void tracepoint_iter_next(struct tracepoint_iter *iter);
+extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
+extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
+extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
+	struct tracepoint *begin, struct tracepoint *end);
+
+/*
+ * tracepoint_synchronize_unregister must be called between the last tracepoint
+ * probe unregistration and the end of module exit to make sure there is no
+ * caller executing a probe when it is freed.
+ */
+static inline void tracepoint_synchronize_unregister(void)
+{
+	synchronize_sched();
+}
+
+#endif
diff --git a/include/trace/sched.h b/include/trace/sched.h
new file mode 100644
index 0000000..ad47369
--- /dev/null
+++ b/include/trace/sched.h
@@ -0,0 +1,56 @@
+#ifndef _TRACE_SCHED_H
+#define _TRACE_SCHED_H
+
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(sched_kthread_stop,
+	TPPROTO(struct task_struct *t),
+		TPARGS(t));
+
+DEFINE_TRACE(sched_kthread_stop_ret,
+	TPPROTO(int ret),
+		TPARGS(ret));
+
+DEFINE_TRACE(sched_wait_task,
+	TPPROTO(struct rq *rq, struct task_struct *p),
+		TPARGS(rq, p));
+
+DEFINE_TRACE(sched_wakeup,
+	TPPROTO(struct rq *rq, struct task_struct *p),
+		TPARGS(rq, p));
+
+DEFINE_TRACE(sched_wakeup_new,
+	TPPROTO(struct rq *rq, struct task_struct *p),
+		TPARGS(rq, p));
+
+DEFINE_TRACE(sched_switch,
+	TPPROTO(struct rq *rq, struct task_struct *prev,
+		struct task_struct *next),
+		TPARGS(rq, prev, next));
+
+DEFINE_TRACE(sched_migrate_task,
+	TPPROTO(struct rq *rq, struct task_struct *p, int dest_cpu),
+		TPARGS(rq, p, dest_cpu));
+
+DEFINE_TRACE(sched_process_free,
+	TPPROTO(struct task_struct *p),
+		TPARGS(p));
+
+DEFINE_TRACE(sched_process_exit,
+	TPPROTO(struct task_struct *p),
+		TPARGS(p));
+
+DEFINE_TRACE(sched_process_wait,
+	TPPROTO(struct pid *pid),
+		TPARGS(pid));
+
+DEFINE_TRACE(sched_process_fork,
+	TPPROTO(struct task_struct *parent, struct task_struct *child),
+		TPARGS(parent, child));
+
+DEFINE_TRACE(sched_signal_send,
+	TPPROTO(int sig, struct task_struct *p),
+		TPARGS(sig, p));
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index c11da38..031344f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -771,6 +771,13 @@ config PROFILING
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
 
+#
+# Place an empty function call at each tracepoint site. Can be
+# dynamically changed for a probe function.
+#
+config TRACEPOINTS
+	bool
+
 config MARKERS
 	bool "Activate markers"
 	help
diff --git a/init/main.c b/init/main.c
index 3820323..b2e7ff4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -60,6 +60,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/ftrace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -687,6 +688,8 @@ asmlinkage void __init start_kernel(void)
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 
+	ftrace_init();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
@@ -703,30 +706,31 @@ __setup("initcall_debug", initcall_debug_setup);
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
-	ktime_t t0, t1, delta;
+	ktime_t delta;
 	char msgbuf[64];
-	int result;
+	struct boot_trace it;
 
 	if (initcall_debug) {
-		printk("calling  %pF\n", fn);
-		t0 = ktime_get();
+		it.caller = task_pid_nr(current);
+		printk("calling  %pF @ %i\n", fn, it.caller);
+		it.calltime = ktime_get();
 	}
 
-	result = fn();
+	it.result = fn();
 
 	if (initcall_debug) {
-		t1 = ktime_get();
-		delta = ktime_sub(t1, t0);
-
-		printk("initcall %pF returned %d after %Ld msecs\n",
-			fn, result,
-			(unsigned long long) delta.tv64 >> 20);
+		it.rettime = ktime_get();
+		delta = ktime_sub(it.rettime, it.calltime);
+		it.duration = (unsigned long long) delta.tv64 >> 10;
+		printk("initcall %pF returned %d after %Ld usecs\n", fn,
+			it.result, it.duration);
+		trace_boot(&it, fn);
 	}
 
 	msgbuf[0] = 0;
 
-	if (result && result != -ENODEV && initcall_debug)
-		sprintf(msgbuf, "error code %d ", result);
+	if (it.result && it.result != -ENODEV && initcall_debug)
+		sprintf(msgbuf, "error code %d ", it.result);
 
 	if (preempt_count() != count) {
 		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
@@ -740,7 +744,7 @@ int do_one_initcall(initcall_t fn)
 		printk("initcall %pF returned with %s\n", fn, msgbuf);
 	}
 
-	return result;
+	return it.result;
 }
 
 
@@ -855,6 +859,7 @@ static int __init kernel_init(void * unused)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+	start_boot_trace();
 
 	smp_init();
 	sched_init_smp();
@@ -881,6 +886,7 @@ static int __init kernel_init(void * unused)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
+	stop_boot_trace();
 	init_post();
 	return 0;
 }
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..8f9ce7e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
+obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FTRACE) += trace/
diff --git a/kernel/exit.c b/kernel/exit.c
index 85a83c8..7b71f87 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -47,6 +47,7 @@
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/tracehook.h>
+#include <trace/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -149,7 +150,10 @@ static void __exit_signal(struct task_struct *tsk)
 
 static void delayed_put_task_struct(struct rcu_head *rhp)
 {
-	put_task_struct(container_of(rhp, struct task_struct, rcu));
+	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
+
+	trace_sched_process_free(tsk);
+	put_task_struct(tsk);
 }
 
 
@@ -1074,6 +1078,8 @@ NORET_TYPE void do_exit(long code)
 
 	if (group_dead)
 		acct_process();
+	trace_sched_process_exit(tsk);
+
 	exit_sem(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
@@ -1675,6 +1681,8 @@ static long do_wait(enum pid_type type, struct pid *pid, int options,
 	struct task_struct *tsk;
 	int retval;
 
+	trace_sched_process_wait(pid);
+
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 30de644..cfaff92 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -58,6 +58,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <trace/sched.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1364,6 +1365,8 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
+		trace_sched_process_fork(current, p);
+
 		nr = task_pid_vnr(p);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 96cff2f..50598e2 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <trace/sched.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
 
@@ -206,6 +207,8 @@ int kthread_stop(struct task_struct *k)
 	/* It could exit after stop_info.k set, but before wake_up_process. */
 	get_task_struct(k);
 
+	trace_sched_kthread_stop(k);
+
 	/* Must init completion *before* thread sees kthread_stop_info.k */
 	init_completion(&kthread_stop_info.done);
 	smp_wmb();
@@ -221,6 +224,8 @@ int kthread_stop(struct task_struct *k)
 	ret = kthread_stop_info.err;
 	mutex_unlock(&kthread_stop_lock);
 
+	trace_sched_kthread_stop_ret(ret);
+
 	return ret;
 }
 EXPORT_SYMBOL(kthread_stop);
diff --git a/kernel/marker.c b/kernel/marker.c
index 7d1faec..e9c6b2b 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -62,7 +62,7 @@ struct marker_entry {
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	struct rcu_head rcu;
 	void *oldptr;
-	unsigned char rcu_pending:1;
+	int rcu_pending;
 	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };
@@ -103,11 +103,11 @@ void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
 	char ptype;
 
 	/*
-	 * preempt_disable does two things : disabling preemption to make sure
-	 * the teardown of the callbacks can be done correctly when they are in
-	 * modules and they insure RCU read coherency.
+	 * rcu_read_lock_sched does two things : disabling preemption to make
+	 * sure the teardown of the callbacks can be done correctly when they
+	 * are in modules and they insure RCU read coherency.
 	 */
-	preempt_disable();
+	rcu_read_lock_sched();
 	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
@@ -145,7 +145,7 @@ void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
 			va_end(args);
 		}
 	}
-	preempt_enable();
+	rcu_read_unlock_sched();
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb);
 
@@ -162,7 +162,7 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 	va_list args;	/* not initialized */
 	char ptype;
 
-	preempt_disable();
+	rcu_read_lock_sched();
 	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
@@ -195,7 +195,7 @@ void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
 			multi[i].func(multi[i].probe_private, call_private,
 				mdata->format, &args);
 	}
-	preempt_enable();
+	rcu_read_unlock_sched();
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
 
@@ -560,7 +560,7 @@ static int set_marker(struct marker_entry **entry, struct marker *elem,
  * Disable a marker and its probe callback.
  * Note: only waiting an RCU period after setting elem->call to the empty
  * function insures that the original callback is not used anymore. This insured
- * by preempt_disable around the call site.
+ * by rcu_read_lock_sched around the call site.
  */
 static void disable_marker(struct marker *elem)
 {
@@ -653,11 +653,17 @@ int marker_probe_register(const char *name, const char *format,
 	entry = get_marker(name);
 	if (!entry) {
 		entry = add_marker(name, format);
-		if (IS_ERR(entry)) {
+		if (IS_ERR(entry))
 			ret = PTR_ERR(entry);
-			goto end;
-		}
+	} else if (format) {
+		if (!entry->format)
+			ret = marker_set_format(&entry, format);
+		else if (strcmp(entry->format, format))
+			ret = -EPERM;
 	}
+	if (ret)
+		goto end;
+
 	/*
 	 * If we detect that a call_rcu is pending for this marker,
 	 * make sure it's executed now.
@@ -674,6 +680,8 @@ int marker_probe_register(const char *name, const char *format,
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
@@ -717,6 +725,8 @@ int marker_probe_unregister(const char *name,
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
@@ -795,6 +805,8 @@ int marker_probe_unregister_private_data(marker_probe_func *probe,
 	mutex_lock(&markers_mutex);
 	entry = get_marker_from_private_data(probe, probe_private);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
diff --git a/kernel/module.c b/kernel/module.c
index 9db1191..7576c2d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -46,6 +46,8 @@
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 #include <asm/sections.h>
+#include <linux/tracepoint.h>
+#include <linux/ftrace.h>
 
 #if 0
 #define DEBUGP printk
@@ -1429,6 +1431,9 @@ static void free_module(struct module *mod)
 	/* Module unload stuff */
 	module_unload_free(mod);
 
+	/* release any pointers to mcount in this module */
+	ftrace_release(mod->module_core, mod->core_size);
+
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
@@ -1831,9 +1836,13 @@ static noinline struct module *load_module(void __user *umod,
 #endif
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int tracepointsindex;
+	unsigned int tracepointsstringsindex;
+	unsigned int mcountindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
+	void *mseg;
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
 
@@ -2117,6 +2126,12 @@ static noinline struct module *load_module(void __user *umod,
 	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
+	tracepointsindex = find_sec(hdr, sechdrs, secstrings, "__tracepoints");
+	tracepointsstringsindex = find_sec(hdr, sechdrs, secstrings,
+					"__tracepoints_strings");
+
+	mcountindex = find_sec(hdr, sechdrs, secstrings,
+			       "__mcount_loc");
 
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
@@ -2144,6 +2159,12 @@ static noinline struct module *load_module(void __user *umod,
 	mod->num_markers =
 		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
 #endif
+#ifdef CONFIG_TRACEPOINTS
+	mod->tracepoints = (void *)sechdrs[tracepointsindex].sh_addr;
+	mod->num_tracepoints =
+		sechdrs[tracepointsindex].sh_size / sizeof(*mod->tracepoints);
+#endif
+
 
         /* Find duplicate symbols */
 	err = verify_export_symbols(mod);
@@ -2162,11 +2183,21 @@ static noinline struct module *load_module(void __user *umod,
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+	if (!mod->taints) {
 #ifdef CONFIG_MARKERS
-	if (!mod->taints)
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+#ifdef CONFIG_TRACEPOINTS
+		tracepoint_update_probe_range(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+#endif
+	}
+
+	/* sechdrs[0].sh_size is always zero */
+	mseg = (void *)sechdrs[mcountindex].sh_addr;
+	ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2236,6 +2267,7 @@ static noinline struct module *load_module(void __user *umod,
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
+	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
 	module_free(mod, mod->module_init);
@@ -2717,3 +2749,50 @@ void module_update_markers(void)
 	mutex_unlock(&module_mutex);
 }
 #endif
+
+#ifdef CONFIG_TRACEPOINTS
+void module_update_tracepoints(void)
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list)
+		if (!mod->taints)
+			tracepoint_update_probe_range(mod->tracepoints,
+				mod->tracepoints + mod->num_tracepoints);
+	mutex_unlock(&module_mutex);
+}
+
+/*
+ * Returns 0 if current not found.
+ * Returns 1 if current found.
+ */
+int module_get_iter_tracepoints(struct tracepoint_iter *iter)
+{
+	struct module *iter_mod;
+	int found = 0;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(iter_mod, &modules, list) {
+		if (!iter_mod->taints) {
+			/*
+			 * Sorted module list
+			 */
+			if (iter_mod < iter->module)
+				continue;
+			else if (iter_mod > iter->module)
+				iter->tracepoint = NULL;
+			found = tracepoint_get_iter_range(&iter->tracepoint,
+				iter_mod->tracepoints,
+				iter_mod->tracepoints
+					+ iter_mod->num_tracepoints);
+			if (found) {
+				iter->module = iter_mod;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&module_mutex);
+	return found;
+}
+#endif
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 823be11..4282c0a 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -550,7 +550,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
-int notify_die(enum die_val val, const char *str,
+int notrace notify_die(enum die_val val, const char *str,
 	       struct pt_regs *regs, long err, int trap, int sig)
 {
 	struct die_args args = {
diff --git a/kernel/sched.c b/kernel/sched.c
index 6f23059..3d1ad13 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <trace/sched.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -1936,6 +1937,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
+		trace_sched_wait_task(rq, p);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
@@ -2297,9 +2299,7 @@ out_activate:
 	success = 1;
 
 out_running:
-	trace_mark(kernel_sched_wakeup,
-		"pid %d state %ld ## rq %p task %p rq->curr %p",
-		p->pid, p->state, rq, p, rq->curr);
+	trace_sched_wakeup(rq, p);
 	check_preempt_curr(rq, p, sync);
 
 	p->state = TASK_RUNNING;
@@ -2432,9 +2432,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(rq);
 	}
-	trace_mark(kernel_sched_wakeup_new,
-		"pid %d state %ld ## rq %p task %p rq->curr %p",
-		p->pid, p->state, rq, p, rq->curr);
+	trace_sched_wakeup_new(rq, p);
 	check_preempt_curr(rq, p, 0);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
@@ -2607,11 +2605,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_mark(kernel_sched_schedule,
-		"prev_pid %d next_pid %d prev_state %ld "
-		"## rq %p prev %p next %p",
-		prev->pid, next->pid, prev->state,
-		rq, prev, next);
+	trace_sched_switch(rq, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -2851,6 +2845,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
+	trace_sched_migrate_task(rq, p, dest_cpu);
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
diff --git a/kernel/signal.c b/kernel/signal.c
index e661b01..bf40ecc 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -27,6 +27,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <trace/sched.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -803,6 +804,8 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	struct sigpending *pending;
 	struct sigqueue *q;
 
+	trace_sched_signal_send(sig, t);
+
 	assert_spin_locked(&t->sighand->siglock);
 	if (!prepare_signal(sig, t))
 		return 0;
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 263e9e6..1cb3e1f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1,23 +1,37 @@
 #
 # Architectures that offer an FTRACE implementation should select HAVE_FTRACE:
 #
+
+config NOP_TRACER
+	bool
+
 config HAVE_FTRACE
 	bool
+	select NOP_TRACER
 
 config HAVE_DYNAMIC_FTRACE
 	bool
 
+config HAVE_FTRACE_MCOUNT_RECORD
+	bool
+
 config TRACER_MAX_TRACE
 	bool
 
+config RING_BUFFER
+	bool
+
 config TRACING
 	bool
 	select DEBUG_FS
+	select RING_BUFFER
 	select STACKTRACE
+	select TRACEPOINTS
 
 config FTRACE
 	bool "Kernel Function Tracer"
 	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
 	select FRAME_POINTER
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
@@ -36,6 +50,7 @@ config IRQSOFF_TRACER
 	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on GENERIC_TIME
 	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
 	select TRACE_IRQFLAGS
 	select TRACING
 	select TRACER_MAX_TRACE
@@ -59,6 +74,7 @@ config PREEMPT_TRACER
 	depends on GENERIC_TIME
 	depends on PREEMPT
 	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
 	select TRACING
 	select TRACER_MAX_TRACE
 	help
@@ -86,6 +102,7 @@ config SYSPROF_TRACER
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
 	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
@@ -96,16 +113,56 @@ config SCHED_TRACER
 config CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
 	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
 	select TRACING
 	select MARKERS
 	help
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
 
+config BOOT_TRACER
+	bool "Trace boot initcalls"
+	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer helps developers to optimize boot times: it records
+	  the timings of the initcalls and traces key events and the identity
+	  of tasks that can cause boot delays, such as context-switches.
+
+	  Its aim is to be parsed by the /scripts/bootgraph.pl tool to
+	  produce pretty graphics about boot inefficiencies, giving a visual
+	  representation of the delays during initcalls - but the raw
+	  /debug/tracing/trace text output is readable too.
+
+	  ( Note that tracing self tests can't be enabled if this tracer is
+	    selected, because the self-tests are an initcall as well and that
+	    would invalidate the boot trace. )
+
+config STACK_TRACER
+	bool "Trace max stack"
+	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
+	select FTRACE
+	select STACKTRACE
+	help
+	  This special tracer records the maximum stack footprint of the
+	  kernel and displays it in debugfs/tracing/stack_trace.
+
+	  This tracer works by hooking into every function call that the
+	  kernel executes, and keeping a maximum stack depth value and
+	  stack-trace saved. Because this logic has to execute in every
+	  kernel function, all the time, this option can slow down the
+	  kernel measurably and is generally intended for kernel
+	  developers only.
+
+	  Say N if unsure.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FTRACE
 	depends on HAVE_DYNAMIC_FTRACE
+	depends on DEBUG_KERNEL
 	default y
 	help
          This option will modify all the calls to ftrace dynamically
@@ -121,12 +178,17 @@ config DYNAMIC_FTRACE
 	 were made. If so, it runs stop_machine (stops all CPUS)
 	 and modifies the code to jump over the call to ftrace.
 
+config FTRACE_MCOUNT_RECORD
+	def_bool y
+	depends on DYNAMIC_FTRACE
+	depends on HAVE_FTRACE_MCOUNT_RECORD
+
 config FTRACE_SELFTEST
 	bool
 
 config FTRACE_STARTUP_TEST
 	bool "Perform a startup test on ftrace"
-	depends on TRACING
+	depends on TRACING && DEBUG_KERNEL && !BOOT_TRACER
 	select FTRACE_SELFTEST
 	help
 	  This option performs a series of startup tests on ftrace. On bootup
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 71d17de..a85dfba 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -11,6 +11,7 @@ obj-y += trace_selftest_dynamic.o
 endif
 
 obj-$(CONFIG_FTRACE) += libftrace.o
+obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
@@ -19,6 +20,9 @@ obj-$(CONFIG_FTRACE) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
+obj-$(CONFIG_NOP_TRACER) += trace_nop.o
+obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
+obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f6e3af3..4dda4f6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -81,7 +81,7 @@ void clear_ftrace_function(void)
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	/* Should never be called by interrupts */
+	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
 	ops->next = ftrace_list;
@@ -115,6 +115,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	struct ftrace_ops **p;
 	int ret = 0;
 
+	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
 	/*
@@ -153,6 +154,30 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+#ifndef CONFIG_FTRACE_MCOUNT_RECORD
+/*
+ * The hash lock is only needed when the recording of the mcount
+ * callers are dynamic. That is, by the caller themselves and
+ * not recorded via the compilation.
+ */
+static DEFINE_SPINLOCK(ftrace_hash_lock);
+#define ftrace_hash_lock(flags)	  spin_lock_irqsave(&ftrace_hash_lock, flags)
+#define ftrace_hash_unlock(flags) \
+			spin_unlock_irqrestore(&ftrace_hash_lock, flags)
+#else
+/* This is protected via the ftrace_lock with MCOUNT_RECORD. */
+#define ftrace_hash_lock(flags)   do { (void)(flags); } while (0)
+#define ftrace_hash_unlock(flags) do { } while(0)
+#endif
+
+/*
+ * Since MCOUNT_ADDR may point to mcount itself, we do not want
+ * to get it confused by reading a reference in the code as we
+ * are parsing on objcopy output of text. Use a variable for
+ * it instead.
+ */
+static unsigned long mcount_addr = MCOUNT_ADDR;
+
 static struct task_struct *ftraced_task;
 
 enum {
@@ -171,7 +196,6 @@ static struct hlist_head ftrace_hash[FTRACE_HASHSIZE];
 
 static DEFINE_PER_CPU(int, ftrace_shutdown_disable_cpu);
 
-static DEFINE_SPINLOCK(ftrace_shutdown_lock);
 static DEFINE_MUTEX(ftraced_lock);
 static DEFINE_MUTEX(ftrace_regex_lock);
 
@@ -294,13 +318,37 @@ static inline void ftrace_del_hash(struct dyn_ftrace *node)
 
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
-	/* no locking, only called from kstop_machine */
-
 	rec->ip = (unsigned long)ftrace_free_records;
 	ftrace_free_records = rec;
 	rec->flags |= FTRACE_FL_FREE;
 }
 
+void ftrace_release(void *start, unsigned long size)
+{
+	struct dyn_ftrace *rec;
+	struct ftrace_page *pg;
+	unsigned long s = (unsigned long)start;
+	unsigned long e = s + size;
+	int i;
+
+	if (ftrace_disabled || !start)
+		return;
+
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
+
+	for (pg = ftrace_pages_start; pg; pg = pg->next) {
+		for (i = 0; i < pg->index; i++) {
+			rec = &pg->records[i];
+
+			if ((rec->ip >= s) && (rec->ip < e))
+				ftrace_free_rec(rec);
+		}
+	}
+	spin_unlock(&ftrace_lock);
+
+}
+
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 {
 	struct dyn_ftrace *rec;
@@ -338,7 +386,6 @@ ftrace_record_ip(unsigned long ip)
 	unsigned long flags;
 	unsigned long key;
 	int resched;
-	int atomic;
 	int cpu;
 
 	if (!ftrace_enabled || ftrace_disabled)
@@ -368,9 +415,7 @@ ftrace_record_ip(unsigned long ip)
 	if (ftrace_ip_in_hash(ip, key))
 		goto out;
 
-	atomic = irqs_disabled();
-
-	spin_lock_irqsave(&ftrace_shutdown_lock, flags);
+	ftrace_hash_lock(flags);
 
 	/* This ip may have hit the hash before the lock */
 	if (ftrace_ip_in_hash(ip, key))
@@ -387,7 +432,7 @@ ftrace_record_ip(unsigned long ip)
 	ftraced_trigger = 1;
 
  out_unlock:
-	spin_unlock_irqrestore(&ftrace_shutdown_lock, flags);
+	ftrace_hash_unlock(flags);
  out:
 	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;
 
@@ -531,6 +576,16 @@ static void ftrace_shutdown_replenish(void)
 	ftrace_pages->next = (void *)get_zeroed_page(GFP_KERNEL);
 }
 
+static void print_ip_ins(const char *fmt, unsigned char *p)
+{
+	int i;
+
+	printk(KERN_CONT "%s", fmt);
+
+	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
+		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+}
+
 static int
 ftrace_code_disable(struct dyn_ftrace *rec)
 {
@@ -541,10 +596,27 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 	ip = rec->ip;
 
 	nop = ftrace_nop_replace();
-	call = ftrace_call_replace(ip, MCOUNT_ADDR);
+	call = ftrace_call_replace(ip, mcount_addr);
 
 	failed = ftrace_modify_code(ip, call, nop);
 	if (failed) {
+		switch (failed) {
+		case 1:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on modifying ");
+			print_ip_sym(ip);
+			break;
+		case 2:
+			WARN_ON_ONCE(1);
+			pr_info("ftrace failed to modify ");
+			print_ip_sym(ip);
+			print_ip_ins(" expected: ", call);
+			print_ip_ins(" actual: ", (unsigned char *)ip);
+			print_ip_ins(" replace: ", nop);
+			printk(KERN_CONT "\n");
+			break;
+		}
+
 		rec->flags |= FTRACE_FL_FAILED;
 		return 0;
 	}
@@ -792,47 +864,7 @@ static int ftrace_update_code(void)
 	return 1;
 }
 
-static int ftraced(void *ignore)
-{
-	unsigned long usecs;
-
-	while (!kthread_should_stop()) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		/* check once a second */
-		schedule_timeout(HZ);
-
-		if (unlikely(ftrace_disabled))
-			continue;
-
-		mutex_lock(&ftrace_sysctl_lock);
-		mutex_lock(&ftraced_lock);
-		if (!ftraced_suspend && !ftraced_stop &&
-		    ftrace_update_code()) {
-			usecs = nsecs_to_usecs(ftrace_update_time);
-			if (ftrace_update_tot_cnt > 100000) {
-				ftrace_update_tot_cnt = 0;
-				pr_info("hm, dftrace overflow: %lu change%s"
-					" (%lu total) in %lu usec%s\n",
-					ftrace_update_cnt,
-					ftrace_update_cnt != 1 ? "s" : "",
-					ftrace_update_tot_cnt,
-					usecs, usecs != 1 ? "s" : "");
-				ftrace_disabled = 1;
-				WARN_ON_ONCE(1);
-			}
-		}
-		mutex_unlock(&ftraced_lock);
-		mutex_unlock(&ftrace_sysctl_lock);
-
-		ftrace_shutdown_replenish();
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-}
-
-static int __init ftrace_dyn_table_alloc(void)
+static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 {
 	struct ftrace_page *pg;
 	int cnt;
@@ -859,7 +891,9 @@ static int __init ftrace_dyn_table_alloc(void)
 
 	pg = ftrace_pages = ftrace_pages_start;
 
-	cnt = NR_TO_INIT / ENTRIES_PER_PAGE;
+	cnt = num_to_init / ENTRIES_PER_PAGE;
+	pr_info("ftrace: allocating %ld hash entries in %d pages\n",
+		num_to_init, cnt);
 
 	for (i = 0; i < cnt; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
@@ -901,6 +935,8 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 	(*pos)++;
 
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
  retry:
 	if (iter->idx >= iter->pg->index) {
 		if (iter->pg->next) {
@@ -910,15 +946,13 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
-		if ((!(iter->flags & FTRACE_ITER_FAILURES) &&
+		if ((rec->flags & FTRACE_FL_FREE) ||
+
+		    (!(iter->flags & FTRACE_ITER_FAILURES) &&
 		     (rec->flags & FTRACE_FL_FAILED)) ||
 
 		    ((iter->flags & FTRACE_ITER_FAILURES) &&
-		     (!(rec->flags & FTRACE_FL_FAILED) ||
-		      (rec->flags & FTRACE_FL_FREE))) ||
-
-		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(rec->flags & FTRACE_FL_FILTER)) ||
+		     !(rec->flags & FTRACE_FL_FAILED)) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
 		     !(rec->flags & FTRACE_FL_NOTRACE))) {
@@ -926,6 +960,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			goto retry;
 		}
 	}
+	spin_unlock(&ftrace_lock);
 
 	iter->pos = *pos;
 
@@ -1039,8 +1074,8 @@ static void ftrace_filter_reset(int enable)
 	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	unsigned i;
 
-	/* keep kstop machine from running */
-	preempt_disable();
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 0;
 	pg = ftrace_pages_start;
@@ -1053,7 +1088,7 @@ static void ftrace_filter_reset(int enable)
 		}
 		pg = pg->next;
 	}
-	preempt_enable();
+	spin_unlock(&ftrace_lock);
 }
 
 static int
@@ -1165,8 +1200,8 @@ ftrace_match(unsigned char *buff, int len, int enable)
 		}
 	}
 
-	/* keep kstop machine from running */
-	preempt_disable();
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 1;
 	pg = ftrace_pages_start;
@@ -1203,7 +1238,7 @@ ftrace_match(unsigned char *buff, int len, int enable)
 		}
 		pg = pg->next;
 	}
-	preempt_enable();
+	spin_unlock(&ftrace_lock);
 }
 
 static ssize_t
@@ -1556,6 +1591,114 @@ static __init int ftrace_init_debugfs(void)
 
 fs_initcall(ftrace_init_debugfs);
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+static int ftrace_convert_nops(unsigned long *start,
+			       unsigned long *end)
+{
+	unsigned long *p;
+	unsigned long addr;
+	unsigned long flags;
+
+	p = start;
+	while (p < end) {
+		addr = ftrace_call_adjust(*p++);
+		/* should not be called from interrupt context */
+		spin_lock(&ftrace_lock);
+		ftrace_record_ip(addr);
+		spin_unlock(&ftrace_lock);
+		ftrace_shutdown_replenish();
+	}
+
+	/* p is ignored */
+	local_irq_save(flags);
+	__ftrace_update_code(p);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+void ftrace_init_module(unsigned long *start, unsigned long *end)
+{
+	if (ftrace_disabled || start == end)
+		return;
+	ftrace_convert_nops(start, end);
+}
+
+extern unsigned long __start_mcount_loc[];
+extern unsigned long __stop_mcount_loc[];
+
+void __init ftrace_init(void)
+{
+	unsigned long count, addr, flags;
+	int ret;
+
+	/* Keep the ftrace pointer to the stub */
+	addr = (unsigned long)ftrace_stub;
+
+	local_irq_save(flags);
+	ftrace_dyn_arch_init(&addr);
+	local_irq_restore(flags);
+
+	/* ftrace_dyn_arch_init places the return code in addr */
+	if (addr)
+		goto failed;
+
+	count = __stop_mcount_loc - __start_mcount_loc;
+
+	ret = ftrace_dyn_table_alloc(count);
+	if (ret)
+		goto failed;
+
+	last_ftrace_enabled = ftrace_enabled = 1;
+
+	ret = ftrace_convert_nops(__start_mcount_loc,
+				  __stop_mcount_loc);
+
+	return;
+ failed:
+	ftrace_disabled = 1;
+}
+#else /* CONFIG_FTRACE_MCOUNT_RECORD */
+static int ftraced(void *ignore)
+{
+	unsigned long usecs;
+
+	while (!kthread_should_stop()) {
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		/* check once a second */
+		schedule_timeout(HZ);
+
+		if (unlikely(ftrace_disabled))
+			continue;
+
+		mutex_lock(&ftrace_sysctl_lock);
+		mutex_lock(&ftraced_lock);
+		if (!ftraced_suspend && !ftraced_stop &&
+		    ftrace_update_code()) {
+			usecs = nsecs_to_usecs(ftrace_update_time);
+			if (ftrace_update_tot_cnt > 100000) {
+				ftrace_update_tot_cnt = 0;
+				pr_info("hm, dftrace overflow: %lu change%s"
+					" (%lu total) in %lu usec%s\n",
+					ftrace_update_cnt,
+					ftrace_update_cnt != 1 ? "s" : "",
+					ftrace_update_tot_cnt,
+					usecs, usecs != 1 ? "s" : "");
+				ftrace_disabled = 1;
+				WARN_ON_ONCE(1);
+			}
+		}
+		mutex_unlock(&ftraced_lock);
+		mutex_unlock(&ftrace_sysctl_lock);
+
+		ftrace_shutdown_replenish();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
 static int __init ftrace_dynamic_init(void)
 {
 	struct task_struct *p;
@@ -1572,7 +1715,7 @@ static int __init ftrace_dynamic_init(void)
 		goto failed;
 	}
 
-	ret = ftrace_dyn_table_alloc();
+	ret = ftrace_dyn_table_alloc(NR_TO_INIT);
 	if (ret)
 		goto failed;
 
@@ -1593,6 +1736,8 @@ static int __init ftrace_dynamic_init(void)
 }
 
 core_initcall(ftrace_dynamic_init);
+#endif /* CONFIG_FTRACE_MCOUNT_RECORD */
+
 #else
 # define ftrace_startup()		do { } while (0)
 # define ftrace_shutdown()		do { } while (0)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
new file mode 100644
index 0000000..94af1fe
--- /dev/null
+++ b/kernel/trace/ring_buffer.c
@@ -0,0 +1,2014 @@
+/*
+ * Generic ring buffer
+ *
+ * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/ring_buffer.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>	/* used for sched_clock() (for now) */
+#include <linux/init.h>
+#include <linux/hash.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+
+/* Up this if you want to test the TIME_EXTENTS and normalization */
+#define DEBUG_SHIFT 0
+
+/* FIXME!!! */
+u64 ring_buffer_time_stamp(int cpu)
+{
+	/* shift to debug/test normalization and TIME_EXTENTS */
+	return sched_clock() << DEBUG_SHIFT;
+}
+
+void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
+{
+	/* Just stupid testing the normalize function and deltas */
+	*ts >>= DEBUG_SHIFT;
+}
+
+#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
+#define RB_ALIGNMENT_SHIFT	2
+#define RB_ALIGNMENT		(1 << RB_ALIGNMENT_SHIFT)
+#define RB_MAX_SMALL_DATA	28
+
+enum {
+	RB_LEN_TIME_EXTEND = 8,
+	RB_LEN_TIME_STAMP = 16,
+};
+
+/* inline for ring buffer fast paths */
+static inline unsigned
+rb_event_length(struct ring_buffer_event *event)
+{
+	unsigned length;
+
+	switch (event->type) {
+	case RINGBUF_TYPE_PADDING:
+		/* undefined */
+		return -1;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		return RB_LEN_TIME_EXTEND;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		return RB_LEN_TIME_STAMP;
+
+	case RINGBUF_TYPE_DATA:
+		if (event->len)
+			length = event->len << RB_ALIGNMENT_SHIFT;
+		else
+			length = event->array[0];
+		return length + RB_EVNT_HDR_SIZE;
+	default:
+		BUG();
+	}
+	/* not hit */
+	return 0;
+}
+
+/**
+ * ring_buffer_event_length - return the length of the event
+ * @event: the event to get the length of
+ */
+unsigned ring_buffer_event_length(struct ring_buffer_event *event)
+{
+	return rb_event_length(event);
+}
+
+/* inline for ring buffer fast paths */
+static inline void *
+rb_event_data(struct ring_buffer_event *event)
+{
+	BUG_ON(event->type != RINGBUF_TYPE_DATA);
+	/* If length is in len field, then array[0] has the data */
+	if (event->len)
+		return (void *)&event->array[0];
+	/* Otherwise length is in array[0] and array[1] has the data */
+	return (void *)&event->array[1];
+}
+
+/**
+ * ring_buffer_event_data - return the data of the event
+ * @event: the event to get the data from
+ */
+void *ring_buffer_event_data(struct ring_buffer_event *event)
+{
+	return rb_event_data(event);
+}
+
+#define for_each_buffer_cpu(buffer, cpu)		\
+	for_each_cpu_mask(cpu, buffer->cpumask)
+
+#define TS_SHIFT	27
+#define TS_MASK		((1ULL << TS_SHIFT) - 1)
+#define TS_DELTA_TEST	(~TS_MASK)
+
+/*
+ * This hack stolen from mm/slob.c.
+ * We can store per page timing information in the page frame of the page.
+ * Thanks to Peter Zijlstra for suggesting this idea.
+ */
+struct buffer_page {
+	u64		 time_stamp;	/* page time stamp */
+	local_t		 write;		/* index for next write */
+	local_t		 commit;	/* write commited index */
+	unsigned	 read;		/* index for next read */
+	struct list_head list;		/* list of free pages */
+	void *page;			/* Actual data page */
+};
+
+/*
+ * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
+ * this issue out.
+ */
+static inline void free_buffer_page(struct buffer_page *bpage)
+{
+	if (bpage->page)
+		__free_page(bpage->page);
+	kfree(bpage);
+}
+
+/*
+ * We need to fit the time_stamp delta into 27 bits.
+ */
+static inline int test_time_stamp(u64 delta)
+{
+	if (delta & TS_DELTA_TEST)
+		return 1;
+	return 0;
+}
+
+#define BUF_PAGE_SIZE PAGE_SIZE
+
+/*
+ * head_page == tail_page && head == tail then buffer is empty.
+ */
+struct ring_buffer_per_cpu {
+	int				cpu;
+	struct ring_buffer		*buffer;
+	spinlock_t			lock;
+	struct lock_class_key		lock_key;
+	struct list_head		pages;
+	struct buffer_page		*head_page;	/* read from head */
+	struct buffer_page		*tail_page;	/* write to tail */
+	struct buffer_page		*commit_page;	/* commited pages */
+	struct buffer_page		*reader_page;
+	unsigned long			overrun;
+	unsigned long			entries;
+	u64				write_stamp;
+	u64				read_stamp;
+	atomic_t			record_disabled;
+};
+
+struct ring_buffer {
+	unsigned long			size;
+	unsigned			pages;
+	unsigned			flags;
+	int				cpus;
+	cpumask_t			cpumask;
+	atomic_t			record_disabled;
+
+	struct mutex			mutex;
+
+	struct ring_buffer_per_cpu	**buffers;
+};
+
+struct ring_buffer_iter {
+	struct ring_buffer_per_cpu	*cpu_buffer;
+	unsigned long			head;
+	struct buffer_page		*head_page;
+	u64				read_stamp;
+};
+
+#define RB_WARN_ON(buffer, cond)				\
+	do {							\
+		if (unlikely(cond)) {				\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+		}						\
+	} while (0)
+
+#define RB_WARN_ON_RET(buffer, cond)				\
+	do {							\
+		if (unlikely(cond)) {				\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+			return -1;				\
+		}						\
+	} while (0)
+
+#define RB_WARN_ON_ONCE(buffer, cond)				\
+	do {							\
+		static int once;				\
+		if (unlikely(cond) && !once) {			\
+			once++;					\
+			atomic_inc(&buffer->record_disabled);	\
+			WARN_ON(1);				\
+		}						\
+	} while (0)
+
+/**
+ * check_pages - integrity check of buffer pages
+ * @cpu_buffer: CPU buffer with pages to test
+ *
+ * As a safty measure we check to make sure the data pages have not
+ * been corrupted.
+ */
+static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct list_head *head = &cpu_buffer->pages;
+	struct buffer_page *page, *tmp;
+
+	RB_WARN_ON_RET(cpu_buffer, head->next->prev != head);
+	RB_WARN_ON_RET(cpu_buffer, head->prev->next != head);
+
+	list_for_each_entry_safe(page, tmp, head, list) {
+		RB_WARN_ON_RET(cpu_buffer,
+			       page->list.next->prev != &page->list);
+		RB_WARN_ON_RET(cpu_buffer,
+			       page->list.prev->next != &page->list);
+	}
+
+	return 0;
+}
+
+static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
+			     unsigned nr_pages)
+{
+	struct list_head *head = &cpu_buffer->pages;
+	struct buffer_page *page, *tmp;
+	unsigned long addr;
+	LIST_HEAD(pages);
+	unsigned i;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
+				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
+		if (!page)
+			goto free_pages;
+		list_add(&page->list, &pages);
+
+		addr = __get_free_page(GFP_KERNEL);
+		if (!addr)
+			goto free_pages;
+		page->page = (void *)addr;
+	}
+
+	list_splice(&pages, head);
+
+	rb_check_pages(cpu_buffer);
+
+	return 0;
+
+ free_pages:
+	list_for_each_entry_safe(page, tmp, &pages, list) {
+		list_del_init(&page->list);
+		free_buffer_page(page);
+	}
+	return -ENOMEM;
+}
+
+static struct ring_buffer_per_cpu *
+rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct buffer_page *page;
+	unsigned long addr;
+	int ret;
+
+	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
+				  GFP_KERNEL, cpu_to_node(cpu));
+	if (!cpu_buffer)
+		return NULL;
+
+	cpu_buffer->cpu = cpu;
+	cpu_buffer->buffer = buffer;
+	spin_lock_init(&cpu_buffer->lock);
+	INIT_LIST_HEAD(&cpu_buffer->pages);
+
+	page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
+			    GFP_KERNEL, cpu_to_node(cpu));
+	if (!page)
+		goto fail_free_buffer;
+
+	cpu_buffer->reader_page = page;
+	addr = __get_free_page(GFP_KERNEL);
+	if (!addr)
+		goto fail_free_reader;
+	page->page = (void *)addr;
+
+	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+
+	ret = rb_allocate_pages(cpu_buffer, buffer->pages);
+	if (ret < 0)
+		goto fail_free_reader;
+
+	cpu_buffer->head_page
+		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+	cpu_buffer->tail_page = cpu_buffer->commit_page = cpu_buffer->head_page;
+
+	return cpu_buffer;
+
+ fail_free_reader:
+	free_buffer_page(cpu_buffer->reader_page);
+
+ fail_free_buffer:
+	kfree(cpu_buffer);
+	return NULL;
+}
+
+static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct list_head *head = &cpu_buffer->pages;
+	struct buffer_page *page, *tmp;
+
+	list_del_init(&cpu_buffer->reader_page->list);
+	free_buffer_page(cpu_buffer->reader_page);
+
+	list_for_each_entry_safe(page, tmp, head, list) {
+		list_del_init(&page->list);
+		free_buffer_page(page);
+	}
+	kfree(cpu_buffer);
+}
+
+/*
+ * Causes compile errors if the struct buffer_page gets bigger
+ * than the struct page.
+ */
+extern int ring_buffer_page_too_big(void);
+
+/**
+ * ring_buffer_alloc - allocate a new ring_buffer
+ * @size: the size in bytes that is needed.
+ * @flags: attributes to set for the ring buffer.
+ *
+ * Currently the only flag that is available is the RB_FL_OVERWRITE
+ * flag. This flag means that the buffer will overwrite old data
+ * when the buffer wraps. If this flag is not set, the buffer will
+ * drop data when the tail hits the head.
+ */
+struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
+{
+	struct ring_buffer *buffer;
+	int bsize;
+	int cpu;
+
+	/* Paranoid! Optimizes out when all is well */
+	if (sizeof(struct buffer_page) > sizeof(struct page))
+		ring_buffer_page_too_big();
+
+
+	/* keep it in its own cache line */
+	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
+			 GFP_KERNEL);
+	if (!buffer)
+		return NULL;
+
+	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+	buffer->flags = flags;
+
+	/* need at least two pages */
+	if (buffer->pages == 1)
+		buffer->pages++;
+
+	buffer->cpumask = cpu_possible_map;
+	buffer->cpus = nr_cpu_ids;
+
+	bsize = sizeof(void *) * nr_cpu_ids;
+	buffer->buffers = kzalloc(ALIGN(bsize, cache_line_size()),
+				  GFP_KERNEL);
+	if (!buffer->buffers)
+		goto fail_free_buffer;
+
+	for_each_buffer_cpu(buffer, cpu) {
+		buffer->buffers[cpu] =
+			rb_allocate_cpu_buffer(buffer, cpu);
+		if (!buffer->buffers[cpu])
+			goto fail_free_buffers;
+	}
+
+	mutex_init(&buffer->mutex);
+
+	return buffer;
+
+ fail_free_buffers:
+	for_each_buffer_cpu(buffer, cpu) {
+		if (buffer->buffers[cpu])
+			rb_free_cpu_buffer(buffer->buffers[cpu]);
+	}
+	kfree(buffer->buffers);
+
+ fail_free_buffer:
+	kfree(buffer);
+	return NULL;
+}
+
+/**
+ * ring_buffer_free - free a ring buffer.
+ * @buffer: the buffer to free.
+ */
+void
+ring_buffer_free(struct ring_buffer *buffer)
+{
+	int cpu;
+
+	for_each_buffer_cpu(buffer, cpu)
+		rb_free_cpu_buffer(buffer->buffers[cpu]);
+
+	kfree(buffer);
+}
+
+static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
+
+static void
+rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
+{
+	struct buffer_page *page;
+	struct list_head *p;
+	unsigned i;
+
+	atomic_inc(&cpu_buffer->record_disabled);
+	synchronize_sched();
+
+	for (i = 0; i < nr_pages; i++) {
+		BUG_ON(list_empty(&cpu_buffer->pages));
+		p = cpu_buffer->pages.next;
+		page = list_entry(p, struct buffer_page, list);
+		list_del_init(&page->list);
+		free_buffer_page(page);
+	}
+	BUG_ON(list_empty(&cpu_buffer->pages));
+
+	rb_reset_cpu(cpu_buffer);
+
+	rb_check_pages(cpu_buffer);
+
+	atomic_dec(&cpu_buffer->record_disabled);
+
+}
+
+static void
+rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
+		struct list_head *pages, unsigned nr_pages)
+{
+	struct buffer_page *page;
+	struct list_head *p;
+	unsigned i;
+
+	atomic_inc(&cpu_buffer->record_disabled);
+	synchronize_sched();
+
+	for (i = 0; i < nr_pages; i++) {
+		BUG_ON(list_empty(pages));
+		p = pages->next;
+		page = list_entry(p, struct buffer_page, list);
+		list_del_init(&page->list);
+		list_add_tail(&page->list, &cpu_buffer->pages);
+	}
+	rb_reset_cpu(cpu_buffer);
+
+	rb_check_pages(cpu_buffer);
+
+	atomic_dec(&cpu_buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_resize - resize the ring buffer
+ * @buffer: the buffer to resize.
+ * @size: the new size.
+ *
+ * The tracer is responsible for making sure that the buffer is
+ * not being used while changing the size.
+ * Note: We may be able to change the above requirement by using
+ *  RCU synchronizations.
+ *
+ * Minimum size is 2 * BUF_PAGE_SIZE.
+ *
+ * Returns -1 on failure.
+ */
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned nr_pages, rm_pages, new_pages;
+	struct buffer_page *page, *tmp;
+	unsigned long buffer_size;
+	unsigned long addr;
+	LIST_HEAD(pages);
+	int i, cpu;
+
+	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+	size *= BUF_PAGE_SIZE;
+	buffer_size = buffer->pages * BUF_PAGE_SIZE;
+
+	/* we need a minimum of two pages */
+	if (size < BUF_PAGE_SIZE * 2)
+		size = BUF_PAGE_SIZE * 2;
+
+	if (size == buffer_size)
+		return size;
+
+	mutex_lock(&buffer->mutex);
+
+	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+
+	if (size < buffer_size) {
+
+		/* easy case, just free pages */
+		BUG_ON(nr_pages >= buffer->pages);
+
+		rm_pages = buffer->pages - nr_pages;
+
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer = buffer->buffers[cpu];
+			rb_remove_pages(cpu_buffer, rm_pages);
+		}
+		goto out;
+	}
+
+	/*
+	 * This is a bit more difficult. We only want to add pages
+	 * when we can allocate enough for all CPUs. We do this
+	 * by allocating all the pages and storing them on a local
+	 * link list. If we succeed in our allocation, then we
+	 * add these pages to the cpu_buffers. Otherwise we just free
+	 * them all and return -ENOMEM;
+	 */
+	BUG_ON(nr_pages <= buffer->pages);
+	new_pages = nr_pages - buffer->pages;
+
+	for_each_buffer_cpu(buffer, cpu) {
+		for (i = 0; i < new_pages; i++) {
+			page = kzalloc_node(ALIGN(sizeof(*page),
+						  cache_line_size()),
+					    GFP_KERNEL, cpu_to_node(cpu));
+			if (!page)
+				goto free_pages;
+			list_add(&page->list, &pages);
+			addr = __get_free_page(GFP_KERNEL);
+			if (!addr)
+				goto free_pages;
+			page->page = (void *)addr;
+		}
+	}
+
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+		rb_insert_pages(cpu_buffer, &pages, new_pages);
+	}
+
+	BUG_ON(!list_empty(&pages));
+
+ out:
+	buffer->pages = nr_pages;
+	mutex_unlock(&buffer->mutex);
+
+	return size;
+
+ free_pages:
+	list_for_each_entry_safe(page, tmp, &pages, list) {
+		list_del_init(&page->list);
+		free_buffer_page(page);
+	}
+	return -ENOMEM;
+}
+
+static inline int rb_null_event(struct ring_buffer_event *event)
+{
+	return event->type == RINGBUF_TYPE_PADDING;
+}
+
+static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
+{
+	return page->page + index;
+}
+
+static inline struct ring_buffer_event *
+rb_reader_event(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return __rb_page_index(cpu_buffer->reader_page,
+			       cpu_buffer->reader_page->read);
+}
+
+static inline struct ring_buffer_event *
+rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return __rb_page_index(cpu_buffer->head_page,
+			       cpu_buffer->head_page->read);
+}
+
+static inline struct ring_buffer_event *
+rb_iter_head_event(struct ring_buffer_iter *iter)
+{
+	return __rb_page_index(iter->head_page, iter->head);
+}
+
+static inline unsigned rb_page_write(struct buffer_page *bpage)
+{
+	return local_read(&bpage->write);
+}
+
+static inline unsigned rb_page_commit(struct buffer_page *bpage)
+{
+	return local_read(&bpage->commit);
+}
+
+/* Size is determined by what has been commited */
+static inline unsigned rb_page_size(struct buffer_page *bpage)
+{
+	return rb_page_commit(bpage);
+}
+
+static inline unsigned
+rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return rb_page_commit(cpu_buffer->commit_page);
+}
+
+static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return rb_page_commit(cpu_buffer->head_page);
+}
+
+/*
+ * When the tail hits the head and the buffer is in overwrite mode,
+ * the head jumps to the next page and all content on the previous
+ * page is discarded. But before doing so, we update the overrun
+ * variable of the buffer.
+ */
+static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct ring_buffer_event *event;
+	unsigned long head;
+
+	for (head = 0; head < rb_head_size(cpu_buffer);
+	     head += rb_event_length(event)) {
+
+		event = __rb_page_index(cpu_buffer->head_page, head);
+		BUG_ON(rb_null_event(event));
+		/* Only count data entries */
+		if (event->type != RINGBUF_TYPE_DATA)
+			continue;
+		cpu_buffer->overrun++;
+		cpu_buffer->entries--;
+	}
+}
+
+static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
+			       struct buffer_page **page)
+{
+	struct list_head *p = (*page)->list.next;
+
+	if (p == &cpu_buffer->pages)
+		p = p->next;
+
+	*page = list_entry(p, struct buffer_page, list);
+}
+
+static inline unsigned
+rb_event_index(struct ring_buffer_event *event)
+{
+	unsigned long addr = (unsigned long)event;
+
+	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
+}
+
+static inline int
+rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
+	     struct ring_buffer_event *event)
+{
+	unsigned long addr = (unsigned long)event;
+	unsigned long index;
+
+	index = rb_event_index(event);
+	addr &= PAGE_MASK;
+
+	return cpu_buffer->commit_page->page == (void *)addr &&
+		rb_commit_index(cpu_buffer) == index;
+}
+
+static inline void
+rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
+		    struct ring_buffer_event *event)
+{
+	unsigned long addr = (unsigned long)event;
+	unsigned long index;
+
+	index = rb_event_index(event);
+	addr &= PAGE_MASK;
+
+	while (cpu_buffer->commit_page->page != (void *)addr) {
+		RB_WARN_ON(cpu_buffer,
+			   cpu_buffer->commit_page == cpu_buffer->tail_page);
+		cpu_buffer->commit_page->commit =
+			cpu_buffer->commit_page->write;
+		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
+		cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+	}
+
+	/* Now set the commit to the event's index */
+	local_set(&cpu_buffer->commit_page->commit, index);
+}
+
+static inline void
+rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	/*
+	 * We only race with interrupts and NMIs on this CPU.
+	 * If we own the commit event, then we can commit
+	 * all others that interrupted us, since the interruptions
+	 * are in stack format (they finish before they come
+	 * back to us). This allows us to do a simple loop to
+	 * assign the commit to the tail.
+	 */
+	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
+		cpu_buffer->commit_page->commit =
+			cpu_buffer->commit_page->write;
+		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
+		cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+		/* add barrier to keep gcc from optimizing too much */
+		barrier();
+	}
+	while (rb_commit_index(cpu_buffer) !=
+	       rb_page_write(cpu_buffer->commit_page)) {
+		cpu_buffer->commit_page->commit =
+			cpu_buffer->commit_page->write;
+		barrier();
+	}
+}
+
+static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	cpu_buffer->read_stamp = cpu_buffer->reader_page->time_stamp;
+	cpu_buffer->reader_page->read = 0;
+}
+
+static inline void rb_inc_iter(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	/*
+	 * The iterator could be on the reader page (it starts there).
+	 * But the head could have moved, since the reader was
+	 * found. Check for this case and assign the iterator
+	 * to the head page instead of next.
+	 */
+	if (iter->head_page == cpu_buffer->reader_page)
+		iter->head_page = cpu_buffer->head_page;
+	else
+		rb_inc_page(cpu_buffer, &iter->head_page);
+
+	iter->read_stamp = iter->head_page->time_stamp;
+	iter->head = 0;
+}
+
+/**
+ * ring_buffer_update_event - update event type and data
+ * @event: the even to update
+ * @type: the type of event
+ * @length: the size of the event field in the ring buffer
+ *
+ * Update the type and data fields of the event. The length
+ * is the actual size that is written to the ring buffer,
+ * and with this, we can determine what to place into the
+ * data field.
+ */
+static inline void
+rb_update_event(struct ring_buffer_event *event,
+			 unsigned type, unsigned length)
+{
+	event->type = type;
+
+	switch (type) {
+
+	case RINGBUF_TYPE_PADDING:
+		break;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		event->len =
+			(RB_LEN_TIME_EXTEND + (RB_ALIGNMENT-1))
+			>> RB_ALIGNMENT_SHIFT;
+		break;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		event->len =
+			(RB_LEN_TIME_STAMP + (RB_ALIGNMENT-1))
+			>> RB_ALIGNMENT_SHIFT;
+		break;
+
+	case RINGBUF_TYPE_DATA:
+		length -= RB_EVNT_HDR_SIZE;
+		if (length > RB_MAX_SMALL_DATA) {
+			event->len = 0;
+			event->array[0] = length;
+		} else
+			event->len =
+				(length + (RB_ALIGNMENT-1))
+				>> RB_ALIGNMENT_SHIFT;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline unsigned rb_calculate_event_length(unsigned length)
+{
+	struct ring_buffer_event event; /* Used only for sizeof array */
+
+	/* zero length can cause confusions */
+	if (!length)
+		length = 1;
+
+	if (length > RB_MAX_SMALL_DATA)
+		length += sizeof(event.array[0]);
+
+	length += RB_EVNT_HDR_SIZE;
+	length = ALIGN(length, RB_ALIGNMENT);
+
+	return length;
+}
+
+static struct ring_buffer_event *
+__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
+		  unsigned type, unsigned long length, u64 *ts)
+{
+	struct buffer_page *tail_page, *head_page, *reader_page;
+	unsigned long tail, write;
+	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct ring_buffer_event *event;
+	unsigned long flags;
+
+	tail_page = cpu_buffer->tail_page;
+	write = local_add_return(length, &tail_page->write);
+	tail = write - length;
+
+	/* See if we shot pass the end of this buffer page */
+	if (write > BUF_PAGE_SIZE) {
+		struct buffer_page *next_page = tail_page;
+
+		spin_lock_irqsave(&cpu_buffer->lock, flags);
+
+		rb_inc_page(cpu_buffer, &next_page);
+
+		head_page = cpu_buffer->head_page;
+		reader_page = cpu_buffer->reader_page;
+
+		/* we grabbed the lock before incrementing */
+		RB_WARN_ON(cpu_buffer, next_page == reader_page);
+
+		/*
+		 * If for some reason, we had an interrupt storm that made
+		 * it all the way around the buffer, bail, and warn
+		 * about it.
+		 */
+		if (unlikely(next_page == cpu_buffer->commit_page)) {
+			WARN_ON_ONCE(1);
+			goto out_unlock;
+		}
+
+		if (next_page == head_page) {
+			if (!(buffer->flags & RB_FL_OVERWRITE)) {
+				/* reset write */
+				if (tail <= BUF_PAGE_SIZE)
+					local_set(&tail_page->write, tail);
+				goto out_unlock;
+			}
+
+			/* tail_page has not moved yet? */
+			if (tail_page == cpu_buffer->tail_page) {
+				/* count overflows */
+				rb_update_overflow(cpu_buffer);
+
+				rb_inc_page(cpu_buffer, &head_page);
+				cpu_buffer->head_page = head_page;
+				cpu_buffer->head_page->read = 0;
+			}
+		}
+
+		/*
+		 * If the tail page is still the same as what we think
+		 * it is, then it is up to us to update the tail
+		 * pointer.
+		 */
+		if (tail_page == cpu_buffer->tail_page) {
+			local_set(&next_page->write, 0);
+			local_set(&next_page->commit, 0);
+			cpu_buffer->tail_page = next_page;
+
+			/* reread the time stamp */
+			*ts = ring_buffer_time_stamp(cpu_buffer->cpu);
+			cpu_buffer->tail_page->time_stamp = *ts;
+		}
+
+		/*
+		 * The actual tail page has moved forward.
+		 */
+		if (tail < BUF_PAGE_SIZE) {
+			/* Mark the rest of the page with padding */
+			event = __rb_page_index(tail_page, tail);
+			event->type = RINGBUF_TYPE_PADDING;
+		}
+
+		if (tail <= BUF_PAGE_SIZE)
+			/* Set the write back to the previous setting */
+			local_set(&tail_page->write, tail);
+
+		/*
+		 * If this was a commit entry that failed,
+		 * increment that too
+		 */
+		if (tail_page == cpu_buffer->commit_page &&
+		    tail == rb_commit_index(cpu_buffer)) {
+			rb_set_commit_to_write(cpu_buffer);
+		}
+
+		spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+
+		/* fail and let the caller try again */
+		return ERR_PTR(-EAGAIN);
+	}
+
+	/* We reserved something on the buffer */
+
+	BUG_ON(write > BUF_PAGE_SIZE);
+
+	event = __rb_page_index(tail_page, tail);
+	rb_update_event(event, type, length);
+
+	/*
+	 * If this is a commit and the tail is zero, then update
+	 * this page's time stamp.
+	 */
+	if (!tail && rb_is_commit(cpu_buffer, event))
+		cpu_buffer->commit_page->time_stamp = *ts;
+
+	return event;
+
+ out_unlock:
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+	return NULL;
+}
+
+static int
+rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
+		  u64 *ts, u64 *delta)
+{
+	struct ring_buffer_event *event;
+	static int once;
+	int ret;
+
+	if (unlikely(*delta > (1ULL << 59) && !once++)) {
+		printk(KERN_WARNING "Delta way too big! %llu"
+		       " ts=%llu write stamp = %llu\n",
+		       *delta, *ts, cpu_buffer->write_stamp);
+		WARN_ON(1);
+	}
+
+	/*
+	 * The delta is too big, we to add a
+	 * new timestamp.
+	 */
+	event = __rb_reserve_next(cpu_buffer,
+				  RINGBUF_TYPE_TIME_EXTEND,
+				  RB_LEN_TIME_EXTEND,
+				  ts);
+	if (!event)
+		return -EBUSY;
+
+	if (PTR_ERR(event) == -EAGAIN)
+		return -EAGAIN;
+
+	/* Only a commited time event can update the write stamp */
+	if (rb_is_commit(cpu_buffer, event)) {
+		/*
+		 * If this is the first on the page, then we need to
+		 * update the page itself, and just put in a zero.
+		 */
+		if (rb_event_index(event)) {
+			event->time_delta = *delta & TS_MASK;
+			event->array[0] = *delta >> TS_SHIFT;
+		} else {
+			cpu_buffer->commit_page->time_stamp = *ts;
+			event->time_delta = 0;
+			event->array[0] = 0;
+		}
+		cpu_buffer->write_stamp = *ts;
+		/* let the caller know this was the commit */
+		ret = 1;
+	} else {
+		/* Darn, this is just wasted space */
+		event->time_delta = 0;
+		event->array[0] = 0;
+		ret = 0;
+	}
+
+	*delta = 0;
+
+	return ret;
+}
+
+static struct ring_buffer_event *
+rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
+		      unsigned type, unsigned long length)
+{
+	struct ring_buffer_event *event;
+	u64 ts, delta;
+	int commit = 0;
+
+ again:
+	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
+
+	/*
+	 * Only the first commit can update the timestamp.
+	 * Yes there is a race here. If an interrupt comes in
+	 * just after the conditional and it traces too, then it
+	 * will also check the deltas. More than one timestamp may
+	 * also be made. But only the entry that did the actual
+	 * commit will be something other than zero.
+	 */
+	if (cpu_buffer->tail_page == cpu_buffer->commit_page &&
+	    rb_page_write(cpu_buffer->tail_page) ==
+	    rb_commit_index(cpu_buffer)) {
+
+		delta = ts - cpu_buffer->write_stamp;
+
+		/* make sure this delta is calculated here */
+		barrier();
+
+		/* Did the write stamp get updated already? */
+		if (unlikely(ts < cpu_buffer->write_stamp))
+			goto again;
+
+		if (test_time_stamp(delta)) {
+
+			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
+
+			if (commit == -EBUSY)
+				return NULL;
+
+			if (commit == -EAGAIN)
+				goto again;
+
+			RB_WARN_ON(cpu_buffer, commit < 0);
+		}
+	} else
+		/* Non commits have zero deltas */
+		delta = 0;
+
+	event = __rb_reserve_next(cpu_buffer, type, length, &ts);
+	if (PTR_ERR(event) == -EAGAIN)
+		goto again;
+
+	if (!event) {
+		if (unlikely(commit))
+			/*
+			 * Ouch! We needed a timestamp and it was commited. But
+			 * we didn't get our event reserved.
+			 */
+			rb_set_commit_to_write(cpu_buffer);
+		return NULL;
+	}
+
+	/*
+	 * If the timestamp was commited, make the commit our entry
+	 * now so that we will update it when needed.
+	 */
+	if (commit)
+		rb_set_commit_event(cpu_buffer, event);
+	else if (!rb_is_commit(cpu_buffer, event))
+		delta = 0;
+
+	event->time_delta = delta;
+
+	return event;
+}
+
+static DEFINE_PER_CPU(int, rb_need_resched);
+
+/**
+ * ring_buffer_lock_reserve - reserve a part of the buffer
+ * @buffer: the ring buffer to reserve from
+ * @length: the length of the data to reserve (excluding event header)
+ * @flags: a pointer to save the interrupt flags
+ *
+ * Returns a reseverd event on the ring buffer to copy directly to.
+ * The user of this interface will need to get the body to write into
+ * and can use the ring_buffer_event_data() interface.
+ *
+ * The length is the length of the data needed, not the event length
+ * which also includes the event header.
+ *
+ * Must be paired with ring_buffer_unlock_commit, unless NULL is returned.
+ * If NULL is returned, then nothing has been allocated or locked.
+ */
+struct ring_buffer_event *
+ring_buffer_lock_reserve(struct ring_buffer *buffer,
+			 unsigned long length,
+			 unsigned long *flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	int cpu, resched;
+
+	if (atomic_read(&buffer->record_disabled))
+		return NULL;
+
+	/* If we are tracing schedule, we don't want to recurse */
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		goto out;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	if (atomic_read(&cpu_buffer->record_disabled))
+		goto out;
+
+	length = rb_calculate_event_length(length);
+	if (length > BUF_PAGE_SIZE)
+		goto out;
+
+	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
+	if (!event)
+		goto out;
+
+	/*
+	 * Need to store resched state on this cpu.
+	 * Only the first needs to.
+	 */
+
+	if (preempt_count() == 1)
+		per_cpu(rb_need_resched, cpu) = resched;
+
+	return event;
+
+ out:
+	if (resched)
+		preempt_enable_notrace();
+	else
+		preempt_enable_notrace();
+	return NULL;
+}
+
+static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
+		      struct ring_buffer_event *event)
+{
+	cpu_buffer->entries++;
+
+	/* Only process further if we own the commit */
+	if (!rb_is_commit(cpu_buffer, event))
+		return;
+
+	cpu_buffer->write_stamp += event->time_delta;
+
+	rb_set_commit_to_write(cpu_buffer);
+}
+
+/**
+ * ring_buffer_unlock_commit - commit a reserved
+ * @buffer: The buffer to commit to
+ * @event: The event pointer to commit.
+ * @flags: the interrupt flags received from ring_buffer_lock_reserve.
+ *
+ * This commits the data to the ring buffer, and releases any locks held.
+ *
+ * Must be paired with ring_buffer_lock_reserve.
+ */
+int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+			      struct ring_buffer_event *event,
+			      unsigned long flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu = raw_smp_processor_id();
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	rb_commit(cpu_buffer, event);
+
+	/*
+	 * Only the last preempt count needs to restore preemption.
+	 */
+	if (preempt_count() == 1) {
+		if (per_cpu(rb_need_resched, cpu))
+			preempt_enable_no_resched_notrace();
+		else
+			preempt_enable_notrace();
+	} else
+		preempt_enable_no_resched_notrace();
+
+	return 0;
+}
+
+/**
+ * ring_buffer_write - write data to the buffer without reserving
+ * @buffer: The ring buffer to write to.
+ * @length: The length of the data being written (excluding the event header)
+ * @data: The data to write to the buffer.
+ *
+ * This is like ring_buffer_lock_reserve and ring_buffer_unlock_commit as
+ * one function. If you already have the data to write to the buffer, it
+ * may be easier to simply call this function.
+ *
+ * Note, like ring_buffer_lock_reserve, the length is the length of the data
+ * and not the length of the event which would hold the header.
+ */
+int ring_buffer_write(struct ring_buffer *buffer,
+			unsigned long length,
+			void *data)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	unsigned long event_length;
+	void *body;
+	int ret = -EBUSY;
+	int cpu, resched;
+
+	if (atomic_read(&buffer->record_disabled))
+		return -EBUSY;
+
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		goto out;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	if (atomic_read(&cpu_buffer->record_disabled))
+		goto out;
+
+	event_length = rb_calculate_event_length(length);
+	event = rb_reserve_next_event(cpu_buffer,
+				      RINGBUF_TYPE_DATA, event_length);
+	if (!event)
+		goto out;
+
+	body = rb_event_data(event);
+
+	memcpy(body, data, length);
+
+	rb_commit(cpu_buffer, event);
+
+	ret = 0;
+ out:
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
+
+	return ret;
+}
+
+static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *reader = cpu_buffer->reader_page;
+	struct buffer_page *head = cpu_buffer->head_page;
+	struct buffer_page *commit = cpu_buffer->commit_page;
+
+	return reader->read == rb_page_commit(reader) &&
+		(commit == reader ||
+		 (commit == head &&
+		  head->read == rb_page_commit(commit)));
+}
+
+/**
+ * ring_buffer_record_disable - stop all writes into the buffer
+ * @buffer: The ring buffer to stop writes to.
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ *
+ * The caller should call synchronize_sched() after this.
+ */
+void ring_buffer_record_disable(struct ring_buffer *buffer)
+{
+	atomic_inc(&buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_enable - enable writes to the buffer
+ * @buffer: The ring buffer to enable writes
+ *
+ * Note, multiple disables will need the same number of enables
+ * to truely enable the writing (much like preempt_disable).
+ */
+void ring_buffer_record_enable(struct ring_buffer *buffer)
+{
+	atomic_dec(&buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_disable_cpu - stop all writes into the cpu_buffer
+ * @buffer: The ring buffer to stop writes to.
+ * @cpu: The CPU buffer to stop
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ *
+ * The caller should call synchronize_sched() after this.
+ */
+void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return;
+
+	cpu_buffer = buffer->buffers[cpu];
+	atomic_inc(&cpu_buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_enable_cpu - enable writes to the buffer
+ * @buffer: The ring buffer to enable writes
+ * @cpu: The CPU to enable.
+ *
+ * Note, multiple disables will need the same number of enables
+ * to truely enable the writing (much like preempt_disable).
+ */
+void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return;
+
+	cpu_buffer = buffer->buffers[cpu];
+	atomic_dec(&cpu_buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the entries from.
+ */
+unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return cpu_buffer->entries;
+}
+
+/**
+ * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return cpu_buffer->overrun;
+}
+
+/**
+ * ring_buffer_entries - get the number of entries in a buffer
+ * @buffer: The ring buffer
+ *
+ * Returns the total number of entries in the ring buffer
+ * (all CPU entries)
+ */
+unsigned long ring_buffer_entries(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long entries = 0;
+	int cpu;
+
+	/* if you care about this being correct, lock the buffer */
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+		entries += cpu_buffer->entries;
+	}
+
+	return entries;
+}
+
+/**
+ * ring_buffer_overrun_cpu - get the number of overruns in buffer
+ * @buffer: The ring buffer
+ *
+ * Returns the total number of overruns in the ring buffer
+ * (all CPU entries)
+ */
+unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long overruns = 0;
+	int cpu;
+
+	/* if you care about this being correct, lock the buffer */
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+		overruns += cpu_buffer->overrun;
+	}
+
+	return overruns;
+}
+
+/**
+ * ring_buffer_iter_reset - reset an iterator
+ * @iter: The iterator to reset
+ *
+ * Resets the iterator, so that it will start from the beginning
+ * again.
+ */
+void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	/* Iterator usage is expected to have record disabled */
+	if (list_empty(&cpu_buffer->reader_page->list)) {
+		iter->head_page = cpu_buffer->head_page;
+		iter->head = cpu_buffer->head_page->read;
+	} else {
+		iter->head_page = cpu_buffer->reader_page;
+		iter->head = cpu_buffer->reader_page->read;
+	}
+	if (iter->head)
+		iter->read_stamp = cpu_buffer->read_stamp;
+	else
+		iter->read_stamp = iter->head_page->time_stamp;
+}
+
+/**
+ * ring_buffer_iter_empty - check if an iterator has no more to read
+ * @iter: The iterator to check
+ */
+int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = iter->cpu_buffer;
+
+	return iter->head_page == cpu_buffer->commit_page &&
+		iter->head == rb_commit_index(cpu_buffer);
+}
+
+static void
+rb_update_read_stamp(struct ring_buffer_per_cpu *cpu_buffer,
+		     struct ring_buffer_event *event)
+{
+	u64 delta;
+
+	switch (event->type) {
+	case RINGBUF_TYPE_PADDING:
+		return;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		delta = event->array[0];
+		delta <<= TS_SHIFT;
+		delta += event->time_delta;
+		cpu_buffer->read_stamp += delta;
+		return;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		return;
+
+	case RINGBUF_TYPE_DATA:
+		cpu_buffer->read_stamp += event->time_delta;
+		return;
+
+	default:
+		BUG();
+	}
+	return;
+}
+
+static void
+rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
+			  struct ring_buffer_event *event)
+{
+	u64 delta;
+
+	switch (event->type) {
+	case RINGBUF_TYPE_PADDING:
+		return;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		delta = event->array[0];
+		delta <<= TS_SHIFT;
+		delta += event->time_delta;
+		iter->read_stamp += delta;
+		return;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		return;
+
+	case RINGBUF_TYPE_DATA:
+		iter->read_stamp += event->time_delta;
+		return;
+
+	default:
+		BUG();
+	}
+	return;
+}
+
+static struct buffer_page *
+rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *reader = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu_buffer->lock, flags);
+
+ again:
+	reader = cpu_buffer->reader_page;
+
+	/* If there's more to read, return this page */
+	if (cpu_buffer->reader_page->read < rb_page_size(reader))
+		goto out;
+
+	/* Never should we have an index greater than the size */
+	RB_WARN_ON(cpu_buffer,
+		   cpu_buffer->reader_page->read > rb_page_size(reader));
+
+	/* check if we caught up to the tail */
+	reader = NULL;
+	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
+		goto out;
+
+	/*
+	 * Splice the empty reader page into the list around the head.
+	 * Reset the reader page to size zero.
+	 */
+
+	reader = cpu_buffer->head_page;
+	cpu_buffer->reader_page->list.next = reader->list.next;
+	cpu_buffer->reader_page->list.prev = reader->list.prev;
+
+	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->commit, 0);
+
+	/* Make the reader page now replace the head */
+	reader->list.prev->next = &cpu_buffer->reader_page->list;
+	reader->list.next->prev = &cpu_buffer->reader_page->list;
+
+	/*
+	 * If the tail is on the reader, then we must set the head
+	 * to the inserted page, otherwise we set it one before.
+	 */
+	cpu_buffer->head_page = cpu_buffer->reader_page;
+
+	if (cpu_buffer->commit_page != reader)
+		rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
+
+	/* Finally update the reader page to the new head */
+	cpu_buffer->reader_page = reader;
+	rb_reset_reader_page(cpu_buffer);
+
+	goto again;
+
+ out:
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+
+	return reader;
+}
+
+static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct ring_buffer_event *event;
+	struct buffer_page *reader;
+	unsigned length;
+
+	reader = rb_get_reader_page(cpu_buffer);
+
+	/* This function should not be called when buffer is empty */
+	BUG_ON(!reader);
+
+	event = rb_reader_event(cpu_buffer);
+
+	if (event->type == RINGBUF_TYPE_DATA)
+		cpu_buffer->entries--;
+
+	rb_update_read_stamp(cpu_buffer, event);
+
+	length = rb_event_length(event);
+	cpu_buffer->reader_page->read += length;
+}
+
+static void rb_advance_iter(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer *buffer;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	unsigned length;
+
+	cpu_buffer = iter->cpu_buffer;
+	buffer = cpu_buffer->buffer;
+
+	/*
+	 * Check if we are at the end of the buffer.
+	 */
+	if (iter->head >= rb_page_size(iter->head_page)) {
+		BUG_ON(iter->head_page == cpu_buffer->commit_page);
+		rb_inc_iter(iter);
+		return;
+	}
+
+	event = rb_iter_head_event(iter);
+
+	length = rb_event_length(event);
+
+	/*
+	 * This should not be called to advance the header if we are
+	 * at the tail of the buffer.
+	 */
+	BUG_ON((iter->head_page == cpu_buffer->commit_page) &&
+	       (iter->head + length > rb_commit_index(cpu_buffer)));
+
+	rb_update_iter_read_stamp(iter, event);
+
+	iter->head += length;
+
+	/* check for end of page padding */
+	if ((iter->head >= rb_page_size(iter->head_page)) &&
+	    (iter->head_page != cpu_buffer->commit_page))
+		rb_advance_iter(iter);
+}
+
+/**
+ * ring_buffer_peek - peek at the next event to be read
+ * @buffer: The ring buffer to read
+ * @cpu: The cpu to peak at
+ * @ts: The timestamp counter of this event.
+ *
+ * This will return the event that will be read next, but does
+ * not consume the data.
+ */
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	struct buffer_page *reader;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return NULL;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+ again:
+	reader = rb_get_reader_page(cpu_buffer);
+	if (!reader)
+		return NULL;
+
+	event = rb_reader_event(cpu_buffer);
+
+	switch (event->type) {
+	case RINGBUF_TYPE_PADDING:
+		RB_WARN_ON(cpu_buffer, 1);
+		rb_advance_reader(cpu_buffer);
+		return NULL;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		/* Internal data, OK to advance */
+		rb_advance_reader(cpu_buffer);
+		goto again;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		rb_advance_reader(cpu_buffer);
+		goto again;
+
+	case RINGBUF_TYPE_DATA:
+		if (ts) {
+			*ts = cpu_buffer->read_stamp + event->time_delta;
+			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
+		}
+		return event;
+
+	default:
+		BUG();
+	}
+
+	return NULL;
+}
+
+/**
+ * ring_buffer_iter_peek - peek at the next event to be read
+ * @iter: The ring buffer iterator
+ * @ts: The timestamp counter of this event.
+ *
+ * This will return the event that will be read next, but does
+ * not increment the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+{
+	struct ring_buffer *buffer;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+
+	if (ring_buffer_iter_empty(iter))
+		return NULL;
+
+	cpu_buffer = iter->cpu_buffer;
+	buffer = cpu_buffer->buffer;
+
+ again:
+	if (rb_per_cpu_empty(cpu_buffer))
+		return NULL;
+
+	event = rb_iter_head_event(iter);
+
+	switch (event->type) {
+	case RINGBUF_TYPE_PADDING:
+		rb_inc_iter(iter);
+		goto again;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		/* Internal data, OK to advance */
+		rb_advance_iter(iter);
+		goto again;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		/* FIXME: not implemented */
+		rb_advance_iter(iter);
+		goto again;
+
+	case RINGBUF_TYPE_DATA:
+		if (ts) {
+			*ts = iter->read_stamp + event->time_delta;
+			ring_buffer_normalize_time_stamp(cpu_buffer->cpu, ts);
+		}
+		return event;
+
+	default:
+		BUG();
+	}
+
+	return NULL;
+}
+
+/**
+ * ring_buffer_consume - return an event and consume it
+ * @buffer: The ring buffer to get the next event from
+ *
+ * Returns the next event in the ring buffer, and that event is consumed.
+ * Meaning, that sequential reads will keep returning a different event,
+ * and eventually empty the ring buffer if the producer is slower.
+ */
+struct ring_buffer_event *
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return NULL;
+
+	event = ring_buffer_peek(buffer, cpu, ts);
+	if (!event)
+		return NULL;
+
+	cpu_buffer = buffer->buffers[cpu];
+	rb_advance_reader(cpu_buffer);
+
+	return event;
+}
+
+/**
+ * ring_buffer_read_start - start a non consuming read of the buffer
+ * @buffer: The ring buffer to read from
+ * @cpu: The cpu buffer to iterate over
+ *
+ * This starts up an iteration through the buffer. It also disables
+ * the recording to the buffer until the reading is finished.
+ * This prevents the reading from being corrupted. This is not
+ * a consuming read, so a producer is not expected.
+ *
+ * Must be paired with ring_buffer_finish.
+ */
+struct ring_buffer_iter *
+ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_iter *iter;
+	unsigned long flags;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return NULL;
+
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return NULL;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	iter->cpu_buffer = cpu_buffer;
+
+	atomic_inc(&cpu_buffer->record_disabled);
+	synchronize_sched();
+
+	spin_lock_irqsave(&cpu_buffer->lock, flags);
+	ring_buffer_iter_reset(iter);
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+
+	return iter;
+}
+
+/**
+ * ring_buffer_finish - finish reading the iterator of the buffer
+ * @iter: The iterator retrieved by ring_buffer_start
+ *
+ * This re-enables the recording to the buffer, and frees the
+ * iterator.
+ */
+void
+ring_buffer_read_finish(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+
+	atomic_dec(&cpu_buffer->record_disabled);
+	kfree(iter);
+}
+
+/**
+ * ring_buffer_read - read the next item in the ring buffer by the iterator
+ * @iter: The ring buffer iterator
+ * @ts: The time stamp of the event read.
+ *
+ * This reads the next event in the ring buffer and increments the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
+{
+	struct ring_buffer_event *event;
+
+	event = ring_buffer_iter_peek(iter, ts);
+	if (!event)
+		return NULL;
+
+	rb_advance_iter(iter);
+
+	return event;
+}
+
+/**
+ * ring_buffer_size - return the size of the ring buffer (in bytes)
+ * @buffer: The ring buffer.
+ */
+unsigned long ring_buffer_size(struct ring_buffer *buffer)
+{
+	return BUF_PAGE_SIZE * buffer->pages;
+}
+
+static void
+rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	cpu_buffer->head_page
+		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+	local_set(&cpu_buffer->head_page->write, 0);
+	local_set(&cpu_buffer->head_page->commit, 0);
+
+	cpu_buffer->head_page->read = 0;
+
+	cpu_buffer->tail_page = cpu_buffer->head_page;
+	cpu_buffer->commit_page = cpu_buffer->head_page;
+
+	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
+	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->commit, 0);
+	cpu_buffer->reader_page->read = 0;
+
+	cpu_buffer->overrun = 0;
+	cpu_buffer->entries = 0;
+}
+
+/**
+ * ring_buffer_reset_cpu - reset a ring buffer per CPU buffer
+ * @buffer: The ring buffer to reset a per cpu buffer of
+ * @cpu: The CPU buffer to be reset
+ */
+void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	unsigned long flags;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return;
+
+	spin_lock_irqsave(&cpu_buffer->lock, flags);
+
+	rb_reset_cpu(cpu_buffer);
+
+	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
+}
+
+/**
+ * ring_buffer_reset - reset a ring buffer
+ * @buffer: The ring buffer to reset all cpu buffers
+ */
+void ring_buffer_reset(struct ring_buffer *buffer)
+{
+	int cpu;
+
+	for_each_buffer_cpu(buffer, cpu)
+		ring_buffer_reset_cpu(buffer, cpu);
+}
+
+/**
+ * rind_buffer_empty - is the ring buffer empty?
+ * @buffer: The ring buffer to test
+ */
+int ring_buffer_empty(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	/* yes this is racy, but if you don't like the race, lock the buffer */
+	for_each_buffer_cpu(buffer, cpu) {
+		cpu_buffer = buffer->buffers[cpu];
+		if (!rb_per_cpu_empty(cpu_buffer))
+			return 0;
+	}
+	return 1;
+}
+
+/**
+ * ring_buffer_empty_cpu - is a cpu buffer of a ring buffer empty?
+ * @buffer: The ring buffer
+ * @cpu: The CPU buffer to test
+ */
+int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (!cpu_isset(cpu, buffer->cpumask))
+		return 1;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return rb_per_cpu_empty(cpu_buffer);
+}
+
+/**
+ * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
+ * @buffer_a: One buffer to swap with
+ * @buffer_b: The other buffer to swap with
+ *
+ * This function is useful for tracers that want to take a "snapshot"
+ * of a CPU buffer and has another back up buffer lying around.
+ * it is expected that the tracer handles the cpu buffer not being
+ * used at the moment.
+ */
+int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+			 struct ring_buffer *buffer_b, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer_a;
+	struct ring_buffer_per_cpu *cpu_buffer_b;
+
+	if (!cpu_isset(cpu, buffer_a->cpumask) ||
+	    !cpu_isset(cpu, buffer_b->cpumask))
+		return -EINVAL;
+
+	/* At least make sure the two buffers are somewhat the same */
+	if (buffer_a->size != buffer_b->size ||
+	    buffer_a->pages != buffer_b->pages)
+		return -EINVAL;
+
+	cpu_buffer_a = buffer_a->buffers[cpu];
+	cpu_buffer_b = buffer_b->buffers[cpu];
+
+	/*
+	 * We can't do a synchronize_sched here because this
+	 * function can be called in atomic context.
+	 * Normally this will be called from the same CPU as cpu.
+	 * If not it's up to the caller to protect this.
+	 */
+	atomic_inc(&cpu_buffer_a->record_disabled);
+	atomic_inc(&cpu_buffer_b->record_disabled);
+
+	buffer_a->buffers[cpu] = cpu_buffer_b;
+	buffer_b->buffers[cpu] = cpu_buffer_a;
+
+	cpu_buffer_b->buffer = buffer_a;
+	cpu_buffer_a->buffer = buffer_b;
+
+	atomic_dec(&cpu_buffer_a->record_disabled);
+	atomic_dec(&cpu_buffer_b->record_disabled);
+
+	return 0;
+}
+
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f3fb3d..d345d64 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -14,6 +14,7 @@
 #include <linux/utsrelease.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
+#include <linux/notifier.h>
 #include <linux/debugfs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
@@ -22,6 +23,7 @@
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
+#include <linux/kdebug.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -31,25 +33,36 @@
 #include <linux/writeback.h>
 
 #include <linux/stacktrace.h>
+#include <linux/ring_buffer.h>
 
 #include "trace.h"
 
+#define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
+
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
-static unsigned long __read_mostly	tracing_nr_buffers;
+static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+
+static inline void ftrace_disable_cpu(void)
+{
+	preempt_disable();
+	local_inc(&__get_cpu_var(ftrace_cpu_disabled));
+}
+
+static inline void ftrace_enable_cpu(void)
+{
+	local_dec(&__get_cpu_var(ftrace_cpu_disabled));
+	preempt_enable();
+}
+
 static cpumask_t __read_mostly		tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu_mask(cpu, tracing_buffer_mask)
 
-static int trace_alloc_page(void);
-static int trace_free_page(void);
-
 static int tracing_disabled = 1;
 
-static unsigned long tracing_pages_allocated;
-
 long
 ns2usecs(cycle_t nsec)
 {
@@ -60,7 +73,9 @@ ns2usecs(cycle_t nsec)
 
 cycle_t ftrace_now(int cpu)
 {
-	return cpu_clock(cpu);
+	u64 ts = ring_buffer_time_stamp(cpu);
+	ring_buffer_normalize_time_stamp(cpu, &ts);
+	return ts;
 }
 
 /*
@@ -100,11 +115,18 @@ static int			tracer_enabled = 1;
 int				ftrace_function_enabled;
 
 /*
- * trace_nr_entries is the number of entries that is allocated
- * for a buffer. Note, the number of entries is always rounded
- * to ENTRIES_PER_PAGE.
+ * trace_buf_size is the size in bytes that is allocated
+ * for a buffer. Note, the number of bytes is always rounded
+ * to page size.
+ *
+ * This number is purposely set to a low number of 16384.
+ * If the dump on oops happens, it will be much appreciated
+ * to not have to wait for all that output. Anyway this can be
+ * boot time and run time configurable.
  */
-static unsigned long		trace_nr_entries = 65536UL;
+#define TRACE_BUF_SIZE_DEFAULT	1441792UL /* 16384 * 88 (sizeof(entry)) */
+
+static unsigned long		trace_buf_size = TRACE_BUF_SIZE_DEFAULT;
 
 /* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
@@ -133,24 +155,6 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds iter_ctrl options */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT;
 
-static notrace void no_trace_init(struct trace_array *tr)
-{
-	int cpu;
-
-	ftrace_function_enabled = 0;
-	if(tr->ctrl)
-		for_each_online_cpu(cpu)
-			tracing_reset(tr->data[cpu]);
-	tracer_enabled = 0;
-}
-
-/* dummy trace to disable tracing */
-static struct tracer no_tracer __read_mostly = {
-	.name		= "none",
-	.init		= no_trace_init
-};
-
-
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
@@ -167,23 +171,21 @@ void trace_wake_up(void)
 		wake_up(&trace_wait);
 }
 
-#define ENTRIES_PER_PAGE (PAGE_SIZE / sizeof(struct trace_entry))
-
-static int __init set_nr_entries(char *str)
+static int __init set_buf_size(char *str)
 {
-	unsigned long nr_entries;
+	unsigned long buf_size;
 	int ret;
 
 	if (!str)
 		return 0;
-	ret = strict_strtoul(str, 0, &nr_entries);
+	ret = strict_strtoul(str, 0, &buf_size);
 	/* nr_entries can not be zero */
-	if (ret < 0 || nr_entries == 0)
+	if (ret < 0 || buf_size == 0)
 		return 0;
-	trace_nr_entries = nr_entries;
+	trace_buf_size = buf_size;
 	return 1;
 }
-__setup("trace_entries=", set_nr_entries);
+__setup("trace_buf_size=", set_buf_size);
 
 unsigned long nsecs_to_usecs(unsigned long nsecs)
 {
@@ -191,21 +193,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 }
 
 /*
- * trace_flag_type is an enumeration that holds different
- * states when a trace occurs. These are:
- *  IRQS_OFF	- interrupts were disabled
- *  NEED_RESCED - reschedule is requested
- *  HARDIRQ	- inside an interrupt handler
- *  SOFTIRQ	- inside a softirq handler
- */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_NEED_RESCHED		= 0x02,
-	TRACE_FLAG_HARDIRQ		= 0x04,
-	TRACE_FLAG_SOFTIRQ		= 0x08,
-};
-
-/*
  * TRACE_ITER_SYM_MASK masks the options in trace_flags that
  * control the output of kernel symbols.
  */
@@ -224,6 +211,7 @@ static const char *trace_options[] = {
 	"block",
 	"stacktrace",
 	"sched-tree",
+	"ftrace_printk",
 	NULL
 };
 
@@ -266,54 +254,6 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	tracing_record_cmdline(current);
 }
 
-#define CHECK_COND(cond)			\
-	if (unlikely(cond)) {			\
-		tracing_disabled = 1;		\
-		WARN_ON(1);			\
-		return -1;			\
-	}
-
-/**
- * check_pages - integrity check of trace buffers
- *
- * As a safty measure we check to make sure the data pages have not
- * been corrupted.
- */
-int check_pages(struct trace_array_cpu *data)
-{
-	struct page *page, *tmp;
-
-	CHECK_COND(data->trace_pages.next->prev != &data->trace_pages);
-	CHECK_COND(data->trace_pages.prev->next != &data->trace_pages);
-
-	list_for_each_entry_safe(page, tmp, &data->trace_pages, lru) {
-		CHECK_COND(page->lru.next->prev != &page->lru);
-		CHECK_COND(page->lru.prev->next != &page->lru);
-	}
-
-	return 0;
-}
-
-/**
- * head_page - page address of the first page in per_cpu buffer.
- *
- * head_page returns the page address of the first page in
- * a per_cpu buffer. This also preforms various consistency
- * checks to make sure the buffer has not been corrupted.
- */
-void *head_page(struct trace_array_cpu *data)
-{
-	struct page *page;
-
-	if (list_empty(&data->trace_pages))
-		return NULL;
-
-	page = list_entry(data->trace_pages.next, struct page, lru);
-	BUG_ON(&page->lru == &data->trace_pages);
-
-	return page_address(page);
-}
-
 /**
  * trace_seq_printf - sequence printing of trace information
  * @s: trace sequence descriptor
@@ -395,28 +335,23 @@ trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
 	return len;
 }
 
-#define HEX_CHARS 17
-static const char hex2asc[] = "0123456789abcdef";
+#define MAX_MEMHEX_BYTES	8
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
 
 static int
 trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 {
 	unsigned char hex[HEX_CHARS];
 	unsigned char *data = mem;
-	unsigned char byte;
 	int i, j;
 
-	BUG_ON(len >= HEX_CHARS);
-
 #ifdef __BIG_ENDIAN
 	for (i = 0, j = 0; i < len; i++) {
 #else
 	for (i = len-1, j = 0; i >= 0; i--) {
 #endif
-		byte = data[i];
-
-		hex[j++] = hex2asc[byte & 0x0f];
-		hex[j++] = hex2asc[byte >> 4];
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
 	}
 	hex[j++] = ' ';
 
@@ -460,34 +395,6 @@ trace_print_seq(struct seq_file *m, struct trace_seq *s)
 	trace_seq_reset(s);
 }
 
-/*
- * flip the trace buffers between two trace descriptors.
- * This usually is the buffers between the global_trace and
- * the max_tr to record a snapshot of a current trace.
- *
- * The ftrace_max_lock must be held.
- */
-static void
-flip_trace(struct trace_array_cpu *tr1, struct trace_array_cpu *tr2)
-{
-	struct list_head flip_pages;
-
-	INIT_LIST_HEAD(&flip_pages);
-
-	memcpy(&tr1->trace_head_idx, &tr2->trace_head_idx,
-		sizeof(struct trace_array_cpu) -
-		offsetof(struct trace_array_cpu, trace_head_idx));
-
-	check_pages(tr1);
-	check_pages(tr2);
-	list_splice_init(&tr1->trace_pages, &flip_pages);
-	list_splice_init(&tr2->trace_pages, &tr1->trace_pages);
-	list_splice_init(&flip_pages, &tr2->trace_pages);
-	BUG_ON(!list_empty(&flip_pages));
-	check_pages(tr1);
-	check_pages(tr2);
-}
-
 /**
  * update_max_tr - snapshot all trace buffers from global_trace to max_tr
  * @tr: tracer
@@ -500,17 +407,17 @@ flip_trace(struct trace_array_cpu *tr1, struct trace_array_cpu *tr2)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data;
-	int i;
+	struct ring_buffer *buf = tr->buffer;
 
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	/* clear out all the previous traces */
-	for_each_tracing_cpu(i) {
-		data = tr->data[i];
-		flip_trace(max_tr.data[i], data);
-		tracing_reset(data);
-	}
+
+	tr->buffer = max_tr.buffer;
+	max_tr.buffer = buf;
+
+	ftrace_disable_cpu();
+	ring_buffer_reset(tr->buffer);
+	ftrace_enable_cpu();
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
@@ -527,16 +434,19 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data = tr->data[cpu];
-	int i;
+	int ret;
 
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
-	for_each_tracing_cpu(i)
-		tracing_reset(max_tr.data[i]);
 
-	flip_trace(max_tr.data[cpu], data);
-	tracing_reset(data);
+	ftrace_disable_cpu();
+
+	ring_buffer_reset(max_tr.buffer);
+	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
+
+	ftrace_enable_cpu();
+
+	WARN_ON_ONCE(ret);
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
@@ -573,7 +483,6 @@ int register_tracer(struct tracer *type)
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
-		struct trace_array_cpu *data;
 		struct trace_array *tr = &global_trace;
 		int saved_ctrl = tr->ctrl;
 		int i;
@@ -585,10 +494,7 @@ int register_tracer(struct tracer *type)
 		 * If we fail, we do not register this tracer.
 		 */
 		for_each_tracing_cpu(i) {
-			data = tr->data[i];
-			if (!head_page(data))
-				continue;
-			tracing_reset(data);
+			tracing_reset(tr, i);
 		}
 		current_trace = type;
 		tr->ctrl = 0;
@@ -604,10 +510,7 @@ int register_tracer(struct tracer *type)
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
 		for_each_tracing_cpu(i) {
-			data = tr->data[i];
-			if (!head_page(data))
-				continue;
-			tracing_reset(data);
+			tracing_reset(tr, i);
 		}
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -653,13 +556,11 @@ void unregister_tracer(struct tracer *type)
 	mutex_unlock(&trace_types_lock);
 }
 
-void tracing_reset(struct trace_array_cpu *data)
+void tracing_reset(struct trace_array *tr, int cpu)
 {
-	data->trace_idx = 0;
-	data->overrun = 0;
-	data->trace_head = data->trace_tail = head_page(data);
-	data->trace_head_idx = 0;
-	data->trace_tail_idx = 0;
+	ftrace_disable_cpu();
+	ring_buffer_reset_cpu(tr->buffer, cpu);
+	ftrace_enable_cpu();
 }
 
 #define SAVED_CMDLINES 128
@@ -745,82 +646,16 @@ void tracing_record_cmdline(struct task_struct *tsk)
 	trace_save_cmdline(tsk);
 }
 
-static inline struct list_head *
-trace_next_list(struct trace_array_cpu *data, struct list_head *next)
-{
-	/*
-	 * Roundrobin - but skip the head (which is not a real page):
-	 */
-	next = next->next;
-	if (unlikely(next == &data->trace_pages))
-		next = next->next;
-	BUG_ON(next == &data->trace_pages);
-
-	return next;
-}
-
-static inline void *
-trace_next_page(struct trace_array_cpu *data, void *addr)
-{
-	struct list_head *next;
-	struct page *page;
-
-	page = virt_to_page(addr);
-
-	next = trace_next_list(data, &page->lru);
-	page = list_entry(next, struct page, lru);
-
-	return page_address(page);
-}
-
-static inline struct trace_entry *
-tracing_get_trace_entry(struct trace_array *tr, struct trace_array_cpu *data)
-{
-	unsigned long idx, idx_next;
-	struct trace_entry *entry;
-
-	data->trace_idx++;
-	idx = data->trace_head_idx;
-	idx_next = idx + 1;
-
-	BUG_ON(idx * TRACE_ENTRY_SIZE >= PAGE_SIZE);
-
-	entry = data->trace_head + idx * TRACE_ENTRY_SIZE;
-
-	if (unlikely(idx_next >= ENTRIES_PER_PAGE)) {
-		data->trace_head = trace_next_page(data, data->trace_head);
-		idx_next = 0;
-	}
-
-	if (data->trace_head == data->trace_tail &&
-	    idx_next == data->trace_tail_idx) {
-		/* overrun */
-		data->overrun++;
-		data->trace_tail_idx++;
-		if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
-			data->trace_tail =
-				trace_next_page(data, data->trace_tail);
-			data->trace_tail_idx = 0;
-		}
-	}
-
-	data->trace_head_idx = idx_next;
-
-	return entry;
-}
-
-static inline void
-tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
+void
+tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
+			     int pc)
 {
 	struct task_struct *tsk = current;
-	unsigned long pc;
-
-	pc = preempt_count();
 
-	entry->preempt_count	= pc & 0xff;
-	entry->pid		= (tsk) ? tsk->pid : 0;
-	entry->t		= ftrace_now(raw_smp_processor_id());
-	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
+	entry->preempt_count		= pc & 0xff;
+	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->flags =
+		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
@@ -828,145 +663,139 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
 
 void
 trace_function(struct trace_array *tr, struct trace_array_cpu *data,
-	       unsigned long ip, unsigned long parent_ip, unsigned long flags)
+	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
+	       int pc)
 {
-	struct trace_entry *entry;
+	struct ring_buffer_event *event;
+	struct ftrace_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_FN;
-	entry->fn.ip		= ip;
-	entry->fn.parent_ip	= parent_ip;
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	/* If we are reading the ring buffer, don't trace */
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_FN;
+	entry->ip			= ip;
+	entry->parent_ip		= parent_ip;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
 
 void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
-       unsigned long ip, unsigned long parent_ip, unsigned long flags)
+       unsigned long ip, unsigned long parent_ip, unsigned long flags,
+       int pc)
 {
 	if (likely(!atomic_read(&data->disabled)))
-		trace_function(tr, data, ip, parent_ip, flags);
+		trace_function(tr, data, ip, parent_ip, flags, pc);
 }
 
-#ifdef CONFIG_MMIOTRACE
-void __trace_mmiotrace_rw(struct trace_array *tr, struct trace_array_cpu *data,
-						struct mmiotrace_rw *rw)
+static void ftrace_trace_stack(struct trace_array *tr,
+			       struct trace_array_cpu *data,
+			       unsigned long flags,
+			       int skip, int pc)
 {
-	struct trace_entry *entry;
+	struct ring_buffer_event *event;
+	struct stack_entry *entry;
+	struct stack_trace trace;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_MMIO_RW;
-	entry->mmiorw		= *rw;
-
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
-
-	trace_wake_up();
-}
-
-void __trace_mmiotrace_map(struct trace_array *tr, struct trace_array_cpu *data,
-						struct mmiotrace_map *map)
-{
-	struct trace_entry *entry;
-	unsigned long irq_flags;
+	if (!(trace_flags & TRACE_ITER_STACKTRACE))
+		return;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type		= TRACE_STACK;
 
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_MMIO_MAP;
-	entry->mmiomap		= *map;
+	memset(&entry->caller, 0, sizeof(entry->caller));
 
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	trace.nr_entries	= 0;
+	trace.max_entries	= FTRACE_STACK_ENTRIES;
+	trace.skip		= skip;
+	trace.entries		= entry->caller;
 
-	trace_wake_up();
+	save_stack_trace(&trace);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
-#endif
 
 void __trace_stack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags,
 		   int skip)
 {
-	struct trace_entry *entry;
-	struct stack_trace trace;
-
-	if (!(trace_flags & TRACE_ITER_STACKTRACE))
-		return;
-
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_STACK;
-
-	memset(&entry->stack, 0, sizeof(entry->stack));
-
-	trace.nr_entries	= 0;
-	trace.max_entries	= FTRACE_STACK_ENTRIES;
-	trace.skip		= skip;
-	trace.entries		= entry->stack.caller;
-
-	save_stack_trace(&trace);
+	ftrace_trace_stack(tr, data, flags, skip, preempt_count());
 }
 
-void
-__trace_special(void *__tr, void *__data,
-		unsigned long arg1, unsigned long arg2, unsigned long arg3)
+static void
+ftrace_trace_special(void *__tr, void *__data,
+		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
+		     int pc)
 {
+	struct ring_buffer_event *event;
 	struct trace_array_cpu *data = __data;
 	struct trace_array *tr = __tr;
-	struct trace_entry *entry;
+	struct special_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_SPECIAL;
-	entry->special.arg1	= arg1;
-	entry->special.arg2	= arg2;
-	entry->special.arg3	= arg3;
-	__trace_stack(tr, data, irq_flags, 4);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, pc);
+	entry->ent.type			= TRACE_SPECIAL;
+	entry->arg1			= arg1;
+	entry->arg2			= arg2;
+	entry->arg3			= arg3;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
 
 	trace_wake_up();
 }
 
 void
+__trace_special(void *__tr, void *__data,
+		unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	ftrace_trace_special(__tr, __data, arg1, arg2, arg3, preempt_count());
+}
+
+void
 tracing_sched_switch_trace(struct trace_array *tr,
 			   struct trace_array_cpu *data,
 			   struct task_struct *prev,
 			   struct task_struct *next,
-			   unsigned long flags)
+			   unsigned long flags, int pc)
 {
-	struct trace_entry *entry;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_CTX;
-	entry->ctx.prev_pid	= prev->pid;
-	entry->ctx.prev_prio	= prev->prio;
-	entry->ctx.prev_state	= prev->state;
-	entry->ctx.next_pid	= next->pid;
-	entry->ctx.next_prio	= next->prio;
-	entry->ctx.next_state	= next->state;
-	__trace_stack(tr, data, flags, 5);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_CTX;
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	ftrace_trace_stack(tr, data, flags, 5, pc);
 }
 
 void
@@ -974,25 +803,28 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 			   struct trace_array_cpu *data,
 			   struct task_struct *wakee,
 			   struct task_struct *curr,
-			   unsigned long flags)
+			   unsigned long flags, int pc)
 {
-	struct trace_entry *entry;
+	struct ring_buffer_event *event;
+	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
 
-	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_WAKE;
-	entry->ctx.prev_pid	= curr->pid;
-	entry->ctx.prev_prio	= curr->prio;
-	entry->ctx.prev_state	= curr->state;
-	entry->ctx.next_pid	= wakee->pid;
-	entry->ctx.next_prio	= wakee->prio;
-	entry->ctx.next_state	= wakee->state;
-	__trace_stack(tr, data, flags, 6);
-	__raw_spin_unlock(&data->lock);
-	raw_local_irq_restore(irq_flags);
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_WAKE;
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	ftrace_trace_stack(tr, data, flags, 6, pc);
 
 	trace_wake_up();
 }
@@ -1002,23 +834,21 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
 	int cpu;
+	int pc;
 
-	if (tracing_disabled || current_trace == &no_tracer || !tr->ctrl)
+	if (tracing_disabled || !tr->ctrl)
 		return;
 
-	local_irq_save(flags);
+	pc = preempt_count();
+	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1))
-		__trace_special(tr, data, arg1, arg2, arg3);
+	if (likely(!atomic_read(&data->disabled)))
+		ftrace_trace_special(tr, data, arg1, arg2, arg3, pc);
 
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	preempt_enable_notrace();
 }
 
 #ifdef CONFIG_FTRACE
@@ -1029,7 +859,8 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
-	int cpu;
+	int cpu, resched;
+	int pc;
 
 	if (unlikely(!ftrace_function_enabled))
 		return;
@@ -1037,16 +868,22 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	if (skip_trace(ip))
 		return;
 
-	local_irq_save(flags);
+	pc = preempt_count();
+	resched = need_resched();
+	preempt_disable_notrace();
+	local_save_flags(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags);
+		trace_function(tr, data, ip, parent_ip, flags, pc);
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
 }
 
 static struct ftrace_ops trace_ops __read_mostly =
@@ -1073,111 +910,96 @@ enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 };
 
-static struct trace_entry *
-trace_entry_idx(struct trace_array *tr, struct trace_array_cpu *data,
-		struct trace_iterator *iter, int cpu)
+static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
 {
-	struct page *page;
-	struct trace_entry *array;
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
 
-	if (iter->next_idx[cpu] >= tr->entries ||
-	    iter->next_idx[cpu] >= data->trace_idx ||
-	    (data->trace_head == data->trace_tail &&
-	     data->trace_head_idx == data->trace_tail_idx))
-		return NULL;
+	iter->idx++;
+	if (iter->buffer_iter[iter->cpu])
+		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
 
-	if (!iter->next_page[cpu]) {
-		/* Initialize the iterator for this cpu trace buffer */
-		WARN_ON(!data->trace_tail);
-		page = virt_to_page(data->trace_tail);
-		iter->next_page[cpu] = &page->lru;
-		iter->next_page_idx[cpu] = data->trace_tail_idx;
-	}
+	ftrace_enable_cpu();
+}
+
+static struct trace_entry *
+peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
+{
+	struct ring_buffer_event *event;
+	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
 
-	page = list_entry(iter->next_page[cpu], struct page, lru);
-	BUG_ON(&data->trace_pages == &page->lru);
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
+
+	if (buf_iter)
+		event = ring_buffer_iter_peek(buf_iter, ts);
+	else
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
 
-	array = page_address(page);
+	ftrace_enable_cpu();
 
-	WARN_ON(iter->next_page_idx[cpu] >= ENTRIES_PER_PAGE);
-	return &array[iter->next_page_idx[cpu]];
+	return event ? ring_buffer_event_data(event) : NULL;
 }
 
 static struct trace_entry *
-find_next_entry(struct trace_iterator *iter, int *ent_cpu)
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 {
-	struct trace_array *tr = iter->tr;
+	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
+	u64 next_ts = 0, ts;
 	int next_cpu = -1;
 	int cpu;
 
 	for_each_tracing_cpu(cpu) {
-		if (!head_page(tr->data[cpu]))
+
+		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
-		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+
+		ent = peek_next_entry(iter, cpu, &ts);
+
 		/*
 		 * Pick the entry with the smallest timestamp:
 		 */
-		if (ent && (!next || ent->t < next->t)) {
+		if (ent && (!next || ts < next_ts)) {
 			next = ent;
 			next_cpu = cpu;
+			next_ts = ts;
 		}
 	}
 
 	if (ent_cpu)
 		*ent_cpu = next_cpu;
 
+	if (ent_ts)
+		*ent_ts = next_ts;
+
 	return next;
 }
 
-static void trace_iterator_increment(struct trace_iterator *iter)
+/* Find the next real entry, without updating the iterator itself */
+static struct trace_entry *
+find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 {
-	iter->idx++;
-	iter->next_idx[iter->cpu]++;
-	iter->next_page_idx[iter->cpu]++;
-
-	if (iter->next_page_idx[iter->cpu] >= ENTRIES_PER_PAGE) {
-		struct trace_array_cpu *data = iter->tr->data[iter->cpu];
-
-		iter->next_page_idx[iter->cpu] = 0;
-		iter->next_page[iter->cpu] =
-			trace_next_list(data, iter->next_page[iter->cpu]);
-	}
+	return __find_next_entry(iter, ent_cpu, ent_ts);
 }
 
-static void trace_consume(struct trace_iterator *iter)
+/* Find the next real entry, and increment the iterator to the next entry */
+static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	struct trace_array_cpu *data = iter->tr->data[iter->cpu];
+	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
 
-	data->trace_tail_idx++;
-	if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
-		data->trace_tail = trace_next_page(data, data->trace_tail);
-		data->trace_tail_idx = 0;
-	}
+	if (iter->ent)
+		trace_iterator_increment(iter, iter->cpu);
 
-	/* Check if we empty it, then reset the index */
-	if (data->trace_head == data->trace_tail &&
-	    data->trace_head_idx == data->trace_tail_idx)
-		data->trace_idx = 0;
+	return iter->ent ? iter : NULL;
 }
 
-static void *find_next_entry_inc(struct trace_iterator *iter)
+static void trace_consume(struct trace_iterator *iter)
 {
-	struct trace_entry *next;
-	int next_cpu = -1;
-
-	next = find_next_entry(iter, &next_cpu);
-
-	iter->prev_ent = iter->ent;
-	iter->prev_cpu = iter->cpu;
-
-	iter->ent = next;
-	iter->cpu = next_cpu;
-
-	if (next)
-		trace_iterator_increment(iter);
-
-	return next ? iter : NULL;
+	/* Don't allow ftrace to trace into the ring buffers */
+	ftrace_disable_cpu();
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
+	ftrace_enable_cpu();
 }
 
 static void *s_next(struct seq_file *m, void *v, loff_t *pos)
@@ -1210,7 +1032,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	struct trace_iterator *iter = m->private;
 	void *p = NULL;
 	loff_t l = 0;
-	int i;
+	int cpu;
 
 	mutex_lock(&trace_types_lock);
 
@@ -1229,14 +1051,15 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		iter->ent = NULL;
 		iter->cpu = 0;
 		iter->idx = -1;
-		iter->prev_ent = NULL;
-		iter->prev_cpu = -1;
 
-		for_each_tracing_cpu(i) {
-			iter->next_idx[i] = 0;
-			iter->next_page[i] = NULL;
+		ftrace_disable_cpu();
+
+		for_each_tracing_cpu(cpu) {
+			ring_buffer_iter_reset(iter->buffer_iter[cpu]);
 		}
 
+		ftrace_enable_cpu();
+
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 
@@ -1330,21 +1153,21 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                _------=> CPU#            \n");
-	seq_puts(m, "#               / _-----=> irqs-off        \n");
-	seq_puts(m, "#              | / _----=> need-resched    \n");
-	seq_puts(m, "#              || / _---=> hardirq/softirq \n");
-	seq_puts(m, "#              ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#              |||| /                      \n");
-	seq_puts(m, "#              |||||     delay             \n");
-	seq_puts(m, "#  cmd     pid ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /    |||||   \\   |   /           \n");
+	seq_puts(m, "#                  _------=> CPU#            \n");
+	seq_puts(m, "#                 / _-----=> irqs-off        \n");
+	seq_puts(m, "#                | / _----=> need-resched    \n");
+	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
+	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
+	seq_puts(m, "#                |||| /                      \n");
+	seq_puts(m, "#                |||||     delay             \n");
+	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
+	seq_puts(m, "#     \\   /      |||||   \\   |   /           \n");
 }
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID   CPU#    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |      |          |         |\n");
+	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#              | |       |          |         |\n");
 }
 
 
@@ -1355,23 +1178,16 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	struct trace_array *tr = iter->tr;
 	struct trace_array_cpu *data = tr->data[tr->cpu];
 	struct tracer *type = current_trace;
-	unsigned long total   = 0;
-	unsigned long entries = 0;
-	int cpu;
+	unsigned long total;
+	unsigned long entries;
 	const char *name = "preemption";
 
 	if (type)
 		name = type->name;
 
-	for_each_tracing_cpu(cpu) {
-		if (head_page(tr->data[cpu])) {
-			total += tr->data[cpu]->trace_idx;
-			if (tr->data[cpu]->trace_idx > tr->entries)
-				entries += tr->entries;
-			else
-				entries += tr->data[cpu]->trace_idx;
-		}
-	}
+	entries = ring_buffer_entries(iter->tr->buffer);
+	total = entries +
+		ring_buffer_overruns(iter->tr->buffer);
 
 	seq_printf(m, "%s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -1428,7 +1244,7 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	comm = trace_find_cmdline(entry->pid);
 
 	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
-	trace_seq_printf(s, "%d", cpu);
+	trace_seq_printf(s, "%3d", cpu);
 	trace_seq_printf(s, "%c%c",
 			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
 			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
@@ -1457,7 +1273,7 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 unsigned long preempt_mark_thresh = 100;
 
 static void
-lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
+lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
 		    unsigned long rel_usecs)
 {
 	trace_seq_printf(s, " %4lldus", abs_usecs);
@@ -1471,34 +1287,76 @@ lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
-static int
+/*
+ * The message is supposed to contain an ending newline.
+ * If the printing stops prematurely, try to add a newline of our own.
+ */
+void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
+{
+	struct trace_entry *ent;
+	struct trace_field_cont *cont;
+	bool ok = true;
+
+	ent = peek_next_entry(iter, iter->cpu, NULL);
+	if (!ent || ent->type != TRACE_CONT) {
+		trace_seq_putc(s, '\n');
+		return;
+	}
+
+	do {
+		cont = (struct trace_field_cont *)ent;
+		if (ok)
+			ok = (trace_seq_printf(s, "%s", cont->buf) > 0);
+
+		ftrace_disable_cpu();
+
+		if (iter->buffer_iter[iter->cpu])
+			ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+		else
+			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+
+		ftrace_enable_cpu();
+
+		ent = peek_next_entry(iter, iter->cpu, NULL);
+	} while (ent && ent->type == TRACE_CONT);
+
+	if (!ok)
+		trace_seq_putc(s, '\n');
+}
+
+static enum print_line_t
 print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_entry *next_entry = find_next_entry(iter, NULL);
+	struct trace_entry *next_entry;
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
+	u64 next_ts;
 	char *comm;
 	int S, T;
 	int i;
 	unsigned state;
 
+	if (entry->type == TRACE_CONT)
+		return TRACE_TYPE_HANDLED;
+
+	next_entry = find_next_entry(iter, NULL, &next_ts);
 	if (!next_entry)
-		next_entry = entry;
-	rel_usecs = ns2usecs(next_entry->t - entry->t);
-	abs_usecs = ns2usecs(entry->t - iter->tr->time_start);
+		next_ts = iter->ts;
+	rel_usecs = ns2usecs(next_ts - iter->ts);
+	abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
 
 	if (verbose) {
 		comm = trace_find_cmdline(entry->pid);
-		trace_seq_printf(s, "%16s %5d %d %d %08x %08x [%08lx]"
+		trace_seq_printf(s, "%16s %5d %3d %d %08x %08x [%08lx]"
 				 " %ld.%03ldms (+%ld.%03ldms): ",
 				 comm,
 				 entry->pid, cpu, entry->flags,
 				 entry->preempt_count, trace_idx,
-				 ns2usecs(entry->t),
+				 ns2usecs(iter->ts),
 				 abs_usecs/1000,
 				 abs_usecs % 1000, rel_usecs/1000,
 				 rel_usecs % 1000);
@@ -1507,52 +1365,85 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
 	switch (entry->type) {
-	case TRACE_FN:
-		seq_print_ip_sym(s, entry->fn.ip, sym_flags);
+	case TRACE_FN: {
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_puts(s, " (");
-		if (kretprobed(entry->fn.parent_ip))
+		if (kretprobed(field->parent_ip))
 			trace_seq_puts(s, KRETPROBE_MSG);
 		else
-			seq_print_ip_sym(s, entry->fn.parent_ip, sym_flags);
+			seq_print_ip_sym(s, field->parent_ip, sym_flags);
 		trace_seq_puts(s, ")\n");
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
+
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
 
-		state = entry->ctx.prev_state ? __ffs(entry->ctx.prev_state) + 1 : 0;
+		state = field->prev_state ?
+			__ffs(field->prev_state) + 1 : 0;
 		S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
-		comm = trace_find_cmdline(entry->ctx.next_pid);
-		trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
-				 entry->ctx.prev_pid,
-				 entry->ctx.prev_prio,
+		comm = trace_find_cmdline(field->next_pid);
+		trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+				 field->prev_pid,
+				 field->prev_prio,
 				 S, entry->type == TRACE_CTX ? "==>" : "  +",
-				 entry->ctx.next_pid,
-				 entry->ctx.next_prio,
+				 field->next_cpu,
+				 field->next_pid,
+				 field->next_prio,
 				 T, comm);
 		break;
-	case TRACE_SPECIAL:
+	}
+	case TRACE_SPECIAL: {
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
+
 		trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+				 field->arg1,
+				 field->arg2,
+				 field->arg3);
 		break;
-	case TRACE_STACK:
+	}
+	case TRACE_STACK: {
+		struct stack_entry *field;
+
+		trace_assign_type(field, entry);
+
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i)
 				trace_seq_puts(s, " <= ");
-			seq_print_ip_sym(s, entry->stack.caller[i], sym_flags);
+			seq_print_ip_sym(s, field->caller[i], sym_flags);
 		}
 		trace_seq_puts(s, "\n");
 		break;
+	}
+	case TRACE_PRINT: {
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
+		trace_seq_printf(s, ": %s", field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
-	return 1;
+	return TRACE_TYPE_HANDLED;
 }
 
-static int print_trace_fmt(struct trace_iterator *iter)
+static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
@@ -1567,90 +1458,126 @@ static int print_trace_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return TRACE_TYPE_HANDLED;
+
 	comm = trace_find_cmdline(iter->ent->pid);
 
-	t = ns2usecs(entry->t);
+	t = ns2usecs(iter->ts);
 	usec_rem = do_div(t, 1000000ULL);
 	secs = (unsigned long)t;
 
 	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
 	if (!ret)
-		return 0;
-	ret = trace_seq_printf(s, "[%02d] ", iter->cpu);
+		return TRACE_TYPE_PARTIAL_LINE;
+	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
 	if (!ret)
-		return 0;
+		return TRACE_TYPE_PARTIAL_LINE;
 	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
 	if (!ret)
-		return 0;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	switch (entry->type) {
-	case TRACE_FN:
-		ret = seq_print_ip_sym(s, entry->fn.ip, sym_flags);
+	case TRACE_FN: {
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
+
+		ret = seq_print_ip_sym(s, field->ip, sym_flags);
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
-						entry->fn.parent_ip) {
+						field->parent_ip) {
 			ret = trace_seq_printf(s, " <-");
 			if (!ret)
-				return 0;
-			if (kretprobed(entry->fn.parent_ip))
+				return TRACE_TYPE_PARTIAL_LINE;
+			if (kretprobed(field->parent_ip))
 				ret = trace_seq_puts(s, KRETPROBE_MSG);
 			else
-				ret = seq_print_ip_sym(s, entry->fn.parent_ip,
+				ret = seq_print_ip_sym(s,
+						       field->parent_ip,
 						       sym_flags);
 			if (!ret)
-				return 0;
+				return TRACE_TYPE_PARTIAL_LINE;
 		}
 		ret = trace_seq_printf(s, "\n");
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
-		ret = trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c\n",
-				       entry->ctx.prev_pid,
-				       entry->ctx.prev_prio,
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
+
+		S = field->prev_state < sizeof(state_to_char) ?
+			state_to_char[field->prev_state] : 'X';
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
+		ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
+				       field->prev_pid,
+				       field->prev_prio,
 				       S,
 				       entry->type == TRACE_CTX ? "==>" : "  +",
-				       entry->ctx.next_pid,
-				       entry->ctx.next_prio,
+				       field->next_cpu,
+				       field->next_pid,
+				       field->next_prio,
 				       T);
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
-	case TRACE_SPECIAL:
+	}
+	case TRACE_SPECIAL: {
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
+
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+				 field->arg1,
+				 field->arg2,
+				 field->arg3);
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
-	case TRACE_STACK:
+	}
+	case TRACE_STACK: {
+		struct stack_entry *field;
+
+		trace_assign_type(field, entry);
+
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i) {
 				ret = trace_seq_puts(s, " <= ");
 				if (!ret)
-					return 0;
+					return TRACE_TYPE_PARTIAL_LINE;
 			}
-			ret = seq_print_ip_sym(s, entry->stack.caller[i],
+			ret = seq_print_ip_sym(s, field->caller[i],
 					       sym_flags);
 			if (!ret)
-				return 0;
+				return TRACE_TYPE_PARTIAL_LINE;
 		}
 		ret = trace_seq_puts(s, "\n");
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
 	}
-	return 1;
+	case TRACE_PRINT: {
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
+		trace_seq_printf(s, ": %s", field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
+	}
+	return TRACE_TYPE_HANDLED;
 }
 
-static int print_raw_fmt(struct trace_iterator *iter)
+static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
@@ -1659,47 +1586,77 @@ static int print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return TRACE_TYPE_HANDLED;
+
 	ret = trace_seq_printf(s, "%d %d %llu ",
-		entry->pid, iter->cpu, entry->t);
+		entry->pid, iter->cpu, iter->ts);
 	if (!ret)
-		return 0;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	switch (entry->type) {
-	case TRACE_FN:
+	case TRACE_FN: {
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
+
 		ret = trace_seq_printf(s, "%x %x\n",
-					entry->fn.ip, entry->fn.parent_ip);
+					field->ip,
+					field->parent_ip);
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
+
+		S = field->prev_state < sizeof(state_to_char) ?
+			state_to_char[field->prev_state] : 'X';
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
-		ret = trace_seq_printf(s, "%d %d %c %d %d %c\n",
-				       entry->ctx.prev_pid,
-				       entry->ctx.prev_prio,
+		ret = trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
+				       field->prev_pid,
+				       field->prev_prio,
 				       S,
-				       entry->ctx.next_pid,
-				       entry->ctx.next_prio,
+				       field->next_cpu,
+				       field->next_pid,
+				       field->next_prio,
 				       T);
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
+	}
 	case TRACE_SPECIAL:
-	case TRACE_STACK:
+	case TRACE_STACK: {
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
+
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+				 field->arg1,
+				 field->arg2,
+				 field->arg3);
 		if (!ret)
-			return 0;
+			return TRACE_TYPE_PARTIAL_LINE;
 		break;
 	}
-	return 1;
+	case TRACE_PRINT: {
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
+	}
+	return TRACE_TYPE_HANDLED;
 }
 
 #define SEQ_PUT_FIELD_RET(s, x)				\
@@ -1710,11 +1667,12 @@ do {							\
 
 #define SEQ_PUT_HEX_FIELD_RET(s, x)			\
 do {							\
+	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
 	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
 		return 0;				\
 } while (0)
 
-static int print_hex_fmt(struct trace_iterator *iter)
+static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned char newline = '\n';
@@ -1723,97 +1681,139 @@ static int print_hex_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return TRACE_TYPE_HANDLED;
+
 	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, entry->t);
+	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
-	case TRACE_FN:
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.ip);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.parent_ip);
+	case TRACE_FN: {
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_HEX_FIELD_RET(s, field->ip);
+		SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
+
+		S = field->prev_state < sizeof(state_to_char) ?
+			state_to_char[field->prev_state] : 'X';
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.prev_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.prev_prio);
+		SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, S);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.next_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.next_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.parent_ip);
+		SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
+		SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, T);
 		break;
+	}
 	case TRACE_SPECIAL:
-	case TRACE_STACK:
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg1);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg2);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg3);
+	case TRACE_STACK: {
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
+		SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
+		SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
 		break;
 	}
+	}
 	SEQ_PUT_FIELD_RET(s, newline);
 
-	return 1;
+	return TRACE_TYPE_HANDLED;
 }
 
-static int print_bin_fmt(struct trace_iterator *iter)
+static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return TRACE_TYPE_HANDLED;
+
 	SEQ_PUT_FIELD_RET(s, entry->pid);
-	SEQ_PUT_FIELD_RET(s, entry->cpu);
-	SEQ_PUT_FIELD_RET(s, entry->t);
+	SEQ_PUT_FIELD_RET(s, iter->cpu);
+	SEQ_PUT_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
-	case TRACE_FN:
-		SEQ_PUT_FIELD_RET(s, entry->fn.ip);
-		SEQ_PUT_FIELD_RET(s, entry->fn.parent_ip);
+	case TRACE_FN: {
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_FIELD_RET(s, field->ip);
+		SEQ_PUT_FIELD_RET(s, field->parent_ip);
 		break;
-	case TRACE_CTX:
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_pid);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_prio);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_state);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_pid);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_prio);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_state);
+	}
+	case TRACE_CTX: {
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_FIELD_RET(s, field->prev_pid);
+		SEQ_PUT_FIELD_RET(s, field->prev_prio);
+		SEQ_PUT_FIELD_RET(s, field->prev_state);
+		SEQ_PUT_FIELD_RET(s, field->next_pid);
+		SEQ_PUT_FIELD_RET(s, field->next_prio);
+		SEQ_PUT_FIELD_RET(s, field->next_state);
 		break;
+	}
 	case TRACE_SPECIAL:
-	case TRACE_STACK:
-		SEQ_PUT_FIELD_RET(s, entry->special.arg1);
-		SEQ_PUT_FIELD_RET(s, entry->special.arg2);
-		SEQ_PUT_FIELD_RET(s, entry->special.arg3);
+	case TRACE_STACK: {
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_FIELD_RET(s, field->arg1);
+		SEQ_PUT_FIELD_RET(s, field->arg2);
+		SEQ_PUT_FIELD_RET(s, field->arg3);
 		break;
 	}
+	}
 	return 1;
 }
 
 static int trace_empty(struct trace_iterator *iter)
 {
-	struct trace_array_cpu *data;
 	int cpu;
 
 	for_each_tracing_cpu(cpu) {
-		data = iter->tr->data[cpu];
-
-		if (head_page(data) && data->trace_idx &&
-		    (data->trace_tail != data->trace_head ||
-		     data->trace_tail_idx != data->trace_head_idx))
-			return 0;
+		if (iter->buffer_iter[cpu]) {
+			if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
+				return 0;
+		} else {
+			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
+				return 0;
+		}
 	}
+
 	return 1;
 }
 
-static int print_trace_line(struct trace_iterator *iter)
+static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
-	if (iter->trace && iter->trace->print_line)
-		return iter->trace->print_line(iter);
+	enum print_line_t ret;
+
+	if (iter->trace && iter->trace->print_line) {
+		ret = iter->trace->print_line(iter);
+		if (ret != TRACE_TYPE_UNHANDLED)
+			return ret;
+	}
 
 	if (trace_flags & TRACE_ITER_BIN)
 		return print_bin_fmt(iter);
@@ -1869,6 +1869,8 @@ static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file, int *ret)
 {
 	struct trace_iterator *iter;
+	struct seq_file *m;
+	int cpu;
 
 	if (tracing_disabled) {
 		*ret = -ENODEV;
@@ -1889,28 +1891,45 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	iter->trace = current_trace;
 	iter->pos = -1;
 
+	for_each_tracing_cpu(cpu) {
+
+		iter->buffer_iter[cpu] =
+			ring_buffer_read_start(iter->tr->buffer, cpu);
+
+		if (!iter->buffer_iter[cpu])
+			goto fail_buffer;
+	}
+
 	/* TODO stop tracer */
 	*ret = seq_open(file, &tracer_seq_ops);
-	if (!*ret) {
-		struct seq_file *m = file->private_data;
-		m->private = iter;
+	if (*ret)
+		goto fail_buffer;
 
-		/* stop the trace while dumping */
-		if (iter->tr->ctrl) {
-			tracer_enabled = 0;
-			ftrace_function_enabled = 0;
-		}
+	m = file->private_data;
+	m->private = iter;
 
-		if (iter->trace && iter->trace->open)
-			iter->trace->open(iter);
-	} else {
-		kfree(iter);
-		iter = NULL;
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl) {
+		tracer_enabled = 0;
+		ftrace_function_enabled = 0;
 	}
+
+	if (iter->trace && iter->trace->open)
+			iter->trace->open(iter);
+
 	mutex_unlock(&trace_types_lock);
 
  out:
 	return iter;
+
+ fail_buffer:
+	for_each_tracing_cpu(cpu) {
+		if (iter->buffer_iter[cpu])
+			ring_buffer_read_finish(iter->buffer_iter[cpu]);
+	}
+	mutex_unlock(&trace_types_lock);
+
+	return ERR_PTR(-ENOMEM);
 }
 
 int tracing_open_generic(struct inode *inode, struct file *filp)
@@ -1926,8 +1945,14 @@ int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct trace_iterator *iter = m->private;
+	int cpu;
 
 	mutex_lock(&trace_types_lock);
+	for_each_tracing_cpu(cpu) {
+		if (iter->buffer_iter[cpu])
+			ring_buffer_read_finish(iter->buffer_iter[cpu]);
+	}
+
 	if (iter->trace && iter->trace->close)
 		iter->trace->close(iter);
 
@@ -2352,9 +2377,11 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	struct tracer *t;
 	char buf[max_tracer_type_len+1];
 	int i;
+	size_t ret;
 
 	if (cnt > max_tracer_type_len)
 		cnt = max_tracer_type_len;
+	ret = cnt;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2370,7 +2397,11 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 		if (strcmp(t->name, buf) == 0)
 			break;
 	}
-	if (!t || t == current_trace)
+	if (!t) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (t == current_trace)
 		goto out;
 
 	if (current_trace && current_trace->reset)
@@ -2383,9 +2414,10 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&trace_types_lock);
 
-	filp->f_pos += cnt;
+	if (ret == cnt)
+		filp->f_pos += cnt;
 
-	return cnt;
+	return ret;
 }
 
 static ssize_t
@@ -2500,20 +2532,12 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	struct trace_array_cpu *data;
-	static cpumask_t mask;
-	unsigned long flags;
-#ifdef CONFIG_FTRACE
-	int ftrace_save;
-#endif
-	int cpu;
 	ssize_t sret;
 
 	/* return any leftover data */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (sret != -EBUSY)
 		return sret;
-	sret = 0;
 
 	trace_seq_reset(&iter->seq);
 
@@ -2524,6 +2548,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 			goto out;
 	}
 
+waitagain:
+	sret = 0;
 	while (trace_empty(iter)) {
 
 		if ((filp->f_flags & O_NONBLOCK)) {
@@ -2588,46 +2614,12 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	       offsetof(struct trace_iterator, seq));
 	iter->pos = -1;
 
-	/*
-	 * We need to stop all tracing on all CPUS to read the
-	 * the next buffer. This is a bit expensive, but is
-	 * not done often. We fill all what we can read,
-	 * and then release the locks again.
-	 */
-
-	cpus_clear(mask);
-	local_irq_save(flags);
-#ifdef CONFIG_FTRACE
-	ftrace_save = ftrace_enabled;
-	ftrace_enabled = 0;
-#endif
-	smp_wmb();
-	for_each_tracing_cpu(cpu) {
-		data = iter->tr->data[cpu];
-
-		if (!head_page(data) || !data->trace_idx)
-			continue;
-
-		atomic_inc(&data->disabled);
-		cpu_set(cpu, mask);
-	}
-
-	for_each_cpu_mask(cpu, mask) {
-		data = iter->tr->data[cpu];
-		__raw_spin_lock(&data->lock);
-
-		if (data->overrun > iter->last_overrun[cpu])
-			iter->overrun[cpu] +=
-				data->overrun - iter->last_overrun[cpu];
-		iter->last_overrun[cpu] = data->overrun;
-	}
-
 	while (find_next_entry_inc(iter) != NULL) {
-		int ret;
+		enum print_line_t ret;
 		int len = iter->seq.len;
 
 		ret = print_trace_line(iter);
-		if (!ret) {
+		if (ret == TRACE_TYPE_PARTIAL_LINE) {
 			/* don't print partial lines */
 			iter->seq.len = len;
 			break;
@@ -2639,26 +2631,17 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 			break;
 	}
 
-	for_each_cpu_mask(cpu, mask) {
-		data = iter->tr->data[cpu];
-		__raw_spin_unlock(&data->lock);
-	}
-
-	for_each_cpu_mask(cpu, mask) {
-		data = iter->tr->data[cpu];
-		atomic_dec(&data->disabled);
-	}
-#ifdef CONFIG_FTRACE
-	ftrace_enabled = ftrace_save;
-#endif
-	local_irq_restore(flags);
-
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
 		trace_seq_reset(&iter->seq);
+
+	/*
+	 * If there was nothing to send to user, inspite of consuming trace
+	 * entries, go back to wait for more entries.
+	 */
 	if (sret == -EBUSY)
-		sret = 0;
+		goto waitagain;
 
 out:
 	mutex_unlock(&trace_types_lock);
@@ -2684,7 +2667,8 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 {
 	unsigned long val;
 	char buf[64];
-	int i, ret;
+	int ret;
+	struct trace_array *tr = filp->private_data;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2704,59 +2688,38 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 
-	if (current_trace != &no_tracer) {
+	if (tr->ctrl) {
 		cnt = -EBUSY;
-		pr_info("ftrace: set current_tracer to none"
+		pr_info("ftrace: please disable tracing"
 			" before modifying buffer size\n");
 		goto out;
 	}
 
-	if (val > global_trace.entries) {
-		long pages_requested;
-		unsigned long freeable_pages;
-
-		/* make sure we have enough memory before mapping */
-		pages_requested =
-			(val + (ENTRIES_PER_PAGE-1)) / ENTRIES_PER_PAGE;
-
-		/* account for each buffer (and max_tr) */
-		pages_requested *= tracing_nr_buffers * 2;
-
-		/* Check for overflow */
-		if (pages_requested < 0) {
-			cnt = -ENOMEM;
-			goto out;
-		}
-
-		freeable_pages = determine_dirtyable_memory();
-
-		/* we only allow to request 1/4 of useable memory */
-		if (pages_requested >
-		    ((freeable_pages + tracing_pages_allocated) / 4)) {
-			cnt = -ENOMEM;
+	if (val != global_trace.entries) {
+		ret = ring_buffer_resize(global_trace.buffer, val);
+		if (ret < 0) {
+			cnt = ret;
 			goto out;
 		}
 
-		while (global_trace.entries < val) {
-			if (trace_alloc_page()) {
-				cnt = -ENOMEM;
-				goto out;
+		ret = ring_buffer_resize(max_tr.buffer, val);
+		if (ret < 0) {
+			int r;
+			cnt = ret;
+			r = ring_buffer_resize(global_trace.buffer,
+					       global_trace.entries);
+			if (r < 0) {
+				/* AARGH! We are left with different
+				 * size max buffer!!!! */
+				WARN_ON(1);
+				tracing_disabled = 1;
 			}
-			/* double check that we don't go over the known pages */
-			if (tracing_pages_allocated > pages_requested)
-				break;
+			goto out;
 		}
 
-	} else {
-		/* include the number of entries in val (inc of page entries) */
-		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
-			trace_free_page();
+		global_trace.entries = val;
 	}
 
-	/* check integrity */
-	for_each_tracing_cpu(i)
-		check_pages(global_trace.data[i]);
-
 	filp->f_pos += cnt;
 
 	/* If check pages failed, return ENOMEM */
@@ -2769,6 +2732,52 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int mark_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+	va_start(args, fmt);
+	ret = trace_vprintk(0, fmt, args);
+	va_end(args);
+	return ret;
+}
+
+static ssize_t
+tracing_mark_write(struct file *filp, const char __user *ubuf,
+					size_t cnt, loff_t *fpos)
+{
+	char *buf;
+	char *end;
+	struct trace_array *tr = &global_trace;
+
+	if (!tr->ctrl || tracing_disabled)
+		return -EINVAL;
+
+	if (cnt > TRACE_BUF_SIZE)
+		cnt = TRACE_BUF_SIZE;
+
+	buf = kmalloc(cnt + 1, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, cnt)) {
+		kfree(buf);
+		return -EFAULT;
+	}
+
+	/* Cut from the first nil or newline. */
+	buf[cnt] = '\0';
+	end = strchr(buf, '\n');
+	if (end)
+		*end = '\0';
+
+	cnt = mark_printk("%s\n", buf);
+	kfree(buf);
+	*fpos += cnt;
+
+	return cnt;
+}
+
 static struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -2800,6 +2809,11 @@ static struct file_operations tracing_entries_fops = {
 	.write		= tracing_entries_write,
 };
 
+static struct file_operations tracing_mark_fops = {
+	.open		= tracing_open_generic,
+	.write		= tracing_mark_write,
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 static ssize_t
@@ -2846,7 +2860,7 @@ struct dentry *tracing_init_dentry(void)
 #include "trace_selftest.c"
 #endif
 
-static __init void tracer_init_debugfs(void)
+static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
 	struct dentry *entry;
@@ -2881,12 +2895,12 @@ static __init void tracer_init_debugfs(void)
 	entry = debugfs_create_file("available_tracers", 0444, d_tracer,
 				    &global_trace, &show_traces_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+		pr_warning("Could not create debugfs 'available_tracers' entry\n");
 
 	entry = debugfs_create_file("current_tracer", 0444, d_tracer,
 				    &global_trace, &set_tracer_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+		pr_warning("Could not create debugfs 'current_tracer' entry\n");
 
 	entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
 				    &tracing_max_latency,
@@ -2899,7 +2913,7 @@ static __init void tracer_init_debugfs(void)
 				    &tracing_thresh, &tracing_max_lat_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
+			   "'tracing_thresh' entry\n");
 	entry = debugfs_create_file("README", 0644, d_tracer,
 				    NULL, &tracing_readme_fops);
 	if (!entry)
@@ -2909,13 +2923,19 @@ static __init void tracer_init_debugfs(void)
 				    NULL, &tracing_pipe_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
+			   "'trace_pipe' entry\n");
 
 	entry = debugfs_create_file("trace_entries", 0644, d_tracer,
 				    &global_trace, &tracing_entries_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
+			   "'trace_entries' entry\n");
+
+	entry = debugfs_create_file("trace_marker", 0220, d_tracer,
+				    NULL, &tracing_mark_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'trace_marker' entry\n");
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
@@ -2928,230 +2948,263 @@ static __init void tracer_init_debugfs(void)
 #ifdef CONFIG_SYSPROF_TRACER
 	init_tracer_sysprof_debugfs(d_tracer);
 #endif
+	return 0;
 }
 
-static int trace_alloc_page(void)
+int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
+	static DEFINE_SPINLOCK(trace_buf_lock);
+	static char trace_buf[TRACE_BUF_SIZE];
+
+	struct ring_buffer_event *event;
+	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	struct page *page, *tmp;
-	LIST_HEAD(pages);
-	void *array;
-	unsigned pages_allocated = 0;
-	int i;
+	struct print_entry *entry;
+	unsigned long flags, irq_flags;
+	int cpu, len = 0, size, pc;
 
-	/* first allocate a page for each CPU */
-	for_each_tracing_cpu(i) {
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_pages;
-		}
+	if (!tr->ctrl || tracing_disabled)
+		return 0;
 
-		pages_allocated++;
-		page = virt_to_page(array);
-		list_add(&page->lru, &pages);
+	pc = preempt_count();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
 
-/* Only allocate if we are actually using the max trace */
-#ifdef CONFIG_TRACER_MAX_TRACE
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_pages;
-		}
-		pages_allocated++;
-		page = virt_to_page(array);
-		list_add(&page->lru, &pages);
-#endif
-	}
+	if (unlikely(atomic_read(&data->disabled)))
+		goto out;
 
-	/* Now that we successfully allocate a page per CPU, add them */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i];
-		page = list_entry(pages.next, struct page, lru);
-		list_del_init(&page->lru);
-		list_add_tail(&page->lru, &data->trace_pages);
-		ClearPageLRU(page);
+	spin_lock_irqsave(&trace_buf_lock, flags);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		page = list_entry(pages.next, struct page, lru);
-		list_del_init(&page->lru);
-		list_add_tail(&page->lru, &data->trace_pages);
-		SetPageLRU(page);
-#endif
-	}
-	tracing_pages_allocated += pages_allocated;
-	global_trace.entries += ENTRIES_PER_PAGE;
+	len = min(len, TRACE_BUF_SIZE-1);
+	trace_buf[len] = 0;
 
-	return 0;
+	size = sizeof(*entry) + len + 1;
+	event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
+	if (!event)
+		goto out_unlock;
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_PRINT;
+	entry->ip			= ip;
 
- free_pages:
-	list_for_each_entry_safe(page, tmp, &pages, lru) {
-		list_del_init(&page->lru);
-		__free_page(page);
-	}
-	return -ENOMEM;
+	memcpy(&entry->buf, trace_buf, len);
+	entry->buf[len] = 0;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+ out_unlock:
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+ out:
+	preempt_enable_notrace();
+
+	return len;
 }
+EXPORT_SYMBOL_GPL(trace_vprintk);
 
-static int trace_free_page(void)
+int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 {
-	struct trace_array_cpu *data;
-	struct page *page;
-	struct list_head *p;
-	int i;
-	int ret = 0;
+	int ret;
+	va_list ap;
 
-	/* free one page from each buffer */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i];
-		p = data->trace_pages.next;
-		if (p == &data->trace_pages) {
-			/* should never happen */
-			WARN_ON(1);
-			tracing_disabled = 1;
-			ret = -1;
-			break;
-		}
-		page = list_entry(p, struct page, lru);
-		ClearPageLRU(page);
-		list_del(&page->lru);
-		tracing_pages_allocated--;
-		tracing_pages_allocated--;
-		__free_page(page);
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
 
-		tracing_reset(data);
+	va_start(ap, fmt);
+	ret = trace_vprintk(ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__ftrace_printk);
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		p = data->trace_pages.next;
-		if (p == &data->trace_pages) {
-			/* should never happen */
-			WARN_ON(1);
-			tracing_disabled = 1;
-			ret = -1;
-			break;
-		}
-		page = list_entry(p, struct page, lru);
-		ClearPageLRU(page);
-		list_del(&page->lru);
-		__free_page(page);
+static int trace_panic_handler(struct notifier_block *this,
+			       unsigned long event, void *unused)
+{
+	ftrace_dump();
+	return NOTIFY_OK;
+}
 
-		tracing_reset(data);
-#endif
-	}
-	global_trace.entries -= ENTRIES_PER_PAGE;
+static struct notifier_block trace_panic_notifier = {
+	.notifier_call  = trace_panic_handler,
+	.next           = NULL,
+	.priority       = 150   /* priority: INT_MAX >= x >= 0 */
+};
 
-	return ret;
+static int trace_die_handler(struct notifier_block *self,
+			     unsigned long val,
+			     void *data)
+{
+	switch (val) {
+	case DIE_OOPS:
+		ftrace_dump();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
 }
 
-__init static int tracer_alloc_buffers(void)
+static struct notifier_block trace_die_notifier = {
+	.notifier_call = trace_die_handler,
+	.priority = 200
+};
+
+/*
+ * printk is set to max of 1024, we really don't need it that big.
+ * Nothing should be printing 1000 characters anyway.
+ */
+#define TRACE_MAX_PRINT		1000
+
+/*
+ * Define here KERN_TRACE so that we have one place to modify
+ * it if we decide to change what log level the ftrace dump
+ * should be at.
+ */
+#define KERN_TRACE		KERN_INFO
+
+static void
+trace_printk_seq(struct trace_seq *s)
 {
-	struct trace_array_cpu *data;
-	void *array;
-	struct page *page;
-	int pages = 0;
-	int ret = -ENOMEM;
-	int i;
+	/* Probably should print a warning here. */
+	if (s->len >= 1000)
+		s->len = 1000;
 
-	/* TODO: make the number of buffers hot pluggable with CPUS */
-	tracing_nr_buffers = num_possible_cpus();
-	tracing_buffer_mask = cpu_possible_map;
+	/* should be zero ended, but we are paranoid. */
+	s->buffer[s->len] = 0;
 
-	/* Allocate the first page for all buffers */
-	for_each_tracing_cpu(i) {
-		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
-		max_tr.data[i] = &per_cpu(max_data, i);
+	printk(KERN_TRACE "%s", s->buffer);
 
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_buffers;
-		}
+	trace_seq_reset(s);
+}
+
+
+void ftrace_dump(void)
+{
+	static DEFINE_SPINLOCK(ftrace_dump_lock);
+	/* use static because iter can be a bit big for the stack */
+	static struct trace_iterator iter;
+	static cpumask_t mask;
+	static int dump_ran;
+	unsigned long flags;
+	int cnt = 0, cpu;
 
-		/* set the array to the list */
-		INIT_LIST_HEAD(&data->trace_pages);
-		page = virt_to_page(array);
-		list_add(&page->lru, &data->trace_pages);
-		/* use the LRU flag to differentiate the two buffers */
-		ClearPageLRU(page);
+	/* only one dump */
+	spin_lock_irqsave(&ftrace_dump_lock, flags);
+	if (dump_ran)
+		goto out;
 
-		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		max_tr.data[i]->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	dump_ran = 1;
 
-/* Only allocate if we are actually using the max trace */
-#ifdef CONFIG_TRACER_MAX_TRACE
-		array = (void *)__get_free_page(GFP_KERNEL);
-		if (array == NULL) {
-			printk(KERN_ERR "tracer: failed to allocate page"
-			       "for trace buffer!\n");
-			goto free_buffers;
-		}
+	/* No turning back! */
+	ftrace_kill_atomic();
 
-		INIT_LIST_HEAD(&max_tr.data[i]->trace_pages);
-		page = virt_to_page(array);
-		list_add(&page->lru, &max_tr.data[i]->trace_pages);
-		SetPageLRU(page);
-#endif
+	for_each_tracing_cpu(cpu) {
+		atomic_inc(&global_trace.data[cpu]->disabled);
 	}
 
+	printk(KERN_TRACE "Dumping ftrace buffer:\n");
+
+	iter.tr = &global_trace;
+	iter.trace = current_trace;
+
 	/*
-	 * Since we allocate by orders of pages, we may be able to
-	 * round up a bit.
+	 * We need to stop all tracing on all CPUS to read the
+	 * the next buffer. This is a bit expensive, but is
+	 * not done often. We fill all what we can read,
+	 * and then release the locks again.
 	 */
-	global_trace.entries = ENTRIES_PER_PAGE;
-	pages++;
 
-	while (global_trace.entries < trace_nr_entries) {
-		if (trace_alloc_page())
-			break;
-		pages++;
+	cpus_clear(mask);
+
+	while (!trace_empty(&iter)) {
+
+		if (!cnt)
+			printk(KERN_TRACE "---------------------------------\n");
+
+		cnt++;
+
+		/* reset all but tr, trace, and overruns */
+		memset(&iter.seq, 0,
+		       sizeof(struct trace_iterator) -
+		       offsetof(struct trace_iterator, seq));
+		iter.iter_flags |= TRACE_FILE_LAT_FMT;
+		iter.pos = -1;
+
+		if (find_next_entry_inc(&iter) != NULL) {
+			print_trace_line(&iter);
+			trace_consume(&iter);
+		}
+
+		trace_printk_seq(&iter.seq);
 	}
-	max_tr.entries = global_trace.entries;
 
-	pr_info("tracer: %d pages allocated for %ld entries of %ld bytes\n",
-		pages, trace_nr_entries, (long)TRACE_ENTRY_SIZE);
-	pr_info("   actual entries %ld\n", global_trace.entries);
+	if (!cnt)
+		printk(KERN_TRACE "   (ftrace buffer empty)\n");
+	else
+		printk(KERN_TRACE "---------------------------------\n");
+
+ out:
+	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
+}
+
+__init static int tracer_alloc_buffers(void)
+{
+	struct trace_array_cpu *data;
+	int i;
+
+	/* TODO: make the number of buffers hot pluggable with CPUS */
+	tracing_buffer_mask = cpu_possible_map;
+
+	global_trace.buffer = ring_buffer_alloc(trace_buf_size,
+						   TRACE_BUFFER_FLAGS);
+	if (!global_trace.buffer) {
+		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
+		WARN_ON(1);
+		return 0;
+	}
+	global_trace.entries = ring_buffer_size(global_trace.buffer);
 
-	tracer_init_debugfs();
+#ifdef CONFIG_TRACER_MAX_TRACE
+	max_tr.buffer = ring_buffer_alloc(trace_buf_size,
+					     TRACE_BUFFER_FLAGS);
+	if (!max_tr.buffer) {
+		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
+		WARN_ON(1);
+		ring_buffer_free(global_trace.buffer);
+		return 0;
+	}
+	max_tr.entries = ring_buffer_size(max_tr.buffer);
+	WARN_ON(max_tr.entries != global_trace.entries);
+#endif
+
+	/* Allocate the first page for all buffers */
+	for_each_tracing_cpu(i) {
+		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
+		max_tr.data[i] = &per_cpu(max_data, i);
+	}
 
 	trace_init_cmdlines();
 
-	register_tracer(&no_tracer);
-	current_trace = &no_tracer;
+	register_tracer(&nop_trace);
+#ifdef CONFIG_BOOT_TRACER
+	register_tracer(&boot_tracer);
+	current_trace = &boot_tracer;
+	current_trace->init(&global_trace);
+#else
+	current_trace = &nop_trace;
+#endif
 
 	/* All seems OK, enable tracing */
 	global_trace.ctrl = tracer_enabled;
 	tracing_disabled = 0;
 
-	return 0;
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &trace_panic_notifier);
 
- free_buffers:
-	for (i-- ; i >= 0; i--) {
-		struct page *page, *tmp;
-		struct trace_array_cpu *data = global_trace.data[i];
+	register_die_notifier(&trace_die_notifier);
 
-		if (data) {
-			list_for_each_entry_safe(page, tmp,
-						 &data->trace_pages, lru) {
-				list_del_init(&page->lru);
-				__free_page(page);
-			}
-		}
-
-#ifdef CONFIG_TRACER_MAX_TRACE
-		data = max_tr.data[i];
-		if (data) {
-			list_for_each_entry_safe(page, tmp,
-						 &data->trace_pages, lru) {
-				list_del_init(&page->lru);
-				__free_page(page);
-			}
-		}
-#endif
-	}
-	return ret;
+	return 0;
 }
-fs_initcall(tracer_alloc_buffers);
+early_initcall(tracer_alloc_buffers);
+fs_initcall(tracer_init_debugfs);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f69f867..f1f9957 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -5,7 +5,9 @@
 #include <asm/atomic.h>
 #include <linux/sched.h>
 #include <linux/clocksource.h>
+#include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
+#include <linux/ftrace.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -13,38 +15,60 @@ enum trace_type {
 	TRACE_FN,
 	TRACE_CTX,
 	TRACE_WAKE,
+	TRACE_CONT,
 	TRACE_STACK,
+	TRACE_PRINT,
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
+	TRACE_BOOT,
 
 	__TRACE_LAST_TYPE
 };
 
 /*
+ * The trace entry - the most basic unit of tracing. This is what
+ * is printed in the end as a single line in the trace output, such as:
+ *
+ *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
+ */
+struct trace_entry {
+	unsigned char		type;
+	unsigned char		cpu;
+	unsigned char		flags;
+	unsigned char		preempt_count;
+	int			pid;
+};
+
+/*
  * Function trace entry - function address and parent function addres:
  */
 struct ftrace_entry {
+	struct trace_entry	ent;
 	unsigned long		ip;
 	unsigned long		parent_ip;
 };
+extern struct tracer boot_tracer;
 
 /*
  * Context switch trace entry - which task (and prio) we switched from/to:
  */
 struct ctx_switch_entry {
+	struct trace_entry	ent;
 	unsigned int		prev_pid;
 	unsigned char		prev_prio;
 	unsigned char		prev_state;
 	unsigned int		next_pid;
 	unsigned char		next_prio;
 	unsigned char		next_state;
+	unsigned int		next_cpu;
 };
 
 /*
  * Special (free-form) trace entry:
  */
 struct special_entry {
+	struct trace_entry	ent;
 	unsigned long		arg1;
 	unsigned long		arg2;
 	unsigned long		arg3;
@@ -57,33 +81,60 @@ struct special_entry {
 #define FTRACE_STACK_ENTRIES	8
 
 struct stack_entry {
+	struct trace_entry	ent;
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
 /*
- * The trace entry - the most basic unit of tracing. This is what
- * is printed in the end as a single line in the trace output, such as:
- *
- *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
+ * ftrace_printk entry:
  */
-struct trace_entry {
-	char			type;
-	char			cpu;
-	char			flags;
-	char			preempt_count;
-	int			pid;
-	cycle_t			t;
-	union {
-		struct ftrace_entry		fn;
-		struct ctx_switch_entry		ctx;
-		struct special_entry		special;
-		struct stack_entry		stack;
-		struct mmiotrace_rw		mmiorw;
-		struct mmiotrace_map		mmiomap;
-	};
+struct print_entry {
+	struct trace_entry	ent;
+	unsigned long		ip;
+	char			buf[];
+};
+
+#define TRACE_OLD_SIZE		88
+
+struct trace_field_cont {
+	unsigned char		type;
+	/* Temporary till we get rid of this completely */
+	char			buf[TRACE_OLD_SIZE - 1];
+};
+
+struct trace_mmiotrace_rw {
+	struct trace_entry	ent;
+	struct mmiotrace_rw	rw;
 };
 
-#define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
+struct trace_mmiotrace_map {
+	struct trace_entry	ent;
+	struct mmiotrace_map	map;
+};
+
+struct trace_boot {
+	struct trace_entry	ent;
+	struct boot_trace	initcall;
+};
+
+/*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF	- interrupts were disabled
+ *  NEED_RESCED - reschedule is requested
+ *  HARDIRQ	- inside an interrupt handler
+ *  SOFTIRQ	- inside a softirq handler
+ *  CONT	- multiple entries hold the trace item
+ */
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_NEED_RESCHED		= 0x02,
+	TRACE_FLAG_HARDIRQ		= 0x04,
+	TRACE_FLAG_SOFTIRQ		= 0x08,
+	TRACE_FLAG_CONT			= 0x10,
+};
+
+#define TRACE_BUF_SIZE		1024
 
 /*
  * The CPU trace array - it consists of thousands of trace entries
@@ -91,16 +142,9 @@ struct trace_entry {
  * the trace, etc.)
  */
 struct trace_array_cpu {
-	struct list_head	trace_pages;
 	atomic_t		disabled;
-	raw_spinlock_t		lock;
-	struct lock_class_key	lock_key;
 
 	/* these fields get copied into max-trace: */
-	unsigned		trace_head_idx;
-	unsigned		trace_tail_idx;
-	void			*trace_head; /* producer */
-	void			*trace_tail; /* consumer */
 	unsigned long		trace_idx;
 	unsigned long		overrun;
 	unsigned long		saved_latency;
@@ -124,6 +168,7 @@ struct trace_iterator;
  * They have on/off state as well:
  */
 struct trace_array {
+	struct ring_buffer	*buffer;
 	unsigned long		entries;
 	long			ctrl;
 	int			cpu;
@@ -132,6 +177,56 @@ struct trace_array {
 	struct trace_array_cpu	*data[NR_CPUS];
 };
 
+#define FTRACE_CMP_TYPE(var, type) \
+	__builtin_types_compatible_p(typeof(var), type *)
+
+#undef IF_ASSIGN
+#define IF_ASSIGN(var, entry, etype, id)		\
+	if (FTRACE_CMP_TYPE(var, etype)) {		\
+		var = (typeof(var))(entry);		\
+		WARN_ON(id && (entry)->type != id);	\
+		break;					\
+	}
+
+/* Will cause compile errors if type is not found. */
+extern void __ftrace_bad_type(void);
+
+/*
+ * The trace_assign_type is a verifier that the entry type is
+ * the same as the type being assigned. To add new types simply
+ * add a line with the following format:
+ *
+ * IF_ASSIGN(var, ent, type, id);
+ *
+ *  Where "type" is the trace type that includes the trace_entry
+ *  as the "ent" item. And "id" is the trace identifier that is
+ *  used in the trace_type enum.
+ *
+ *  If the type can have more than one id, then use zero.
+ */
+#define trace_assign_type(var, ent)					\
+	do {								\
+		IF_ASSIGN(var, ent, struct ftrace_entry, TRACE_FN);	\
+		IF_ASSIGN(var, ent, struct ctx_switch_entry, 0);	\
+		IF_ASSIGN(var, ent, struct trace_field_cont, TRACE_CONT); \
+		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
+		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
+		IF_ASSIGN(var, ent, struct special_entry, 0);		\
+		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
+			  TRACE_MMIO_RW);				\
+		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
+			  TRACE_MMIO_MAP);				\
+		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		__ftrace_bad_type();					\
+	} while (0)
+
+/* Return values for print_line callback */
+enum print_line_t {
+	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
+	TRACE_TYPE_HANDLED	= 1,
+	TRACE_TYPE_UNHANDLED	= 2	/* Relay to other output functions */
+};
+
 /*
  * A specific tracer, represented by methods that operate on a trace array:
  */
@@ -152,7 +247,7 @@ struct tracer {
 	int			(*selftest)(struct tracer *trace,
 					    struct trace_array *tr);
 #endif
-	int			(*print_line)(struct trace_iterator *iter);
+	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	struct tracer		*next;
 	int			print_max;
 };
@@ -171,57 +266,58 @@ struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
 	void			*private;
-	long			last_overrun[NR_CPUS];
-	long			overrun[NR_CPUS];
+	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
 	int			cpu;
-
-	struct trace_entry	*prev_ent;
-	int			prev_cpu;
+	u64			ts;
 
 	unsigned long		iter_flags;
 	loff_t			pos;
-	unsigned long		next_idx[NR_CPUS];
-	struct list_head	*next_page[NR_CPUS];
-	unsigned		next_page_idx[NR_CPUS];
 	long			idx;
 };
 
-void tracing_reset(struct trace_array_cpu *data);
+void trace_wake_up(void);
+void tracing_reset(struct trace_array *tr, int cpu);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
+struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
+						struct trace_array_cpu *data);
+void tracing_generic_entry_update(struct trace_entry *entry,
+				  unsigned long flags,
+				  int pc);
+
 void ftrace(struct trace_array *tr,
 			    struct trace_array_cpu *data,
 			    unsigned long ip,
 			    unsigned long parent_ip,
-			    unsigned long flags);
+			    unsigned long flags, int pc);
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct task_struct *prev,
 				struct task_struct *next,
-				unsigned long flags);
+				unsigned long flags, int pc);
 void tracing_record_cmdline(struct task_struct *tsk);
 
 void tracing_sched_wakeup_trace(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct task_struct *wakee,
 				struct task_struct *cur,
-				unsigned long flags);
+				unsigned long flags, int pc);
 void trace_special(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long arg1,
 		   unsigned long arg2,
-		   unsigned long arg3);
+		   unsigned long arg3, int pc);
 void trace_function(struct trace_array *tr,
 		    struct trace_array_cpu *data,
 		    unsigned long ip,
 		    unsigned long parent_ip,
-		    unsigned long flags);
+		    unsigned long flags, int pc);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
@@ -268,51 +364,33 @@ extern unsigned long ftrace_update_tot_cnt;
 extern int DYN_FTRACE_TEST_NAME(void);
 #endif
 
-#ifdef CONFIG_MMIOTRACE
-extern void __trace_mmiotrace_rw(struct trace_array *tr,
-				struct trace_array_cpu *data,
-				struct mmiotrace_rw *rw);
-extern void __trace_mmiotrace_map(struct trace_array *tr,
-				struct trace_array_cpu *data,
-				struct mmiotrace_map *map);
-#endif
-
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-#ifdef CONFIG_FTRACE
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
-#endif
-#ifdef CONFIG_IRQSOFF_TRACER
 extern int trace_selftest_startup_irqsoff(struct tracer *trace,
 					  struct trace_array *tr);
-#endif
-#ifdef CONFIG_PREEMPT_TRACER
 extern int trace_selftest_startup_preemptoff(struct tracer *trace,
 					     struct trace_array *tr);
-#endif
-#if defined(CONFIG_IRQSOFF_TRACER) && defined(CONFIG_PREEMPT_TRACER)
 extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
 						 struct trace_array *tr);
-#endif
-#ifdef CONFIG_SCHED_TRACER
 extern int trace_selftest_startup_wakeup(struct tracer *trace,
 					 struct trace_array *tr);
-#endif
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
+extern int trace_selftest_startup_nop(struct tracer *trace,
+					 struct trace_array *tr);
 extern int trace_selftest_startup_sched_switch(struct tracer *trace,
 					       struct trace_array *tr);
-#endif
-#ifdef CONFIG_SYSPROF_TRACER
 extern int trace_selftest_startup_sysprof(struct tracer *trace,
 					       struct trace_array *tr);
-#endif
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern void trace_seq_print_cont(struct trace_seq *s,
+				 struct trace_iterator *iter);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
+extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
 
@@ -334,6 +412,9 @@ enum trace_iterator_flags {
 	TRACE_ITER_BLOCK		= 0x80,
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
+	TRACE_ITER_PRINTK		= 0x400,
 };
 
+extern struct tracer nop_trace;
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
new file mode 100644
index 0000000..d0a5e50
--- /dev/null
+++ b/kernel/trace/trace_boot.c
@@ -0,0 +1,126 @@
+/*
+ * ring buffer based initcalls tracer
+ *
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <linux/kallsyms.h>
+
+#include "trace.h"
+
+static struct trace_array *boot_trace;
+static int trace_boot_enabled;
+
+
+/* Should be started after do_pre_smp_initcalls() in init/main.c */
+void start_boot_trace(void)
+{
+	trace_boot_enabled = 1;
+}
+
+void stop_boot_trace(void)
+{
+	trace_boot_enabled = 0;
+}
+
+void reset_boot_trace(struct trace_array *tr)
+{
+	stop_boot_trace();
+}
+
+static void boot_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	boot_trace = tr;
+
+	trace_boot_enabled = 0;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+}
+
+static void boot_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_boot_trace();
+	else
+		stop_boot_trace();
+}
+
+static enum print_line_t initcall_print_line(struct trace_iterator *iter)
+{
+	int ret;
+	struct trace_entry *entry = iter->ent;
+	struct trace_boot *field = (struct trace_boot *)entry;
+	struct boot_trace *it = &field->initcall;
+	struct trace_seq *s = &iter->seq;
+	struct timespec calltime = ktime_to_timespec(it->calltime);
+	struct timespec rettime = ktime_to_timespec(it->rettime);
+
+	if (entry->type == TRACE_BOOT) {
+		ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
+					  calltime.tv_sec,
+					  calltime.tv_nsec,
+					  it->func, it->caller);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
+					  "returned %d after %lld msecs\n",
+					  rettime.tv_sec,
+					  rettime.tv_nsec,
+					  it->func, it->result, it->duration);
+
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+struct tracer boot_tracer __read_mostly =
+{
+	.name		= "initcall",
+	.init		= boot_trace_init,
+	.reset		= reset_boot_trace,
+	.ctrl_update	= boot_trace_ctrl_update,
+	.print_line	= initcall_print_line,
+};
+
+void trace_boot(struct boot_trace *it, initcall_t fn)
+{
+	struct ring_buffer_event *event;
+	struct trace_boot *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = boot_trace;
+
+	if (!trace_boot_enabled)
+		return;
+
+	/* Get its name now since this function could
+	 * disappear because it is in the .init section.
+	 */
+	sprint_symbol(it->func, (unsigned long)fn);
+	preempt_disable();
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_BOOT;
+	entry->initcall = *it;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+
+ out:
+	preempt_enable();
+}
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 3121448..e90eb0c 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -23,7 +23,7 @@ static void function_reset(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void start_function_trace(struct trace_array *tr)
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index ece6cfb..a7db7f0 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -95,7 +95,7 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags);
+		trace_function(tr, data, ip, parent_ip, flags, preempt_count());
 
 	atomic_dec(&data->disabled);
 }
@@ -130,6 +130,7 @@ check_critical_timing(struct trace_array *tr,
 	unsigned long latency, t0, t1;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
+	int pc;
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -141,6 +142,8 @@ check_critical_timing(struct trace_array *tr,
 
 	local_save_flags(flags);
 
+	pc = preempt_count();
+
 	if (!report_latency(delta))
 		goto out;
 
@@ -150,7 +153,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags);
+	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags, pc);
 
 	latency = nsecs_to_usecs(delta);
 
@@ -173,8 +176,8 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	tracing_reset(data);
-	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags);
+	tracing_reset(tr, cpu);
+	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
 static inline void
@@ -203,11 +206,11 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	data->critical_start = parent_ip ? : ip;
-	tracing_reset(data);
+	tracing_reset(tr, cpu);
 
 	local_save_flags(flags);
 
-	trace_function(tr, data, ip, parent_ip, flags);
+	trace_function(tr, data, ip, parent_ip, flags, preempt_count());
 
 	per_cpu(tracing_cpu, cpu) = 1;
 
@@ -234,14 +237,14 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 
 	data = tr->data[cpu];
 
-	if (unlikely(!data) || unlikely(!head_page(data)) ||
+	if (unlikely(!data) ||
 	    !data->critical_start || atomic_read(&data->disabled))
 		return;
 
 	atomic_inc(&data->disabled);
 
 	local_save_flags(flags);
-	trace_function(tr, data, ip, parent_ip, flags);
+	trace_function(tr, data, ip, parent_ip, flags, preempt_count());
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index b13dc19..f284846 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -27,7 +27,7 @@ static void mmio_reset_data(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void mmio_trace_init(struct trace_array *tr)
@@ -130,10 +130,14 @@ static unsigned long count_overruns(struct trace_iterator *iter)
 {
 	int cpu;
 	unsigned long cnt = 0;
+/* FIXME: */
+#if 0
 	for_each_online_cpu(cpu) {
 		cnt += iter->overrun[cpu];
 		iter->overrun[cpu] = 0;
 	}
+#endif
+	(void)cpu;
 	return cnt;
 }
 
@@ -171,17 +175,21 @@ print_out:
 	return (ret == -EBUSY) ? 0 : ret;
 }
 
-static int mmio_print_rw(struct trace_iterator *iter)
+static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_rw *rw	= &entry->mmiorw;
+	struct trace_mmiotrace_rw *field;
+	struct mmiotrace_rw *rw;
 	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->mmiorw.opcode) {
+	trace_assign_type(field, entry);
+	rw = &field->rw;
+
+	switch (rw->opcode) {
 	case MMIO_READ:
 		ret = trace_seq_printf(s,
 			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
@@ -209,21 +217,25 @@ static int mmio_print_rw(struct trace_iterator *iter)
 		break;
 	}
 	if (ret)
-		return 1;
-	return 0;
+		return TRACE_TYPE_HANDLED;
+	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int mmio_print_map(struct trace_iterator *iter)
+static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_map *m	= &entry->mmiomap;
+	struct trace_mmiotrace_map *field;
+	struct mmiotrace_map *m;
 	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
-	int ret = 1;
+	int ret;
 
-	switch (entry->mmiorw.opcode) {
+	trace_assign_type(field, entry);
+	m = &field->map;
+
+	switch (m->opcode) {
 	case MMIO_PROBE:
 		ret = trace_seq_printf(s,
 			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
@@ -241,20 +253,43 @@ static int mmio_print_map(struct trace_iterator *iter)
 		break;
 	}
 	if (ret)
-		return 1;
-	return 0;
+		return TRACE_TYPE_HANDLED;
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct print_entry *print = (struct print_entry *)entry;
+	const char *msg		= print->buf;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(iter->ts);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret;
+
+	/* The trailing newline must be in the message. */
+	ret = trace_seq_printf(s, "MARK %lu.%06lu %s", secs, usec_rem, msg);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (entry->flags & TRACE_FLAG_CONT)
+		trace_seq_print_cont(s, iter);
+
+	return TRACE_TYPE_HANDLED;
 }
 
-/* return 0 to abort printing without consuming current entry in pipe mode */
-static int mmio_print_line(struct trace_iterator *iter)
+static enum print_line_t mmio_print_line(struct trace_iterator *iter)
 {
 	switch (iter->ent->type) {
 	case TRACE_MMIO_RW:
 		return mmio_print_rw(iter);
 	case TRACE_MMIO_MAP:
 		return mmio_print_map(iter);
+	case TRACE_PRINT:
+		return mmio_print_mark(iter);
 	default:
-		return 1; /* ignore unknown entries */
+		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
 	}
 }
 
@@ -276,6 +311,27 @@ __init static int init_mmio_trace(void)
 }
 device_initcall(init_mmio_trace);
 
+static void __trace_mmiotrace_rw(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_rw *rw)
+{
+	struct ring_buffer_event *event;
+	struct trace_mmiotrace_rw *entry;
+	unsigned long irq_flags;
+
+	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
+	entry->ent.type			= TRACE_MMIO_RW;
+	entry->rw			= *rw;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
 void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
@@ -283,6 +339,27 @@ void mmio_trace_rw(struct mmiotrace_rw *rw)
 	__trace_mmiotrace_rw(tr, data, rw);
 }
 
+static void __trace_mmiotrace_map(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_map *map)
+{
+	struct ring_buffer_event *event;
+	struct trace_mmiotrace_map *entry;
+	unsigned long irq_flags;
+
+	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
+	entry->ent.type			= TRACE_MMIO_MAP;
+	entry->map			= *map;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
 void mmio_trace_mapping(struct mmiotrace_map *map)
 {
 	struct trace_array *tr = mmio_trace_array;
@@ -293,3 +370,8 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
 	__trace_mmiotrace_map(tr, data, map);
 	preempt_enable();
 }
+
+int mmio_trace_printk(const char *fmt, va_list args)
+{
+	return trace_vprintk(0, fmt, args);
+}
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
new file mode 100644
index 0000000..4592b48
--- /dev/null
+++ b/kernel/trace/trace_nop.c
@@ -0,0 +1,64 @@
+/*
+ * nop tracer
+ *
+ * Copyright (C) 2008 Steven Noonan <steven@uplinklabs.net>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+
+#include "trace.h"
+
+static struct trace_array	*ctx_trace;
+
+static void start_nop_trace(struct trace_array *tr)
+{
+	/* Nothing to do! */
+}
+
+static void stop_nop_trace(struct trace_array *tr)
+{
+	/* Nothing to do! */
+}
+
+static void nop_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	ctx_trace = tr;
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+
+	if (tr->ctrl)
+		start_nop_trace(tr);
+}
+
+static void nop_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_nop_trace(tr);
+}
+
+static void nop_trace_ctrl_update(struct trace_array *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_nop_trace(tr);
+	else
+		stop_nop_trace(tr);
+}
+
+struct tracer nop_trace __read_mostly =
+{
+	.name		= "nop",
+	.init		= nop_trace_init,
+	.reset		= nop_trace_reset,
+	.ctrl_update	= nop_trace_ctrl_update,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_nop,
+#endif
+};
+
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index cb817a2..b8f56be 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -9,8 +9,8 @@
 #include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
-#include <linux/marker.h>
 #include <linux/ftrace.h>
+#include <trace/sched.h>
 
 #include "trace.h"
 
@@ -19,15 +19,16 @@ static int __read_mostly	tracer_enabled;
 static atomic_t			sched_ref;
 
 static void
-sched_switch_func(void *private, void *__rq, struct task_struct *prev,
+probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 			struct task_struct *next)
 {
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
 	int cpu;
+	int pc;
+
+	if (!atomic_read(&sched_ref))
+		return;
 
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
@@ -35,97 +36,41 @@ sched_switch_func(void *private, void *__rq, struct task_struct *prev,
 	if (!tracer_enabled)
 		return;
 
+	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
+	data = ctx_trace->data[cpu];
 
-	if (likely(disabled == 1))
-		tracing_sched_switch_trace(tr, data, prev, next, flags);
+	if (likely(!atomic_read(&data->disabled)))
+		tracing_sched_switch_trace(ctx_trace, data, prev, next, flags, pc);
 
-	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
-static notrace void
-sched_switch_callback(void *probe_data, void *call_data,
-		      const char *format, va_list *args)
-{
-	struct task_struct *prev;
-	struct task_struct *next;
-	struct rq *__rq;
-
-	if (!atomic_read(&sched_ref))
-		return;
-
-	/* skip prev_pid %d next_pid %d prev_state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	__rq = va_arg(*args, typeof(__rq));
-	prev = va_arg(*args, typeof(prev));
-	next = va_arg(*args, typeof(next));
-
-	/*
-	 * If tracer_switch_func only points to the local
-	 * switch func, it still needs the ptr passed to it.
-	 */
-	sched_switch_func(probe_data, __rq, prev, next);
-}
-
 static void
-wakeup_func(void *private, void *__rq, struct task_struct *wakee, struct
-			task_struct *curr)
+probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee)
 {
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
-	int cpu;
+	int cpu, pc;
 
-	if (!tracer_enabled)
+	if (!likely(tracer_enabled))
 		return;
 
-	tracing_record_cmdline(curr);
+	pc = preempt_count();
+	tracing_record_cmdline(current);
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
+	data = ctx_trace->data[cpu];
 
-	if (likely(disabled == 1))
-		tracing_sched_wakeup_trace(tr, data, wakee, curr, flags);
+	if (likely(!atomic_read(&data->disabled)))
+		tracing_sched_wakeup_trace(ctx_trace, data, wakee, current,
+					   flags, pc);
 
-	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
-static notrace void
-wake_up_callback(void *probe_data, void *call_data,
-		 const char *format, va_list *args)
-{
-	struct task_struct *curr;
-	struct task_struct *task;
-	struct rq *__rq;
-
-	if (likely(!tracer_enabled))
-		return;
-
-	/* Skip pid %d state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	/* now get the meat: "rq %p task %p rq->curr %p" */
-	__rq = va_arg(*args, typeof(__rq));
-	task = va_arg(*args, typeof(task));
-	curr = va_arg(*args, typeof(curr));
-
-	tracing_record_cmdline(task);
-	tracing_record_cmdline(curr);
-
-	wakeup_func(probe_data, __rq, task, curr);
-}
-
 static void sched_switch_reset(struct trace_array *tr)
 {
 	int cpu;
@@ -133,67 +78,47 @@ static void sched_switch_reset(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static int tracing_sched_register(void)
 {
 	int ret;
 
-	ret = marker_probe_register("kernel_sched_wakeup",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&ctx_trace);
+	ret = register_trace_sched_wakeup(probe_sched_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return ret;
 	}
 
-	ret = marker_probe_register("kernel_sched_wakeup_new",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&ctx_trace);
+	ret = register_trace_sched_wakeup_new(probe_sched_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = marker_probe_register("kernel_sched_schedule",
-		"prev_pid %d next_pid %d prev_state %ld "
-		"## rq %p prev %p next %p",
-		sched_switch_callback,
-		&ctx_trace);
+	ret = register_trace_sched_switch(probe_sched_switch);
 	if (ret) {
-		pr_info("sched trace: Couldn't add marker"
+		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_schedule\n");
 		goto fail_deprobe_wake_new;
 	}
 
 	return ret;
 fail_deprobe_wake_new:
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&ctx_trace);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
 fail_deprobe:
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&ctx_trace);
+	unregister_trace_sched_wakeup(probe_sched_wakeup);
 	return ret;
 }
 
 static void tracing_sched_unregister(void)
 {
-	marker_probe_unregister("kernel_sched_schedule",
-				sched_switch_callback,
-				&ctx_trace);
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&ctx_trace);
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&ctx_trace);
+	unregister_trace_sched_switch(probe_sched_switch);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
+	unregister_trace_sched_wakeup(probe_sched_wakeup);
 }
 
 static void tracing_start_sched_switch(void)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e303ccb..fe4a252 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -15,7 +15,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
-#include <linux/marker.h>
+#include <trace/sched.h>
 
 #include "trace.h"
 
@@ -44,10 +44,12 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	long disabled;
 	int resched;
 	int cpu;
+	int pc;
 
 	if (likely(!wakeup_task))
 		return;
 
+	pc = preempt_count();
 	resched = need_resched();
 	preempt_disable_notrace();
 
@@ -70,7 +72,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	if (task_cpu(wakeup_task) != cpu)
 		goto unlock;
 
-	trace_function(tr, data, ip, parent_ip, flags);
+	trace_function(tr, data, ip, parent_ip, flags, pc);
 
  unlock:
 	__raw_spin_unlock(&wakeup_lock);
@@ -112,17 +114,18 @@ static int report_latency(cycle_t delta)
 }
 
 static void notrace
-wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
+probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	struct task_struct *next)
 {
 	unsigned long latency = 0, t0 = 0, t1 = 0;
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
 	long disabled;
 	int cpu;
+	int pc;
+
+	tracing_record_cmdline(prev);
 
 	if (unlikely(!tracer_enabled))
 		return;
@@ -139,12 +142,14 @@ wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
 	if (next != wakeup_task)
 		return;
 
+	pc = preempt_count();
+
 	/* The task we are waiting for is waking up */
-	data = tr->data[wakeup_cpu];
+	data = wakeup_trace->data[wakeup_cpu];
 
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
-	disabled = atomic_inc_return(&tr->data[cpu]->disabled);
+	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
 	if (likely(disabled != 1))
 		goto out;
 
@@ -155,7 +160,7 @@ wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
-	trace_function(tr, data, CALLER_ADDR1, CALLER_ADDR2, flags);
+	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -174,39 +179,14 @@ wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
 	t0 = nsecs_to_usecs(T0);
 	t1 = nsecs_to_usecs(T1);
 
-	update_max_tr(tr, wakeup_task, wakeup_cpu);
+	update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
 
 out_unlock:
-	__wakeup_reset(tr);
+	__wakeup_reset(wakeup_trace);
 	__raw_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 out:
-	atomic_dec(&tr->data[cpu]->disabled);
-}
-
-static notrace void
-sched_switch_callback(void *probe_data, void *call_data,
-		      const char *format, va_list *args)
-{
-	struct task_struct *prev;
-	struct task_struct *next;
-	struct rq *__rq;
-
-	/* skip prev_pid %d next_pid %d prev_state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	__rq = va_arg(*args, typeof(__rq));
-	prev = va_arg(*args, typeof(prev));
-	next = va_arg(*args, typeof(next));
-
-	tracing_record_cmdline(prev);
-
-	/*
-	 * If tracer_switch_func only points to the local
-	 * switch func, it still needs the ptr passed to it.
-	 */
-	wakeup_sched_switch(probe_data, __rq, prev, next);
+	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
 
 static void __wakeup_reset(struct trace_array *tr)
@@ -216,7 +196,7 @@ static void __wakeup_reset(struct trace_array *tr)
 
 	for_each_possible_cpu(cpu) {
 		data = tr->data[cpu];
-		tracing_reset(data);
+		tracing_reset(tr, cpu);
 	}
 
 	wakeup_cpu = -1;
@@ -240,19 +220,26 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-wakeup_check_start(struct trace_array *tr, struct task_struct *p,
-		   struct task_struct *curr)
+probe_wakeup(struct rq *rq, struct task_struct *p)
 {
 	int cpu = smp_processor_id();
 	unsigned long flags;
 	long disabled;
+	int pc;
+
+	if (likely(!tracer_enabled))
+		return;
+
+	tracing_record_cmdline(p);
+	tracing_record_cmdline(current);
 
 	if (likely(!rt_task(p)) ||
 			p->prio >= wakeup_prio ||
-			p->prio >= curr->prio)
+			p->prio >= current->prio)
 		return;
 
-	disabled = atomic_inc_return(&tr->data[cpu]->disabled);
+	pc = preempt_count();
+	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
@@ -264,7 +251,7 @@ wakeup_check_start(struct trace_array *tr, struct task_struct *p,
 		goto out_locked;
 
 	/* reset the trace */
-	__wakeup_reset(tr);
+	__wakeup_reset(wakeup_trace);
 
 	wakeup_cpu = task_cpu(p);
 	wakeup_prio = p->prio;
@@ -274,74 +261,37 @@ wakeup_check_start(struct trace_array *tr, struct task_struct *p,
 
 	local_save_flags(flags);
 
-	tr->data[wakeup_cpu]->preempt_timestamp = ftrace_now(cpu);
-	trace_function(tr, tr->data[wakeup_cpu],
-		       CALLER_ADDR1, CALLER_ADDR2, flags);
+	wakeup_trace->data[wakeup_cpu]->preempt_timestamp = ftrace_now(cpu);
+	trace_function(wakeup_trace, wakeup_trace->data[wakeup_cpu],
+		       CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
 	__raw_spin_unlock(&wakeup_lock);
 out:
-	atomic_dec(&tr->data[cpu]->disabled);
-}
-
-static notrace void
-wake_up_callback(void *probe_data, void *call_data,
-		 const char *format, va_list *args)
-{
-	struct trace_array **ptr = probe_data;
-	struct trace_array *tr = *ptr;
-	struct task_struct *curr;
-	struct task_struct *task;
-	struct rq *__rq;
-
-	if (likely(!tracer_enabled))
-		return;
-
-	/* Skip pid %d state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	/* now get the meat: "rq %p task %p rq->curr %p" */
-	__rq = va_arg(*args, typeof(__rq));
-	task = va_arg(*args, typeof(task));
-	curr = va_arg(*args, typeof(curr));
-
-	tracing_record_cmdline(task);
-	tracing_record_cmdline(curr);
-
-	wakeup_check_start(tr, task, curr);
+	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
 
 static void start_wakeup_tracer(struct trace_array *tr)
 {
 	int ret;
 
-	ret = marker_probe_register("kernel_sched_wakeup",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&wakeup_trace);
+	ret = register_trace_sched_wakeup(probe_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return;
 	}
 
-	ret = marker_probe_register("kernel_sched_wakeup_new",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&wakeup_trace);
+	ret = register_trace_sched_wakeup_new(probe_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = marker_probe_register("kernel_sched_schedule",
-		"prev_pid %d next_pid %d prev_state %ld "
-		"## rq %p prev %p next %p",
-		sched_switch_callback,
-		&wakeup_trace);
+	ret = register_trace_sched_switch(probe_wakeup_sched_switch);
 	if (ret) {
-		pr_info("sched trace: Couldn't add marker"
+		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_schedule\n");
 		goto fail_deprobe_wake_new;
 	}
@@ -363,28 +313,18 @@ static void start_wakeup_tracer(struct trace_array *tr)
 
 	return;
 fail_deprobe_wake_new:
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&wakeup_trace);
+	unregister_trace_sched_wakeup_new(probe_wakeup);
 fail_deprobe:
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&wakeup_trace);
+	unregister_trace_sched_wakeup(probe_wakeup);
 }
 
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
-	marker_probe_unregister("kernel_sched_schedule",
-				sched_switch_callback,
-				&wakeup_trace);
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&wakeup_trace);
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&wakeup_trace);
+	unregister_trace_sched_switch(probe_wakeup_sched_switch);
+	unregister_trace_sched_wakeup_new(probe_wakeup);
+	unregister_trace_sched_wakeup(probe_wakeup);
 }
 
 static void wakeup_tracer_init(struct trace_array *tr)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 0911b7e..09cf230 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -9,65 +9,29 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_FN:
 	case TRACE_CTX:
 	case TRACE_WAKE:
+	case TRACE_CONT:
 	case TRACE_STACK:
+	case TRACE_PRINT:
 	case TRACE_SPECIAL:
 		return 1;
 	}
 	return 0;
 }
 
-static int
-trace_test_buffer_cpu(struct trace_array *tr, struct trace_array_cpu *data)
+static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 {
-	struct trace_entry *entries;
-	struct page *page;
-	int idx = 0;
-	int i;
+	struct ring_buffer_event *event;
+	struct trace_entry *entry;
 
-	BUG_ON(list_empty(&data->trace_pages));
-	page = list_entry(data->trace_pages.next, struct page, lru);
-	entries = page_address(page);
+	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
+		entry = ring_buffer_event_data(event);
 
-	check_pages(data);
-	if (head_page(data) != entries)
-		goto failed;
-
-	/*
-	 * The starting trace buffer always has valid elements,
-	 * if any element exists.
-	 */
-	entries = head_page(data);
-
-	for (i = 0; i < tr->entries; i++) {
-
-		if (i < data->trace_idx && !trace_valid_entry(&entries[idx])) {
+		if (!trace_valid_entry(entry)) {
 			printk(KERN_CONT ".. invalid entry %d ",
-				entries[idx].type);
+				entry->type);
 			goto failed;
 		}
-
-		idx++;
-		if (idx >= ENTRIES_PER_PAGE) {
-			page = virt_to_page(entries);
-			if (page->lru.next == &data->trace_pages) {
-				if (i != tr->entries - 1) {
-					printk(KERN_CONT ".. entries buffer mismatch");
-					goto failed;
-				}
-			} else {
-				page = list_entry(page->lru.next, struct page, lru);
-				entries = page_address(page);
-			}
-			idx = 0;
-		}
 	}
-
-	page = virt_to_page(entries);
-	if (page->lru.next != &data->trace_pages) {
-		printk(KERN_CONT ".. too many entries");
-		goto failed;
-	}
-
 	return 0;
 
  failed:
@@ -89,13 +53,11 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 	/* Don't allow flipping of max traces now */
 	raw_local_irq_save(flags);
 	__raw_spin_lock(&ftrace_max_lock);
-	for_each_possible_cpu(cpu) {
-		if (!head_page(tr->data[cpu]))
-			continue;
 
-		cnt += tr->data[cpu]->trace_idx;
+	cnt = ring_buffer_entries(tr->buffer);
 
-		ret = trace_test_buffer_cpu(tr, tr->data[cpu]);
+	for_each_possible_cpu(cpu) {
+		ret = trace_test_buffer_cpu(tr, cpu);
 		if (ret)
 			break;
 	}
@@ -120,11 +82,11 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 					   struct trace_array *tr,
 					   int (*func)(void))
 {
-	unsigned long count;
-	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	unsigned long count;
 	char *func_name;
+	int ret;
 
 	/* The ftrace test PASSED */
 	printk(KERN_CONT "PASSED\n");
@@ -157,6 +119,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	/* enable tracing */
 	tr->ctrl = 1;
 	trace->init(tr);
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 
@@ -212,10 +175,10 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long count;
-	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	unsigned long count;
+	int ret;
 
 	/* make sure msleep has been recorded */
 	msleep(1);
@@ -415,6 +378,15 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 }
 #endif /* CONFIG_IRQSOFF_TRACER && CONFIG_PREEMPT_TRACER */
 
+#ifdef CONFIG_NOP_TRACER
+int
+trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
+{
+	/* What could possibly go wrong? */
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_SCHED_TRACER
 static int trace_wakeup_test_thread(void *data)
 {
@@ -486,6 +458,9 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 
 	wake_up_process(p);
 
+	/* give a little time to let the thread wake up */
+	msleep(100);
+
 	/* stop the tracing. */
 	tr->ctrl = 0;
 	trace->ctrl_update(tr);
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
new file mode 100644
index 0000000..74c5d9a
--- /dev/null
+++ b/kernel/trace/trace_stack.c
@@ -0,0 +1,310 @@
+/*
+ * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/stacktrace.h>
+#include <linux/kallsyms.h>
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include "trace.h"
+
+#define STACK_TRACE_ENTRIES 500
+
+static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =
+	 { [0 ... (STACK_TRACE_ENTRIES)] = ULONG_MAX };
+static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
+
+static struct stack_trace max_stack_trace = {
+	.max_entries		= STACK_TRACE_ENTRIES,
+	.entries		= stack_dump_trace,
+};
+
+static unsigned long max_stack_size;
+static raw_spinlock_t max_stack_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+static int stack_trace_disabled __read_mostly;
+static DEFINE_PER_CPU(int, trace_active);
+
+static inline void check_stack(void)
+{
+	unsigned long this_size, flags;
+	unsigned long *p, *top, *start;
+	int i;
+
+	this_size = ((unsigned long)&this_size) & (THREAD_SIZE-1);
+	this_size = THREAD_SIZE - this_size;
+
+	if (this_size <= max_stack_size)
+		return;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&max_stack_lock);
+
+	/* a race could have already updated it */
+	if (this_size <= max_stack_size)
+		goto out;
+
+	max_stack_size = this_size;
+
+	max_stack_trace.nr_entries	= 0;
+	max_stack_trace.skip		= 3;
+
+	save_stack_trace(&max_stack_trace);
+
+	/*
+	 * Now find where in the stack these are.
+	 */
+	i = 0;
+	start = &this_size;
+	top = (unsigned long *)
+		(((unsigned long)start & ~(THREAD_SIZE-1)) + THREAD_SIZE);
+
+	/*
+	 * Loop through all the entries. One of the entries may
+	 * for some reason be missed on the stack, so we may
+	 * have to account for them. If they are all there, this
+	 * loop will only happen once. This code only takes place
+	 * on a new max, so it is far from a fast path.
+	 */
+	while (i < max_stack_trace.nr_entries) {
+
+		stack_dump_index[i] = this_size;
+		p = start;
+
+		for (; p < top && i < max_stack_trace.nr_entries; p++) {
+			if (*p == stack_dump_trace[i]) {
+				this_size = stack_dump_index[i++] =
+					(top - p) * sizeof(unsigned long);
+				/* Start the search from here */
+				start = p + 1;
+			}
+		}
+
+		i++;
+	}
+
+ out:
+	__raw_spin_unlock(&max_stack_lock);
+	raw_local_irq_restore(flags);
+}
+
+static void
+stack_trace_call(unsigned long ip, unsigned long parent_ip)
+{
+	int cpu, resched;
+
+	if (unlikely(!ftrace_enabled || stack_trace_disabled))
+		return;
+
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	/* no atomic needed, we only modify this variable by this cpu */
+	if (per_cpu(trace_active, cpu)++ != 0)
+		goto out;
+
+	check_stack();
+
+ out:
+	per_cpu(trace_active, cpu)--;
+	/* prevent recursion in schedule */
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
+}
+
+static struct ftrace_ops trace_ops __read_mostly =
+{
+	.func = stack_trace_call,
+};
+
+static ssize_t
+stack_max_size_read(struct file *filp, char __user *ubuf,
+		    size_t count, loff_t *ppos)
+{
+	unsigned long *ptr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = snprintf(buf, sizeof(buf), "%ld\n", *ptr);
+	if (r > sizeof(buf))
+		r = sizeof(buf);
+	return simple_read_from_buffer(ubuf, count, ppos, buf, r);
+}
+
+static ssize_t
+stack_max_size_write(struct file *filp, const char __user *ubuf,
+		     size_t count, loff_t *ppos)
+{
+	long *ptr = filp->private_data;
+	unsigned long val, flags;
+	char buf[64];
+	int ret;
+
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, count))
+		return -EFAULT;
+
+	buf[count] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&max_stack_lock);
+	*ptr = val;
+	__raw_spin_unlock(&max_stack_lock);
+	raw_local_irq_restore(flags);
+
+	return count;
+}
+
+static struct file_operations stack_max_size_fops = {
+	.open		= tracing_open_generic,
+	.read		= stack_max_size_read,
+	.write		= stack_max_size_write,
+};
+
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	long i = (long)m->private;
+
+	(*pos)++;
+
+	i++;
+
+	if (i >= max_stack_trace.nr_entries ||
+	    stack_dump_trace[i] == ULONG_MAX)
+		return NULL;
+
+	m->private = (void *)i;
+
+	return &m->private;
+}
+
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
+	void *t = &m->private;
+	loff_t l = 0;
+
+	local_irq_disable();
+	__raw_spin_lock(&max_stack_lock);
+
+	for (; t && l < *pos; t = t_next(m, t, &l))
+		;
+
+	return t;
+}
+
+static void t_stop(struct seq_file *m, void *p)
+{
+	__raw_spin_unlock(&max_stack_lock);
+	local_irq_enable();
+}
+
+static int trace_lookup_stack(struct seq_file *m, long i)
+{
+	unsigned long addr = stack_dump_trace[i];
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(str, addr);
+
+	return seq_printf(m, "%s\n", str);
+#else
+	return seq_printf(m, "%p\n", (void*)addr);
+#endif
+}
+
+static int t_show(struct seq_file *m, void *v)
+{
+	long i = *(long *)v;
+	int size;
+
+	if (i < 0) {
+		seq_printf(m, "        Depth   Size      Location"
+			   "    (%d entries)\n"
+			   "        -----   ----      --------\n",
+			   max_stack_trace.nr_entries);
+		return 0;
+	}
+
+	if (i >= max_stack_trace.nr_entries ||
+	    stack_dump_trace[i] == ULONG_MAX)
+		return 0;
+
+	if (i+1 == max_stack_trace.nr_entries ||
+	    stack_dump_trace[i+1] == ULONG_MAX)
+		size = stack_dump_index[i];
+	else
+		size = stack_dump_index[i] - stack_dump_index[i+1];
+
+	seq_printf(m, "%3ld) %8d   %5d   ", i, stack_dump_index[i], size);
+
+	trace_lookup_stack(m, i);
+
+	return 0;
+}
+
+static struct seq_operations stack_trace_seq_ops = {
+	.start		= t_start,
+	.next		= t_next,
+	.stop		= t_stop,
+	.show		= t_show,
+};
+
+static int stack_trace_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open(file, &stack_trace_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = (void *)-1;
+	}
+
+	return ret;
+}
+
+static struct file_operations stack_trace_fops = {
+	.open		= stack_trace_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static __init int stack_trace_init(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("stack_max_size", 0644, d_tracer,
+				    &max_stack_size, &stack_max_size_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'stack_max_size' entry\n");
+
+	entry = debugfs_create_file("stack_trace", 0444, d_tracer,
+				    NULL, &stack_trace_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'stack_trace' entry\n");
+
+	register_ftrace_function(&trace_ops);
+
+	return 0;
+}
+
+device_initcall(stack_trace_init);
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index db58fb6..9587d3b 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -241,7 +241,7 @@ static void stack_reset(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr->data[cpu]);
+		tracing_reset(tr, cpu);
 }
 
 static void start_stack_trace(struct trace_array *tr)
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
new file mode 100644
index 0000000..f2b7c28
--- /dev/null
+++ b/kernel/tracepoint.c
@@ -0,0 +1,477 @@
+/*
+ * Copyright (C) 2008 Mathieu Desnoyers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/jhash.h>
+#include <linux/list.h>
+#include <linux/rcupdate.h>
+#include <linux/tracepoint.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+extern struct tracepoint __start___tracepoints[];
+extern struct tracepoint __stop___tracepoints[];
+
+/* Set to 1 to enable tracepoint debug output */
+static const int tracepoint_debug;
+
+/*
+ * tracepoints_mutex nests inside module_mutex. Tracepoints mutex protects the
+ * builtin and module tracepoints and the hash table.
+ */
+static DEFINE_MUTEX(tracepoints_mutex);
+
+/*
+ * Tracepoint hash table, containing the active tracepoints.
+ * Protected by tracepoints_mutex.
+ */
+#define TRACEPOINT_HASH_BITS 6
+#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
+
+/*
+ * Note about RCU :
+ * It is used to to delay the free of multiple probes array until a quiescent
+ * state is reached.
+ * Tracepoint entries modifications are protected by the tracepoints_mutex.
+ */
+struct tracepoint_entry {
+	struct hlist_node hlist;
+	void **funcs;
+	int refcount;	/* Number of times armed. 0 if disarmed. */
+	struct rcu_head rcu;
+	void *oldptr;
+	unsigned char rcu_pending:1;
+	char name[0];
+};
+
+static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
+
+static void free_old_closure(struct rcu_head *head)
+{
+	struct tracepoint_entry *entry = container_of(head,
+		struct tracepoint_entry, rcu);
+	kfree(entry->oldptr);
+	/* Make sure we free the data before setting the pending flag to 0 */
+	smp_wmb();
+	entry->rcu_pending = 0;
+}
+
+static void tracepoint_entry_free_old(struct tracepoint_entry *entry, void *old)
+{
+	if (!old)
+		return;
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu_sched(&entry->rcu, free_old_closure);
+}
+
+static void debug_print_probes(struct tracepoint_entry *entry)
+{
+	int i;
+
+	if (!tracepoint_debug)
+		return;
+
+	for (i = 0; entry->funcs[i]; i++)
+		printk(KERN_DEBUG "Probe %d : %p\n", i, entry->funcs[i]);
+}
+
+static void *
+tracepoint_entry_add_probe(struct tracepoint_entry *entry, void *probe)
+{
+	int nr_probes = 0;
+	void **old, **new;
+
+	WARN_ON(!probe);
+
+	debug_print_probes(entry);
+	old = entry->funcs;
+	if (old) {
+		/* (N -> N+1), (N != 0, 1) probes */
+		for (nr_probes = 0; old[nr_probes]; nr_probes++)
+			if (old[nr_probes] == probe)
+				return ERR_PTR(-EEXIST);
+	}
+	/* + 2 : one for new probe, one for NULL func */
+	new = kzalloc((nr_probes + 2) * sizeof(void *), GFP_KERNEL);
+	if (new == NULL)
+		return ERR_PTR(-ENOMEM);
+	if (old)
+		memcpy(new, old, nr_probes * sizeof(void *));
+	new[nr_probes] = probe;
+	entry->refcount = nr_probes + 1;
+	entry->funcs = new;
+	debug_print_probes(entry);
+	return old;
+}
+
+static void *
+tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
+{
+	int nr_probes = 0, nr_del = 0, i;
+	void **old, **new;
+
+	old = entry->funcs;
+
+	debug_print_probes(entry);
+	/* (N -> M), (N > 1, M >= 0) probes */
+	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
+		if ((!probe || old[nr_probes] == probe))
+			nr_del++;
+	}
+
+	if (nr_probes - nr_del == 0) {
+		/* N -> 0, (N > 1) */
+		entry->funcs = NULL;
+		entry->refcount = 0;
+		debug_print_probes(entry);
+		return old;
+	} else {
+		int j = 0;
+		/* N -> M, (N > 1, M > 0) */
+		/* + 1 for NULL */
+		new = kzalloc((nr_probes - nr_del + 1)
+			* sizeof(void *), GFP_KERNEL);
+		if (new == NULL)
+			return ERR_PTR(-ENOMEM);
+		for (i = 0; old[i]; i++)
+			if ((probe && old[i] != probe))
+				new[j++] = old[i];
+		entry->refcount = nr_probes - nr_del;
+		entry->funcs = new;
+	}
+	debug_print_probes(entry);
+	return old;
+}
+
+/*
+ * Get tracepoint if the tracepoint is present in the tracepoint hash table.
+ * Must be called with tracepoints_mutex held.
+ * Returns NULL if not present.
+ */
+static struct tracepoint_entry *get_tracepoint(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *e;
+	u32 hash = jhash(name, strlen(name), 0);
+
+	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name))
+			return e;
+	}
+	return NULL;
+}
+
+/*
+ * Add the tracepoint to the tracepoint hash table. Must be called with
+ * tracepoints_mutex held.
+ */
+static struct tracepoint_entry *add_tracepoint(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *e;
+	size_t name_len = strlen(name) + 1;
+	u32 hash = jhash(name, name_len-1, 0);
+
+	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			printk(KERN_NOTICE
+				"tracepoint %s busy\n", name);
+			return ERR_PTR(-EEXIST);	/* Already there */
+		}
+	}
+	/*
+	 * Using kmalloc here to allocate a variable length element. Could
+	 * cause some memory fragmentation if overused.
+	 */
+	e = kmalloc(sizeof(struct tracepoint_entry) + name_len, GFP_KERNEL);
+	if (!e)
+		return ERR_PTR(-ENOMEM);
+	memcpy(&e->name[0], name, name_len);
+	e->funcs = NULL;
+	e->refcount = 0;
+	e->rcu_pending = 0;
+	hlist_add_head(&e->hlist, head);
+	return e;
+}
+
+/*
+ * Remove the tracepoint from the tracepoint hash table. Must be called with
+ * mutex_lock held.
+ */
+static int remove_tracepoint(const char *name)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct tracepoint_entry *e;
+	int found = 0;
+	size_t len = strlen(name) + 1;
+	u32 hash = jhash(name, len-1, 0);
+
+	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
+	hlist_for_each_entry(e, node, head, hlist) {
+		if (!strcmp(name, e->name)) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		return -ENOENT;
+	if (e->refcount)
+		return -EBUSY;
+	hlist_del(&e->hlist);
+	/* Make sure the call_rcu_sched has been executed */
+	if (e->rcu_pending)
+		rcu_barrier_sched();
+	kfree(e);
+	return 0;
+}
+
+/*
+ * Sets the probe callback corresponding to one tracepoint.
+ */
+static void set_tracepoint(struct tracepoint_entry **entry,
+	struct tracepoint *elem, int active)
+{
+	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
+
+	/*
+	 * rcu_assign_pointer has a smp_wmb() which makes sure that the new
+	 * probe callbacks array is consistent before setting a pointer to it.
+	 * This array is referenced by __DO_TRACE from
+	 * include/linux/tracepoints.h. A matching smp_read_barrier_depends()
+	 * is used.
+	 */
+	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
+	elem->state = active;
+}
+
+/*
+ * Disable a tracepoint and its probe callback.
+ * Note: only waiting an RCU period after setting elem->call to the empty
+ * function insures that the original callback is not used anymore. This insured
+ * by preempt_disable around the call site.
+ */
+static void disable_tracepoint(struct tracepoint *elem)
+{
+	elem->state = 0;
+}
+
+/**
+ * tracepoint_update_probe_range - Update a probe range
+ * @begin: beginning of the range
+ * @end: end of the range
+ *
+ * Updates the probe callback corresponding to a range of tracepoints.
+ */
+void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{
+	struct tracepoint *iter;
+	struct tracepoint_entry *mark_entry;
+
+	mutex_lock(&tracepoints_mutex);
+	for (iter = begin; iter < end; iter++) {
+		mark_entry = get_tracepoint(iter->name);
+		if (mark_entry) {
+			set_tracepoint(&mark_entry, iter,
+					!!mark_entry->refcount);
+		} else {
+			disable_tracepoint(iter);
+		}
+	}
+	mutex_unlock(&tracepoints_mutex);
+}
+
+/*
+ * Update probes, removing the faulty probes.
+ */
+static void tracepoint_update_probes(void)
+{
+	/* Core kernel tracepoints */
+	tracepoint_update_probe_range(__start___tracepoints,
+		__stop___tracepoints);
+	/* tracepoints in modules. */
+	module_update_tracepoints();
+}
+
+/**
+ * tracepoint_probe_register -  Connect a probe to a tracepoint
+ * @name: tracepoint name
+ * @probe: probe handler
+ *
+ * Returns 0 if ok, error value on error.
+ * The probe address must at least be aligned on the architecture pointer size.
+ */
+int tracepoint_probe_register(const char *name, void *probe)
+{
+	struct tracepoint_entry *entry;
+	int ret = 0;
+	void *old;
+
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	if (!entry) {
+		entry = add_tracepoint(name);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			goto end;
+		}
+	}
+	/*
+	 * If we detect that a call_rcu_sched is pending for this tracepoint,
+	 * make sure it's executed now.
+	 */
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	old = tracepoint_entry_add_probe(entry, probe);
+	if (IS_ERR(old)) {
+		ret = PTR_ERR(old);
+		goto end;
+	}
+	mutex_unlock(&tracepoints_mutex);
+	tracepoint_update_probes();		/* may update entry */
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	tracepoint_entry_free_old(entry, old);
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_register);
+
+/**
+ * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
+ * @name: tracepoint name
+ * @probe: probe function pointer
+ *
+ * We do not need to call a synchronize_sched to make sure the probes have
+ * finished running before doing a module unload, because the module unload
+ * itself uses stop_machine(), which insures that every preempt disabled section
+ * have finished.
+ */
+int tracepoint_probe_unregister(const char *name, void *probe)
+{
+	struct tracepoint_entry *entry;
+	void *old;
+	int ret = -ENOENT;
+
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	if (!entry)
+		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	old = tracepoint_entry_remove_probe(entry, probe);
+	mutex_unlock(&tracepoints_mutex);
+	tracepoint_update_probes();		/* may update entry */
+	mutex_lock(&tracepoints_mutex);
+	entry = get_tracepoint(name);
+	if (!entry)
+		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
+	tracepoint_entry_free_old(entry, old);
+	remove_tracepoint(name);	/* Ignore busy error message */
+	ret = 0;
+end:
+	mutex_unlock(&tracepoints_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
+
+/**
+ * tracepoint_get_iter_range - Get a next tracepoint iterator given a range.
+ * @tracepoint: current tracepoints (in), next tracepoint (out)
+ * @begin: beginning of the range
+ * @end: end of the range
+ *
+ * Returns whether a next tracepoint has been found (1) or not (0).
+ * Will return the first tracepoint in the range if the input tracepoint is
+ * NULL.
+ */
+int tracepoint_get_iter_range(struct tracepoint **tracepoint,
+	struct tracepoint *begin, struct tracepoint *end)
+{
+	if (!*tracepoint && begin != end) {
+		*tracepoint = begin;
+		return 1;
+	}
+	if (*tracepoint >= begin && *tracepoint < end)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tracepoint_get_iter_range);
+
+static void tracepoint_get_iter(struct tracepoint_iter *iter)
+{
+	int found = 0;
+
+	/* Core kernel tracepoints */
+	if (!iter->module) {
+		found = tracepoint_get_iter_range(&iter->tracepoint,
+				__start___tracepoints, __stop___tracepoints);
+		if (found)
+			goto end;
+	}
+	/* tracepoints in modules. */
+	found = module_get_iter_tracepoints(iter);
+end:
+	if (!found)
+		tracepoint_iter_reset(iter);
+}
+
+void tracepoint_iter_start(struct tracepoint_iter *iter)
+{
+	tracepoint_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_start);
+
+void tracepoint_iter_next(struct tracepoint_iter *iter)
+{
+	iter->tracepoint++;
+	/*
+	 * iter->tracepoint may be invalid because we blindly incremented it.
+	 * Make sure it is valid by marshalling on the tracepoints, getting the
+	 * tracepoints from following modules if necessary.
+	 */
+	tracepoint_get_iter(iter);
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_next);
+
+void tracepoint_iter_stop(struct tracepoint_iter *iter)
+{
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_stop);
+
+void tracepoint_iter_reset(struct tracepoint_iter *iter)
+{
+	iter->module = NULL;
+	iter->tracepoint = NULL;
+}
+EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
diff --git a/samples/Kconfig b/samples/Kconfig
index e1fb471..4b02f5a 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -13,6 +13,12 @@ config SAMPLE_MARKERS
 	help
 	  This build markers example modules.
 
+config SAMPLE_TRACEPOINTS
+	tristate "Build tracepoints examples -- loadable modules only"
+	depends on TRACEPOINTS && m
+	help
+	  This build tracepoints example modules.
+
 config SAMPLE_KOBJECT
 	tristate "Build kobject examples"
 	help
diff --git a/samples/Makefile b/samples/Makefile
index 2e02575..10eaca8 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
diff --git a/samples/markers/probe-example.c b/samples/markers/probe-example.c
index c8e099d..2dfb3b3 100644
--- a/samples/markers/probe-example.c
+++ b/samples/markers/probe-example.c
@@ -81,6 +81,7 @@ static void __exit probe_fini(void)
 			probe_array[i].probe_func, &probe_array[i]);
 	printk(KERN_INFO "Number of event b : %u\n",
 			atomic_read(&eventb_count));
+	marker_synchronize_unregister();
 }
 
 module_init(probe_init);
diff --git a/samples/tracepoints/Makefile b/samples/tracepoints/Makefile
new file mode 100644
index 0000000..36479ad
--- /dev/null
+++ b/samples/tracepoints/Makefile
@@ -0,0 +1,6 @@
+# builds the tracepoint example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-sample.o
+obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-probe-sample.o
+obj-$(CONFIG_SAMPLE_TRACEPOINTS) += tracepoint-probe-sample2.o
diff --git a/samples/tracepoints/tp-samples-trace.h b/samples/tracepoints/tp-samples-trace.h
new file mode 100644
index 0000000..0216b55
--- /dev/null
+++ b/samples/tracepoints/tp-samples-trace.h
@@ -0,0 +1,13 @@
+#ifndef _TP_SAMPLES_TRACE_H
+#define _TP_SAMPLES_TRACE_H
+
+#include <linux/proc_fs.h>	/* for struct inode and struct file */
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(subsys_event,
+	TPPROTO(struct inode *inode, struct file *file),
+	TPARGS(inode, file));
+DEFINE_TRACE(subsys_eventb,
+	TPPROTO(void),
+	TPARGS());
+#endif
diff --git a/samples/tracepoints/tracepoint-probe-sample.c b/samples/tracepoints/tracepoint-probe-sample.c
new file mode 100644
index 0000000..55abfdd
--- /dev/null
+++ b/samples/tracepoints/tracepoint-probe-sample.c
@@ -0,0 +1,55 @@
+/*
+ * tracepoint-probe-sample.c
+ *
+ * sample tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/dcache.h>
+#include "tp-samples-trace.h"
+
+/*
+ * Here the caller only guarantees locking for struct file and struct inode.
+ * Locking must therefore be done in the probe to use the dentry.
+ */
+static void probe_subsys_event(struct inode *inode, struct file *file)
+{
+	path_get(&file->f_path);
+	dget(file->f_path.dentry);
+	printk(KERN_INFO "Event is encountered with filename %s\n",
+		file->f_path.dentry->d_name.name);
+	dput(file->f_path.dentry);
+	path_put(&file->f_path);
+}
+
+static void probe_subsys_eventb(void)
+{
+	printk(KERN_INFO "Event B is encountered\n");
+}
+
+int __init tp_sample_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_subsys_event(probe_subsys_event);
+	WARN_ON(ret);
+	ret = register_trace_subsys_eventb(probe_subsys_eventb);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(tp_sample_trace_init);
+
+void __exit tp_sample_trace_exit(void)
+{
+	unregister_trace_subsys_eventb(probe_subsys_eventb);
+	unregister_trace_subsys_event(probe_subsys_event);
+}
+
+module_exit(tp_sample_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Tracepoint Probes Samples");
diff --git a/samples/tracepoints/tracepoint-probe-sample2.c b/samples/tracepoints/tracepoint-probe-sample2.c
new file mode 100644
index 0000000..5e9fcf4
--- /dev/null
+++ b/samples/tracepoints/tracepoint-probe-sample2.c
@@ -0,0 +1,42 @@
+/*
+ * tracepoint-probe-sample2.c
+ *
+ * 2nd sample tracepoint probes.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include "tp-samples-trace.h"
+
+/*
+ * Here the caller only guarantees locking for struct file and struct inode.
+ * Locking must therefore be done in the probe to use the dentry.
+ */
+static void probe_subsys_event(struct inode *inode, struct file *file)
+{
+	printk(KERN_INFO "Event is encountered with inode number %lu\n",
+		inode->i_ino);
+}
+
+int __init tp_sample_trace_init(void)
+{
+	int ret;
+
+	ret = register_trace_subsys_event(probe_subsys_event);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+module_init(tp_sample_trace_init);
+
+void __exit tp_sample_trace_exit(void)
+{
+	unregister_trace_subsys_event(probe_subsys_event);
+}
+
+module_exit(tp_sample_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Tracepoint Probes Samples");
diff --git a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
new file mode 100644
index 0000000..4ae4b7f
--- /dev/null
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -0,0 +1,53 @@
+/* tracepoint-sample.c
+ *
+ * Executes a tracepoint when /proc/tracepoint-example is opened.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/proc_fs.h>
+#include "tp-samples-trace.h"
+
+struct proc_dir_entry *pentry_example;
+
+static int my_open(struct inode *inode, struct file *file)
+{
+	int i;
+
+	trace_subsys_event(inode, file);
+	for (i = 0; i < 10; i++)
+		trace_subsys_eventb();
+	return -EPERM;
+}
+
+static struct file_operations mark_ops = {
+	.open = my_open,
+};
+
+static int example_init(void)
+{
+	printk(KERN_ALERT "example init\n");
+	pentry_example = proc_create("tracepoint-example", 0444, NULL,
+		&mark_ops);
+	if (!pentry_example)
+		return -EPERM;
+	return 0;
+}
+
+static void example_exit(void)
+{
+	printk(KERN_ALERT "example exit\n");
+	remove_proc_entry("tracepoint-example", NULL);
+}
+
+module_init(example_init)
+module_exit(example_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Tracepoint example");
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 277cfe0..5ed4cbf 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -198,10 +198,17 @@ cmd_modversions =							\
 	fi;
 endif
 
+ifdef CONFIG_FTRACE_MCOUNT_RECORD
+cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
+	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
+	"$(MV)" "$(@)";
+endif
+
 define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
 	$(cmd_modversions)						  \
+	$(cmd_record_mcount)						  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
new file mode 100644
index 0000000..5e7316e
--- /dev/null
+++ b/scripts/bootgraph.pl
@@ -0,0 +1,149 @@
+#!/usr/bin/perl
+
+# Copyright 2008, Intel Corporation
+#
+# This file is part of the Linux kernel
+#
+# This program file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# This program is distributed in the hope that it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+# for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program in a file named COPYING; if not, write to the
+# Free Software Foundation, Inc.,
+# 51 Franklin Street, Fifth Floor,
+# Boston, MA 02110-1301 USA
+#
+# Authors:
+# 	Arjan van de Ven <arjan@linux.intel.com>
+
+
+#
+# This script turns a dmesg output into a SVG graphic that shows which
+# functions take how much time. You can view SVG graphics with various
+# programs, including Inkscape, The Gimp and Firefox.
+#
+#
+# For this script to work, the kernel needs to be compiled with the
+# CONFIG_PRINTK_TIME configuration option enabled, and with
+# "initcall_debug" passed on the kernel command line.
+#
+# usage:
+# 	dmesg | perl scripts/bootgraph.pl > output.svg
+#
+
+my %start, %end;
+my $done = 0;
+my $maxtime = 0;
+my $firsttime = 100;
+my $count = 0;
+my %pids;
+
+while (<>) {
+	my $line = $_;
+	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_]+)\+/) {
+		my $func = $2;
+		if ($done == 0) {
+			$start{$func} = $1;
+			if ($1 < $firsttime) {
+				$firsttime = $1;
+			}
+		}
+		if ($line =~ /\@ ([0-9]+)/) {
+			$pids{$func} = $1;
+		}
+		$count = $count + 1;
+	}
+
+	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_]+)\+.*returned/) {
+		if ($done == 0) {
+			$end{$2} = $1;
+			$maxtime = $1;
+		}
+	}
+	if ($line =~ /Write protecting the/) {
+		$done = 1;
+	}
+	if ($line =~ /Freeing unused kernel memory/) {
+		$done = 1;
+	}
+}
+
+if ($count == 0) {
+	print "No data found in the dmesg. Make sure that 'printk.time=1' and\n";
+	print "'initcall_debug' are passed on the kernel command line.\n\n";
+	print "Usage: \n";
+	print "      dmesg | perl scripts/bootgraph.pl > output.svg\n\n";
+	exit;
+}
+
+print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
+print "<svg width=\"1000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
+
+my @styles;
+
+$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[8] = "fill:rgb(255,0,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[9] = "fill:rgb(255,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[10] = "fill:rgb(255,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[11] = "fill:rgb(128,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+
+my $mult = 950.0 / ($maxtime - $firsttime);
+my $threshold = ($maxtime - $firsttime) / 60.0;
+my $stylecounter = 0;
+my %rows;
+my $rowscount = 1;
+while (($key,$value) = each %start) {
+	my $duration = $end{$key} - $start{$key};
+
+	if ($duration >= $threshold) {
+		my $s, $s2, $e, $y;
+		$pid = $pids{$key};
+
+		if (!defined($rows{$pid})) {
+			$rows{$pid} = $rowscount;
+			$rowscount = $rowscount + 1;
+		}
+		$s = ($value - $firsttime) * $mult;
+		$s2 = $s + 6;
+		$e = ($end{$key} - $firsttime) * $mult;
+		$w = $e - $s;
+
+		$y = $rows{$pid} * 150;
+		$y2 = $y + 4;
+
+		$style = $styles[$stylecounter];
+		$stylecounter = $stylecounter + 1;
+		if ($stylecounter > 11) {
+			$stylecounter = 0;
+		};
+
+		print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"145\" style=\"$style\"/>\n";
+		print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+	}
+}
+
+
+# print the time line on top
+my $time = $firsttime;
+my $step = ($maxtime - $firsttime) / 15;
+while ($time < $maxtime) {
+	my $s2 = ($time - $firsttime) * $mult;
+	my $tm = int($time * 100) / 100.0;
+	print "<text transform=\"translate($s2,89) rotate(90)\">$tm</text>\n";
+	$time = $time + $step;
+}
+
+print "</svg>\n";
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
new file mode 100755
index 0000000..f56d760
--- /dev/null
+++ b/scripts/recordmcount.pl
@@ -0,0 +1,395 @@
+#!/usr/bin/perl -w
+# (c) 2008, Steven Rostedt <srostedt@redhat.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# recordmcount.pl - makes a section called __mcount_loc that holds
+#                   all the offsets to the calls to mcount.
+#
+#
+# What we want to end up with is a section in vmlinux called
+# __mcount_loc that contains a list of pointers to all the
+# call sites in the kernel that call mcount. Later on boot up, the kernel
+# will read this list, save the locations and turn them into nops.
+# When tracing or profiling is later enabled, these locations will then
+# be converted back to pointers to some function.
+#
+# This is no easy feat. This script is called just after the original
+# object is compiled and before it is linked.
+#
+# The references to the call sites are offsets from the section of text
+# that the call site is in. Hence, all functions in a section that
+# has a call site to mcount, will have the offset from the beginning of
+# the section and not the beginning of the function.
+#
+# The trick is to find a way to record the beginning of the section.
+# The way we do this is to look at the first function in the section
+# which will also be the location of that section after final link.
+# e.g.
+#
+#  .section ".text.sched"
+#  .globl my_func
+#  my_func:
+#        [...]
+#        call mcount  (offset: 0x5)
+#        [...]
+#        ret
+#  other_func:
+#        [...]
+#        call mcount (offset: 0x1b)
+#        [...]
+#
+# Both relocation offsets for the mcounts in the above example will be
+# offset from .text.sched. If we make another file called tmp.s with:
+#
+#  .section __mcount_loc
+#  .quad  my_func + 0x5
+#  .quad  my_func + 0x1b
+#
+# We can then compile this tmp.s into tmp.o, and link it to the original
+# object.
+#
+# But this gets hard if my_func is not globl (a static function).
+# In such a case we have:
+#
+#  .section ".text.sched"
+#  my_func:
+#        [...]
+#        call mcount  (offset: 0x5)
+#        [...]
+#        ret
+#  .globl my_func
+#  other_func:
+#        [...]
+#        call mcount (offset: 0x1b)
+#        [...]
+#
+# If we make the tmp.s the same as above, when we link together with
+# the original object, we will end up with two symbols for my_func:
+# one local, one global.  After final compile, we will end up with
+# an undefined reference to my_func.
+#
+# Since local objects can reference local variables, we need to find
+# a way to make tmp.o reference the local objects of the original object
+# file after it is linked together. To do this, we convert the my_func
+# into a global symbol before linking tmp.o. Then after we link tmp.o
+# we will only have a single symbol for my_func that is global.
+# We can convert my_func back into a local symbol and we are done.
+#
+# Here are the steps we take:
+#
+# 1) Record all the local symbols by using 'nm'
+# 2) Use objdump to find all the call site offsets and sections for
+#    mcount.
+# 3) Compile the list into its own object.
+# 4) Do we have to deal with local functions? If not, go to step 8.
+# 5) Make an object that converts these local functions to global symbols
+#    with objcopy.
+# 6) Link together this new object with the list object.
+# 7) Convert the local functions back to local symbols and rename
+#    the result as the original object.
+#    End.
+# 8) Link the object with the list object.
+# 9) Move the result back to the original object.
+#    End.
+#
+
+use strict;
+
+my $P = $0;
+$P =~ s@.*/@@g;
+
+my $V = '0.1';
+
+if ($#ARGV < 6) {
+	print "usage: $P arch objdump objcopy cc ld nm rm mv inputfile\n";
+	print "version: $V\n";
+	exit(1);
+}
+
+my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
+
+$objdump = "objdump" if ((length $objdump) == 0);
+$objcopy = "objcopy" if ((length $objcopy) == 0);
+$cc = "gcc" if ((length $cc) == 0);
+$ld = "ld" if ((length $ld) == 0);
+$nm = "nm" if ((length $nm) == 0);
+$rm = "rm" if ((length $rm) == 0);
+$mv = "mv" if ((length $mv) == 0);
+
+#print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
+#    "'$nm' '$rm' '$mv' '$inputfile'\n";
+
+my %locals;		# List of local (static) functions
+my %weak;		# List of weak functions
+my %convert;		# List of local functions used that needs conversion
+
+my $type;
+my $section_regex;	# Find the start of a section
+my $function_regex;	# Find the name of a function
+			#    (return offset and func name)
+my $mcount_regex;	# Find the call site to mcount (return offset)
+
+if ($arch eq "x86_64") {
+    $section_regex = "Disassembly of section";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
+    $type = ".quad";
+
+    # force flags for this arch
+    $ld .= " -m elf_x86_64";
+    $objdump .= " -M x86-64";
+    $objcopy .= " -O elf64-x86-64";
+    $cc .= " -m64";
+
+} elsif ($arch eq "i386") {
+    $section_regex = "Disassembly of section";
+    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+    $type = ".long";
+
+    # force flags for this arch
+    $ld .= " -m elf_i386";
+    $objdump .= " -M i386";
+    $objcopy .= " -O elf32-i386";
+    $cc .= " -m32";
+
+} else {
+    die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
+}
+
+my $text_found = 0;
+my $read_function = 0;
+my $opened = 0;
+my $mcount_section = "__mcount_loc";
+
+my $dirname;
+my $filename;
+my $prefix;
+my $ext;
+
+if ($inputfile =~ m,^(.*)/([^/]*)$,) {
+    $dirname = $1;
+    $filename = $2;
+} else {
+    $dirname = ".";
+    $filename = $inputfile;
+}
+
+if ($filename =~ m,^(.*)(\.\S),) {
+    $prefix = $1;
+    $ext = $2;
+} else {
+    $prefix = $filename;
+    $ext = "";
+}
+
+my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
+my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
+
+#
+# --globalize-symbols came out in 2.17, we must test the version
+# of objcopy, and if it is less than 2.17, then we can not
+# record local functions.
+my $use_locals = 01;
+my $local_warn_once = 0;
+my $found_version = 0;
+
+open (IN, "$objcopy --version |") || die "error running $objcopy";
+while (<IN>) {
+    if (/objcopy.*\s(\d+)\.(\d+)/) {
+	my $major = $1;
+	my $minor = $2;
+
+	$found_version = 1;
+	if ($major < 2 ||
+	    ($major == 2 && $minor < 17)) {
+	    $use_locals = 0;
+	}
+	last;
+    }
+}
+close (IN);
+
+if (!$found_version) {
+    print STDERR "WARNING: could not find objcopy version.\n" .
+	"\tDisabling local function references.\n";
+}
+
+
+#
+# Step 1: find all the local (static functions) and weak symbols.
+#        't' is local, 'w/W' is weak (we never use a weak function)
+#
+open (IN, "$nm $inputfile|") || die "error running $nm";
+while (<IN>) {
+    if (/^[0-9a-fA-F]+\s+t\s+(\S+)/) {
+	$locals{$1} = 1;
+    } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
+	$weak{$2} = $1;
+    }
+}
+close(IN);
+
+my @offsets;		# Array of offsets of mcount callers
+my $ref_func;		# reference function to use for offsets
+my $offset = 0;		# offset of ref_func to section beginning
+
+##
+# update_funcs - print out the current mcount callers
+#
+#  Go through the list of offsets to callers and write them to
+#  the output file in a format that can be read by an assembler.
+#
+sub update_funcs
+{
+    return if ($#offsets < 0);
+
+    defined($ref_func) || die "No function to reference";
+
+    # A section only had a weak function, to represent it.
+    # Unfortunately, a weak function may be overwritten by another
+    # function of the same name, making all these offsets incorrect.
+    # To be safe, we simply print a warning and bail.
+    if (defined $weak{$ref_func}) {
+	print STDERR
+	    "$inputfile: WARNING: referencing weak function" .
+	    " $ref_func for mcount\n";
+	return;
+    }
+
+    # is this function static? If so, note this fact.
+    if (defined $locals{$ref_func}) {
+
+	# only use locals if objcopy supports globalize-symbols
+	if (!$use_locals) {
+	    return;
+	}
+	$convert{$ref_func} = 1;
+    }
+
+    # Loop through all the mcount caller offsets and print a reference
+    # to the caller based from the ref_func.
+    for (my $i=0; $i <= $#offsets; $i++) {
+	if (!$opened) {
+	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
+	    $opened = 1;
+	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	}
+	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
+    }
+}
+
+#
+# Step 2: find the sections and mcount call sites
+#
+open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
+
+my $text;
+
+while (<IN>) {
+    # is it a section?
+    if (/$section_regex/) {
+	$read_function = 1;
+	# print out any recorded offsets
+	update_funcs() if ($text_found);
+
+	# reset all markers and arrays
+	$text_found = 0;
+	undef($ref_func);
+	undef(@offsets);
+
+    # section found, now is this a start of a function?
+    } elsif ($read_function && /$function_regex/) {
+	$text_found = 1;
+	$offset = hex $1;
+	$text = $2;
+
+	# if this is either a local function or a weak function
+	# keep looking for functions that are global that
+	# we can use safely.
+	if (!defined($locals{$text}) && !defined($weak{$text})) {
+	    $ref_func = $text;
+	    $read_function = 0;
+	} else {
+	    # if we already have a function, and this is weak, skip it
+	    if (!defined($ref_func) || !defined($weak{$text})) {
+		$ref_func = $text;
+	    }
+	}
+    }
+
+    # is this a call site to mcount? If so, record it to print later
+    if ($text_found && /$mcount_regex/) {
+	$offsets[$#offsets + 1] = hex $1;
+    }
+}
+
+# dump out anymore offsets that may have been found
+update_funcs() if ($text_found);
+
+# If we did not find any mcount callers, we are done (do nothing).
+if (!$opened) {
+    exit(0);
+}
+
+close(FILE);
+
+#
+# Step 3: Compile the file that holds the list of call sites to mcount.
+#
+`$cc -o $mcount_o -c $mcount_s`;
+
+my @converts = keys %convert;
+
+#
+# Step 4: Do we have sections that started with local functions?
+#
+if ($#converts >= 0) {
+    my $globallist = "";
+    my $locallist = "";
+
+    foreach my $con (@converts) {
+	$globallist .= " --globalize-symbol $con";
+	$locallist .= " --localize-symbol $con";
+    }
+
+    my $globalobj = $dirname . "/.tmp_gl_" . $filename;
+    my $globalmix = $dirname . "/.tmp_mx_" . $filename;
+
+    #
+    # Step 5: set up each local function as a global
+    #
+    `$objcopy $globallist $inputfile $globalobj`;
+
+    #
+    # Step 6: Link the global version to our list.
+    #
+    `$ld -r $globalobj $mcount_o -o $globalmix`;
+
+    #
+    # Step 7: Convert the local functions back into local symbols
+    #
+    `$objcopy $locallist $globalmix $inputfile`;
+
+    # Remove the temp files
+    `$rm $globalobj $globalmix`;
+
+} else {
+
+    my $mix = $dirname . "/.tmp_mx_" . $filename;
+
+    #
+    # Step 8: Link the object with our list of call sites object.
+    #
+    `$ld -r $inputfile $mcount_o -o $mix`;
+
+    #
+    # Step 9: Move the result back to the original object.
+    #
+    `$mv $mix $inputfile`;
+}
+
+# Clean up the temp files
+`$rm $mcount_o $mcount_s`;
+
+exit(0);
