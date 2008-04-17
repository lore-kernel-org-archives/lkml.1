Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbYDQSEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbYDQSEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763713AbYDQSER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:04:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40270 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763948AbYDQSEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:04:13 -0400
Date: Thu, 17 Apr 2008 20:03:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 changes for v2.6.26
Message-ID: <20080417180347.GA15158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree for v2.6.26 from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

This tree contains the first wave of arch/x86 changes for v2.6.26.

[ Note: i kept the header cleanups from Joe Perches split up after all - 
  that is because a number of bugs were found in those cleanups during 
  development and their finegrained-ness (while somewhat annoying on 
  lkml) was actually very useful for bisection. ]

Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      x86: remove the write-only timer_uses_ioapic_pin_0

Akinobu Mita (6):
      x86: avoid redundant loop in io_apic_level_ack_pending()
      x86: use ioapic_read_entry() and ioapic_write_entry()
      x86: remove unnecessary memset()
      x86: remove unnecessary tmp local variable
      x86: use cpumask_of_cpu()
      x86: use cpu_online()

Alexander van Heukelum (6):
      x86: reserve end-of-conventional-memory to 1MB on 32-bit
      x86: reserve_early end-of-conventional-memory to 1MB, 64-bit
      x86: reserve end-of-conventional-memory to 1MB, 64-bit
      x86: reserve end-of-conventional-memory to 1MB, 32-bit, use paravirt_enabled
      x86: reserve end-of-conventional-memory to 1MB, 64-bit, use paravirt_enabled
      x86: remove superfluous initialisation in boot code.

Alexey Dobriyan (1):
      x86: switch to proc_create()

Alexey Starikovskiy (72):
      x86: move quad_local_to_mp_bus_id to numa.c
      x86: add mp_bus_not_pci bitmap to mpparse_32.c
      x86: use not_pci bitmap #1
      x86: use not_pci bitmap #2
      x86: use not_pci bitmap #3
      x86: use not_pci bitmap #4
      x86: use not_pci bitmap #5
      x86: use not_pci bitmap #6
      x86: rearrange bus_type parse
      x86: make mp_bus_id_to_type optional
      x86: move mp_bus_id_to_local to numa.c
      x86: move mp_bus_id_to_node to numa.c
      x86: lindent mpparse_64.c
      x86: add bad_ioapic to mpparse_32.c
      x86: add uniq_ioapic_id to mpparse_32.c
      x86: use get_bios_ebda in mpparse_64.c
      x86: limit scan to 1k of EBDA.
      x86: rename gsi_start to gsi_base to match mpparse_32.c
      x86: remove mpc_apic_id()
      x86: remove mpc_oem_pci_bus()
      x86: remove mpc_oem_bus_info()
      x86: make struct mpc_config_translation NUMAQ-only
      x86: use same index for processor maps
      x86: move es7000_plat closer to its user
      x86: don't call MP_processor_info for disabled cpu
      x86: separate generic_processor_info into its own function
      x86: don't use MP_processor_info for ACPI mode
      x86: move apic_ver array to apic_32.c
      x86: move mp_lapic_addr to apic_32.c
      x86: move phys_cpu_present_map to smpboot.c
      x86: move num_processors to smpboot.c
      x86: move disabled_cpus to smpboot.c
      x86: move def_to_bigsmp to setup_32.c
      x86: move boot_cpu_physical_apicid to apic_32.c
      x86: move x86_bios_cpu_apicid to apic_32.c
      x86: move generic_processor_info to apic_32.c
      x86: don't call MP_processor_info for disabled cpu (64bit)
      x86: separate generic_processor_info into its own function (64bit)
      x86: don't use MP_processor_info for ACPI mode (64bit)
      x86: move mp_lapic_addr to apic_64.c
      x86: move phys_cpu_present_map to smpboot.c (64bit)
      x86: move num_processors to smpboot.c (64 bit)
      x86: move disabled_cpus to smpboot.c (64bit)
      x86: move boot_cpu_physical_apicid to apic_64.c
      x86: move generic_processor_info to apic_64.c
      x86: move x86_bios_cpu_apicid to io_apic_64.c
      x86: move x86_cpu_to_apicid to setup.c
      x86: move phys_cpu_present_map to setup.c
      x86: move x86_cpu_to_apicid_init to smpboot.c
      x86: move x86_bios_cpu_apicid_init to smpboot.c
      x86: don't set IO APIC features if IO APIC is not enabled
      x86: move mp_ioapics to io_apic_32.c
      x86: move mp_ioapics to io_apic_64.c
      x86: move mp_ioapic_routing to boot.c
      x86: move mp_irqs to io_apics_32.c
      x86: move mp_irqs to io_apic_64.c
      x86: move up & smp variables to setup.c
      x86: move mp_register_lapic to boot.c
      x86: move mp_register_lapic_address to boot.c
      x86: lindent mpparse_32.c
      x86: add early flags to mpparse_32.c
      x86: unify arch/x86/kernel/mpparse_64.c
      x86: unify mp_bus_info
      x86: unify smp_read_mpc
      x86: unify construct_default_ioirq_mptable
      x86: unify get_smp_config
      x86: unify smp_scan_config
      x86: unify uniq_io_apic_id
      x86: unify mp_register_ioapic
      x86: unify mp_config_acpi_legacy_irqs
      x86: unify mp_register_gsi
      x86: merge mpparse_{32,64}.c

Alok Kataria (1):
      x86: fix paranoia about using BIOS quickboot mechanism.

Andi Kleen (13):
      x86: do kernel direct mapping at boot using GB pages
      x86: use year 2000 offset for cmos clock
      x86: add warning when RTC clock reports binary
      x86: enable ACPI extended century handling for 32bit
      x86: don't set up early exception handlers for external interrupts
      x86: replace early exception setup macro recursion with loop
      x86: move early exception handlers into init.text
      x86: implement true end_pfn_mapped for 32bit
      x86: account overlapped mappings in max_pfn_mapped
      x86: add set_memory_4k to pageattr.c
      x86: don't use large pages to map the first 2/4MB of memory
      x86: re-add rdmsrl_safe
      x86: split large page mapping for AMD TSEG

Andrew Morton (2):
      i386: arch/x86/math-emu/fpu_entry.c warning fix
      i386: arch/x86/math-emu/reg_ld_str.c: fix warning

Arjan van de Ven (2):
      x86: add code to dump the (kernel) page tables for visual inspection by kernel developers
      x86: add comments to describe the new api's in cacheflush.h

Arnaldo Carvalho de Melo (1):
      x86: reducing debuginfo size by removing unneeded includes

Ben Castricum (1):
      x86: microcode: show results on success too

Björn Steinbrink (1):
      x86, pci: fix off-by-one errors in some pirq warnings

Cyrill Gorcunov (4):
      x86: processor.h - use PAGE_SIZE instead of numeric value
      x86: relocate_kernel - use predefined PAGE_SIZE instead of own alias
      x86: entry_32.S - use flags from processor-flags.h
      x86: debug Store - call kfree if only we really need it

Dave Jones (1):
      x86: Centaur Isaiah processor to use sysenter in 64-bit compatibility mode rather than syscall

David P. Reed (2):
      x86: fix cmos read and write to not use inb_p and outb_p
      x86: define outb_pic and inb_pic to stop using outb_p and inb_p

Eric W. Biederman (1):
      x86: introduce kernel/head32.c

Florian Fainelli (1):
      x86, rdc321x: remove watchdog file

Gautham R Shenoy (1):
      x86: Don't send RESCHEDULE_VECTOR to offlined cpus

Glauber Costa (62):
      x86: change vsmp compile dependency
      x86: make vsmp_init void, instead of static int
      x86: call vsmp_init explicitly
      x86: introduce vsmp paravirt helpers
      x86, vsmp: use the paravirt helpers
      x86: commonize smp.h
      x86: merge extern function definitions
      x86: merge extern variables definitions
      x86: define smp_ops in common header
      x86: move smp_ops extern declaration to common header
      x86: merge smp_send_reschedule
      x86: unify smp_call_function_mask
      x86: unify __cpu_up.
      x86: unify prepare_boot_cpu
      x86: unify smp_prepare_cpus
      x86: unify smp_cpus_done
      x86: move disabled_cpus to common header
      x86: use disabled_cpus in i386
      x86: move prefill_possible_map to common file
      x86: remove export for smp_call_function_mask.
      x86: remove irqs disabled warning.
      x86: create smpcommon.c
      x86: provide __smp_call_function
      x86: change x86_64 smp_call_function_mask to look alike i386
      x86: provide hlt_works function.
      x86: make stop_this_cpu looks exactly equal in both arches
      x86: add reboot_force test to native_smp_send_stop
      x86: unify smp_send_stop
      x86: create smp.c
      x86: create ipi.c
      x86: create tlb files
      x86: get rid of smp_32.c and smp_64.c
      x86: remove cpu_llc_id from processor.h
      x86: adjust types in smpcommon_32.c
      x86: move equal types to common file
      x86: make set_cpu_sibling_map nonstatic
      x86: make remove_siblinginfo non-static
      x86: move hotplug related extern definitions to smp.h
      x86: move sibling functions to common file
      x86: move cpu_coregroup_map to common file
      x86: remove vector_lock around cpu_online_map
      x86: use remove_from_maps in cpu_disable
      x86: do not clear cpu_online_map
      x86: merge __cpu_disable and cpu_die
      x86: make x86_64 accept the max_cpus parameter
      x86: move trampoline arrays extern definition to smp.h
      x86: adapt voyager's trampoline_base
      x86: adapt voyager's setup_trampoline
      x86: unify setup_trampoline
      x86: use wait_for_init_deassert in x86_64
      x86: use cpu_relax instead of rep_nop
      x86: move ipi definitions to mach_ipi.h
      x86: move apic declarations to mach_apic.h
      x86: surround hard_smp_processor_id in APIC_DEFINITION
      x86: provide bogus hard_smp_processor_id
      x86: merge hard/logical_smp_processor_id
      x86: surround apic headers in apic definitions
      x86: merge includes in smp.h
      x86: split safe_smp_processor_id
      x86: merge SMP definitions of smp.h
      x86: change naming of cpu_initialized_mask for xen
      x86: merge smp_32.h and smp_64.h into smp.h

Glauber de Oliveira Costa (78):
      x86: change var types in __inquire_remote_apic
      x86: add loglevel to printks
      x86: use apic_*_around instead of apic_write in x86_64
      x86: use start_ipi_hook in x86_64
      x86: add an smp_apply_quirks to smpboot_32.c
      x86: decouple call to print_cpu_info from smp_store_cpu_info
      x86: provide specialized identification routines for x86_64
      x86: use identify_boot_cpu
      x86: call identify_secondary_cpu in smp_store_cpu_info
      x86: merge smp_store_cpu_info
      x86: always enable irqs when entering idle
      x86: don't call local_irq_enable before entering idle
      x86: move setup_secondary_clock a little bit down in the function
      x86: move state update out of ipi_lock
      x86: provide APIC_INTEGRATED definition for x86_64
      x86: use APIC_INTEGRATED tests in x86_64
      x86: add barriers statement
      x86: isolate sanity checking
      x86: isolate logic to disable smp
      x86: do tests before do_boot_cpu in i386
      x86: make __smp_prepare_cpu void
      x86: move assignment of CPU_PREPARE before do_boot_cpu
      x86: unify extern masks declaration
      x86: define bios to apicid mapping
      x86: initialize map pointers in setup_32.c
      x86: make node to apic mapping declarations unconditional
      x86: fix alloc_bootmem_pages_node macro
      x86: use specialized routine for setup per-cpu area
      x86: fill bios cpu to apicid maps
      x86: fill cpu to apicid and present map in mpparse
      x86: get rid of cpucount
      x86: allow user to impress friends.
      x86: do smp tainting checks in a separate function
      x86: move impress_friends and smp_check to cpus_done
      x86: add subarch support (for headers) to x86_64
      x86: include mach_wakecpu.h in smpboot_64
      x86: include smpboot_hooks.h in smpboot_64.c
      x86: move smp_intr_init away from smpboot_32.c
      x86: don't set maps in native_smp_prepare_boot_cpu()
      x86: wipe get_nmi_reason out of nmi_64.h
      x86: unify nmi_32.h and nmi_64.h
      x86: call check_nmi_watchdog explicitly in native_smp_cpus_done
      x86: call nmi_watchdog_default in i386
      x86: don't initialize sibling and core maps during preparation
      x86: schedule work only if keventd is already running
      x86: do not zap_low_mappings in __smp_prepare_cpus
      x86: boot cpus from cpu_up, instead of prepare_cpus
      x86: get rid of commenced mask.
      x86: use create_idle struct in do_boot_cpu
      x86: don't span a new worker in __smp_prepare_cpu
      x86: modify smp_callin in x86_64 to look like i386
      x86: wrap esr setting up in i386 in lapic_setup_esr
      x86: provide an end_local_APIC_setup function
      x86: calibrate delay with irqs enabled
      x86: minor adjustments for do_boot_cpu
      x86: call do_boot_cpu directly from native_cpu_up
      x86: include mach_apic.h in smpboot_64.c and smpboot.c
      x86: change wakeup_secondary name
      x86: add callin tests to cpu_up
      x86: move {un}map_cpu_to_logical_apicid to smpboot.c
      x86: move stack_start to smp.h
      x86: change boot_cpu_id to boot_cpu_physical_apicid
      x86: integrate do_boot_cpu
      x86: integrate start_secondary
      x86: merge smp_prepare_boot_cpu
      x86: merge native_smp_cpus_done
      x86: use physical id when disabling smp
      x86: get rid of smp_boot_cpus
      x86: additions to i386 native_smp_prepare_cpus.
      x86: assign nr_ioapics = 0 in smpboot_hooks.h
      x86: change x86_64 native_smp_prepare_cpus to match i386
      x86: add extra sanity check
      x86: change x86_64 sanity checks to match i386.
      x86: introduce smpboot_clear_io_apic
      x86: merge native_smp_prepare_cpus
      x86: merge cpu_exit_clear
      x86: move apicid mappings to smpboot.c
      x86: remove smpboot_32.c and smpboot_64.c

H. Peter Anvin (2):
      x86: unify arch/x86/mm/Makefile
      x86: clean up the page table dumper and add 32-bit support

Harvey Harrison (10):
      x86: change most X86_32 pt_regs members to unsigned long
      x86: make X86_32 pt_regs members unsigned long
      x86: regparm(3) is mandatory, no need to annotate
      x86: reduce trivial style differences in signal_32|64.c
      x86: Use FIX_EFLAGS define in X86_64
      x86: use sizeof(long) to unify signal_32|64.c
      x86: move struct definitions to unifed sigframe.h
      x86: Unify argument names in signal_32|64.c
      x86: define DEBUG_SIG in signal_64.c
      x86: replace remaining __FUNCTION__ occurances

Hiroshi Shimamoto (6):
      x86: split cpuinfo from setup_64.c into cpu/proc_64.c
      x86: make cpu/proc|_64.c similar
      x86: add power management line in /proc/cpuinfo
      x86: cosmetic unification cpu/proc|_64.c
      x86: unify cpu/proc|_64.c
      x86: X86_HT always enable on X86_64 SMP

Hugh Dickins (1):
      x86: MPSC should use P6 NOPs

Ian Campbell (4):
      x86: use ELF format in compressed images.
      x86: add a crc32 checksum to the kernel image.
      x86: reduce arch/x86/mm/ioremap.o size
      x86: boot protocol updates

Ingo Molnar (55):
      x86: check vmlinux limits, 64-bit
      x86: increase the kernel text limit to 512 MB
      x86: add gbpages switches
      x86: bump image header to version 2.08.
      x86: clean up mmx_32.c
      x86: more coding style fixes in centaur.c
      x86: clean up include/asm-x86/processor.h
      x86: more cleanups in arch/x86/boot/compressed/misc.c
      x86: de-macro start_thread()
      x86: clean up cpu capabilities accesses
      x86: clean up cpu capabilities accesses, generic
      x86: clean up cpu capabilities accesses, amd.c
      x86: clean up cpu capabilities accesses, centaur.c
      x86: clean up cpu capabilities accesses, common.c
      x86: clean up cpu capabilities accesses, cyrix.c
      x86: clean up cpu capabilities in arch/x86/kernel/cpu/intel.c
      x86: clean up cpu capabilities accesses, transmeta.c
      x86: clean up traps_32.c
      x86, tracing: add notrace to asm-x86/linkage.h
      x86: ioremap(), extend check to all RAM pages
      x86: warn about RAM pages in ioremap()
      x86: redo cded932b75ab0a5f9181e
      x86: debug pmd_bad()
      x86: clean up switch_to()
      x86: fix switch_to() clobbers
      x86: add comments to processor.h
      x86: clean up i387.c
      x86: remove DEBUG_SIG
      x86: clean up arch/x86/kernel/signal_32.c
      x86: move extern declaration to vdso.h
      x86: add KERN_INFO to show_unhandled_signals printout
      x86: remove mach_reboot.h
      x86: fill cpu to apicid and present map in mpparse, fix
      x86: vsmp fix x86 vsmp fix is vsmp box cleanup
      x86: revert ucminus change
      x86: PAT fix
      x86: tom2 warning fix
      x86: fix ioapic bug again
      undo "x86: fix breakage of vSMP irq operations"
      x86: spinlock ops are always-inlined
      x86: ioremap of 64-bit resource on 32-bit kernel fix
      x86: mpparse, move disabled cpus to smpboot.c, fix
      x86: mpparse, move boot cpu physical apicid to apic_32.c, fix
      x86: mpparse, move generic processor info to apic_32.c fix
      x86: move phys cpu present map to smpboot.c, 64-bit, prepare
      x86: mpparse: 64-bit fix
      x86: cleanup replace most vm86 flags with flags from processor-flags.h, fix
      x86: support for new UV apic, prepare
      x86: uv fix
      x86: set_cyc2ns_scale() remove prev scale
      x86: improve default idle
      x86: extend the scheduled bzImage symlinks removal
      x86: 4kstacks default
      x86: don't set io apic features if io-apic is not enabled, fix
      x86: standalone trampoline code

Jacek Luczak (2):
      x86: section mismatch fixes, #1
      x86: setup_trampoline() - fix section mismatch warning

Jack Steiner (11):
      x86: increase max physical memory size of 64-bit
      x86: allow NODES_SHIFT to be a config option on x86_64
      x86: change GET_APIC_ID() from an inline function to an out-of-line function
      x86: add functions to determine if platform is a UV platform
      x86: increase size of APICID
      x86: parsing for ACPI "SAPIC" table
      x86: add UV specific header for MMR definitions
      x86: define the macros and tables for the basic UV infrastructure.
      x86: define the macros and tables for blade functions
      x86: support for new UV apic
      x86: support for new UV apic, fix

Jan Beulich (3):
      x86: prevent unconditional writes to DebugCtl MSR
      x86: simplify sync_test_bit()
      x86: bitops asm constraint fixes

Jeremy Fitzhardinge (5):
      xen: use iret instruction all the time
      x86: only enable interrupts when kernel state has been set up
      x86: simplify sync_test_bit(), improve
      x86: sparsemem: reduce i386 PAE section size
      x86: paravirt_ops: don't steal memory resources in paravirt_disable_iospace

Jesper Juhl (1):
      x86 floppy: kill off the 'register' keyword from header

Jiri Slaby (1):
      x86: pgtable, document pde bits

Joe Perches (139):
      x86: include/asm-x86/mutex_32.h - use angle brackets for include
      x86: arch/x86/kernel/cpu/feature_names.c - use angle brackets for include
      x86: cleanup duplicate includes
      include/asm-x86/acpi.h: checkpatch cleanups - formatting only
      include/asm-x86/alternative.h: checkpatch cleanups - formatting only
      include/asm-x86/a.out-core.h: checkpatch cleanups - formatting only
      include/asm-x86/apicdef.h: checkpatch cleanups - formatting only
      include/asm-x86/apic.h: checkpatch cleanups - formatting only
      include/asm-x86/atomic_32.h: checkpatch cleanups - formatting only
      include/asm-x86/atomic_64.h: checkpatch cleanups - formatting only
      include/asm-x86/bitops_32.h: checkpatch cleanups - formatting only
      include/asm-x86/bitops_64.h: checkpatch cleanups - formatting only
      include/asm-x86/bitops.h: checkpatch cleanups - formatting only
      include/asm-x86/bug.h: checkpatch cleanups - formatting only
      include/asm-x86/byteorder.h: checkpatch cleanups - formatting only
      include/asm-x86/cacheflush.h: checkpatch cleanups - formatting only
      include/asm-x86/checksum_32.h: checkpatch cleanups - formatting only
      include/asm-x86/checksum_64.h: checkpatch cleanups - formatting only
      include/asm-x86/cmpxchg_32.h: checkpatch cleanups - formatting only
      include/asm-x86/cmpxchg_64.h: checkpatch cleanups - formatting only
      include/asm-x86/compat.h: checkpatch cleanups - formatting only
      include/asm-x86/current_32.h: checkpatch cleanups - formatting only
      include/asm-x86/current_64.h: checkpatch cleanups - formatting only
      include/asm-x86/desc_defs.h: checkpatch cleanups - formatting only
      include/asm-x86/desc.h: checkpatch cleanups - formatting only
      include/asm-x86/div64.h: checkpatch cleanups - formatting only
      include/asm-x86/dma.h: checkpatch cleanups - formatting only
      include/asm-x86/dwarf2_64.h: checkpatch cleanups - formatting only
      include/asm-x86/e820_32.h: checkpatch cleanups - formatting only
      include/asm-x86/e820_64.h: checkpatch cleanups - formatting only
      include/asm-x86/edac.h: checkpatch cleanups - formatting only
      include/asm-x86/efi.h: checkpatch cleanups - formatting only
      include/asm-x86/elf.h: checkpatch cleanups - formatting only
      include/asm-x86/fixmap_32.h: checkpatch cleanups - formatting only
      include/asm-x86/fixmap_64.h: checkpatch cleanups - formatting only
      include/asm-x86/floppy.h: checkpatch cleanups - formatting only
      include/asm-x86/futex.h: checkpatch cleanups - formatting only
      include/asm-x86/genapic_32.h: checkpatch cleanups - formatting only
      include/asm-x86/geode.h: checkpatch cleanups - formatting only
      include/asm-x86/highmem.h: checkpatch cleanups - formatting only
      include/asm-x86/hw_irq_64.h: checkpatch cleanups - formatting only
      include/asm-x86/hypertransport.h: checkpatch cleanups - formatting only
      include/asm-x86/i387.h: checkpatch cleanups - formatting only
      include/asm-x86/i8259.h: checkpatch cleanups - formatting only
      include/asm-x86/ia32.h: checkpatch cleanups - formatting only
      include/asm-x86/io_32.h: checkpatch cleanups - formatting only
      include/asm-x86/io_64.h: checkpatch cleanups - formatting only
      include/asm-x86/ioctls.h: checkpatch cleanups - formatting only
      include/asm-x86/io.h: checkpatch cleanups - formatting only
      include/asm-x86/ipcbuf.h: checkpatch cleanups - formatting only
      include/asm-x86/ipi.h: checkpatch cleanups - formatting only
      include/asm-x86/irq_32.h: checkpatch cleanups - formatting only
      include/asm-x86/irq_64.h: checkpatch cleanups - formatting only
      include/asm-x86/irqflags.h: checkpatch cleanups - formatting only
      include/asm-x86/kdebug.h: checkpatch cleanups - formatting only
      include/asm-x86/kexec.h: checkpatch cleanups - formatting only
      include/asm-x86/kprobes.h: checkpatch cleanups - formatting only
      include/asm-x86/kvm_host.h: checkpatch cleanups - formatting only
      include/asm-x86/kvm_x86_emulate.h: checkpatch cleanups - formatting only
      include/asm-x86/lguest_hcall.h: checkpatch cleanups - formatting only
      include/asm-x86/lguest.h: checkpatch cleanups - formatting only
      include/asm-x86/local.h: checkpatch cleanups - formatting only
      include/asm-x86/mc146818rtc.h: checkpatch cleanups - formatting only
      include/asm-x86/mca_dma.h: checkpatch cleanups - formatting only
      include/asm-x86/mmu_context_32.h: checkpatch cleanups - formatting only
      include/asm-x86/mmu_context_64.h: checkpatch cleanups - formatting only
      include/asm-x86/mmu.h: checkpatch cleanups - formatting only
      include/asm-x86/mmx.h: checkpatch cleanups - formatting only
      include/asm-x86/mmzone_32.h: checkpatch cleanups - formatting only
      include/asm-x86/mmzone_64.h: checkpatch cleanups - formatting only
      include/asm-x86/mpspec_def.h: checkpatch cleanups - formatting only
      include/asm-x86/mpspec.h: checkpatch cleanups - formatting only
      include/asm-x86/msidef.h: checkpatch cleanups - formatting only
      include/asm-x86/msr.h: checkpatch cleanups - formatting only
      include/asm-x86/mtrr.h: checkpatch cleanups - formatting only
      include/asm-x86/mutex_32.h: checkpatch cleanups - formatting only
      include/asm-x86/mutex_64.h: checkpatch cleanups - formatting only
      include/asm-x86/numa_64.h: checkpatch cleanups - formatting only
      include/asm-x86/numaq.h: checkpatch cleanups - formatting only
      include/asm-x86/page_32.h: checkpatch cleanups - formatting only
      include/asm-x86/page_64.h: checkpatch cleanups - formatting only
      include/asm-x86/param.h: checkpatch cleanups - formatting only
      include/asm-x86/paravirt.h: checkpatch cleanups - formatting only
      include/asm-x86/parport.h: checkpatch cleanups - formatting only
      include/asm-x86/pci_64.h: checkpatch cleanups - formatting only
      include/asm-x86/pci-direct.h: checkpatch cleanups - formatting only
      include/asm-x86/pci.h: checkpatch cleanups - formatting only
      include/asm-x86/pda.h: checkpatch cleanups - formatting only
      include/asm-x86/percpu.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable-2level.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable_32.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable-3level.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable_64.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable.h: checkpatch cleanups - formatting only
      include/asm-x86/posix_types_32.h: checkpatch cleanups - formatting only
      include/asm-x86/posix_types_64.h: checkpatch cleanups - formatting only
      include/asm-x86/processor.h: checkpatch cleanups - formatting only
      include/asm-x86/proto.h: checkpatch cleanups - formatting only
      include/asm-x86/ptrace.h: checkpatch cleanups - formatting only
      include/asm-x86/reboot.h: checkpatch cleanups - formatting only
      include/asm-x86/resume-trace.h: checkpatch cleanups - formatting only
      include/asm-x86/rio.h: checkpatch cleanups - formatting only
      include/asm-x86/rwsem.h: checkpatch cleanups - formatting only
      include/asm-x86/setup.h: checkpatch cleanups - formatting only
      include/asm-x86/sigcontext32.h: checkpatch cleanups - formatting only
      include/asm-x86/sigcontext.h: checkpatch cleanups - formatting only
      include/asm-x86/signal.h: checkpatch cleanups - formatting only
      include/asm-x86/smp_32.h: checkpatch cleanups - formatting only
      include/asm-x86/smp_64.h: checkpatch cleanups - formatting only
      include/asm-x86/spinlock.h: checkpatch cleanups - formatting only
      include/asm-x86/srat.h: checkpatch cleanups - formatting only
      include/asm-x86/string_32.h: checkpatch cleanups - formatting only
      include/asm-x86/string_64.h: checkpatch cleanups - formatting only
      include/asm-x86/suspend_32.h: checkpatch cleanups - formatting only
      include/asm-x86/suspend_64.h: checkpatch cleanups - formatting only
      include/asm-x86/swiotlb.h: checkpatch cleanups - formatting only
      include/asm-x86/sync_bitops.h: checkpatch cleanups - formatting only
      include/asm-x86/system.h: checkpatch cleanups - formatting only
      include/asm-x86/tce.h: checkpatch cleanups - formatting only
      include/asm-x86/thread_info_32.h: checkpatch cleanups - formatting only
      include/asm-x86/thread_info_64.h: checkpatch cleanups - formatting only
      include/asm-x86/tlbflush.h: checkpatch cleanups - formatting only
      include/asm-x86/topology.h: checkpatch cleanups - formatting only
      include/asm-x86/tsc.h: checkpatch cleanups - formatting only
      include/asm-x86/uaccess_32.h: checkpatch cleanups - formatting only
      include/asm-x86/uaccess_64.h: checkpatch cleanups - formatting only
      include/asm-x86/unaligned.h: checkpatch cleanups - formatting only
      include/asm-x86/unistd_32.h: checkpatch cleanups - formatting only
      include/asm-x86/unistd_64.h: checkpatch cleanups - formatting only
      include/asm-x86/user_32.h: checkpatch cleanups - formatting only
      include/asm-x86/user32.h: checkpatch cleanups - formatting only
      include/asm-x86/user_64.h: checkpatch cleanups - formatting only
      include/asm-x86/vdso.h: checkpatch cleanups - formatting only
      include/asm-x86/vga.h: checkpatch cleanups - formatting only
      include/asm-x86/vm86.h: checkpatch cleanups - formatting only
      include/asm-x86/vmi.h: checkpatch cleanups - formatting only
      include/asm-x86/voyager.h: checkpatch cleanups - formatting only
      include/asm-x86/xor_32.h: checkpatch cleanups - formatting only
      include/asm-x86/xor_64.h: checkpatch cleanups - formatting only

Johannes Weiner (1):
      x86: Remove redundant display of free swap space in show_mem()

Markus Armbruster (1):
      xen: make hvc0 the preferred console in domU

Mathieu Desnoyers (3):
      x86: enhance DEBUG_RODATA support - alternatives
      x86: enhance DEBUG_RODATA support for hotplug and kprobes
      x86: fix test_poke for vmalloced pages

Mikael Pettersson (1):
      x86: correct/clarify comment in nops.h

Mike Travis (1):
      x86: clean up non-smp usage of cpu maps

Paolo Ciarrocchi (42):
      x86: coding style fixes for arch/x86/kernel/cpu/centaur.c
      x86: coding style fixes to arch/x86/lib/memmove_64.c
      x86: coding style fixes to arch/x86/kernel/syscall_64.c
      x86: coding style fixes to arch/x86/lib/string_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/p5.c
      x86: coding style fixes to arch/x86/kernel/x8664_ksyms_64.c
      x86: coding style fixes to arch/x86/oprofile/op_model_ppro.c
      x86: coding style fixes to arch/x86/oprofile/op_model_athlon.c
      x86: coding style fixes to arch/x86/mach-generic/probe.c
      x86: coding style fixes to arch/x86/mach-generic/default.c
      x86: coding style fixes to arch/x86/mach-generic/summit.c
      x86: coding style fixes to arch/x86/kernel/cpu/nexgen.c
      x86: coding style fixes to arch/x86/mach-generic/bigsmp.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/p6.c
      x86: coding style fixes to arch/x86/kernel/cpu/umc.c
      x86: coding style fixes to arch/x86/boot/compressed/misc.c
      x86: coding style fix to arch/x86/boot/pm.c
      x86: coding style fixes to arch/x86/kernel/summit_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/intel.c
      x86: coding style fixes to arch/x86/oprofile/init.c
      x86: coding style fixes to arch/x86/lib/strstr_3
      x86: coding style fixes to arch/x86/kernel/mca_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mtrr/state.c
      x86: coding style fixes to arch/x86/lib/memcpy_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/transmeta.c
      x86: coding style fixes to arch/x86/kernel/cpu/amd.c
      x86: coding style fixes to arch/x86/kernel/vm86_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/non-fatal.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/winchip.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/mce_32.c
      x86: coding style fixes to arch/x86/boot/cpucheck.c
      x86: coding style fixes to arch/x86/kernel/cpu/cyrix.c
      x86: coding style fixes to arch/x86/oprofile/nmi_timer_int.c
      x86: coding style fixes to arch/x86/kernel/msr.c
      x86: coding style fixes to arch/x86/xen/multicalls.c
      x86: coding style fixes to arch/x86/power/cpu_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/common.c
      x86: coding style fixes to arch/x86/lib/usercopy_32.c
      x86: coding style fixes to arch/x86/kernel/early_printk.c
      x86: coding style fixes to x86/kernel/early_printk.c
      x86: coding style fixes to arch/x86/kernel/setup_32.c
      x86: coding style fixes to arch/x86/kernel/acpi/sleep.c

Pavel Machek (4):
      x86: wmb() confusion in system.h
      x86 iommu: add more documentation
      x86: clean up aperture_64.c
      x86: move suspend wakeup code to C

Randy Dunlap (1):
      x86: fix VisualWS and Voyager kexec build failures

Ravikiran G Thirumalai (5):
      x86: vSMP: Fix is_vsmp_box()
      x86: fix build breakage when PCI is define and PARAVIRT is not
      x86: vSMP: use pvops only if platform has the capability to support it
      x86: apic_is_clustered_box to indicate unsynched TSC's on multiboard vSMP systems
      x86: clean up vSMP detection

Robert P. J. Day (1):
      x86: Explicitly include required header files.

Robert Richter (1):
      x86: apic: extended interrupt LVT support for AMD

Roland McGrath (7):
      x86 vDSO: don't use disabled vDSO for signal trampoline
      x86 vDSO: don't map 32-bit vdso when disabled
      x86: ia32 ptrace vs -ENOSYS
      x86: ptrace vs -ENOSYS
      x86: ia32 ptrace vs -ENOSYS sysenter/syscall
      x86: sys32_execve PT_DTRACE
      x86: handle_vm86_trap cleanup

Roman Zippel (1):
      x86: fix recursive dependencies

Rusty Russell (1):
      x86: if we cannot calibrate the TSC, we panic.

Thomas Gleixner (3):
      x86: add debug info to DEBUG_PAGEALLOC
      x86: check physical address range in ioremap
      x86: replace the now useless max_pfn_mapped define

Thomas Petazzoni (1):
      x86: use ELF section to list CPU vendor specific code

Venki Pallipadi (3):
      x86: PAT infrastructure patch, documentation updates
      x86: PAT bug fix for attribute type check after reserve_memtype
      x86: PAT bug fix for attribute type check after reserve_memtype, debug

Yakov Lerner (1):
      x86, kprobes: correct post-eip value in post_hander()

Yinghai Lu (21):
      x86: clean up find_e820_area(), 64-bit
      x86: get apic_id later in acpi_numa_processor_affinity_init
      x86: remove never used nodenumer in pda
      x86: make amd quad core 8 socket system not be clustered_box, #2
      x86: clean up e820_reserve_resources on 64-bit
      x86: insert_resorce for lapic addr after e820_reserve_resources
      x86: apic_is_clustered_box for vsmp
      x86: remove wrong setting about CONSTANT_TSC for intel cpu
      x86: fix amd_detect_cmp
      x86: show apicid for cpu in proc
      x86: introduce initial apicid
      x86: sort address_markers for dump_pagetables
      x86: get boot_cpu_id as early for k8_scan_nodes
      x86: early memtest to find bad ram
      x86: allocate e820 resource struct all together
      x86: enable PAT for amd k8 and fam10h
      x86: pat cpu feature bit setting for known cpus
      x86: fix smpboot integration
      x86: memtest bootparam
      x86: fix memtest print out
      x86: print out buggy mptable

gorcunov@gmail.com (6):
      x86: relocate_kernel_32.S - clear register in more elegant way
      x86: relocate_kernel - use PAGE_SIZE instead of numeric constant
      x86: relocate_kernel - use predefined macroses for processor state
      x86: relocate_kernel - use predefined macroses for page attributes
      x86: cleanup - rename VM_MASK to X86_VM_MASK
      x86: replace most VM86 flags with flags from processor-flags.h

stephane eranian (2):
      x86: add cpu_has_arch_perfmon
      x86: add AMD Northbridge MSR definition

venkatesh.pallipadi@intel.com (9):
      x86: PAT documentation
      x86: PAT infrastructure patch
      x86: PAT make ioremap_change_attr non-static
      x86: PAT use reserve free memtype in ioremap and iounmap
      x86: PAT use reserve free memtype in set_memory_uc
      x86: PAT use reserve free memtype in pci_mmap_page_range
      x86: PAT add set_memory_wc() interface
      x86: PAT add ioremap_wc() interface
      x86: add PAT related debug prints

 Documentation/feature-removal-schedule.txt     |    2 +-
 Documentation/i386/boot.txt                    |   28 +
 Documentation/kernel-parameters.txt            |   18 +
 Documentation/x86/pat.txt                      |  100 ++
 Documentation/x86_64/boot-options.txt          |    5 +
 arch/x86/Kconfig                               |   70 +-
 arch/x86/Kconfig.cpu                           |    2 +-
 arch/x86/Kconfig.debug                         |   26 +-
 arch/x86/Makefile                              |    7 +-
 arch/x86/boot/Makefile                         |   16 +-
 arch/x86/boot/boot.h                           |    5 +
 arch/x86/boot/compressed/Makefile              |    2 +-
 arch/x86/boot/compressed/misc.c                |  202 +++--
 arch/x86/boot/cpucheck.c                       |   20 +-
 arch/x86/boot/header.S                         |    6 +-
 arch/x86/boot/pm.c                             |    2 +-
 arch/x86/boot/tools/build.c                    |   88 ++-
 arch/x86/boot/video-bios.c                     |    6 +
 arch/x86/boot/video-mode.c                     |  173 +++
 arch/x86/boot/video-vesa.c                     |    8 +
 arch/x86/boot/video-vga.c                      |   12 +-
 arch/x86/boot/video.c                          |  157 +---
 arch/x86/ia32/ia32_signal.c                    |    2 +-
 arch/x86/ia32/ia32entry.S                      |   12 +-
 arch/x86/ia32/sys_ia32.c                       |   31 +-
 arch/x86/kernel/Makefile                       |   19 +-
 arch/x86/kernel/acpi/Makefile                  |    9 +-
 arch/x86/kernel/acpi/boot.c                    |   67 +-
 arch/x86/kernel/acpi/realmode/Makefile         |   57 +
 arch/x86/kernel/acpi/realmode/copy.S           |    1 +
 arch/x86/kernel/acpi/realmode/video-bios.c     |    1 +
 arch/x86/kernel/acpi/realmode/video-mode.c     |    1 +
 arch/x86/kernel/acpi/realmode/video-vesa.c     |    1 +
 arch/x86/kernel/acpi/realmode/video-vga.c      |    1 +
 arch/x86/kernel/acpi/realmode/wakemain.c       |   81 ++
 arch/x86/kernel/acpi/realmode/wakeup.S         |  113 ++
 arch/x86/kernel/acpi/realmode/wakeup.h         |   36 +
 arch/x86/kernel/acpi/realmode/wakeup.lds.S     |   61 ++
 arch/x86/kernel/acpi/sleep.c                   |   73 ++-
 arch/x86/kernel/acpi/sleep.h                   |   16 +
 arch/x86/kernel/acpi/sleep_32.c                |   40 -
 arch/x86/kernel/acpi/wakeup_32.S               |  247 +----
 arch/x86/kernel/acpi/wakeup_64.S               |  313 +------
 arch/x86/kernel/acpi/wakeup_rm.S               |   10 +
 arch/x86/kernel/alternative.c                  |  103 ++-
 arch/x86/kernel/aperture_64.c                  |    6 +-
 arch/x86/kernel/apic_32.c                      |  224 ++++-
 arch/x86/kernel/apic_64.c                      |  140 +++-
 arch/x86/kernel/apm_32.c                       |    5 +-
 arch/x86/kernel/asm-offsets_32.c               |    2 +-
 arch/x86/kernel/bugs_64.c                      |   14 +-
 arch/x86/kernel/cpu/Makefile                   |    4 +-
 arch/x86/kernel/cpu/amd.c                      |  121 ++-
 arch/x86/kernel/cpu/centaur.c                  |  490 +++++-----
 arch/x86/kernel/cpu/common.c                   |  180 ++--
 arch/x86/kernel/cpu/cpu.h                      |   26 +-
 arch/x86/kernel/cpu/cyrix.c                    |  136 ++--
 arch/x86/kernel/cpu/feature_names.c            |    2 +-
 arch/x86/kernel/cpu/intel.c                    |  106 +-
 arch/x86/kernel/cpu/mcheck/mce_32.c            |   50 +-
 arch/x86/kernel/cpu/mcheck/non-fatal.c         |   21 +-
 arch/x86/kernel/cpu/mcheck/p5.c                |   16 +-
 arch/x86/kernel/cpu/mcheck/p6.c                |   48 +-
 arch/x86/kernel/cpu/mcheck/winchip.c           |    8 +-
 arch/x86/kernel/cpu/mtrr/generic.c             |  139 +++
 arch/x86/kernel/cpu/mtrr/if.c                  |    7 +-
 arch/x86/kernel/cpu/mtrr/main.c                |    2 +-
 arch/x86/kernel/cpu/mtrr/state.c               |   14 +-
 arch/x86/kernel/cpu/nexgen.c                   |   15 +-
 arch/x86/kernel/cpu/proc.c                     |  170 ++-
 arch/x86/kernel/cpu/transmeta.c                |   30 +-
 arch/x86/kernel/cpu/umc.c                      |   19 +-
 arch/x86/kernel/crash.c                        |    4 -
 arch/x86/kernel/ds.c                           |    8 +-
 arch/x86/kernel/e820_32.c                      |   27 +-
 arch/x86/kernel/e820_64.c                      |  156 ++-
 arch/x86/kernel/early_printk.c                 |   24 +-
 arch/x86/kernel/entry_32.S                     |   39 +-
 arch/x86/kernel/entry_64.S                     |    8 +-
 arch/x86/kernel/genapic_64.c                   |   47 +-
 arch/x86/kernel/genapic_flat_64.c              |    7 +-
 arch/x86/kernel/genx2apic_uv_x.c               |  245 +++++
 arch/x86/kernel/head32.c                       |   14 +
 arch/x86/kernel/head64.c                       |   78 +-
 arch/x86/kernel/head_32.S                      |    2 +-
 arch/x86/kernel/head_64.S                      |   28 +-
 arch/x86/kernel/i387.c                         |   88 +-
 arch/x86/kernel/io_apic_32.c                   |  164 ++--
 arch/x86/kernel/io_apic_64.c                   |   63 +-
 arch/x86/kernel/ipi.c                          |  178 ++++
 arch/x86/kernel/irq_32.c                       |    2 +-
 arch/x86/kernel/kprobes.c                      |   14 +-
 arch/x86/kernel/mca_32.c                       |   96 +-
 arch/x86/kernel/microcode.c                    |   16 +-
 arch/x86/kernel/{mpparse_32.c => mpparse.c}    |  850 +++++++--------
 arch/x86/kernel/mpparse_64.c                   |  867 ---------------
 arch/x86/kernel/msr.c                          |    4 +-
 arch/x86/kernel/nmi_32.c                       |   14 +-
 arch/x86/kernel/nmi_64.c                       |    2 +
 arch/x86/kernel/paravirt.c                     |   18 +-
 arch/x86/kernel/pci-dma_64.c                   |   20 +-
 arch/x86/kernel/process_32.c                   |   41 +-
 arch/x86/kernel/process_64.c                   |   27 +-
 arch/x86/kernel/ptrace.c                       |    1 -
 arch/x86/kernel/reboot.c                       |    5 +-
 arch/x86/kernel/relocate_kernel_32.S           |   30 +-
 arch/x86/kernel/relocate_kernel_64.S           |   40 +-
 arch/x86/kernel/rtc.c                          |   33 +-
 arch/x86/kernel/setup.c                        |  113 ++
 arch/x86/kernel/setup64.c                      |   81 +--
 arch/x86/kernel/setup_32.c                     |   95 ++-
 arch/x86/kernel/setup_64.c                     |  224 ++---
 arch/x86/kernel/{sigframe_32.h => sigframe.h}  |   14 +-
 arch/x86/kernel/signal_32.c                    |  303 +++---
 arch/x86/kernel/signal_64.c                    |  108 +--
 arch/x86/kernel/smp.c                          |  343 ++++++
 arch/x86/kernel/smp_32.c                       |  712 -------------
 arch/x86/kernel/smp_64.c                       |  530 ----------
 arch/x86/kernel/{smpboot_32.c => smpboot.c}    | 1345 +++++++++++++-----------
 arch/x86/kernel/smpboot_64.c                   | 1108 -------------------
 arch/x86/kernel/smpcommon.c                    |   83 ++
 arch/x86/kernel/smpcommon_32.c                 |   81 --
 arch/x86/kernel/srat_32.c                      |   10 +-
 arch/x86/kernel/step.c                         |    2 +-
 arch/x86/kernel/summit_32.c                    |   57 +-
 arch/x86/kernel/syscall_64.c                   |   13 +-
 arch/x86/kernel/test_nx.c                      |    2 +
 arch/x86/kernel/tlb_32.c                       |  243 +++++
 arch/x86/kernel/tlb_64.c                       |  274 +++++
 arch/x86/kernel/trampoline.c                   |   18 +
 arch/x86/kernel/trampoline_64.S                |    5 -
 arch/x86/kernel/traps_32.c                     |  612 ++++++-----
 arch/x86/kernel/traps_64.c                     |    2 +
 arch/x86/kernel/tsc_32.c                       |   16 +-
 arch/x86/kernel/tsc_64.c                       |    3 +-
 arch/x86/kernel/vm86_32.c                      |  213 ++--
 arch/x86/kernel/vmlinux_32.lds.S               |    5 +
 arch/x86/kernel/vmlinux_64.lds.S               |   11 +
 arch/x86/kernel/vsmp_64.c                      |  131 ++-
 arch/x86/kernel/x8664_ksyms_64.c               |   12 +-
 arch/x86/lguest/boot.c                         |    2 +-
 arch/x86/lib/memcpy_32.c                       |    2 +-
 arch/x86/lib/memmove_64.c                      |    8 +-
 arch/x86/lib/mmx_32.c                          |  197 ++--
 arch/x86/lib/string_32.c                       |   60 +-
 arch/x86/lib/strstr_32.c                       |    4 +-
 arch/x86/lib/usercopy_32.c                     |  122 ++--
 arch/x86/mach-generic/bigsmp.c                 |   30 +-
 arch/x86/mach-generic/default.c                |    8 +-
 arch/x86/mach-generic/probe.c                  |   37 +-
 arch/x86/mach-generic/summit.c                 |    8 +-
 arch/x86/mach-rdc321x/Makefile                 |    2 +-
 arch/x86/mach-rdc321x/wdt.c                    |  275 -----
 arch/x86/mach-voyager/voyager_smp.c            |   18 +-
 arch/x86/math-emu/fpu_entry.c                  |    1 +
 arch/x86/math-emu/reg_ld_str.c                 |   13 +-
 arch/x86/mm/Makefile                           |   16 +-
 arch/x86/mm/Makefile_32                        |    9 -
 arch/x86/mm/Makefile_64                        |    9 -
 arch/x86/mm/discontig_32.c                     |    2 +-
 arch/x86/mm/dump_pagetables.c                  |  354 +++++++
 arch/x86/mm/fault.c                            |    6 +-
 arch/x86/mm/init_32.c                          |   35 +-
 arch/x86/mm/init_64.c                          |  222 ++++-
 arch/x86/mm/ioremap.c                          |  152 ++-
 arch/x86/mm/numa_64.c                          |    6 +-
 arch/x86/mm/pageattr.c                         |  105 ++-
 arch/x86/mm/pat.c                              |  421 ++++++++
 arch/x86/mm/pgtable_32.c                       |    8 +-
 arch/x86/mm/srat_64.c                          |    7 +-
 arch/x86/oprofile/init.c                       |   13 +-
 arch/x86/oprofile/nmi_timer_int.c              |    6 +-
 arch/x86/oprofile/op_model_athlon.c            |   46 +-
 arch/x86/oprofile/op_model_ppro.c              |   52 +-
 arch/x86/pci/i386.c                            |   73 ++-
 arch/x86/pci/irq.c                             |   12 +-
 arch/x86/pci/numa.c                            |   32 +-
 arch/x86/power/cpu_32.c                        |   41 +-
 arch/x86/vdso/Makefile                         |    2 +-
 arch/x86/vdso/vdso32-setup.c                   |   11 +-
 arch/x86/xen/enlighten.c                       |    7 +-
 arch/x86/xen/multicalls.c                      |    4 +-
 arch/x86/xen/smp.c                             |    6 +-
 arch/x86/xen/xen-asm.S                         |   11 +-
 arch/x86/xen/xen-ops.h                         |    2 +-
 include/asm-x86/Kbuild                         |    1 +
 include/asm-x86/a.out-core.h                   |   12 +-
 include/asm-x86/acpi.h                         |    8 +-
 include/asm-x86/alternative.h                  |   32 +-
 include/asm-x86/apic.h                         |    7 +-
 include/asm-x86/apicdef.h                      |   69 +-
 include/asm-x86/atomic_32.h                    |  143 ++--
 include/asm-x86/atomic_64.h                    |  251 +++---
 include/asm-x86/{mach-default => }/bios_ebda.h |    0 
 include/asm-x86/bitops.h                       |   54 +-
 include/asm-x86/bitops_32.h                    |   40 +-
 include/asm-x86/bitops_64.h                    |   40 +-
 include/asm-x86/bug.h                          |   34 +-
 include/asm-x86/byteorder.h                    |   39 +-
 include/asm-x86/cacheflush.h                   |   80 ++-
 include/asm-x86/checksum_32.h                  |  152 ++--
 include/asm-x86/checksum_64.h                  |  118 +--
 include/asm-x86/cmpxchg_32.h                   |  253 +++---
 include/asm-x86/cmpxchg_64.h                   |  134 ++--
 include/asm-x86/compat.h                       |    2 +-
 include/asm-x86/cpufeature.h                   |    8 +-
 include/asm-x86/current_32.h                   |    2 +-
 include/asm-x86/current_64.h                   |   12 +-
 include/asm-x86/desc.h                         |   61 +-
 include/asm-x86/desc_defs.h                    |   15 +-
 include/asm-x86/div64.h                        |   35 +-
 include/asm-x86/dma.h                          |   45 +-
 include/asm-x86/dwarf2_64.h                    |    9 +-
 include/asm-x86/e820_32.h                      |    4 +-
 include/asm-x86/e820_64.h                      |   24 +-
 include/asm-x86/edac.h                         |    4 +-
 include/asm-x86/efi.h                          |    2 +-
 include/asm-x86/elf.h                          |  112 ++-
 include/asm-x86/fixmap_32.h                    |   21 +-
 include/asm-x86/fixmap_64.h                    |   20 +-
 include/asm-x86/floppy.h                       |   93 +-
 include/asm-x86/futex.h                        |  101 +-
 include/asm-x86/genapic_32.h                   |  105 +-
 include/asm-x86/genapic_64.h                   |   10 +
 include/asm-x86/geode.h                        |    2 +-
 include/asm-x86/highmem.h                      |    2 +-
 include/asm-x86/hw_irq_64.h                    |   15 +-
 include/asm-x86/hypertransport.h               |   15 +-
 include/asm-x86/i387.h                         |   23 +-
 include/asm-x86/i8259.h                        |   29 +-
 include/asm-x86/ia32.h                         |   62 +-
 include/asm-x86/io.h                           |    6 +
 include/asm-x86/io_32.h                        |  137 ++-
 include/asm-x86/io_64.h                        |  110 ++-
 include/asm-x86/io_apic.h                      |    8 +-
 include/asm-x86/ioctls.h                       |   13 +-
 include/asm-x86/ipcbuf.h                       |    3 +-
 include/asm-x86/ipi.h                          |   11 +-
 include/asm-x86/irq_32.h                       |    2 +-
 include/asm-x86/irq_64.h                       |    4 +-
 include/asm-x86/irqflags.h                     |   59 +-
 include/asm-x86/kdebug.h                       |    4 +-
 include/asm-x86/kexec.h                        |   71 +-
 include/asm-x86/kprobes.h                      |   12 +-
 include/asm-x86/kvm_host.h                     |   24 +-
 include/asm-x86/kvm_x86_emulate.h              |   28 +-
 include/asm-x86/lguest.h                       |   11 +-
 include/asm-x86/lguest_hcall.h                 |    5 +-
 include/asm-x86/linkage.h                      |    3 +
 include/asm-x86/local.h                        |  105 +-
 include/asm-x86/mach-bigsmp/mach_apic.h        |   18 +-
 include/asm-x86/mach-default/mach_apic.h       |   95 +-
 include/asm-x86/mach-default/mach_apicdef.h    |    9 +-
 include/asm-x86/mach-default/mach_ipi.h        |   10 +
 include/asm-x86/mach-default/mach_mpparse.h    |   11 -
 include/asm-x86/mach-default/mach_reboot.h     |   61 --
 include/asm-x86/mach-default/smpboot_hooks.h   |    7 +
 include/asm-x86/mach-es7000/mach_apic.h        |   20 +-
 include/asm-x86/mach-es7000/mach_mpparse.h     |   11 -
 include/asm-x86/mach-generic/mach_apic.h       |    1 -
 include/asm-x86/mach-generic/mach_mpparse.h    |    5 -
 include/asm-x86/mach-numaq/mach_apic.h         |   10 +
 include/asm-x86/mach-numaq/mach_mpparse.h      |   23 +-
 include/asm-x86/mach-summit/mach_apic.h        |   14 +-
 include/asm-x86/mach-summit/mach_mpparse.h     |   11 -
 include/asm-x86/mach-visws/mach_apic.h         |    2 +-
 include/asm-x86/mach-visws/smpboot_hooks.h     |    4 +
 include/asm-x86/mach_apic.h                    |   29 -
 include/asm-x86/mc146818rtc.h                  |   16 +-
 include/asm-x86/mca_dma.h                      |   34 +-
 include/asm-x86/mmu.h                          |    4 +-
 include/asm-x86/mmu_context_32.h               |   12 +-
 include/asm-x86/mmu_context_64.h               |   21 +-
 include/asm-x86/mmx.h                          |    2 +-
 include/asm-x86/mmzone_32.h                    |    4 +-
 include/asm-x86/mmzone_64.h                    |   24 +-
 include/asm-x86/mpspec.h                       |   47 +-
 include/asm-x86/mpspec_def.h                   |   46 +-
 include/asm-x86/msidef.h                       |   12 +-
 include/asm-x86/msr-index.h                    |    4 +
 include/asm-x86/msr.h                          |   89 +-
 include/asm-x86/mtrr.h                         |   73 +-
 include/asm-x86/mutex_32.h                     |   66 +-
 include/asm-x86/mutex_64.h                     |   73 +-
 include/asm-x86/nmi.h                          |   94 ++-
 include/asm-x86/nmi_32.h                       |   61 --
 include/asm-x86/nmi_64.h                       |   90 --
 include/asm-x86/nops.h                         |    2 +
 include/asm-x86/numa_64.h                      |    5 +-
 include/asm-x86/numaq.h                        |    9 +-
 include/asm-x86/page.h                         |    4 +-
 include/asm-x86/page_32.h                      |    9 +-
 include/asm-x86/page_64.h                      |   10 +-
 include/asm-x86/param.h                        |    4 +-
 include/asm-x86/paravirt.h                     |   54 +-
 include/asm-x86/parport.h                      |    6 +-
 include/asm-x86/pat.h                          |   16 +
 include/asm-x86/pci-direct.h                   |    2 +-
 include/asm-x86/pci.h                          |    8 +-
 include/asm-x86/pci_64.h                       |   14 +-
 include/asm-x86/pda.h                          |   81 +-
 include/asm-x86/percpu.h                       |  104 +-
 include/asm-x86/pgtable-2level.h               |   18 +-
 include/asm-x86/pgtable-3level.h               |   48 +-
 include/asm-x86/pgtable.h                      |  178 +++-
 include/asm-x86/pgtable_32.h                   |  100 +-
 include/asm-x86/pgtable_64.h                   |  151 ++--
 include/asm-x86/posix_types.h                  |    8 +-
 include/asm-x86/posix_types_32.h               |   47 +-
 include/asm-x86/posix_types_64.h               |   54 +-
 include/asm-x86/processor.h                    |  729 +++++++------
 include/asm-x86/proto.h                        |    6 +-
 include/asm-x86/ptrace.h                       |   46 +-
 include/asm-x86/reboot.h                       |    3 +-
 include/asm-x86/resume-trace.h                 |   15 +-
 include/asm-x86/rio.h                          |   76 +-
 include/asm-x86/rwsem.h                        |  169 ++--
 include/asm-x86/segment.h                      |    3 +-
 include/asm-x86/setup.h                        |    8 +-
 include/asm-x86/sigcontext.h                   |    7 +-
 include/asm-x86/sigcontext32.h                 |    4 +-
 include/asm-x86/signal.h                       |   48 +-
 include/asm-x86/smp.h                          |  210 ++++-
 include/asm-x86/smp_32.h                       |  165 ---
 include/asm-x86/smp_64.h                       |  101 --
 include/asm-x86/sparsemem.h                    |    6 +-
 include/asm-x86/spinlock.h                     |  117 +--
 include/asm-x86/srat.h                         |    2 +-
 include/asm-x86/string_32.h                    |    2 +-
 include/asm-x86/string_64.h                    |   66 +-
 include/asm-x86/suspend_32.h                   |   12 +-
 include/asm-x86/suspend_64.h                   |    5 +-
 include/asm-x86/swiotlb.h                      |   28 +-
 include/asm-x86/sync_bitops.h                  |   77 +-
 include/asm-x86/system.h                       |  115 ++-
 include/asm-x86/tce.h                          |    2 +-
 include/asm-x86/thread_info_32.h               |   88 +-
 include/asm-x86/thread_info_64.h               |   78 +-
 include/asm-x86/tlbflush.h                     |    5 +-
 include/asm-x86/topology.h                     |   23 +-
 include/asm-x86/trampoline.h                   |   21 +
 include/asm-x86/tsc.h                          |    2 +-
 include/asm-x86/uaccess_32.h                   |  316 ++++---
 include/asm-x86/uaccess_64.h                   |  376 ++++---
 include/asm-x86/unaligned.h                    |    2 +-
 include/asm-x86/unistd.h                       |    8 +-
 include/asm-x86/unistd_32.h                    |    2 +-
 include/asm-x86/unistd_64.h                    |    2 +-
 include/asm-x86/user32.h                       |    7 +-
 include/asm-x86/user_32.h                      |    6 +-
 include/asm-x86/user_64.h                      |   16 +-
 include/asm-x86/uv/uv_hub.h                    |  284 +++++
 include/asm-x86/uv/uv_mmrs.h                   |  373 +++++++
 include/asm-x86/vdso.h                         |   23 +-
 include/asm-x86/vga.h                          |    4 +-
 include/asm-x86/vm86.h                         |   23 +-
 include/asm-x86/vmi.h                          |   88 +-
 include/asm-x86/voyager.h                      |   51 +-
 include/asm-x86/xor_32.h                       |  494 +++++-----
 include/asm-x86/xor_64.h                       |  294 +++---
 360 files changed, 13763 insertions(+), 12537 deletions(-)
 create mode 100644 Documentation/x86/pat.txt
 create mode 100644 arch/x86/boot/video-mode.c
 create mode 100644 arch/x86/kernel/acpi/realmode/Makefile
 create mode 100644 arch/x86/kernel/acpi/realmode/copy.S
 create mode 100644 arch/x86/kernel/acpi/realmode/video-bios.c
 create mode 100644 arch/x86/kernel/acpi/realmode/video-mode.c
 create mode 100644 arch/x86/kernel/acpi/realmode/video-vesa.c
 create mode 100644 arch/x86/kernel/acpi/realmode/video-vga.c
 create mode 100644 arch/x86/kernel/acpi/realmode/wakemain.c
 create mode 100644 arch/x86/kernel/acpi/realmode/wakeup.S
 create mode 100644 arch/x86/kernel/acpi/realmode/wakeup.h
 create mode 100644 arch/x86/kernel/acpi/realmode/wakeup.lds.S
 create mode 100644 arch/x86/kernel/acpi/sleep.h
 delete mode 100644 arch/x86/kernel/acpi/sleep_32.c
 create mode 100644 arch/x86/kernel/acpi/wakeup_rm.S
 create mode 100644 arch/x86/kernel/genx2apic_uv_x.c
 create mode 100644 arch/x86/kernel/head32.c
 create mode 100644 arch/x86/kernel/ipi.c
 rename arch/x86/kernel/{mpparse_32.c => mpparse.c} (53%)
 delete mode 100644 arch/x86/kernel/mpparse_64.c
 create mode 100644 arch/x86/kernel/setup.c
 rename arch/x86/kernel/{sigframe_32.h => sigframe.h} (66%)
 create mode 100644 arch/x86/kernel/smp.c
 delete mode 100644 arch/x86/kernel/smp_32.c
 delete mode 100644 arch/x86/kernel/smp_64.c
 rename arch/x86/kernel/{smpboot_32.c => smpboot.c} (62%)
 delete mode 100644 arch/x86/kernel/smpboot_64.c
 create mode 100644 arch/x86/kernel/smpcommon.c
 create mode 100644 arch/x86/kernel/tlb_32.c
 create mode 100644 arch/x86/kernel/tlb_64.c
 create mode 100644 arch/x86/kernel/trampoline.c
 delete mode 100644 arch/x86/mach-rdc321x/wdt.c
 delete mode 100644 arch/x86/mm/Makefile_32
 delete mode 100644 arch/x86/mm/Makefile_64
 create mode 100644 arch/x86/mm/dump_pagetables.c
 create mode 100644 arch/x86/mm/pat.c
 rename include/asm-x86/{mach-default => }/bios_ebda.h (100%)
 delete mode 100644 include/asm-x86/mach-default/mach_reboot.h
 delete mode 100644 include/asm-x86/mach_apic.h
 delete mode 100644 include/asm-x86/nmi_32.h
 delete mode 100644 include/asm-x86/nmi_64.h
 create mode 100644 include/asm-x86/pat.h
 delete mode 100644 include/asm-x86/smp_32.h
 delete mode 100644 include/asm-x86/smp_64.h
 create mode 100644 include/asm-x86/trampoline.h
 create mode 100644 include/asm-x86/uv/uv_hub.h
 create mode 100644 include/asm-x86/uv/uv_mmrs.h

