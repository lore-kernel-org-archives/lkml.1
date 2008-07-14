Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYGNOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYGNOWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYGNOWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:22:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbYGNOWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:22:45 -0400
Date: Mon, 14 Jul 2008 16:22:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] ftrace for v2.6.27
Message-ID: <20080714142226.GA11412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.1 required=5.9 tests=BAYES_00,FB_CIALIS_LEO3 autolearn=no SpamAssassin version=3.2.3
	1.4 FB_CIALIS_LEO3         BODY: Uses a mis-spelled version of cialis.
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the ftrace git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/for-linus

[ NOTE: please pull this only after the x86/for-linus and
  sched/for-linus pulls, as it's a manual merge ontop of those branches. ]

This tree adds the ftrace framework and a couple of tracing plugins: 
ftrace, latency tracer, x86/mmiotrace, irqs-off tracer, sysprof, 
scheduler tracer.

Thanks,

	Ingo

------------------>
Abhishek Sagar (15):
      ftrace: safe traversal of ftrace_hash hlist
      ftrace: fix updating of ftrace_update_cnt
      ftrace: core support for ARM
      ftrace: distinguish kretprobe'd functions in trace logs
      ftrace: export kretprobe_trampoline for function tracer
      ftrace: prevent freeing of all failed updates
      ftrace: remove ftrace_ip_converted()
      ftrace: add debugfs entry 'failures'
      ftrace: prevent freeing of all failed updates
      ftrace: fix "notrace" filtering priority
      ftrace: store mcount address in rec->ip
      kprobes: enable clean usage of get_kprobe
      ftrace: freeze kprobe'd records
      ftrace: avoid modifying kprobe'd records
      ftrace: prevent ftrace modifications while being kprobe'd, v2

Ankita Garg (2):
      ftrace: fix conversion of task state to char in latency tracer
      ftrace: disable tracing when current_tracer is set to "none"

Arnaldo Carvalho de Melo (2):
      ftrace: annotate core code that should not be traced
      ftrace: add basic support for gcc profiler instrumentation

David Miller (2):
      ftrace: remove packed attribute on ftrace_page.
      sparc64: add ftrace support.

Ingo Molnar (70):
      sched: add latency tracer callbacks to the scheduler
      tracing: add notrace to linkage.h
      ftrace: fix kexec
      ftrace: cleanups
      ftrace: add README
      ftrace: fix time offset
      ftrace: fix locking
      ftrace: cleanups
      ftrace: timestamp syncing, prepare
      ftrace: fast, scalable, synchronized timestamps
      ftrace: remove-idx-sync
      ftrace: clean-up-pipe-iteration
      ftrace: add raw output
      ftrace: bin-output
      ftrace: add trace_special()
      ftrace, locking fix
      ftrace: use cpu clock again
      ftrace: build fix
      ftrace: introduce the "hex" output method
      ftrace: build fix
      ftrace: build fix
      ftrace: cleanups
      ftrace: disable -pg for the tracer itself
      ftrace: remove notrace
      ftrace: add wakeup events to sched tracer
      ftrace: add stack tracing
      ftrace: sched tracer fix
      ftrace: make nostacktrace the default
      ftrace: sched tracer, trace full rbtree
      ftrace: trace curr/next tasks
      ftrace: fix wakeups
      ftrace: fix __trace_special()
      ftrace: trace scheduler rbtree
      ftrace: add tracing_cpumask
      ftrace: make use of tracing_cpumask
      ftrace: fix cmdline tracing
      ftrace: iter ctrl fix
      ftrace: include cpu in stacktrace
      ftrace: sched tree fix
      ftrace: sched special
      ftrace: make it more available in the Kconfig
      ftrace: remove add-hoc code
      ftrace: restrict tracing to HAVE_FTRACE architectures
      ftrace: cleanups
      ftrace: trace faster
      ftrace: special stacktrace
      ftrace: stacktrace fix
      ftrace: fix mcount export bug
      ftrace: cleanups
      ftrace: fix include file dependency
      ftrace: fix build bug
      ftrace: add sysprof plugin
      ftrace: extend sysprof plugin
      ftrace: extend sysprof plugin some more
      ftrace: sysprof-plugin, add self-tests
      ftrace: sysprof plugin improvement
      ftrace: make sysprof dependent on x86 for now
      ftrace: sysprof fix
      ftrace: sysprof updates
      sysprof: update copyrights
      mmiotrace: ftrace fix
      mmiotrace: cleanup
      - fix mmioftrace + rcu merge interaction
      sched: do not trace sched_clock
      ftrace: fix merge
      sched: sched_clock() lockdep fix
      namespacecheck: fixes
      ftrace: build fix with gcc 4.3
      fix "ftrace: store mcount address in rec->ip"
      ftrace: build fix for ftraced_suspend

Jiri Slaby (1):
      ftrace: fix printout

Mathieu Desnoyers (3):
      Markers - remove extra format argument
      Markers - define non optimized marker
      Port ftrace to markers

Pekka Paalanen (30):
      x86: add a list for custom page fault handlers.
      x86_64: fix kernel rodata NX setting
      x86: fix SMP alternatives: use mutex instead of spinlock, text_poke is sleepable
      ftrace: add readpos to struct trace_seq; add trace_seq_to_user()
      x86: mmiotrace - trace memory mapped IO
      x86 mmiotrace: use lookup_address()
      x86 mmiotrace: fix relay-buffer-full flag for SMP
      x86 mmiotrace: comment about user space ABI
      x86: explicit call to mmiotrace in do_page_fault()
      x86 mmiotrace: Use percpu instead of arrays.
      x86: mmiotrace full patch, preview 1
      x86: mmiotrace, preview 2
      ftrace: add mmiotrace plugin
      ftrace: mmiotrace, updates
      ftrace: mmiotrace update, #2
      x86 mmiotrace: move files into arch/x86/mm/.
      x86 mmiotrace: remove ISA_trace parameter.
      x86 mmiotrace: Do not print bogus pid
      mmiotrace: add user documentation
      x86 mmiotrace: dynamically disable non-boot CPUs
      mmiotrace: print header using the read hook.
      mmiotrace: print overrun counts
      mmiotrace: do not print bogus pid for maps either
      doc: update mmiotrace doc to current status
      mmiotrace: code style cleanups
      x86 mmiotrace: fix page-unaligned ioremaps
      x86 mmiotrace: use resource_size_t for phys addresses
      mmiotrace: rename kmmio_probe::user_data to :private.
      x86 mmiotrace: page level is unsigned
      mmiotrace broken in linux-next (8-bit writes only)

Peter Zijlstra (2):
      ftrace: trace next state
      ftrace: fix wakeup callback

Randy Dunlap (2):
      mmiotrace: fix printk format
      x86/mmiotrace: uses/depends on PCI

Soeren Sandmann (1):
      ftrace/sysprof: don't trace the user stack if we are a kernel thread.

Soeren Sandmann Pedersen (2):
      ftrace: allow the event pipe to be polled
      sysprof: kernel trace

Steven Rostedt (90):
      ftrace: make the task state char-string visible to all
      ftrace: add preempt_enable/disable notrace macros
      x86: add notrace annotations to vsyscall.
      ftrace: latency tracer infrastructure
      ftrace: function tracer
      ftrace: add tracing of context switches
      ftrace: tracer for scheduler wakeup latency
      ftrace: trace irq disabled critical timings
      ftrace: trace preempt off critical timings
      ftrace: dynamic enabling/disabling of function calls
      ftrace: add ftrace_enabled sysctl to disable mcount function
      ftrace: use nops instead of jmp
      ftrace: move memory management out of arch code
      ftrace: use dynamic patching for updating mcount calls
      ftrace: add filter select functions to trace
      ftrace: convert single large buffer into single pages.
      ftrace: debug smp_processor_id, use notrace preempt disable
      ftrace: irqs off smp_processor_id() fix
      ftrace: lockdep notrace annotations
      ftrace: don't use raw_local_irq_save/restore
      ftrace: fix updates to max trace
      ftrace: fix max latency
      ftrace: force recording
      ftrace: add self-tests
      ftrace: startup tester on dynamic tracing.
      ftrace: disable all tracers on corrupted buffer
      ftrace: reset selftests
      ftrace: change buffers to producer consumer
      ftrace: add a buffer for output
      ftrace: user run time file reading
      ftrace: pipe fixes
      ftrace - fix dynamic ftrace memory leak
      ftrace: disable tracing on failure
      ftrace: enabled tracing by default
      ftrace: add trace_function api for other tracers to use
      ftrace: remove address of function names
      ftrace: do not profile lib/string.o
      ftrace: remove wakeup from function trace
      ftrace: printk and trace irqsoff and wakeups
      ftrace: add TRACE_STACK and TRACE_SPECIAL to selftest validation
      ftrace: fix dynamic ftrace selftest
      ftrace: irqsoff use raw_smp_processor_id
      ftrace: user raw_spin_lock in tracing
      ftrace: remove function tracing from spinlock debug
      ftrace: use Makefile to remove tracing from lockdep
      ftrace: add UNINTERRUPTIBLE state for kftraced on disable
      ftrace: fix mutex unlock in trace output
      ftrace: selftest protect againt max flip
      ftrace: fix the fault label in updating code
      ftrace: dont write protect kernel text
      ftrace: allow trace_pipe to block on all reads
      ftrace: restore iterator trace in pipe read
      ftrace: return EOF in trace_pipe on change of tracer
      ftrace: trace_pipe implement NONBLOCK
      ftrace: user proper API for setting RT prios in selftest
      ftrace: trace_entries to dynamically change trace buffer size
      lockdep: update lockdep_recursion on graph_lock
      ftrace: simple clean ups
      ftrace: replace simple_strtoul with strict_strtoul
      ftrace: modulize the number of CPU buffers
      ftrace: comment code
      ftrace: fix comm on function trace output
      ftrace: add logic to record overruns
      ftrace: add trace pipe header pluggin
      ftrace: fix setting of pos in read_pipe
      ftrace: use raw_smp_processor_id for mcount functions
      ftrace: limit trace entries
      ftrace, POWERPC: add irqs_disabled_flags to ppc
      ftrace: support for PowerPC
      kbuild: create new CFLAGS_REMOVE_(basename).o option
      ftrace: use the new kbuild CFLAGS_REMOVE for kernel directory
      ftrace: use the new kbuild CFLAGS_REMOVE for lib directory
      ftrace: use the new kbuild CFLAGS_REMOVE for x86/kernel directory
      ftrace: add have dynamic ftrace config for archs
      ftrace: limit use of check pages
      ftrace: move ftrace_special to trace.c
      ftrace: add function tracing to wake up tracing
      ftrace: remove printks from irqsoff trace
      ftrace: set_ftrace_notrace feature
      ftrace: fix up cmdline recording
      ftrace: powerpc clean ups
      ftrace: user update and disable dynamic ftrace daemon
      ftrace: move sched_switch enable after markers
      ftrace: define function trace nop
      ftrace: trace schedule
      ftrace: check proper config for preempt type
      ftrace: start wakeup tracing after setting function tracer
      ftrace: use current CPU for function startup
      ftrace: add ftrace_kill_atomic
      ftrace: separate out the function enabled variable

Thomas Gleixner (6):
      ftrace: move enums to ftrace.h and make helper function global
      ftrace: simplify hexprint
      ftrace: remove notrace
      ftrace: fix __trace_special()
      ftrace: make it more available in the Kconfig
      sysprof: make it depend on X86


 Documentation/tracers/mmiotrace.txt      |  164 ++
 Makefile                                 |    4 +
 arch/arm/Kconfig                         |    2 +
 arch/arm/boot/compressed/Makefile        |    6 +
 arch/arm/kernel/Makefile                 |    5 +
 arch/arm/kernel/armksyms.c               |    5 +
 arch/arm/kernel/entry-common.S           |   51 +
 arch/arm/kernel/ftrace.c                 |  116 ++
 arch/arm/kernel/kprobes.c                |    2 +-
 arch/powerpc/Kconfig                     |    4 +-
 arch/powerpc/kernel/Makefile             |   14 +
 arch/powerpc/kernel/entry_32.S           |  127 ++
 arch/powerpc/kernel/entry_64.S           |   65 +
 arch/powerpc/kernel/ftrace.c             |  154 ++
 arch/powerpc/kernel/io.c                 |    3 +-
 arch/powerpc/kernel/irq.c                |    6 +-
 arch/powerpc/kernel/ppc_ksyms.c          |    5 +
 arch/powerpc/kernel/setup_32.c           |    6 +-
 arch/powerpc/platforms/powermac/Makefile |    5 +
 arch/sparc64/Kconfig                     |    2 +
 arch/sparc64/Kconfig.debug               |    2 +-
 arch/sparc64/kernel/Makefile             |    1 +
 arch/sparc64/kernel/ftrace.c             |   94 +
 arch/sparc64/kernel/sparc64_ksyms.c      |    4 +-
 arch/sparc64/lib/mcount.S                |   58 +-
 arch/x86/Kconfig                         |    2 +
 arch/x86/Kconfig.debug                   |   28 +
 arch/x86/kernel/Makefile                 |    8 +
 arch/x86/kernel/alternative.c            |   22 +-
 arch/x86/kernel/entry_32.S               |   72 +
 arch/x86/kernel/entry_64.S               |  106 +
 arch/x86/kernel/ftrace.c                 |  141 ++
 arch/x86/kernel/i386_ksyms_32.c          |    9 +-
 arch/x86/kernel/machine_kexec_32.c       |    4 +
 arch/x86/kernel/machine_kexec_64.c       |    4 +
 arch/x86/kernel/process_32.c             |    3 +
 arch/x86/kernel/process_64.c             |    3 +
 arch/x86/kernel/vsyscall_64.c            |    3 +-
 arch/x86/kernel/x8664_ksyms_64.c         |   11 +-
 arch/x86/lib/Makefile                    |    1 +
 arch/x86/lib/thunk_32.S                  |   47 +
 arch/x86/lib/thunk_64.S                  |   19 +-
 arch/x86/mm/Makefile                     |    5 +
 arch/x86/mm/fault.c                      |   13 +
 arch/x86/mm/init_32.c                    |    4 +
 arch/x86/mm/init_64.c                    |   10 +-
 arch/x86/mm/ioremap.c                    |   11 +-
 arch/x86/mm/kmmio.c                      |  510 +++++
 arch/x86/mm/mmio-mod.c                   |  515 +++++
 arch/x86/mm/pageattr.c                   |    1 +
 arch/x86/mm/pf_in.c                      |  489 +++++
 arch/x86/mm/pf_in.h                      |   39 +
 arch/x86/mm/testmmiotrace.c              |   71 +
 arch/x86/vdso/vclock_gettime.c           |   15 +-
 arch/x86/vdso/vgetcpu.c                  |    3 +-
 include/asm-arm/ftrace.h                 |   14 +
 include/asm-arm/kprobes.h                |    1 +
 include/asm-powerpc/ftrace.h             |   14 +
 include/asm-powerpc/hw_irq.h             |   10 +
 include/asm-sparc64/ftrace.h             |   14 +
 include/asm-x86/alternative.h            |    2 +
 include/asm-x86/ftrace.h                 |   14 +
 include/asm-x86/irqflags.h               |   24 +-
 include/asm-x86/vsyscall.h               |    3 +-
 include/linux/ftrace.h                   |  144 ++
 include/linux/irqflags.h                 |   13 +-
 include/linux/kprobes.h                  |    4 +
 include/linux/linkage.h                  |    2 +
 include/linux/marker.h                   |   40 +-
 include/linux/mmiotrace.h                |   85 +
 include/linux/preempt.h                  |   34 +-
 include/linux/sched.h                    |   16 +
 include/linux/writeback.h                |    2 +
 kernel/Makefile                          |   14 +
 kernel/fork.c                            |    2 +-
 kernel/lockdep.c                         |   33 +-
 kernel/marker.c                          |   30 +-
 kernel/printk.c                          |    2 +
 kernel/sched.c                           |   55 +-
 kernel/semaphore.c                       |    1 +
 kernel/spinlock.c                        |    2 +-
 kernel/sysctl.c                          |   11 +
 kernel/trace/Kconfig                     |  135 ++
 kernel/trace/Makefile                    |   24 +
 kernel/trace/ftrace.c                    | 1727 ++++++++++++++++
 kernel/trace/trace.c                     | 3161 ++++++++++++++++++++++++++++++
 kernel/trace/trace.h                     |  339 ++++
 kernel/trace/trace_functions.c           |   81 +
 kernel/trace/trace_irqsoff.c             |  486 +++++
 kernel/trace/trace_mmiotrace.c           |  295 +++
 kernel/trace/trace_sched_switch.c        |  286 +++
 kernel/trace/trace_sched_wakeup.c        |  448 +++++
 kernel/trace/trace_selftest.c            |  563 ++++++
 kernel/trace/trace_selftest_dynamic.c    |    7 +
 kernel/trace/trace_sysprof.c             |  363 ++++
 lib/Kconfig.debug                        |    2 +
 lib/Makefile                             |    9 +
 lib/smp_processor_id.c                   |    6 +-
 mm/page-writeback.c                      |   10 +-
 scripts/Makefile.lib                     |    3 +-
 100 files changed, 11490 insertions(+), 115 deletions(-)
 create mode 100644 Documentation/tracers/mmiotrace.txt
 create mode 100644 arch/arm/kernel/ftrace.c
 create mode 100644 arch/powerpc/kernel/ftrace.c
 create mode 100644 arch/sparc64/kernel/ftrace.c
 create mode 100644 arch/x86/kernel/ftrace.c
 create mode 100644 arch/x86/lib/thunk_32.S
 create mode 100644 arch/x86/mm/kmmio.c
 create mode 100644 arch/x86/mm/mmio-mod.c
 create mode 100644 arch/x86/mm/pf_in.c
 create mode 100644 arch/x86/mm/pf_in.h
 create mode 100644 arch/x86/mm/testmmiotrace.c
 create mode 100644 include/asm-arm/ftrace.h
 create mode 100644 include/asm-powerpc/ftrace.h
 create mode 100644 include/asm-sparc64/ftrace.h
 create mode 100644 include/asm-x86/ftrace.h
 create mode 100644 include/linux/ftrace.h
 create mode 100644 include/linux/mmiotrace.h
 create mode 100644 kernel/trace/Kconfig
 create mode 100644 kernel/trace/Makefile
 create mode 100644 kernel/trace/ftrace.c
 create mode 100644 kernel/trace/trace.c
 create mode 100644 kernel/trace/trace.h
 create mode 100644 kernel/trace/trace_functions.c
 create mode 100644 kernel/trace/trace_irqsoff.c
 create mode 100644 kernel/trace/trace_mmiotrace.c
 create mode 100644 kernel/trace/trace_sched_switch.c
 create mode 100644 kernel/trace/trace_sched_wakeup.c
 create mode 100644 kernel/trace/trace_selftest.c
 create mode 100644 kernel/trace/trace_selftest_dynamic.c
 create mode 100644 kernel/trace/trace_sysprof.c

