Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYJIXrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYJIXrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYJIXrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:47:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56784 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYJIXrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:47:19 -0400
Date: Fri, 10 Oct 2008 01:47:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #1
Message-ID: <20081009234705.GA20540@elte.hu>
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

Please pull the latest x86-v28-for-linus-phase1 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase1

these are the easiest, purely independent x86 topics with no conflicts, 
in one nice Octopus merge.

 Thanks,

	Ingo

------------------>
Adam Jackson (1):
      x86, debug printouts: IOMMU setup failures should not be KERN_ERR

Akinobu Mita (2):
      x86: check for ioremap() failure in copy_oldmem_page()
      x86: use platform_device_register_simple()

Alex Nixon (1):
      x86/paravirt: Remove duplicate paravirt_pagetable_setup_{start, done}()

Alexander van Heukelum (1):
      x86, 64-bit, dwarf2: push pushes 8 bytes and popf pops 8

Alexey Dobriyan (3):
      x86_64: remove empty lines from stack traces/oopses
      seccomp: drop now bogus dependency on PROC_FS
      x86: simpler SYSVIPC_COMPAT definition

Andi Kleen (1):
      x86: capitalize function call interrupts consistently

Andrew Morton (2):
      x86, ptrace: PEBS support, warning fix
      arch/x86/pci/irq.c: attempt to clean up code layout

Aristeu Rozanski (2):
      x86, NMI watchdog: when booting with reset_devices, clear the performance counters
      x86, NMI watchdog: setup before enabling NMI watchdog

Arjan van de Ven (1):
      x86: print DMI information in the oops trace

Avi Kivity (1):
      x86: default to reboot via ACPI

Bill Nottingham (1):
      x86_64: be less annoying on boot

Bruce Allan (1):
      x86: export set_memory_ro and set_memory_rw

Christoph Hellwig (1):
      x86: kill sys32_pause

Cyrill Gorcunov (1):
      x86: DS cleanup - dont treat 0 as NULL

Dave Young (1):
      i386: vmalloc size fix

Dimitri Sivanich (1):
      x86: remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU

Eduardo Habkost (1):
      x86, paravirt_ops: use unsigned long instead of u32 for alloc_p*() pfn args

FUJITA Tomonori (1):
      x86 gart: allocate size-aligned address for alloc_coherent, v2

Gustavo F. Padovan (7):
      x86: coding styles fixes to arch/x86/kernel/process_64.c
      x86: add KERN_INFO to printks on process_64.c
      x86: coding style fixes to arch/x86/kernel/crash_dump_64.c
      x86: coding style fixes to arch/x86/kernel/signal_64.c
      x86: coding style fixes to arch/x86/kernel/traps_64.c
      x86: coding style fixes to arch/x86/kernel/sys_x86_64.c
      x86: coding style fixes to arch/x86/kernel/traps_64.c

H. Peter Anvin (5):
      x86: doc: move x86-generic documentation from Doc/x86/i386
      x86: doc: boot.txt: fix the size of the start_sys field
      x86: <asm/asm.h> consistency cleanups
      x86: msr-on-cpu: remove unnecessary level of abstraction
      x86: additional defconfig updates

Harvey Harrison (2):
      x86: ds.c ptrace.c integer as NULL pointer sparse fixes
      x86, olpc: fix endian bug in openfirmware workaround

Hiroshi Shimamoto (1):
      x86: acpi: move acpi_mcfg_64bit_base_addr into CONFIG_PCI_MMCONFIG

Huang Weiyi (4):
      arch/x86/kernel/visws_quirks.c: Removed duplicated #include
      arch/x86/kernel/acpi/boot.c: removed duplicated #include
      arch/x86/kernel/cpuid.c: removed duplicated #include
      arch/x86/kernel/apm_32.c: remove duplicated #include

Hugh Dickins (1):
      x86: unsigned long pte_pfn

Ingo Molnar (5):
      x86: PEBS cleanup
      x86: fix ds.c build error
      x86: visws_quirks, fix build error
      x86: quick TSC calibration, improve
      x86, tsc calibration: fix

J.A. Magallón (1):
      x86: mtrr_cleanup try gran_size to less than 1M, cleanup

Jan Beulich (2):
      x86: pgd_{c,d}tor() cleanup
      x86-64: eliminate dead code

Jaswinder Singh (27):
      x86: Introducing asm/syscalls.h
      x86: process_32.c declare cpu_number before they get used
      x86: signal_XX.c declare do_notify_resume before they get used
      x86: time_XX.c declare functions before they get used
      x86: setup.c declare saved_video_mode before they get used
      x86: e820.c declare pci_mem_start before they get used
      x86: pci-dma.c declare iommu_bio_merge before they get used
      x86: pci-nommu.c declare nommu_dma_ops before they get used
      x86: i387.c declare dump_fpu() before they get used
      x86: ptrace.c declare functions before they get used
      x86: proc.c declare cpuinfo_op before they get used
      x86: common.c declare idle_regs before they get used
      x86: mtrr/main.c declare range_state as static
      x86: apic_XX.c declare functions before they get used
      x86: vm86_32.c declare functions before they get used
      x86: mm/init_XX.c declare functions before they get used
      x86: mm/fault.c declare do_page_fault before they get used
      x86: mm/ioremap.c declare early_ioremap_debug and early_ioremap_nested as static
      x86: mm/pageattr.c declare arch_report_meminfo before they get used
      x86: mm/pgtable_32.c declare set_pmd_pfn before they get used
      x86: mach-default/setup.c declare no_broadcast before they get used
      x86_64: Declare new_utsname in asm-x86/syscalls.h
      X86_32: declare pt_regs_access as unsigned long
      X86_SMP: smp.c declare functions before they get used
      X86_SMP: smpboot.c declare idle_thread_array and smp_b_stepping as static
      X86_SMP: ipi.c declare functions before they get used
      X86_SMP: tlb_XX.c declare smp_invalidate_interrupt before they get used

Jeff Chua (1):
      x86: make sparsemem more available

Jeremy Fitzhardinge (2):
      x86_64: use save/loadsegment in ia32 compat
      x86: another user of PTE_FLAGS_MASK

Joe Korty (1):
      x86: make poll_idle behave more like the other idle methods

Joerg Roedel (5):
      x86: convert pci-dma.c from round_up to roundup
      x86: convert pageattr.c from round_up to roundup
      x86: convert init_64.c from round_up to roundup
      x86: convert numa_64.c from round_up to roundup
      x86: convert discontig_32.c from round_up to roundup

Li Zefan (1):
      x86: remove nesting CONFIG_HOTPLUG_CPU

Linus Torvalds (1):
      x86: quick TSC calibration

Luiz Fernando N. Capitulino (1):
      x86: remove 8254 timer texts from Documentation

Maciej W. Rozycki (1):
      x86: fix up a comment in ack_APIC_irq()

Marcin Slusarz (4):
      x86, tsc: fix section mismatch warning
      x86: fix MP_processor_info section mismatch warning
      x86: mmconf: fix section mismatch warning
      x86: mpparse.c: fix section mismatch warning

Markus Metzger (1):
      x86, ptrace: PEBS support

Mathieu Desnoyers (3):
      x86: alternatives : fix LOCK_PREFIX race with preemptible kernel and CPU hotplug
      x86: revert replace LOCK_PREFIX in futex.h
      x86: spinlock use LOCK_PREFIX

Paolo Ciarrocchi (6):
      x86: coding style fixes to arch/x86/boot/compressed/misc.c
      x86: coding style fixes to arch/x86/kernel/bios_uv.c
      x86: coding style fixes to arch/x86/lib/strstr_32.c
      x86: coding style fixes to arch/x86/lib/string_32.c
      x86: coding style fixes to arch/x86/kernel/paravirt_patch_32.c
      x86: Coding style fixes to arch/x86/oprofile/op_model_p4.c

Paul Bolle (1):
      x86 setup: drop SWAP_DEV

Petr Tesarik (1):
      x86, tracehook: clean up implementation of syscall_get_error()

Philipp Kohlbecher (1):
      x86: fix comment in protected mode header

Prarit Bhargava (1):
      x86, pci: iommu fix potential overflow in alloc_iommu()

Randy Dunlap (1):
      documentation: move mtrr.txt to Doc/x86/ subdir

Robert Richter (1):
      x86: cleanup in amd_cpu_notify()

Roland McGrath (6):
      x86: tracehook_signal_handler
      x86: tracehook syscall
      x86: tracehook: asm/syscall.h
      x86 signals: use asm/syscall.h
      x86: tracehook: TIF_NOTIFY_RESUME
      x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

Russ Anderson (1):
      x86: trivial printk fix in efi.c

Thomas Gleixner (4):
      x86: TSC: define the PIT latch value separate
      x86: TSC: separate hpet/pmtimer calculation out
      x86: TSC: use one set of reference variables
      x86: TSC make the calibration loop smarter

Tim Bird (1):
      x86, bootup: add built-in kernel command line for x86 (v2)

Uros Bizjak (1):
      x86, cleanup: use X86_CR4_PGE in x86/power/hibernate_asm_32.S

Uwe Kleine-König (1):
      x86, debug: gpio_free might sleep

Vegard Nossum (3):
      x86: fix spurious '#' in kvm header
      x86: consolidate header guards
      x86: consolidate header guards

Yinghai Lu (17):
      x86: print per_cpu data address
      x86_64: printout msr -v2
      x86: fix arch/x86/kernel/cpu/mtrr/main.c warning
      x86: use WARN_ONCE in workaround for mtrr mask
      x86: don't need to go to chunksize to 4G
      x86: mtrr_cleanup optimization, v2
      x86: add mtrr_cleanup_debug command line
      x86: mtrr_cleanup hole size should be less than half of chunk_size, v2
      x86: mtrr_cleanup safe to get more spare regs now
      x86: mtrr_cleanup prepare to make gran_size to less 1M
      x86: mtrr_cleanup try gran_size to less than 1M
      x86: change MTRR_SANITIZER to def_bool y
      x86: mtrr_cleanup try gran_size to less than 1M, v3
      x86, debug: mtrr_cleanup print out var mtrr before change it
      x86: mtrr_cleanup: print out correct type v2
      x86: mtrr_cleanup: first 1M may be covered in var mtrrs
      x86: mtrr_cleanup: treat WRPROT as UNCACHEABLE

dcg (1):
      x86_64: be less annoying on boot, v2

venkatesh.pallipadi@intel.com (1):
      x86: PAT documentation updates with debug info


 Documentation/00-INDEX                             |    2 -
 Documentation/kernel-parameters.txt                |   12 +-
 Documentation/x86/00-INDEX                         |    4 +
 Documentation/x86/{i386 => }/boot.txt              |    2 +-
 Documentation/{ => x86}/mtrr.txt                   |    4 +-
 Documentation/x86/pat.txt                          |   54 +-
 .../x86/{i386 => }/usb-legacy-support.txt          |    0
 Documentation/x86/x86_64/boot-options.txt          |    4 -
 Documentation/x86/{i386 => }/zero-page.txt         |    0
 arch/x86/Kconfig                                   |   75 ++-
 arch/x86/Kconfig.cpu                               |   18 +
 arch/x86/boot/compressed/head_32.S                 |    5 +-
 arch/x86/boot/compressed/misc.c                    |   12 +-
 arch/x86/boot/header.S                             |    1 -
 arch/x86/configs/i386_defconfig                    |   19 +-
 arch/x86/configs/x86_64_defconfig                  |   29 +-
 arch/x86/ia32/ia32_aout.c                          |   11 +-
 arch/x86/ia32/ia32_signal.c                        |   21 +-
 arch/x86/ia32/sys_ia32.c                           |    9 -
 arch/x86/kernel/acpi/boot.c                        |    5 +-
 arch/x86/kernel/alternative.c                      |    8 +-
 arch/x86/kernel/aperture_64.c                      |    6 +-
 arch/x86/kernel/apm_32.c                           |    1 -
 arch/x86/kernel/asm-offsets_64.c                   |    2 +-
 arch/x86/kernel/bios_uv.c                          |   10 +-
 arch/x86/kernel/cpu/common_64.c                    |   51 +
 arch/x86/kernel/cpu/intel.c                        |    3 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |    7 +-
 arch/x86/kernel/cpu/mtrr/if.c                      |    4 +-
 arch/x86/kernel/cpu/mtrr/main.c                    |  274 ++++--
 arch/x86/kernel/cpu/perfctr-watchdog.c             |   86 ++-
 arch/x86/kernel/cpuid.c                            |    1 -
 arch/x86/kernel/crash_dump_64.c                    |   13 +-
 arch/x86/kernel/ds.c                               |  954 ++++++++++++++------
 arch/x86/kernel/efi.c                              |    6 +-
 arch/x86/kernel/entry_64.S                         |    4 +-
 arch/x86/kernel/head64.c                           |    5 +-
 arch/x86/kernel/ioport.c                           |    1 +
 arch/x86/kernel/ipi.c                              |    3 +-
 arch/x86/kernel/irq_32.c                           |    2 +-
 arch/x86/kernel/irq_64.c                           |    2 +-
 arch/x86/kernel/kvm.c                              |    2 +-
 arch/x86/kernel/ldt.c                              |    1 +
 arch/x86/kernel/nmi.c                              |   11 +-
 arch/x86/kernel/olpc.c                             |    6 +-
 arch/x86/kernel/paravirt.c                         |    1 +
 arch/x86/kernel/paravirt_patch_32.c                |    2 +-
 arch/x86/kernel/pci-dma.c                          |    2 +-
 arch/x86/kernel/pci-gart_64.c                      |   27 +-
 arch/x86/kernel/pcspeaker.c                        |   13 +-
 arch/x86/kernel/process.c                          |    3 +-
 arch/x86/kernel/process_32.c                       |   62 +-
 arch/x86/kernel/process_64.c                       |  170 ++--
 arch/x86/kernel/ptrace.c                           |  480 ++++++-----
 arch/x86/kernel/reboot.c                           |    6 +-
 arch/x86/kernel/setup.c                            |   16 +
 arch/x86/kernel/setup_percpu.c                     |    9 +-
 arch/x86/kernel/sigframe.h                         |    5 +
 arch/x86/kernel/signal_32.c                        |   12 +-
 arch/x86/kernel/signal_64.c                        |  112 +--
 arch/x86/kernel/smpboot.c                          |    9 +-
 arch/x86/kernel/sys_i386_32.c                      |    2 +
 arch/x86/kernel/sys_x86_64.c                       |   44 +-
 arch/x86/kernel/syscall_64.c                       |    4 +-
 arch/x86/kernel/time_32.c                          |    1 +
 arch/x86/kernel/tls.c                              |    1 +
 arch/x86/kernel/traps_64.c                         |   66 +-
 arch/x86/kernel/tsc.c                              |  290 +++++--
 arch/x86/kernel/visws_quirks.c                     |   16 +-
 arch/x86/kernel/vm86_32.c                          |    1 +
 arch/x86/kernel/vmi_32.c                           |   10 +-
 arch/x86/lib/msr-on-cpu.c                          |   78 +-
 arch/x86/lib/string_32.c                           |   42 +-
 arch/x86/lib/strstr_32.c                           |    6 +-
 arch/x86/mach-default/setup.c                      |    4 +-
 arch/x86/mm/discontig_32.c                         |    2 +-
 arch/x86/mm/dump_pagetables.c                      |    4 +-
 arch/x86/mm/fault.c                                |    3 +-
 arch/x86/mm/init_32.c                              |    1 +
 arch/x86/mm/init_64.c                              |    8 +-
 arch/x86/mm/ioremap.c                              |    4 +-
 arch/x86/mm/numa_64.c                              |   10 +-
 arch/x86/mm/pageattr.c                             |    4 +-
 arch/x86/mm/pgtable.c                              |    6 +-
 arch/x86/mm/pgtable_32.c                           |    3 +-
 arch/x86/oprofile/op_model_p4.c                    |  175 ++--
 arch/x86/pci/amd_bus.c                             |    2 +-
 arch/x86/pci/irq.c                                 |   67 +-
 arch/x86/power/hibernate_asm_32.S                  |   14 +-
 arch/x86/xen/enlighten.c                           |   20 +-
 include/asm-x86/a.out-core.h                       |    6 +-
 include/asm-x86/a.out.h                            |    6 +-
 include/asm-x86/acpi.h                             |    6 +-
 include/asm-x86/agp.h                              |    6 +-
 include/asm-x86/alternative.h                      |    6 +-
 include/asm-x86/amd_iommu.h                        |    6 +-
 include/asm-x86/amd_iommu_types.h                  |    6 +-
 include/asm-x86/apic.h                             |   15 +-
 include/asm-x86/apicdef.h                          |    6 +-
 include/asm-x86/arch_hooks.h                       |    6 +-
 include/asm-x86/asm.h                              |   13 +-
 include/asm-x86/atomic_32.h                        |    6 +-
 include/asm-x86/atomic_64.h                        |    6 +-
 include/asm-x86/auxvec.h                           |    6 +-
 include/asm-x86/bios_ebda.h                        |    6 +-
 include/asm-x86/bitops.h                           |    6 +-
 include/asm-x86/boot.h                             |    6 +-
 include/asm-x86/bootparam.h                        |    6 +-
 include/asm-x86/bug.h                              |    6 +-
 include/asm-x86/bugs.h                             |    6 +-
 include/asm-x86/byteorder.h                        |    6 +-
 include/asm-x86/cache.h                            |    6 +-
 include/asm-x86/cacheflush.h                       |    6 +-
 include/asm-x86/calgary.h                          |    6 +-
 include/asm-x86/checksum_32.h                      |    6 +-
 include/asm-x86/checksum_64.h                      |    6 +-
 include/asm-x86/cmpxchg_32.h                       |    6 +-
 include/asm-x86/cmpxchg_64.h                       |    6 +-
 include/asm-x86/compat.h                           |    6 +-
 include/asm-x86/cpu.h                              |    6 +-
 include/asm-x86/cpufeature.h                       |    6 +-
 include/asm-x86/current.h                          |    6 +-
 include/asm-x86/debugreg.h                         |    6 +-
 include/asm-x86/delay.h                            |    6 +-
 include/asm-x86/desc.h                             |    6 +-
 include/asm-x86/desc_defs.h                        |    6 +-
 include/asm-x86/device.h                           |    6 +-
 include/asm-x86/div64.h                            |    6 +-
 include/asm-x86/dma-mapping.h                      |    6 +-
 include/asm-x86/dma.h                              |    6 +-
 include/asm-x86/dmi.h                              |    6 +-
 include/asm-x86/ds.h                               |  266 +++++-
 include/asm-x86/dwarf2.h                           |    6 +-
 include/asm-x86/e820.h                             |    7 +-
 include/asm-x86/edac.h                             |    6 +-
 include/asm-x86/efi.h                              |    6 +-
 include/asm-x86/elf.h                              |   11 +-
 include/asm-x86/emergency-restart.h                |    6 +-
 include/asm-x86/fb.h                               |    6 +-
 include/asm-x86/fixmap.h                           |    6 +-
 include/asm-x86/fixmap_32.h                        |    6 +-
 include/asm-x86/fixmap_64.h                        |    6 +-
 include/asm-x86/floppy.h                           |    6 +-
 include/asm-x86/ftrace.h                           |    6 +-
 include/asm-x86/futex.h                            |   12 +-
 include/asm-x86/gart.h                             |   12 +-
 include/asm-x86/genapic_32.h                       |    6 +-
 include/asm-x86/genapic_64.h                       |    6 +-
 include/asm-x86/geode.h                            |    6 +-
 include/asm-x86/gpio.h                             |    2 +-
 include/asm-x86/hardirq_32.h                       |    6 +-
 include/asm-x86/hardirq_64.h                       |    6 +-
 include/asm-x86/highmem.h                          |    6 +-
 include/asm-x86/hpet.h                             |    6 +-
 include/asm-x86/hugetlb.h                          |    6 +-
 include/asm-x86/hw_irq.h                           |   26 +-
 include/asm-x86/hypertransport.h                   |    6 +-
 include/asm-x86/i387.h                             |    7 +-
 include/asm-x86/i8253.h                            |    6 +-
 include/asm-x86/i8259.h                            |    6 +-
 include/asm-x86/ia32.h                             |    6 +-
 include/asm-x86/ia32_unistd.h                      |    6 +-
 include/asm-x86/idle.h                             |    6 +-
 include/asm-x86/intel_arch_perfmon.h               |    6 +-
 include/asm-x86/io.h                               |    8 +-
 include/asm-x86/io_32.h                            |    6 +-
 include/asm-x86/io_64.h                            |    7 +-
 include/asm-x86/io_apic.h                          |    6 +-
 include/asm-x86/ioctls.h                           |    6 +-
 include/asm-x86/iommu.h                            |    6 +-
 include/asm-x86/ipcbuf.h                           |    6 +-
 include/asm-x86/ipi.h                              |    6 +-
 include/asm-x86/irq.h                              |    6 +-
 include/asm-x86/irq_regs_32.h                      |    6 +-
 include/asm-x86/irq_vectors.h                      |    6 +-
 include/asm-x86/ist.h                              |    6 +-
 include/asm-x86/k8.h                               |    6 +-
 include/asm-x86/kdebug.h                           |    6 +-
 include/asm-x86/kexec.h                            |    6 +-
 include/asm-x86/kgdb.h                             |    6 +-
 include/asm-x86/kmap_types.h                       |    6 +-
 include/asm-x86/kprobes.h                          |    6 +-
 include/asm-x86/kvm.h                              |    6 +-
 include/asm-x86/kvm_host.h                         |    8 +-
 include/asm-x86/kvm_para.h                         |    6 +-
 include/asm-x86/kvm_x86_emulate.h                  |    6 +-
 include/asm-x86/ldt.h                              |    6 +-
 include/asm-x86/lguest.h                           |    6 +-
 include/asm-x86/lguest_hcall.h                     |    6 +-
 include/asm-x86/linkage.h                          |    6 +-
 include/asm-x86/local.h                            |    6 +-
 include/asm-x86/mach-bigsmp/mach_apic.h            |    6 +-
 include/asm-x86/mach-bigsmp/mach_apicdef.h         |    6 +-
 include/asm-x86/mach-bigsmp/mach_ipi.h             |    6 +-
 include/asm-x86/mach-default/apm.h                 |    6 +-
 include/asm-x86/mach-default/mach_apic.h           |    6 +-
 include/asm-x86/mach-default/mach_apicdef.h        |    6 +-
 include/asm-x86/mach-default/mach_ipi.h            |    6 +-
 include/asm-x86/mach-default/mach_mpparse.h        |    6 +-
 include/asm-x86/mach-default/mach_mpspec.h         |    6 +-
 include/asm-x86/mach-default/mach_timer.h          |    6 +-
 include/asm-x86/mach-default/mach_traps.h          |    6 +-
 include/asm-x86/mach-default/mach_wakecpu.h        |    6 +-
 include/asm-x86/mach-es7000/mach_apic.h            |    6 +-
 include/asm-x86/mach-es7000/mach_apicdef.h         |    6 +-
 include/asm-x86/mach-es7000/mach_ipi.h             |    6 +-
 include/asm-x86/mach-es7000/mach_mpparse.h         |    6 +-
 include/asm-x86/mach-es7000/mach_wakecpu.h         |    6 +-
 include/asm-x86/mach-generic/gpio.h                |    6 +-
 include/asm-x86/mach-generic/irq_vectors_limits.h  |    6 +-
 include/asm-x86/mach-generic/mach_apic.h           |    6 +-
 include/asm-x86/mach-generic/mach_apicdef.h        |    6 +-
 include/asm-x86/mach-generic/mach_ipi.h            |    6 +-
 include/asm-x86/mach-generic/mach_mpparse.h        |    6 +-
 include/asm-x86/mach-generic/mach_mpspec.h         |    6 +-
 include/asm-x86/mach-numaq/mach_apic.h             |    6 +-
 include/asm-x86/mach-numaq/mach_apicdef.h          |    6 +-
 include/asm-x86/mach-numaq/mach_ipi.h              |    6 +-
 include/asm-x86/mach-numaq/mach_mpparse.h          |    6 +-
 include/asm-x86/mach-numaq/mach_wakecpu.h          |    6 +-
 include/asm-x86/mach-rdc321x/gpio.h                |    9 +-
 include/asm-x86/mach-summit/irq_vectors_limits.h   |    6 +-
 include/asm-x86/mach-summit/mach_apic.h            |    6 +-
 include/asm-x86/mach-summit/mach_apicdef.h         |    6 +-
 include/asm-x86/mach-summit/mach_ipi.h             |    6 +-
 include/asm-x86/mach-summit/mach_mpparse.h         |    6 +-
 include/asm-x86/math_emu.h                         |    6 +-
 include/asm-x86/mc146818rtc.h                      |    6 +-
 include/asm-x86/mca.h                              |    6 +-
 include/asm-x86/mca_dma.h                          |    6 +-
 include/asm-x86/mce.h                              |    6 +-
 include/asm-x86/mman.h                             |    6 +-
 include/asm-x86/mmconfig.h                         |    6 +-
 include/asm-x86/mmu.h                              |   11 +-
 include/asm-x86/mmu_context.h                      |    6 +-
 include/asm-x86/mmu_context_32.h                   |    6 +-
 include/asm-x86/mmu_context_64.h                   |    6 +-
 include/asm-x86/mmx.h                              |    6 +-
 include/asm-x86/mmzone_32.h                        |    6 +-
 include/asm-x86/mmzone_64.h                        |    6 +-
 include/asm-x86/module.h                           |    6 +-
 include/asm-x86/mpspec.h                           |    6 +-
 include/asm-x86/mpspec_def.h                       |    6 +-
 include/asm-x86/msgbuf.h                           |    6 +-
 include/asm-x86/msidef.h                           |    6 +-
 include/asm-x86/msr-index.h                        |    6 +-
 include/asm-x86/msr.h                              |   29 +-
 include/asm-x86/mtrr.h                             |    6 +-
 include/asm-x86/mutex_32.h                         |    6 +-
 include/asm-x86/mutex_64.h                         |    6 +-
 include/asm-x86/nmi.h                              |    7 +-
 include/asm-x86/nops.h                             |    6 +-
 include/asm-x86/numa_32.h                          |    6 +-
 include/asm-x86/numa_64.h                          |    6 +-
 include/asm-x86/numaq.h                            |    6 +-
 include/asm-x86/olpc.h                             |    6 +-
 include/asm-x86/page.h                             |    6 +-
 include/asm-x86/page_32.h                          |   10 +-
 include/asm-x86/page_64.h                          |    7 +-
 include/asm-x86/param.h                            |    6 +-
 include/asm-x86/paravirt.h                         |   48 +-
 include/asm-x86/parport.h                          |    6 +-
 include/asm-x86/pat.h                              |    6 +-
 include/asm-x86/pci-direct.h                       |    6 +-
 include/asm-x86/pci.h                              |    6 +-
 include/asm-x86/pci_32.h                           |    6 +-
 include/asm-x86/pci_64.h                           |    6 +-
 include/asm-x86/pda.h                              |    6 +-
 include/asm-x86/percpu.h                           |    6 +-
 include/asm-x86/pgalloc.h                          |    6 +-
 include/asm-x86/pgtable-2level-defs.h              |    6 +-
 include/asm-x86/pgtable-2level.h                   |    8 +-
 include/asm-x86/pgtable-3level-defs.h              |    6 +-
 include/asm-x86/pgtable-3level.h                   |   13 +-
 include/asm-x86/pgtable.h                          |   15 +-
 include/asm-x86/pgtable_32.h                       |   12 +-
 include/asm-x86/pgtable_64.h                       |    8 +-
 include/asm-x86/posix_types_32.h                   |    6 +-
 include/asm-x86/posix_types_64.h                   |    6 +-
 include/asm-x86/prctl.h                            |    6 +-
 include/asm-x86/processor-flags.h                  |    6 +-
 include/asm-x86/processor.h                        |   22 +-
 include/asm-x86/proto.h                            |    6 +-
 include/asm-x86/ptrace-abi.h                       |   20 +-
 include/asm-x86/ptrace.h                           |   52 +-
 include/asm-x86/pvclock-abi.h                      |    6 +-
 include/asm-x86/pvclock.h                          |    6 +-
 include/asm-x86/reboot.h                           |    6 +-
 include/asm-x86/reboot_fixups.h                    |    6 +-
 include/asm-x86/required-features.h                |    6 +-
 include/asm-x86/resume-trace.h                     |    8 +-
 include/asm-x86/rio.h                              |    6 +-
 include/asm-x86/rwlock.h                           |    6 +-
 include/asm-x86/rwsem.h                            |    6 +-
 include/asm-x86/scatterlist.h                      |    6 +-
 include/asm-x86/seccomp_32.h                       |    6 +-
 include/asm-x86/seccomp_64.h                       |    6 +-
 include/asm-x86/segment.h                          |    6 +-
 include/asm-x86/sembuf.h                           |    6 +-
 include/asm-x86/serial.h                           |    6 +-
 include/asm-x86/setup.h                            |    7 +-
 include/asm-x86/shmbuf.h                           |    6 +-
 include/asm-x86/shmparam.h                         |    6 +-
 include/asm-x86/sigcontext.h                       |    6 +-
 include/asm-x86/sigcontext32.h                     |    6 +-
 include/asm-x86/siginfo.h                          |    6 +-
 include/asm-x86/signal.h                           |    9 +-
 include/asm-x86/smp.h                              |   10 +-
 include/asm-x86/socket.h                           |    6 +-
 include/asm-x86/sockios.h                          |    6 +-
 include/asm-x86/sparsemem.h                        |    6 +-
 include/asm-x86/spinlock.h                         |   12 +-
 include/asm-x86/spinlock_types.h                   |    6 +-
 include/asm-x86/srat.h                             |    6 +-
 include/asm-x86/stacktrace.h                       |    6 +-
 include/asm-x86/stat.h                             |    6 +-
 include/asm-x86/statfs.h                           |    6 +-
 include/asm-x86/string_32.h                        |    6 +-
 include/asm-x86/string_64.h                        |    6 +-
 include/asm-x86/suspend_32.h                       |    6 +-
 include/asm-x86/suspend_64.h                       |    6 +-
 include/asm-x86/swiotlb.h                          |    6 +-
 include/asm-x86/sync_bitops.h                      |    6 +-
 include/asm-x86/syscall.h                          |  211 +++++
 include/asm-x86/syscalls.h                         |   93 ++
 include/asm-x86/system.h                           |    6 +-
 include/asm-x86/system_64.h                        |    6 +-
 include/asm-x86/tce.h                              |    6 +-
 include/asm-x86/termbits.h                         |    6 +-
 include/asm-x86/termios.h                          |    6 +-
 include/asm-x86/therm_throt.h                      |    6 +-
 include/asm-x86/thread_info.h                      |   10 +-
 include/asm-x86/time.h                             |    8 +-
 include/asm-x86/timer.h                            |   11 +-
 include/asm-x86/timex.h                            |    6 +-
 include/asm-x86/tlb.h                              |    6 +-
 include/asm-x86/tlbflush.h                         |    6 +-
 include/asm-x86/topology.h                         |    6 +-
 include/asm-x86/trampoline.h                       |    6 +-
 include/asm-x86/traps.h                            |   10 +-
 include/asm-x86/tsc.h                              |    6 +-
 include/asm-x86/types.h                            |    6 +-
 include/asm-x86/uaccess.h                          |    6 +-
 include/asm-x86/uaccess_32.h                       |    6 +-
 include/asm-x86/uaccess_64.h                       |    6 +-
 include/asm-x86/ucontext.h                         |    6 +-
 include/asm-x86/unaligned.h                        |    6 +-
 include/asm-x86/unistd_32.h                        |    6 +-
 include/asm-x86/unistd_64.h                        |    6 +-
 include/asm-x86/unwind.h                           |    6 +-
 include/asm-x86/user32.h                           |    6 +-
 include/asm-x86/user_32.h                          |    6 +-
 include/asm-x86/user_64.h                          |    6 +-
 include/asm-x86/uv/bios.h                          |    6 +-
 include/asm-x86/uv/uv_bau.h                        |    6 +-
 include/asm-x86/uv/uv_hub.h                        |    6 +-
 include/asm-x86/uv/uv_mmrs.h                       |    6 +-
 include/asm-x86/vdso.h                             |    6 +-
 include/asm-x86/vga.h                              |    6 +-
 include/asm-x86/vgtod.h                            |    6 +-
 include/asm-x86/visws/cobalt.h                     |    6 +-
 include/asm-x86/visws/lithium.h                    |    6 +-
 include/asm-x86/visws/piix4.h                      |    6 +-
 include/asm-x86/vm86.h                             |    6 +-
 include/asm-x86/vmi_time.h                         |    6 +-
 include/asm-x86/vsyscall.h                         |    6 +-
 include/asm-x86/xen/events.h                       |    6 +-
 include/asm-x86/xen/grant_table.h                  |    6 +-
 include/asm-x86/xen/hypercall.h                    |    6 +-
 include/asm-x86/xen/hypervisor.h                   |    6 +-
 include/asm-x86/xen/interface.h                    |    6 +-
 include/asm-x86/xen/interface_32.h                 |    6 +-
 include/asm-x86/xen/interface_64.h                 |    6 +-
 include/asm-x86/xen/page.h                         |    6 +-
 374 files changed, 3870 insertions(+), 2221 deletions(-)
 create mode 100644 Documentation/x86/00-INDEX
 rename Documentation/x86/{i386 => }/boot.txt (99%)
 rename Documentation/{ => x86}/mtrr.txt (99%)
 rename Documentation/x86/{i386 => }/usb-legacy-support.txt (100%)
 rename Documentation/x86/{i386 => }/zero-page.txt (100%)
 create mode 100644 include/asm-x86/syscall.h
 create mode 100644 include/asm-x86/syscalls.h

