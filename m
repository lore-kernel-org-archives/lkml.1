Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbXJQUGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbXJQUGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763584AbXJQUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:06:11 -0400
Received: from www.tglx.de ([62.245.132.106]:33942 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763540AbXJQUGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:06:07 -0400
Date: Wed, 17 Oct 2007 22:05:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [Git pull] arch/x86 updates
Message-ID: <alpine.LFD.0.9999.0710172153490.24155@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git

This tree contains a 

- couple of fixups for the x86 merge fallout
- ~80 patches from -mm and ak
- the first chunk of cleanups

We have still ~20 patches pending, which we need to review in
depth. That's planned for tomorrow.

A full log, including the patches is available here:

  http://userweb.kernel.org/~tglx/git-x86-changes

Thanks,

	tglx


Adrian Bunk (7):
      i386: setup_trampoline() must be __cpuinit
      i386: make struct apic_probe static
      i386: make some variables static
      i386: es7000 minor cleanups
      i386: no need to make enable_cpu_hotplug a variable
      x86: rename .i assembler includes to .h
      x86: visws extern inline to static inline

Andi Kleen (9):
      x86: initialize 64bit registers for a.out executables
      x86_64: Fix compat emulation of PTRACE_GET/SET_THREAD_AREA
      x86: remove rogue default m in drivers/video/Kconfig
      x86_64: Remove serialize_cpu() inline
      x86: Some cleanups for pci gart code
      i386: Remove strrchr assembler implementation
      x86: clean up mce= argument parsing slightly
      x86: Use string instruction memcpy on AMD Fam11h
      x86: remove duplicated vsyscall nsec update

Andrew Hastings (1):
      x86: fix off-by-one in find_next_zero_string

Andrew Morton (2):
      x86: clean up apicid_to_node declaration
      x86: asm-i386/io.h fix constness

Andrey Mirkin (1):
      x86: return correct error code from child_rip in x86_64 entry.S

Avi Kivity (2):
      i386: simplify smp_call_function_single() call sequence in cpuid
      i386: simplify smp_call_function_single() call sequence in msr-on-cpu

Brian Gerst (1):
      x86: trivial header merges

Chris Snook (1):
      x86: make atomic64_t work like atomic_t

Chuck Lever (1):
      x86: Eliminate result signage problem in asm-x86_64/bitops.h

Denis V. Lunev (1):
      .gitignore update for x86 arch

Fengguang Wu (1):
      x86: call free_init_pages() with irqs enabled in alternative_instructions()

Glauber de Oliveira Costa (1):
      x86: remove STR() macros

H. Peter Anvin (1):
      x86: Create clflush() inline, remove hardcoded wbinvd

Huang, Ying (1):
      x86: NX bit handling in change_page_attr()

Ingo Molnar (6):
      x86: enable NMI watchdog on nosmp
      x86: do not crash on non-Geode PCs in TSC probe
      x86: prepare page allocator for high allocations on PAGEALLOC=y
      x86: fix CONFIG_PAGEALLOC related boot hangs/OOMs
      i386: print better early fault info
      i386: remove unnecessary code

James Bottomley (1):
      x86: voyager don't try to support uniprocessor builds

Jan Beulich (6):
      i386: avoid temporarily inconsistent pte-s
      x86: misc. constifications
      x86: constify stacktrace_ops
      i386: constify wd_ops
      x86: also show non-zero IRQ counts for vectors that currently don't have a handler
      x86: multi-byte single instruction NOPs

Jesper Juhl (2):
      i386: Clean up duplicate includes in arch/i386/kernel/
      i386: Clean up duplicate includes in arch/i386/xen/

Joe Korty (1):
      x86: expand /proc/interrupts to include missing vectors, v2

Kirill Korotaev (1):
      x86: mark read_crX() asm code as volatile

Laurent Vivier (1):
      i386: export i386 smp_call_function_mask() to modules

Luiz Fernando N. Capitulino (2):
      x86: convert mm_context_t semaphore to a mutex
      x86: convert mm_context_t semaphore to a mutex

Mariusz Kozlowski (1):
      x86: kmalloc + memset conversion to kzalloc

Michal Schmidt (1):
      x86: pci use pci=bfsort for HP DL385 G2 and DL585 G2

Mike Frysinger (1):
      x86: hide cond_syscall behind __KERNEL__

Mike Travis (2):
      x86: remove x86_cpu_to_log_apicid
      x86: fix cpu_to_node references

Muli Ben-Yehuda (2):
      x86: Calgary: fix disable busnum for CalIOC2
      x86: calgary get rid of translate_phb

Oliver Pinter (1):
      x86: add cpu codenames for Kconfig.cpu

Pavel Emelyanov (1):
      i386: clean up oops/bug reports

Prarit Bhargava (1):
      x86: stop nmi softlockup warnings in show_mem()

Roland Dreier (1):
      x86: merge some trivially mergeable headers

Roland McGrath (4):
      x86_64: install unstripped copies of compat vdso on disk
      x86: Install unstripped copy of 64bit vdso to disk
      x86: vdso put vars in rodata
      x86: vdso linker script cleanup

Sam Ravnborg (2):
      i386: fix section mismatch warning in intel.c
      x86: fix kernel rebuild due to vsyscall fallout

Satyam Sharma (6):
      i386: Fix section mismatch
      x86: intel_cacheinfo misc section annotation fixes
      i386: Misc cpuinit annotations
      i386: misc cpuinit annotations
      i386: fix argument signedness warnings
      x86: call cache_add_dev() from cache_sysfs_init() explicitly

Siddha, Suresh B (1):
      i386: fix 4 bit apicid assumption of mach-default

Stefan Richter (1):
      x86: configure HPET_EMULATE_RTC automatically

Stephane Eranian (1):
      i386: make Oprofile call shutdown() only once per session

Steven Rostedt (1):
      x86: Add parenthesis to IRQ vector macros

Thomas Gleixner (31):
      x86: C1E late detection fix. Really switch off lapic timer
      x86: remove reminder of i386 irqstat per cpu conversion
      x86: clean up struct irqaction initializers
      x86: more struct irqaction initializer cleanups
      x86: cleanup 64bit unistd.h
      x86: unify include/asm/mce_32/64.h
      x86: unify include/asm/ptrace-abi_32/64.h
      x86: unify include/asm/ldt_32/64.h
      x86: fix dmi const-ify fallout
      x86: print info about late C1E detection on 32bit as well
      x86: unify some more trivial include/asm-x86/ 32/64 variants
      x86: unify include/asm/agp_32/64.h
      x86: unify include/asm/auxvec_32/64.h
      x86: unify include/asm/cacheflush_32/64.h
      x86: unify include/asm/cache_32/64.h
      x86: unify include/asm/delay_32/64.h
      x86: unify include/asm/dmi_32/64.h
      x86: unify include/asm/cache_32/64.h
      x86: unify include/asm/cache_32/64.h
      x86: apply missing DMA/OOM prevention to floppy_32.h
      x86: unify include/asm/floppy_32/64.h
      x86: unify include/asm/ioctls_32/64.h
      x86: unify include/asm/kdebug_32/64.h
      x86: unify include/asm/agp_32/64.h
      x86: unify include/asm/mman_32/64.h
      x86: unify include/asm/bug_32/64.h
      x86: unify include/asm/siginfo_32/64.h
      x86: unify include/asm/tlb_32/64.h
      x86: unify include/asm/types_32/64.h
      x86: unify include/asm/unwind_32/64.h
      x86: unify include/asm/debugreg_32/64.h

Yinghai Lu (3):
      x86: use dev_to_node() to get node for device in dma_alloc_pages()
      x86: make io_apic not connected pin print complete
      kbuild: fix typo SRCARCH in find_sources

Yoann Padioleau (1):
      x86: 0 -> NULL, for arch/x86_64

akpm@linux-foundation.org (1):
      i386: Remove local CPU logic in MTRR call to smp_call_function_single

 .gitignore                                         |    1 +
 Documentation/filesystems/proc.txt                 |   30 +-
 Documentation/kernel-parameters.txt                |    2 +
 Makefile                                           |    8 +-
 arch/i386/.gitignore                               |    1 +
 arch/i386/Kconfig                                  |    1 +
 arch/i386/Kconfig.cpu                              |   36 +-
 arch/x86/ia32/Makefile                             |   25 +-
 arch/x86/ia32/ia32_aout.c                          |    2 +
 arch/x86/ia32/ia32_binfmt.c                        |    5 +-
 arch/x86/ia32/ptrace32.c                           |   10 +-
 arch/x86/kernel/.gitignore                         |    1 +
 arch/x86/kernel/Makefile_32                        |    2 +-
 arch/x86/kernel/alternative.c                      |   61 ++-
 arch/x86/kernel/apic_32.c                          |    1 +
 arch/x86/kernel/apic_64.c                          |    4 +-
 arch/x86/kernel/cpu/amd.c                          |   15 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c          |    2 +-
 arch/x86/kernel/cpu/intel.c                        |   17 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   15 +-
 arch/x86/kernel/cpu/mcheck/p4.c                    |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |    8 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c             |   14 +-
 arch/x86/kernel/cpuid.c                            |   28 +-
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/kernel/genapic_64.c                       |    2 -
 arch/x86/kernel/genapic_flat_64.c                  |    1 -
 arch/x86/kernel/head_32.S                          |   21 +-
 arch/x86/kernel/i386_ksyms_32.c                    |    1 +
 arch/x86/kernel/i8259_32.c                         |    6 +-
 arch/x86/kernel/i8259_64.c                         |    6 +-
 arch/x86/kernel/io_apic_32.c                       |    5 +
 arch/x86/kernel/io_apic_64.c                       |   11 +-
 arch/x86/kernel/irq_32.c                           |   49 ++-
 arch/x86/kernel/irq_64.c                           |   48 ++-
 arch/x86/kernel/ldt_32.c                           |   14 +-
 arch/x86/kernel/ldt_64.c                           |   14 +-
 arch/x86/kernel/mce_64.c                           |    4 +-
 arch/x86/kernel/mce_amd_64.c                       |    1 +
 arch/x86/kernel/mce_intel_64.c                     |    1 +
 arch/x86/kernel/msr.c                              |    4 +-
 arch/x86/kernel/pci-calgary_64.c                   |   41 +-
 arch/x86/kernel/pci-dma_32.c                       |    1 -
 arch/x86/kernel/pci-dma_64.c                       |    8 +-
 arch/x86/kernel/pci-gart_64.c                      |    4 +-
 arch/x86/kernel/ptrace_32.c                        |    4 +-
 arch/x86/kernel/ptrace_64.c                        |    4 +-
 arch/x86/kernel/setup_64.c                         |    6 +-
 arch/x86/kernel/signal_32.c                        |    2 -
 arch/x86/kernel/smp_32.c                           |   10 +
 arch/x86/kernel/smp_64.c                           |    3 +
 arch/x86/kernel/smpboot_32.c                       |   12 +-
 arch/x86/kernel/smpboot_64.c                       |    5 +-
 arch/x86/kernel/stacktrace.c                       |    2 +-
 arch/x86/kernel/tce_64.c                           |    4 +-
 arch/x86/kernel/topology.c                         |    6 +-
 arch/x86/kernel/trampoline_32.S                    |    4 +-
 arch/x86/kernel/trampoline_64.S                    |    7 +-
 arch/x86/kernel/traps_32.c                         |   37 +-
 arch/x86/kernel/traps_64.c                         |    4 +-
 arch/x86/kernel/tsc_32.c                           |    6 +-
 arch/x86/kernel/vsyscall_64.c                      |    3 +-
 arch/x86/lib/bitstr_64.c                           |    2 +-
 arch/x86/lib/msr-on-cpu.c                          |   62 +--
 arch/x86/lib/rwlock_64.S                           |    2 +-
 arch/x86/lib/semaphore_32.S                        |    4 +-
 arch/x86/lib/string_32.c                           |   20 -
 arch/x86/mach-default/setup.c                      |    6 +-
 arch/x86/mach-es7000/es7000plat.c                  |   32 +-
 arch/x86/mach-generic/probe.c                      |    2 +-
 arch/x86/mach-voyager/setup.c                      |    6 +-
 arch/x86/mach-voyager/voyager_smp.c                |    5 +-
 arch/x86/mm/discontig_32.c                         |   10 +-
 arch/x86/mm/fault_32.c                             |   17 +-
 arch/x86/mm/init_32.c                              |   11 +-
 arch/x86/mm/numa_64.c                              |    6 +-
 arch/x86/mm/pageattr_32.c                          |    4 +-
 arch/x86/mm/pageattr_64.c                          |    3 +-
 arch/x86/mm/pgtable_32.c                           |    6 +-
 arch/x86/mm/srat_64.c                              |    4 +-
 arch/x86/oprofile/nmi_int.c                        |    2 +-
 arch/x86/pci/common.c                              |   16 +
 arch/x86/vdso/Makefile                             |   17 +-
 arch/x86/vdso/vdso.lds.S                           |   16 +-
 arch/x86/vdso/vvar.c                               |    2 +-
 arch/x86/xen/enlighten.c                           |    1 -
 arch/x86/xen/mmu.c                                 |    1 -
 arch/x86/xen/smp.c                                 |    1 +
 arch/x86_64/Kconfig                                |   14 +-
 arch/x86_64/Makefile                               |    8 +-
 drivers/char/agp/efficeon-agp.c                    |   11 +-
 drivers/video/Kconfig                              |    1 -
 .../{alternative-asm.i => alternative-asm.h}       |    2 +-
 include/asm-um/{frame.i => frame.h}                |    2 +-
 include/asm-x86/Kbuild                             |   36 --
 include/asm-x86/agp.h                              |   43 ++-
 include/asm-x86/agp_32.h                           |   36 --
 include/asm-x86/agp_64.h                           |   34 --
 include/asm-x86/alternative-asm.h                  |   22 +
 include/asm-x86/alternative-asm.i                  |    5 -
 include/asm-x86/alternative-asm_32.i               |   12 -
 include/asm-x86/alternative-asm_64.i               |   12 -
 include/asm-x86/atomic_64.h                        |    2 +-
 include/asm-x86/auxvec.h                           |   23 +-
 include/asm-x86/auxvec_32.h                        |   11 -
 include/asm-x86/auxvec_64.h                        |    6 -
 include/asm-x86/bitops_64.h                        |    2 +-
 include/asm-x86/bug.h                              |   41 ++-
 include/asm-x86/bug_32.h                           |   37 --
 include/asm-x86/bug_64.h                           |   34 --
 include/asm-x86/bugs.h                             |   11 +-
 include/asm-x86/bugs_32.h                          |   12 -
 include/asm-x86/bugs_64.h                          |    6 -
 include/asm-x86/cache.h                            |   23 +-
 include/asm-x86/cache_32.h                         |   14 -
 include/asm-x86/cache_64.h                         |   26 -
 include/asm-x86/cacheflush.h                       |   43 ++-
 include/asm-x86/cacheflush_32.h                    |   39 --
 include/asm-x86/cacheflush_64.h                    |   35 --
 include/asm-x86/cpu.h                              |    3 -
 include/asm-x86/cputime.h                          |    6 +-
 include/asm-x86/cputime_32.h                       |    6 -
 include/asm-x86/cputime_64.h                       |    6 -
 include/asm-x86/debugreg.h                         |   79 +++-
 include/asm-x86/debugreg_32.h                      |   64 --
 include/asm-x86/debugreg_64.h                      |   65 --
 include/asm-x86/delay.h                            |   36 +-
 include/asm-x86/delay_32.h                         |   31 -
 include/asm-x86/delay_64.h                         |   30 -
 include/asm-x86/device.h                           |   13 +-
 include/asm-x86/device_32.h                        |   15 -
 include/asm-x86/device_64.h                        |   15 -
 include/asm-x86/dmi.h                              |   36 +-
 include/asm-x86/dmi_32.h                           |   11 -
 include/asm-x86/dmi_64.h                           |   24 -
 include/asm-x86/edac.h                             |   21 +-
 include/asm-x86/edac_32.h                          |   18 -
 include/asm-x86/edac_64.h                          |   18 -
 include/asm-x86/errno.h                            |   14 +-
 include/asm-x86/errno_32.h                         |    6 -
 include/asm-x86/errno_64.h                         |    6 -
 include/asm-x86/fb.h                               |   20 +-
 include/asm-x86/fb_32.h                            |   17 -
 include/asm-x86/fb_64.h                            |   19 -
 include/asm-x86/floppy.h                           |  281 +++++++++-
 include/asm-x86/floppy_32.h                        |  280 ---------
 include/asm-x86/floppy_64.h                        |  279 ---------
 include/asm-x86/{frame.i => frame.h}               |    4 +
 include/asm-x86/hardirq_32.h                       |    6 +-
 include/asm-x86/hw_irq_64.h                        |   35 +-
 include/asm-x86/intel_arch_perfmon.h               |   36 +-
 include/asm-x86/intel_arch_perfmon_32.h            |   31 -
 include/asm-x86/intel_arch_perfmon_64.h            |   31 -
 include/asm-x86/io_32.h                            |   17 +-
 include/asm-x86/ioctls.h                           |   98 +++-
 include/asm-x86/ioctls_32.h                        |   87 ---
 include/asm-x86/ioctls_64.h                        |   86 ---
 include/asm-x86/ipcbuf.h                           |   42 +-
 include/asm-x86/ipcbuf_32.h                        |   29 -
 include/asm-x86/ipcbuf_64.h                        |   29 -
 include/asm-x86/kdebug.h                           |   36 +-
 include/asm-x86/kdebug_32.h                        |   27 -
 include/asm-x86/kdebug_64.h                        |   32 -
 include/asm-x86/kmap_types.h                       |   30 +-
 include/asm-x86/kmap_types_32.h                    |   30 -
 include/asm-x86/kmap_types_64.h                    |   19 -
 include/asm-x86/ldt.h                              |   51 ++-
 include/asm-x86/ldt_32.h                           |   32 -
 include/asm-x86/ldt_64.h                           |   36 --
 include/asm-x86/mach-default/mach_apicdef.h        |    8 +-
 include/asm-x86/mach-visws/cobalt.h                |    8 +-
 include/asm-x86/mach-visws/lithium.h               |    8 +-
 include/asm-x86/mce.h                              |  128 ++++-
 include/asm-x86/mce_32.h                           |   11 -
 include/asm-x86/mce_64.h                           |  115 ----
 include/asm-x86/mman.h                             |   32 +-
 include/asm-x86/mman_32.h                          |   17 -
 include/asm-x86/mman_64.h                          |   19 -
 include/asm-x86/mmu_32.h                           |    4 +-
 include/asm-x86/mmu_64.h                           |    4 +-
 include/asm-x86/namei.h                            |   16 +-
 include/asm-x86/namei_32.h                         |   17 -
 include/asm-x86/namei_64.h                         |   11 -
 include/asm-x86/numa_64.h                          |    3 +-
 include/asm-x86/param.h                            |   31 +-
 include/asm-x86/param_32.h                         |   22 -
 include/asm-x86/param_64.h                         |   22 -
 include/asm-x86/parport.h                          |   15 +-
 include/asm-x86/parport_32.h                       |   18 -
 include/asm-x86/parport_64.h                       |   18 -
 include/asm-x86/pda.h                              |    6 +
 include/asm-x86/processor_32.h                     |   31 +-
 include/asm-x86/processor_64.h                     |   27 +-
 include/asm-x86/ptrace-abi.h                       |   90 +++-
 include/asm-x86/ptrace-abi_32.h                    |   39 --
 include/asm-x86/ptrace-abi_64.h                    |   51 --
 include/asm-x86/resource.h                         |   14 +-
 include/asm-x86/resource_32.h                      |    6 -
 include/asm-x86/resource_64.h                      |    6 -
 include/asm-x86/rtc.h                              |    6 +-
 include/asm-x86/rtc_32.h                           |   10 -
 include/asm-x86/rtc_64.h                           |   10 -
 include/asm-x86/rwlock.h                           |   14 +-
 include/asm-x86/rwlock_32.h                        |   25 -
 include/asm-x86/rwlock_64.h                        |   26 -
 include/asm-x86/sections.h                         |    6 +-
 include/asm-x86/sections_32.h                      |    7 -
 include/asm-x86/sections_64.h                      |    7 -
 include/asm-x86/sembuf.h                           |   37 +-
 include/asm-x86/sembuf_32.h                        |   25 -
 include/asm-x86/sembuf_64.h                        |   25 -
 include/asm-x86/serial.h                           |   30 +-
 include/asm-x86/serial_32.h                        |   29 -
 include/asm-x86/serial_64.h                        |   29 -
 include/asm-x86/shmparam.h                         |   19 +-
 include/asm-x86/shmparam_32.h                      |    6 -
 include/asm-x86/shmparam_64.h                      |    6 -
 include/asm-x86/siginfo.h                          |   21 +-
 include/asm-x86/siginfo_32.h                       |    6 -
 include/asm-x86/siginfo_64.h                       |    8 -
 include/asm-x86/smp_32.h                           |    9 +-
 include/asm-x86/smp_64.h                           |    1 -
 include/asm-x86/sockios.h                          |   26 +-
 include/asm-x86/sockios_32.h                       |   13 -
 include/asm-x86/sockios_64.h                       |   13 -
 include/asm-x86/stacktrace.h                       |    2 +-
 include/asm-x86/string_32.h                        |    3 -
 include/asm-x86/system_32.h                        |    6 +-
 include/asm-x86/system_64.h                        |   16 +-
 include/asm-x86/termbits.h                         |  211 +++++++-
 include/asm-x86/termbits_32.h                      |  198 -------
 include/asm-x86/termbits_64.h                      |  198 -------
 include/asm-x86/termios.h                          |  108 +++-
 include/asm-x86/termios_32.h                       |   90 ---
 include/asm-x86/termios_64.h                       |   90 ---
 include/asm-x86/tlb.h                              |   14 +-
 include/asm-x86/tlb_32.h                           |   20 -
 include/asm-x86/tlb_64.h                           |   13 -
 include/asm-x86/types.h                            |   77 +++-
 include/asm-x86/types_32.h                         |   64 --
 include/asm-x86/types_64.h                         |   55 --
 include/asm-x86/ucontext.h                         |   25 +-
 include/asm-x86/ucontext_32.h                      |   12 -
 include/asm-x86/ucontext_64.h                      |   12 -
 include/asm-x86/unaligned.h                        |   42 ++-
 include/asm-x86/unaligned_32.h                     |   37 --
 include/asm-x86/unaligned_64.h                     |   37 --
 include/asm-x86/unistd_64.h                        |  619 ++++++++++----------
 include/asm-x86/unwind.h                           |   18 +-
 include/asm-x86/unwind_32.h                        |   13 -
 include/asm-x86/unwind_64.h                        |   12 -
 kernel/time/tick-broadcast.c                       |   18 +-
 253 files changed, 2684 insertions(+), 4296 deletions(-)
 create mode 100644 arch/i386/.gitignore
 rename include/asm-um/{alternative-asm.i => alternative-asm.h} (65%)
 rename include/asm-um/{frame.i => frame.h} (65%)
 delete mode 100644 include/asm-x86/agp_32.h
 delete mode 100644 include/asm-x86/agp_64.h
 create mode 100644 include/asm-x86/alternative-asm.h
 delete mode 100644 include/asm-x86/alternative-asm.i
 delete mode 100644 include/asm-x86/alternative-asm_32.i
 delete mode 100644 include/asm-x86/alternative-asm_64.i
 delete mode 100644 include/asm-x86/auxvec_32.h
 delete mode 100644 include/asm-x86/auxvec_64.h
 delete mode 100644 include/asm-x86/bug_32.h
 delete mode 100644 include/asm-x86/bug_64.h
 delete mode 100644 include/asm-x86/bugs_32.h
 delete mode 100644 include/asm-x86/bugs_64.h
 delete mode 100644 include/asm-x86/cache_32.h
 delete mode 100644 include/asm-x86/cache_64.h
 delete mode 100644 include/asm-x86/cacheflush_32.h
 delete mode 100644 include/asm-x86/cacheflush_64.h
 delete mode 100644 include/asm-x86/cputime_32.h
 delete mode 100644 include/asm-x86/cputime_64.h
 delete mode 100644 include/asm-x86/debugreg_32.h
 delete mode 100644 include/asm-x86/debugreg_64.h
 delete mode 100644 include/asm-x86/delay_32.h
 delete mode 100644 include/asm-x86/delay_64.h
 delete mode 100644 include/asm-x86/device_32.h
 delete mode 100644 include/asm-x86/device_64.h
 delete mode 100644 include/asm-x86/dmi_32.h
 delete mode 100644 include/asm-x86/dmi_64.h
 delete mode 100644 include/asm-x86/edac_32.h
 delete mode 100644 include/asm-x86/edac_64.h
 delete mode 100644 include/asm-x86/errno_32.h
 delete mode 100644 include/asm-x86/errno_64.h
 delete mode 100644 include/asm-x86/fb_32.h
 delete mode 100644 include/asm-x86/fb_64.h
 delete mode 100644 include/asm-x86/floppy_32.h
 delete mode 100644 include/asm-x86/floppy_64.h
 rename include/asm-x86/{frame.i => frame.h} (90%)
 delete mode 100644 include/asm-x86/intel_arch_perfmon_32.h
 delete mode 100644 include/asm-x86/intel_arch_perfmon_64.h
 delete mode 100644 include/asm-x86/ioctls_32.h
 delete mode 100644 include/asm-x86/ioctls_64.h
 delete mode 100644 include/asm-x86/ipcbuf_32.h
 delete mode 100644 include/asm-x86/ipcbuf_64.h
 delete mode 100644 include/asm-x86/kdebug_32.h
 delete mode 100644 include/asm-x86/kdebug_64.h
 delete mode 100644 include/asm-x86/kmap_types_32.h
 delete mode 100644 include/asm-x86/kmap_types_64.h
 delete mode 100644 include/asm-x86/ldt_32.h
 delete mode 100644 include/asm-x86/ldt_64.h
 delete mode 100644 include/asm-x86/mce_32.h
 delete mode 100644 include/asm-x86/mce_64.h
 delete mode 100644 include/asm-x86/mman_32.h
 delete mode 100644 include/asm-x86/mman_64.h
 delete mode 100644 include/asm-x86/namei_32.h
 delete mode 100644 include/asm-x86/namei_64.h
 delete mode 100644 include/asm-x86/param_32.h
 delete mode 100644 include/asm-x86/param_64.h
 delete mode 100644 include/asm-x86/parport_32.h
 delete mode 100644 include/asm-x86/parport_64.h
 delete mode 100644 include/asm-x86/ptrace-abi_32.h
 delete mode 100644 include/asm-x86/ptrace-abi_64.h
 delete mode 100644 include/asm-x86/resource_32.h
 delete mode 100644 include/asm-x86/resource_64.h
 delete mode 100644 include/asm-x86/rtc_32.h
 delete mode 100644 include/asm-x86/rtc_64.h
 delete mode 100644 include/asm-x86/rwlock_32.h
 delete mode 100644 include/asm-x86/rwlock_64.h
 delete mode 100644 include/asm-x86/sections_32.h
 delete mode 100644 include/asm-x86/sections_64.h
 delete mode 100644 include/asm-x86/sembuf_32.h
 delete mode 100644 include/asm-x86/sembuf_64.h
 delete mode 100644 include/asm-x86/serial_32.h
 delete mode 100644 include/asm-x86/serial_64.h
 delete mode 100644 include/asm-x86/shmparam_32.h
 delete mode 100644 include/asm-x86/shmparam_64.h
 delete mode 100644 include/asm-x86/siginfo_32.h
 delete mode 100644 include/asm-x86/siginfo_64.h
 delete mode 100644 include/asm-x86/sockios_32.h
 delete mode 100644 include/asm-x86/sockios_64.h
 delete mode 100644 include/asm-x86/termbits_32.h
 delete mode 100644 include/asm-x86/termbits_64.h
 delete mode 100644 include/asm-x86/termios_32.h
 delete mode 100644 include/asm-x86/termios_64.h
 delete mode 100644 include/asm-x86/tlb_32.h
 delete mode 100644 include/asm-x86/tlb_64.h
 delete mode 100644 include/asm-x86/types_32.h
 delete mode 100644 include/asm-x86/types_64.h
 delete mode 100644 include/asm-x86/ucontext_32.h
 delete mode 100644 include/asm-x86/ucontext_64.h
 delete mode 100644 include/asm-x86/unaligned_32.h
 delete mode 100644 include/asm-x86/unaligned_64.h
 delete mode 100644 include/asm-x86/unwind_32.h
 delete mode 100644 include/asm-x86/unwind_64.h
