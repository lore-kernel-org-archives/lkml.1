Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXBMMl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXBMMl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXBMMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:41:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39392 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXBMMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:41:27 -0500
From: Andi Kleen <andi@firstfloor.org>
Organization: -
To: torvalds@osdl.org
Subject: Please pull x86 updates
Date: Tue, 13 Feb 2007 13:40:56 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131340.57004.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linux please pull from

  git://one.firstfloor.org/home/andi/git/linux-2.6

This is not all, but I pruned lots of stuff that still wasn't
quite ready. Less is more I guess.


Adrian Bunk:
      i386: arch/i386/kernel/e820.c should #include <asm/setup.h
      i386: arch/i386/kernel/cpu/mcheck/mce.c should #include <asm/mce.h>

Alan:
      i386: Fix Cyrix MediaGX detection

Alexey Dobriyan:
      i386: use smp_call_function_single()
      i386: use smp_call_function_single()
      i386: Convert /proc/apm to seqfile

Amul Shah:
      x86-64: Allocate the NUMA hash function nodemap dynamically
      x86-64: x86_64-make-the-numa-hash-function-nodemap-allocation fix fix

Andi Kleen:
      x86-64: Update defconfig
      i386: Update defconfig
      x86-64: Add __copy_from_user_nocache
      x86-64: Allow to run a program when a machine check event is detected
      i386: Small cleanup to TLB flush code
      x86-64: Check return value of putreg in PTRACE_SETREGS
      x86-64: Unexport __supported_pte_mask
      x86-64: Fix off by one error in IOMMU boundary checking
      x86-64: Don't reserve ROMs
      x86-64: Fix wrong gcc check in bitops.h
      i386: Remove fastcall in paravirt.[ch]
      x86: Add new CPUID bits for AMD Family 10 CPUs in /proc/cpuinfo
      x86: Enable NMI watchdog for AMD Family 0x10 CPUs
      i386: Fix warning in microcode.c
      i386: Fix warning in cpu initialization
      x86: Don't require the vDSO for handling a.out signals
      x86: Unify pcspeaker platform device code between i386/x86-64
      x86-64: Remove mk_pte_phys()

Andreas Herrmann:
      i386: fix size_or_mask and size_and_mask

Benjamin Romer:
      x86-64: update IO-APIC dest field to 8-bit for xAPIC

Bob Picco:
      x86-64: clean up sparsemem memory_present call

Catalin Marinas:
      x86-64: do not always end the stack trace with ULONG_MAX

Chuck Ebbert:
      i386: add option to show more code in oops reports

Eric Dumazet:
      x86-64: get rid of ARCH_HAVE_XTIME_LOCK

Eric W. Biederman:
      x86-64: survive having no irq mapping for a vector

Evgeniy Polyakov:
      x86-64: Minor patch for compilation warning in x86_64 signal code

Giuliano Procida:
      i386: fix 32-bit ioctls on x64_32

Glauber de Oliveira Costa:
      x86-64: Remove fastcall references in x86_64 code
      x86-64: Use constant instead of raw number in x86_64 ioperm.c

H. Peter Anvin:
      i386: All Transmeta CPUs have constant TSCs

Ingo Molnar:
      i386: improve sched_clock() on i686
      x86: fix laptop bootup hang in init_acpi()

Jack Steiner:
      x86-64: - Ignore long SMI interrupts in clock calibration code - update 1

Jan Beulich:
      x86: simplify notify_page_fault()
      x86-64: Tighten mce_amd driver MSR reads
      x86-64: remove get_pmd()
      i386: entry.S END/ENDPROC annotations
      i386: Fix broken CONFIG_COMPAT_VDSO on i386

Jeff Garzik:
      x86-64: define dma noncoherent API functions

Jeremy Fitzhardinge:
      i386: Convert i386 PDA code to use %fs

Josef 'Jeff' Sipek:
      x86-64: Fix preprocessor condition

Karsten Weiss:
      x86-64: improved iommu documentation

Maciej W. Rozycki:
      i386: Fix a typo in an IRQ handler name

Muli Ben-Yehuda:
      x86-64: robustify bad_dma_address handling

Nicolas Kaiser:
      x86-64: Kconfig typos

OGAWA Hirofumi:
      mmconfig: Fix x86_64 ioremap base_address
      mmconfig: Reject a broken MCFG tables on Asus etc
      mmconfig: remove #define MMCONFIG_APER_XXX
      mmconfig: minor cleanup in mmconfig code
      mmconfig: fix unreachable_devices()
      mmconfig: Move e820 check into pci_mmcfg_reject_broken()

Olivier Galibert:
      mmconfig: Share parts of mmconfig code between i386 and x86-64
      i386: Only call unreachable_devices() when type 1 is available.
      mmconfig: Detect and support the E7520 and the 945G/GZ/P/PL
      mmconfig: Reserve resources but only when we're sure about them.

Ralf Baechle:
      x86_64: Wire up compat epoll_pwait

Randy Dunlap:
      x86-64: cleanup Doc/x86_64/ files
      x86-64: list x86_64 quilt tree
      i386: avoid gcc extension

Rene Herman:
      i386: romsignature/checksum cleanup

Robert P. J. Day:
      i386: Remove unused kernel config option X86_XADD

Rohit Seth:
      x86-64: Fix fake numa for x86_64 machines with big IO hole

Roland Dreier:
      x86-64: avoid warning message livelock

Rusty Russell:
      i386: paravirt unhandled fallthrough
      i386: Move mce_disabled to asm/mce.h
      i386: Rename cpu_gdt_descr and remove extern declaration from smpboot.c
      i386: Remove extern declaration from mm/discontig.c, put in header.

Stephane Eranian:
      i386: add idle notifier

takada:
      i386: support Classic MediaGXm

TAKADA Yoshihito:
      i386: geode configuration fixes

Venkatesh Pallipadi:
      x86-64: Handle 32 bit PerfMon Counter writes cleanly in x86_64 nmi_watchdog
      i386: Handle 32 bit PerfMon Counter writes cleanly in i386 nmi_watchdog
      i386: Handle 32 bit PerfMon Counter writes cleanly in oprofile

Vivek Goyal:
      i386: move startup_32() in text.head section
      generic: Break init() in two parts to avoid MODPOST warnings

Zachary Amsden:
      MM: page allocation hooks for VMI backend
      i386: paravirt CPU hypercall batching mode
      i386: iOPL handling for paravirt guests
      i386: SMP boot hook for paravirt
      i386: vMI backend for paravirt-ops
      i386: vMI timer patches
      i386: Profile pc badness
      i386: Kprobe rpl fix
      i386: Vmi timer race
      i386: Paravirt debug defaults off
      x86-64: x86_64 - Fix FS/GS registers for VT execution

 Documentation/kernel-parameters.txt   |    8 
 Documentation/x86_64/boot-options.txt |  132 +++--
 Documentation/x86_64/cpu-hotplug-spec |    2 
 Documentation/x86_64/kernel-stacks    |   26 -
 Documentation/x86_64/machinecheck     |   70 ++
 Documentation/x86_64/mm.txt           |   22 -
 MAINTAINERS                           |    1 
 arch/i386/Kconfig                     |   18 +
 arch/i386/Kconfig.cpu                 |    5 
 arch/i386/Kconfig.debug               |    2 
 arch/i386/defconfig                   |   51 +-
 arch/i386/kernel/Makefile             |    3 
 arch/i386/kernel/apic.c               |    6 
 arch/i386/kernel/apm.c                |   26 +
 arch/i386/kernel/asm-offsets.c        |    2 
 arch/i386/kernel/cpu/common.c         |   14 
 arch/i386/kernel/cpu/cyrix.c          |   52 +-
 arch/i386/kernel/cpu/mcheck/mce.c     |    1 
 arch/i386/kernel/cpu/mcheck/mce.h     |    2 
 arch/i386/kernel/cpu/mcheck/p4.c      |    2 
 arch/i386/kernel/cpu/mtrr/if.c        |   30 +
 arch/i386/kernel/cpu/mtrr/main.c      |    6 
 arch/i386/kernel/cpu/mtrr/mtrr.h      |    2 
 arch/i386/kernel/cpu/proc.c           |   14 
 arch/i386/kernel/cpu/transmeta.c      |    5 
 arch/i386/kernel/cpuid.c              |    7 
 arch/i386/kernel/e820.c               |   18 -
 arch/i386/kernel/entry.S              |   78 ++-
 arch/i386/kernel/head.S               |   38 +
 arch/i386/kernel/io_apic.c            |    4 
 arch/i386/kernel/irq.c                |    3 
 arch/i386/kernel/kprobes.c            |    6 
 arch/i386/kernel/microcode.c          |    2 
 arch/i386/kernel/msr.c                |   13 
 arch/i386/kernel/nmi.c                |   98 +++
 arch/i386/kernel/paravirt.c           |  116 ++--
 arch/i386/kernel/pcspeaker.c          |   20 +
 arch/i386/kernel/process.c            |   99 +++
 arch/i386/kernel/ptrace.c             |   16 -
 arch/i386/kernel/setup.c              |   35 -
 arch/i386/kernel/signal.c             |   16 -
 arch/i386/kernel/smp.c                |    7 
 arch/i386/kernel/smpboot.c            |   16 -
 arch/i386/kernel/sysenter.c           |    2 
 arch/i386/kernel/time.c               |   14 
 arch/i386/kernel/traps.c              |   27 +
 arch/i386/kernel/tsc.c                |   26 +
 arch/i386/kernel/vm86.c               |   33 +
 arch/i386/kernel/vmi.c                |  949 +++++++++++++++++++++++++++++++++
 arch/i386/kernel/vmitime.c            |  499 +++++++++++++++++
 arch/i386/kernel/vmlinux.lds.S        |    7 
 arch/i386/math-emu/get_address.c      |   14 
 arch/i386/math-emu/status_w.h         |    8 
 arch/i386/mm/discontig.c              |    1 
 arch/i386/mm/fault.c                  |   18 -
 arch/i386/mm/init.c                   |    4 
 arch/i386/mm/pageattr.c               |    2 
 arch/i386/mm/pgtable.c                |   26 +
 arch/i386/oprofile/op_model_ppro.c    |    9 
 arch/i386/pci/Makefile                |    2 
 arch/i386/pci/mmconfig-shared.c       |  264 +++++++++
 arch/i386/pci/mmconfig.c              |   96 ---
 arch/i386/pci/pci.h                   |   10 
 arch/x86_64/Kconfig                   |   22 -
 arch/x86_64/defconfig                 |   45 +-
 arch/x86_64/ia32/ia32_signal.c        |   11 
 arch/x86_64/ia32/ia32entry.S          |    1 
 arch/x86_64/kernel/Makefile           |    2 
 arch/x86_64/kernel/acpi/sleep.c       |    2 
 arch/x86_64/kernel/e820.c             |   38 +
 arch/x86_64/kernel/head.S             |   20 -
 arch/x86_64/kernel/io_apic.c          |   24 -
 arch/x86_64/kernel/ioport.c           |    2 
 arch/x86_64/kernel/irq.c              |   12 
 arch/x86_64/kernel/mce.c              |   66 ++
 arch/x86_64/kernel/mce_amd.c          |   44 +-
 arch/x86_64/kernel/nmi.c              |   75 ++-
 arch/x86_64/kernel/pci-calgary.c      |   17 +
 arch/x86_64/kernel/pci-dma.c          |   28 -
 arch/x86_64/kernel/pci-gart.c         |    4 
 arch/x86_64/kernel/ptrace.c           |    8 
 arch/x86_64/kernel/setup.c            |  169 +-----
 arch/x86_64/kernel/setup64.c          |    1 
 arch/x86_64/kernel/stacktrace.c       |    5 
 arch/x86_64/kernel/time.c             |   14 
 arch/x86_64/kernel/x8664_ksyms.c      |    5 
 arch/x86_64/lib/Makefile              |    2 
 arch/x86_64/lib/copy_user_nocache.S   |  217 ++++++++
 arch/x86_64/mm/fault.c                |   18 -
 arch/x86_64/mm/numa.c                 |  202 ++++++-
 arch/x86_64/mm/pageattr.c             |    4 
 arch/x86_64/pci/Makefile              |    3 
 arch/x86_64/pci/mmconfig.c            |  116 +---
 drivers/acpi/namespace/nsinit.c       |    9 
 drivers/kvm/vmx.c                     |   12 
 fs/binfmt_elf.c                       |    3 
 include/asm-generic/pgtable.h         |   13 
 include/asm-i386/apic.h               |    2 
 include/asm-i386/bugs.h               |    2 
 include/asm-i386/desc.h               |    2 
 include/asm-i386/elf.h                |    4 
 include/asm-i386/idle.h               |   14 
 include/asm-i386/mce.h                |    2 
 include/asm-i386/mmu_context.h        |    2 
 include/asm-i386/paravirt.h           |  168 ++++--
 include/asm-i386/pda.h                |   12 
 include/asm-i386/pgalloc.h            |   30 +
 include/asm-i386/processor.h          |   14 
 include/asm-i386/ptrace.h             |    8 
 include/asm-i386/segment.h            |   19 -
 include/asm-i386/setup.h              |    2 
 include/asm-i386/smp.h                |    5 
 include/asm-i386/time.h               |    1 
 include/asm-i386/timer.h              |    3 
 include/asm-i386/vmi.h                |  262 +++++++++
 include/asm-i386/vmi_time.h           |  103 ++++
 include/asm-x86_64/bitops.h           |    2 
 include/asm-x86_64/dma-mapping.h      |    3 
 include/asm-x86_64/e820.h             |    2 
 include/asm-x86_64/hw_irq.h           |    2 
 include/asm-x86_64/io.h               |    2 
 include/asm-x86_64/io_apic.h          |   14 
 include/asm-x86_64/mce.h              |    2 
 include/asm-x86_64/mmzone.h           |   18 -
 include/asm-x86_64/mutex.h            |    6 
 include/asm-x86_64/pgalloc.h          |    5 
 include/asm-x86_64/pgtable.h          |    9 
 include/asm-x86_64/uaccess.h          |   14 
 include/asm-x86_64/vsyscall.h         |    5 
 include/linux/binfmts.h               |    1 
 include/linux/nmi.h                   |    9 
 include/linux/time.h                  |    2 
 init/main.c                           |   81 ++-
 kernel/kmod.c                         |   44 +-
 kernel/sched.c                        |    7 
 kernel/timer.c                        |    4 
 scripts/mod/modpost.c                 |   10 
 137 files changed, 4113 insertions(+), 1103 deletions(-)
 create mode 100644 Documentation/x86_64/machinecheck
 create mode 100644 arch/i386/kernel/pcspeaker.c
 create mode 100644 arch/i386/kernel/vmi.c
 create mode 100644 arch/i386/kernel/vmitime.c
 create mode 100644 arch/i386/pci/mmconfig-shared.c
 create mode 100644 arch/x86_64/lib/copy_user_nocache.S
 create mode 100644 include/asm-i386/idle.h
 create mode 100644 include/asm-i386/vmi.h
 create mode 100644 include/asm-i386/vmi_time.h
