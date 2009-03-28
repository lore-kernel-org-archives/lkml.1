Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbZC1Vdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbZC1Vdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761275AbZC1Vbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:31:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761255AbZC1Vb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:31:27 -0400
Date: Sat, 28 Mar 2009 22:31:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] percpu, cpumask, x86 updates for v2.6.30
Message-ID: <20090328213108.GA3938@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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


( Resend to lkml without the full diff, 1.5MB was too large for lkml. )

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Linus,

Please pull the latest percpu-cpumask-x86-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git percpu-cpumask-x86-for-linus-2

------------------>
Alain Knaff (8):
      bzip2/lzma: library support for gzip, bzip2 and lzma decompression
      bzip2/lzma: config and initramfs support for bzip2/lzma decompression
      bzip2/lzma: x86 kernel compression support
      bzip2/lzma: fix built-in initramfs vs CONFIG_RD_GZIP
      bzip2/lzma: fix decompress_inflate.c vs multi-block-with-embedded-filename
      bzip2/lzma: don't stop search at first unconfigured compression
      bzip2/lzma: don't leave empty files around on failure
      bzip2/lzma: make internal initramfs compression configurable

Alok Kataria (2):
      x86, apic: fix initialization of wakeup_cpu
      x86, vmi: TSC going backwards check in vmi clocksource, cleanup

Andi Kleen (1):
      x86, mce: enable machine checks in 64-bit defconfig

Andreas Herrmann (7):
      x86: memtest: reuse test patterns when memtest parameter exceeds number of available patterns
      x86: memtest: introduce array to select memtest patterns
      x86: memtest: cleanup memtest function
      x86: memtest: adapt log messages
      x86: memtest: wipe out test pattern from memory
      x86: update description for memtest boot parameter
      x86: memtest: add additional (regular) test patterns

Andreas Schwab (1):
      x86 setup: fix asm constraints in vesa_store_edid

Arjan van de Ven (6):
      x86: setup stack canary for the idle threads
      x86: add CONFIG_CC_STACKPROTECTOR self-test
      stackprotector: turn not having the right gcc into a #warning
      stackprotector: better self-test
      x86: simplify stackprotector self-check
      x86: don't pretend that non-framepointer stack traces are reliable

Baodong Chen (1):
      Documentation/x86/boot.txt: modify fieldname

Benjamin LaHaise (1):
      x86-64: remove locked instruction from switch_to()

Brian Gerst (48):
      x86-64: Move irq stats from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Move TLB state from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Convert irqstacks to per-cpu
      x86-64: Convert exception stacks to per-cpu
      x86-64: Move cpu number from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Move current task from PDA to per-cpu and consolidate with 32-bit.
      x86-64: Move kernelstack from PDA to per-cpu.
      x86-64: Move oldrsp from PDA to per-cpu.
      x86-64: Move irqcount from PDA to per-cpu.
      x86-64: Move nodenumber from PDA to per-cpu.
      x86-64: Move isidle from PDA to per-cpu.
      x86-64: Use absolute displacements for per-cpu accesses.
      x86: remove pda_init()
      percpu: refactor percpu.h
      x86: rework __per_cpu_load adjustments
      x86: move stack_canary into irq_stack
      x86: remove pda.h
      x86: clean up gdt_page definition
      x86: fix percpu_write with 64-bit constants
      x86: set %fs to __KERNEL_PERCPU unconditionally for x86_32
      x86: merge mmu_context.h
      x86: merge irq_regs.h
      x86: remove idle_timestamp from 32bit irq_cpustat_t
      x86: remove include of apic.h from hardirq_64.h
      x86: sync hardirq_{32,64}.h
      x86: merge hardirq_{32,64}.h into hardirq.h
      x86: make irq_cpustat_t fields conditional
      generic, x86: fix __per_cpu_load relocation
      x86: merge setup_per_cpu_maps() into setup_per_cpu_areas()
      x86: move 64-bit NUMA code
      x86: move setup_cpu_local_masks()
      x86: always page-align per-cpu area start and size
      x86: move apic variables to apic.c
      x86: only compile setup_percpu.o on SMP
      x86: move this_cpu_offset
      x86: don't assume boot cpu is #0
      x86: make Voyager use x86 per-cpu setup.
      x86: initialize per-cpu GDT segment in per-cpu setup
      x86: remove extra barriers from load_gs_base()
      x86: load new GDT after setting up boot cpu per-cpu area
      x86: pass in cpu number to switch_to_new_gdt()
      percpu: make PER_CPU_BASE_SECTION overridable by arches
      x86: use linker to offset symbols by __per_cpu_load
      x86: fix abuse of per_cpu_offset
      x86: use pt_regs pointer in do_device_not_available()
      x86: pass in pt_regs pointer for syscalls that need it
      x86: drop -fno-stack-protector annotations after pt_regs fixes
      x86: use regparm(3) for passed-in pt_regs pointer

Christophe Saout (1):
      xen: fix too early kmalloc call

Cliff Wickman (2):
      x86: UV fix uv_flush_send_and_wait()
      x86: UV: remove uv_flush_tlb_others() WARN_ON

Cyrill Gorcunov (17):
      x86: headers cleanup - prctl.h
      x86: headers cleanup - sigcontext32.h
      x86: headers cleanup - setup.h
      x86: headers cleanup - boot.h
      x86: trampoline_64.S - use predefined constants with simplification
      x86: asm linkage - introduce GLOBAL macro
      x86: linkage - get rid of _X86 macros
      x86: copy.S - use GLOBAL,ENDPROC macros
      x86: pmjump - use GLOBAL,ENDPROC macros
      x86: compressed head_64 - use ENTRY,ENDPROC macros
      x86: compressed head_32 - use ENTRY,ENDPROC macros
      x86: head_64.S - remove useless balign
      x86: head_64.S - use IDT_ENTRIES instead of hardcoded number
      x86: invalid_vm86_irq -- use predefined macros
      x86: entry_64.S - add missing ENDPROC
      x86: head_64.S - use GLOBAL macro
      x86: efi_stub_32,64 - add missing ENDPROCs

Daniel Walker (1):
      panic.c: fix whitespace additions

Dean Nelson (1):
      SGI IA64 UV: fix ia64 build error in the linux-next tree

Dimitri Sivanich (1):
      x86, UV: set full apicid in uv_hub_send_ipi

Eric Sandeen (1):
      stackprotector: use canary at end of stack to indicate overruns at oops time

Frederic Weisbecker (1):
      x86: micro-optimize __raw_read_trylock()

Frederik Deweerdt (1):
      x86, tlb flush_data: replace per_cpu with an array

Gustavo F. Padovan (8):
      x86, fixmap: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE
      x86, fixmap: define FIXADDR_BOOT_* and redefine FIX_ADDR_SIZE
      x86, fixmap: define reserve_top_address for x86_64
      x86, fixmap: add CONFIG_X86_{LOCAL,IO}_APIC
      x86, fixmap: add CONFIG_EFI
      x86, fixmap: prepare fixmap_64.h for unification
      x86, fixmap: prepare fixmap_32.h for unification
      x86, fixmap: unify fixmap.h

H. Peter Anvin (18):
      bzip2/lzma: use a table to search for initramfs compression formats
      bzip2/lzma: handle failures from bzip2 and lzma correctly
      bzip2/lzma: make config machinery an arch configurable
      bzip2/lzma: proper Kconfig dependencies for the ramdisk options
      bzip2/lzma: DECOMPRESS_GZIP should select ZLIB_INFLATE
      bzip2/lzma: move initrd/ramfs options out of BLK_DEV
      bzip2/lzma: fix constant in decompress_inflate
      bzip2/lzma: centralize format detection
      bzip2/lzma: comprehensible error messages for missing decompressor
      init: make initrd/initramfs decompression failure a KERN_EMERG event
      bzip2/lzma: update boot protocol specification
      x86: clean up stray space in <asm/processor.h>
      x86: handle PAT more like other CPU features
      x86: filter CPU features dependent on unavailable CPUID levels
      x86 setup: a20: early timeout for a nonexistent keyboard controller
      x86: merge sys_rt_sigreturn between 32 and 64 bits
      x86: truncate ISA addresses to unsigned int
      x86, mce: enable machine checks in 32-bit defconfig

Hannes Eder (2):
      x86: kexec/i386: fix sparse warnings: Using plain integer as NULL pointer
      x86: numa_32.c: fix sparse warning: Using plain integer as NULL pointer

Hiroshi Shimamoto (18):
      x86: uaccess: fix style problems
      x86: uaccess: rename __put_user_u64() to __put_user_asm_u64()
      x86: uaccess: introduce try and catch framework
      x86: signal: use {get|put}_user_try and catch
      x86: ia32_signal: use {get|put}_user_try and catch
      x86: uaccess: fix compilation error on CONFIG_M386
      x86: mm: introduce helper function in fault.c
      x86: uaccess: use errret as error value in __put_user_size()
      x86: syscalls.h: remove asmlinkage from declaration of sys_rt_sigreturn()
      x86: ia32_signal: remove unused debug code
      x86: ia32_signal: introduce GET_SEG() macro
      x86: ia32_signal: introduce {get|set}_user_seg()
      x86: signal: add __user annotation
      x86: signal: intrroduce get_sigframe() and replace get_sigstack()
      x86: signal: use 16 bytes boundary for rt_sigframe
      x86: signal: unify get_sigframe()
      x86: signal: introduce helper align_sigframe()
      x86, signals: fix xine & firefox bustage

Huang Ying (1):
      x86: kexec: Use one page table in x86_64 machine_kexec

Ian Campbell (4):
      xen: explicitly initialise the cpu field of irq_info
      xen: expose enable_IO_APIC for 32-bit
      xen: fix xen_flush_tlb_others
      x86, xen: record and display initiator of each multicall when debugging

Ingo Molnar (230):
      x86: stackprotector & PARAVIRT fix
      x86: fix stackprotector canary updates during context switches
      x86: fix canary of the boot CPU's idle task
      panic: print more informative messages on stackprotect failure
      panic: print out stacktrace if DEBUG_BUGVERBOSE
      x86: if stackprotector is enabled, thn use stack-protector-all by default
      stackprotector: include files
      stackprotector: add boot_init_stack_canary()
      x86: fix the stackprotector canary of the boot CPU
      x86: stackprotector: mix TSC to the boot canary
      x86: unify stackprotector features
      stackprotector: remove self-test
      bzip2/lzma: make flush_buffer() unconditional
      x86: change the default cache size to 64 bytes
      x86: fix broken flush_tlb_others_ipi(), fix
      fix: crash: IP: __bitmap_intersects+0x48/0x73
      percpu: add optimized generic percpu accessors
      x86, rdc321x: remove/move leftover files
      x86: fully honor "nolapic", fix
      x86, cpumask: fix tlb flush race
      x86, mm: move tlb.c to arch/x86/mm/
      x86: uv cleanup, build fix
      x86: make x86_32 use tlb_64.c, build fix, clean up X86_L1_CACHE_BYTES
      x86: uv cleanup, build fix #2
      x86, xen: fix hardirq.h merge fallout
      x86, debug: remove early_printk() #ifdefs from head_32.S
      x86: improve early fault/irq printout
      x86, genapic: refactor genapic_64.h
      x86, genapic: refactor genapic_32.h
      x86, genapic: unify struct genapic
      x86, genapic: finish unification
      x86, genapic: cleanups
      x86, genapic: provide IPI callbacks unconditionally
      x86: rename 'genapic' to 'apic'
      x86: clean up genapic_flat
      x86: clean up genapic_phys_flat
      x86: clean up apic_x2apic_uv_x
      x86: clean up apic_x2apic_phys
      x86: clean up apic_x2apic_cluster
      x86, genapic: cleanup 32-bit apic_default template
      x86, genapic: cleanup 32-bit apic_bigsmp template
      x86, genapic: cleanup 32-bit apic_numaq template
      x86, genapic: cleanup 32-bit apic_es7000 template
      x86, genapic: cleanup 32-bit apic_summit template
      x86: remove APIC_INIT / APICFUNC / IPIFUNC
      x86: clean up apic->acpi_madt_oem_check methods
      x86: clean up apic->apic_id_registered() methods
      x86, genapic: rename int_delivery_mode, et. al.
      x86, apic: remove IRQ_DEST_MODE / IRQ_DELIVERY_MODE
      x86, apic: remove DEFAULT_IRQ_DELIVERY_MODE and DEFAULT_IRQ_DEST_MODE
      x86, apic: remove SUMMIT_IRQ_DELIVERY_MODE and SUMMIT_IRQ_DEST_MODE
      x86, apic: remove NUMAQ_IRQ_DELIVERY_MODE and NUMAQ_IRQ_DEST_MODE
      x86, apic: remove BIGSMP_IRQ_DELIVERY_MODE and BIGSMP_IRQ_DEST_MODE
      x86, apic: remove ES7000_IRQ_DELIVERY_MODE and ES7000_IRQ_DEST_MODE
      x86, apic: remove IRQ_DEST_MODE
      x86, apic: clean up target_cpus methods
      x86, apic: clean up / remove TARGET_CPUS
      x86: clean up esr_disable() methods
      x86: rename ->ESR_DISABLE to ->disable_esr
      x86: clean up the APIC_DEST_LOGICAL logic
      x86, apic: rename genapic::apic_destination_logical to genapic::dest_logical
      x86, apic: clean up check_apicid*() callbacks
      x86, apic: remove no_balance_irq and no_ioapic_check flags
      x86, apic: clean up ->vector_allocation_domain()
      x86, apic: clean up ->init_apic_ldr()
      x86, apic: clean up ->ioapic_phys_id_map()
      x86, apic: clean up ->setup_apic_routing()
      x86, apic: streamline the ->multi_timer_check() quirk
      x86, apic: clean up ->apicid_to_node()
      x86, apic: clean up ->cpu_to_logical_apicid()
      x86, apic: clean up ->cpu_present_to_apicid()
      x86, apic: clean up ->apicid_to_cpu_present()
      x86: refactor ->setup_portio_remap() subarch methods
      x86: refactor ->check_phys_apicid_present() subarch methods
      x86: refactor ->enable_apic_mode() subarch methods
      x86, es7000: clean up es7000_enable_apic_mode()
      x86, apic: unify phys_pkg_id()
      x86, apic: refactor ->phys_pkg_id()
      x86, smp: clean up mps_oem_check()
      x86, mpparse: call the generic quirk handlers early
      x86: consolidate the ->mps_oem_check() code
      x86, apic: refactor ->get_apic_id() & GET_APIC_ID()
      x86, apic: refactor ->apic_id_mask & APIC_ID_MASK
      x86, apic: get rid of *_APIC_ID_MASK definitions
      x86, apic: refactor ->cpu_mask_to_apicid*()
      x86, apic: untangle the send_IPI_*() jungle
      x86, smp: clean up ->trampoline_phys_low/high handling
      x86: set ->trampoline_phys_low/high on 64-bit too
      x86, smp: refactor ->wait_for_init_deassert()
      x86, smp: refactor ->smp_callin_clear_local_apic() methods
      x86, smp: refactor ->store/restore_NMI_vector() methods
      x86, smp: remove ->restore_NMI_vector()
      x86, smp: refactor ->inquire_remote_apic() methods
      x86, ES7000: consolidate the APIC code
      x86, smp: eliminate asm/mach-default/mach_wakecpu.h
      x86: eliminate asm/mach-*/mach_mpparse.h
      x86: remove mach_mpspec.h
      x86: remove mach_apicdef.h
      x86, smp: refactor ->wake_cpu
      x86, numaq: consolidate code
      x86, summit: consolidate code
      x86, summit: consolidate code, fix
      x86: remove mach_apic.h
      x86, ES7000: Consolidate code
      x86, NUMAQ: Consolidate code
      x86, bigsmp: consolidate code
      x86, bigsmp: consolidate header code
      x86, smp: remove mach_ipi.h
      x86: remove subarchitecture support code
      x86: move mach-default/*.h files to asm/
      x86: remove subarchitecture support
      x86/Voyager: clean up BROKEN Kconfig reference
      x86: disable Voyager temporarily
      x86/Voyager: remove MCA Kconfig quirk
      x86/Voyager: remove NATSEMI Kconfig quirk
      x86/Voyager: remove KVM Kconfig quirk
      x86/Voyager: remove KGDB Kconfig quirk
      x86/Voyager: remove HIBERNATION Kconfig quirk
      x86/Voyager: remove ARCH_SUSPEND_POSSIBLE Kconfig quirk
      x86: replace CONFIG_X86_SMP with CONFIG_SMP
      x86: generalize boot_cpu_id
      x86/Voyager: remove X86_HT Kconfig quirk
      x86/Voyager: remove X86_BIOS_REBOOT Kconfig quirk
      x86/Voyager: remove X86_FIND_SMP_CONFIG Kconfig quirk
      x86/VisWS: remove Kconfig quirk
      x86/Voyager: remove VMI Kconfig quirk
      x86/Voyager: remove KVM_CLOCK quirk
      x86/Voyager: remove KVM_GUEST quirk
      x86/Voyager: remove PARAVIRT Kconfig quirk
      x86/Voyager: remove APIC/IO-APIC Kbuild quirk
      x86/Voyager: remove MCE quirk
      x86/Voyager: remove HOTPLUG_CPU Kconfig quirk
      x86/Voyager: remove power management Kconfig quirk
      x86/Voyager: remove ISA quirk
      x86: cleanup, introduce CONFIG_NON_STANDARD_PLATFORMS
      x86: move ELAN to the NON_STANDARD_PLATFORM section
      x86: move VOYAGER to the NON_STANDARD_PLATFORM section
      x86: move non-standard 32-bit platform Kconfig entries
      x86: move X86_VSMP from subarch menu
      x86: remove the subarch menu
      x86: rename X86_GENERICARCH to X86_32_NON_STANDARD
      x86/Voyager: move to the X86_32_NON_STANDARD code section
      Revert "generic, x86: fix __per_cpu_load relocation"
      x86, apic, 32-bit: add self-IPI methods
      x86, irq: add LOCAL_PERF_VECTOR
      x86, apic: clean up header section
      x86: update copyrights
      x86, apic: unify the APIC vector enumeration
      x86, apic: clean up spurious vector sanity check
      x86, voyager: move Voyager-specific defines to voyager.h
      x86, irqs, voyager: remove Voyager quirk
      x86, irq: add IRQ layout comments
      x86, irq_vectors.h: remove needless includes
      x86, irq: describe NR_IRQ sizing details, clean up
      x86, vm86: clean up invalid_vm86_irq()
      x86: document 64-bit and 32-bit function call convention ABI
      smp, generic: introduce arch_disable_smp_support() instead of disable_ioapic_setup()
      x86, apic: explain the purpose of max_physical_apicid
      smp, generic: introduce arch_disable_smp_support(), build fix
      x86, numaq: cleanups
      x86: clean up arch/x86/Kconfig*
      x86: early_printk.c - fix pgtable.h unification fallout
      x86, pgtable.h: macro-ify *_page() methods
      x86, pgtable.h: fix 2-level 32-bit build
      x86, apic: make generic_apic_probe() generally available
      stackprotector: fix multi-word cross-builds
      x86: make hibernation always-possible
      x86, defconfig: update the 32-bit defconfig
      x86, defconfig: update the 64-bit defconfig
      x86, defconfig: turn off CONFIG_ENABLE_WARN_DEPRECATED
      x86, defconfig: turn off CONFIG_SCSI_ISCSI_ATTRS=y
      x86: fix warning in find_low_pfn_range()
      x86, 32-bit: clean up find_low_pfn_range()
      x86, 32-bit: refactor find_low_pfn_range()
      x86 headers: remove duplicate pud_large() definition
      x86 headers: include linux/types.h
      x86 headers: include page_types.h in pgtable_types.h
      x86 headers: protect page_32.h via __ASSEMBLY__
      x86: remove stale arch/x86/include/asm/page_64.h.rej file
      x86, apic: fix build fallout of genapic changes
      remove: genapic prepare
      x86, apic: merge genapic.h into apic.h
      x86, apic: remove genapic.h
      x86, apic: remove duplicate asm/apic.h inclusions
      x86, apic: remove stale references to APIC_DEFINITION
      x86, apic: clean up arch/x86/kernel/bigsmp_32.c
      x86, apic: clean up the cpu_2_logical_apiciddeclaration
      x86, es7000: clean up
      x86, apic: remove apicid_cluster()
      x86, es7000: remove externs
      x86, es7000: remove dead code, clean up
      x86, es7000: misc cleanups
      x86, numaq_32: clean up
      x86, numaq_32: clean up, misc
      x86, apic: remove ->store_NMI_vector()
      x86, apic: rename 'genapic' to 'apic'
      x86, apic: move APIC drivers to arch/x86/kernel/apic/*
      x86, apic: move remaining APIC drivers to arch/x86/kernel/apic/*
      x86, apic: separate 32-bit setup functionality out of apic_32.c
      x86, pat: add large-PAT check to split_large_page()
      x86, mm: fault.c cleanup
      x86, mm: fault.c, refactor/simplify the is_prefetch() code
      x86, mm: fault.c, factor out the vm86 fault check
      x86, mm: fault.c, enable PF_RSVD checks on 32-bit too
      x86, mm: fault.c, simplify kmmio_fault()
      x86, mm, kprobes: fault.c, simplify notify_page_fault()
      x86, mm: fault.c, reorder functions
      x86, mm: fault.c, unify oops printing
      x86, mm: fault.c, unify oops handling
      x86, mm: fault.c, remove #ifdef from do_page_fault()
      x86, mm: rename TASK_SIZE64 => TASK_SIZE_MAX
      x86, mm: fault.c, remove #ifdef from fault_in_kernel_space()
      x86, mm: fault.c, give another attempt at prefetch handing before SIGBUS
      x86, mm: fault.c, update copyrights
      x86, mm: fault.c, simplify kmmio_fault(), cleanup
      x86: remove the Voyager 32-bit subarch
      x86: remove various unused subarch hooks
      x86: refactor x86_quirks support
      x86, mm: pass in 'total' to __copy_from_user_*nocache()
      x86: usercopy: check for total size when deciding non-temporal cutoff
      alloc_percpu: add align argument to __alloc_percpu, fix
      alloc_percpu: fix UP build
      gpu/drm, x86, PAT: PAT support for io_mapping_*, export symbols for modules
      x86: remove update_apic from x86_quirks, fix
      x86: apic: simplify secondary CPU wakeup methods
      x86: apic: simplify secondary CPU wakeup methods, fix
      x86: fix !ACPI build for es7000_32.c
      Revert "gpu/drm, x86, PAT: PAT support for io_mapping_*"
      x86, mm: dont use non-temporal stores in pagecache accesses
      x86: set_highmem_pages_init() cleanup, fix !CONFIG_NUMA && CONFIG_HIGHMEM=y

James Bottomley (2):
      x86: fix build breakage on voyage
      x86: fix "__udivdi3" [drivers/scsi/aha1542.ko] undefined

Jan Beulich (2):
      x86: fully honor "nolapic"
      x86: avoid early crash in disable_local_APIC()

Jaswinder Singh Rajput (29):
      x86: smp.h remove obsolete function declaration
      x86: smp.h move zap_low_mappings declartion to tlbflush.h
      x86: smp.h move prefill_possible_map declartion to cpu.h
      x86: smp.h move stack_processor_id declartion to cpu.h
      x86: smp.h move safe_smp_processor_id declartion to cpu.h
      x86: smp.h move cpu_physical_id declartion to cpu.h
      x86: smp.h move boot_cpu_id declartion to cpu.h
      x86: rename intel_mp_floating to mpf_intel
      x86: rename all fields of mpf_intel mpf_X to X
      x86: smp.h move cpu_callin_mask and cpu_callin_map declartion to cpumask.h
      x86: smp.h move cpu_callout_mask and cpu_callout_map declartion to cpumask.h
      x86: smp.h move cpu_initialized_mask and cpu_initialized declartion to cpumask.h
      x86: smp.h move cpu_sibling_setup_mask and cpu_sibling_setup_map declartion to cpumask.h
      x86: microcode_intel.c fix style problems
      x86: msr.c fix style problems
      x86: module_32.c fix style problems
      x86: module_64.c fix style problems
      x86: replacing mp_config_ioapic with mpc_ioapic
      x86: replacing mp_config_intsrc with mpc_intsrc
      unconditionally include asm/types.h from linux/types.h
      x86: mm/init_32.c fix compilation warning
      x86: kernel/mpparse.c fix compilation warnings
      drm_proc.c fix compilation warning
      falcon fix compilation warnings
      iscsi_ibft.c fix compilation warning
      ne3210.c fix compilation warning for phys_addr_t
      arlan-main.c fix compilation warnings for phys_addr_t
      x86: include/asm/processor.h remove double declaration of print_cpu_info
      x86: remove double copy of show_cpuinfo_core for 32 and 64 bit

Jeremy Fitzhardinge (92):
      x86/pvops: remove pte_flags pvop
      x86: add pte_set_flags/clear_flags for pte flag manipulation
      x86: unify asm/io.h: IO_SPACE_LIMIT
      xen: move remaining mmu-related stuff into mmu.c
      x86/pvops: add a paravirt_ident functions to allow special patching
      x86: fix paravirt clobber in entry_64.S
      x86/paravirt: selectively save/restore regs around pvops calls
      x86/paravirt: add register-saving thunks to reduce caller register pressure
      x86/paravirt: implement PVOP_CALL macros for callee-save functions
      x86/paravirt: use callee-saved convention for pte_val/make_pte/etc
      x86/paravirt: fix missing callee-save call on pud_val
      x86: split loading percpu segments from loading gdt
      xen: setup percpu data pointers
      x86/paravirt: don't restore second return reg
      x86/vmi: fix interrupt enable/disable/save/restore calling convention.
      x86/paravirt: return full 64-bit result
      xen: fix 32-bit build resulting from mmu move
      xen: setup percpu data pointers
      xen: make direct versions of irq_enable/disable/save/restore to common code
      xen: use direct ops on 64-bit
      x86: unify pte_none
      x86: unify pte_same
      x86: unify pte_present
      x86: unify pud_present
      x86: unify pgd_present
      x86: unify pmd_present
      x86: unify pmd_none
      x86: unify pgd_page_vaddr
      x86: unify pud_page_vaddr
      x86: include pgtable_SIZE.h earlier
      x86: unify pud_page
      x86: unify pgd_page
      x86: unify pud_index
      x86: unify pud_offset
      x86: unify pmd_page_vaddr
      x86: unify pmd_page
      x86: unify pmd_index
      x86: unify pmd_offset
      x86: remove redundant pfn_pmd definition
      x86: unify pmd_pfn
      x86: unify pmd_pfn
      x86: unify pte_index
      x86: unify pte_offset_kernel
      x86: unify pud_large
      x86: unify pgd_bad
      x86: unify pgd_bad
      x86: unify pmd_bad
      x86: unify pages_to_mb
      x86: unify pud_none
      x86: unify pgd_none
      x86: unify io_remap_pfn_range
      x86: add and use pgd/pud/pmd_flags
      x86: make pgd/pud/pmd/pte_none consistent
      x86: asm/io.h: unify virt_to_phys/phys_to_virt
      x86: asm/io.h: unify ioremap prototypes
      x86: Fix compile error in arch/x86/kernel/early_printk.c
      x86: add handle_irq() to allow interrupt injection
      x86: unify do_IRQ()
      xen: set irq_chip disable
      xen: use our own eventchannel->irq path
      xen: pack all irq-related info together
      xen: remove irq bindcount
      xen: make sure that softirqs get handled at the end of event processing
      x86: use early_ioremap in __acpi_map_table
      x86: always explicitly map acpi memory
      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
      x86: make apic_* operations inline functions
      x86: unstatic mp_find_ioapic so it can be used elsewhere
      x86: add mp_find_ioapic_pin
      x86: unstatic ioapic entry funcs
      x86: rename *-defs.h to *-_types.h for consistency
      Split pgtable.h into pgtable_types.h and pgtable.h
      x86: Split pgtable_32.h into pgtable_32.h and pgtable_32_types.h
      x86: Split pgtable_64.h into pgtable_64_types.h and pgtable_64.h
      x86: Include pgtable_32|64_types.h in pgtable_types.h
      x86: create _types.h counterparts for page*.h
      x86: move 2 and 3 level asm-generic defs into page-defs
      x86: move defs around to allow paravirt.h to just include page_types.h
      x86: define pud_flags and pud_large properly to allow non-PAE builds
      x86: move pte types into pgtable*.h
      x86: use _types.h headers in asm where available
      x86: move more pagetable-related definitions into pgtable*.h
      x86, xen: short-circuit tests for dom0
      x86, xen: degrade BUG to WARN when multicall fails
      x86, xen: do multicall callbacks with interrupts disabled
      acpi: add some missing section markers
      x86-32: use non-lazy io bitmap context switching
      x86: unify chunks of kernel/process*.c
      x86: add forward decl for tss_struct
      xen: deal with virtually mapped percpu data
      x86: remove vestigial fix_ioremap prototypes
      x86: un-__init fill_pud/pmd/pte

Jiri Kosina (1):
      x86: remove byte locks

Jiri Slaby (9):
      x86_32: summit_32, use BAD_APICID
      x86_32: summit_32, de-inline functions
      x86_32: apic/bigsmp_32, de-inline functions
      x86_32: apic/es7000_32, cpu_mask_to_apicid cleanup
      x86_32: apic/es7000_32, fix cpu_mask_to_apicid
      x86_32: apic/summit_32, fix cpu_mask_to_apicid
      x86_32: apic/es7000_32, fix section mismatch
      x86_32: apic/summit_32, fix section mismatch
      x86_32: apic/numaq_32, fix section mismatch

Johannes Weiner (1):
      x86: optimise page fault entry, cleanup

Lai Jiangshan (1):
      x86: use percpu data for 4k hardirq and softirq stacks

Michael Ellerman (1):
      x86: Remove never-called arch_setup_msi_irq()

Mike Travis (21):
      cpumask: update irq_desc to use cpumask_var_t
      cpumask: fix bug in use cpumask_var_t in irq_desc
      SGI UV cpumask: use static temp cpumask in flush_tlb
      x86: cleanup remaining cpumask_t code in mce_amd_64.c
      x86: reduce stack usage in init_intel_cacheinfo
      cpumask: use cpumask_var_t in dcdbas.c
      cpumask: reduce stack usage in find_lowest_rq
      Xen: reduce memory required for cpu_evtchn_mask
      irq: change references from NR_IRQS to nr_irqs
      irq: use WARN() instead of WARN_ON().
      irq: allocate irq_desc_ptrs array based on nr_irqs
      irq: initialize nr_irqs based on nr_cpu_ids
      kstat: modify kstat_irqs_legacy to be variable sized
      cpumask, irq: non-x86 build failures
      irq: update all arches for new irq_desc
      irq: update all arches for new irq_desc, fix
      x86: fix build warning when CONFIG_NUMA not defined.
      sched: fix warning on ia64
      x86: cleanup early setup_percpu references
      cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
      x86: put trigger in to detect mismatched apic versions.

Nick Piggin (2):
      x86: optimise x86's do_page_fault (C entry point for the page fault path)
      x86: make UV support configurable

Pekka Enberg (6):
      x86: move __VMALLOC_RESERVE to pgtable_32.c
      x86: use roundup() instead of PAGE_ALIGN() in find_early_table_space()
      x86: add sanity checks to init_32.c
      x86: make sure initmem is writable on 64-bit
      x86: unify free_init_pages() and free_initmem()
      x86: set_highmem_pages_init() cleanup

Peter Zijlstra (3):
      x86: cpu_init(): remove ugly #ifdef construct around debug register clear
      x86: add might_sleep() to do_page_fault()
      x86: make vmap yell louder when it is used under irqs_disabled()

Randy Dunlap (1):
      x86: UV: fix header struct usage

Ravikiran G Thirumalai (2):
      x86: cleanup, rename CONFIG_X86_NON_STANDARD to CONFIG_X86_EXTENDED_PLATFORM
      x86: improve the help text of X86_EXTENDED_PLATFORM

Rusty Russell (9):
      cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
      cpumask: convert misc driver functions
      cpumask: convert drivers/net/sfc
      cpumask: convert other misc kernel functions
      x86: change flush_tlb_others to take a const struct cpumask
      work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
      work_on_cpu: Use our own workqueue.
      alloc_percpu: change percpu_ptr to per_cpu_ptr
      alloc_percpu: add align argument to __alloc_percpu.

Salman Qazi (1):
      x86: fix performance regression in write() syscall

Stas Sergeev (1):
      x86: minor cleanup in the espfix code

Steven Rostedt (1):
      x86: check PMD in spurious_fault handler

Suresh Siddha (4):
      x86: fix broken flush_tlb_others_ipi()
      x86: remove mach_apic.h, fix
      x86: unify genapic code, unify subarchitectures, remove old subarchitecture code, xapic fix
      x86: select x2apic ops in early apic probe only if x2apic mode is enabled

Tejun Heo (78):
      x86: fix pda_to_op()
      x86: make early_per_cpu() a lvalue and use it
      x86: make vmlinux_32.lds.S use PERCPU() macro
      x86: make percpu symbols zerobased on SMP
      x86: load pointer to pda into %gs while brining up a CPU
      x86: use static _cpu_pda array
      x86: fold pda into percpu area on SMP
      x86: merge 64 and 32 SMP percpu handling
      x86: make pda a percpu variable
      x86: convert pda ops to wrappers around x86 percpu accessors
      x86: misc clean up after the percpu update
      x86: fix build bug introduced during merge
      x86_64: initialize this_cpu_off to __per_cpu_load
      linker script: add missing VMLINUX_SYMBOL
      linker script: add missing .data.percpu.page_aligned
      x86: cleanup stack protector
      x86: conditionalize stack canary handling in hot path
      linker script: kill PERCPU_VADDR_PREALLOC()
      x86: update canary handling during switch
      x86: uv cleanup
      x86: prepare for tlb merge
      x86: make x86_32 use tlb_64.c
      x86: rename tlb_64.c to tlb.c
      x86: clean up indentation in setup_per_cpu_areas()
      linker script: use separate simpler definition for PERCPU()
      x86: style cleanups for xen assemblies
      modpost: NOBITS sections may point beyond the end of the file
      elf: add ELF_CORE_COPY_KERNEL_REGS()
      x86: stackprotector.h misc update
      stackprotector: update make rules
      x86: no stack protector for vdso
      x86: use asm .macro instead of cpp #define in entry_32.S
      x86: add %gs accessors for x86_32
      x86: make lazy %gs optional on x86_32
      x86: implement x86_32 stack protector
      x86: fix x86_32 stack protector bugs
      vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
      module: reorder module pcpu related functions
      percpu: kill percpu_alloc() and friends
      vmalloc: implement vm_area_register_early()
      vmalloc: add un/map_kernel_range_noflush()
      percpu: implement new dynamic percpu allocator
      x86: convert to the new dynamic percpu allocator
      percpu: clean up size usage
      percpu: fix pcpu_chunk_struct_size
      bootmem: clean up arch-specific bootmem wrapping
      bootmem: reorder interface functions and add a missing one
      vmalloc: add @align to vm_area_register_early()
      x86: update populate_extra_pte() and add populate_extra_pmd()
      percpu: remove unit_size power-of-2 restriction
      percpu: give more latitude to arch specific first chunk initialization
      x86: separate out setup_pcpu_4k() from setup_per_cpu_areas()
      x86: add embedding percpu first chunk allocator
      x86: add remapping percpu first chunk allocator
      percpu: add __read_mostly to variables which are mostly read only
      x86, percpu: fix minor bugs in setup_percpu.c
      x86: convert cacheflush macros inline functions
      percpu: fix too low alignment restriction on UP
      percpu: kill compile warning in pcpu_populate_chunk()
      alpha: fix typo in recent early vmalloc change
      bootmem, x86: further fixes for arch-specific bootmem wrapping
      percpu: clean up percpu constants
      percpu: cosmetic renames in pcpu_setup_first_chunk()
      percpu: improve first chunk initial area map handling
      percpu: use negative for auto for pcpu_setup_first_chunk() arguments
      x86: make embedding percpu allocator return excessive free space
      percpu: add an indirection ptr for chunk page map access
      percpu, module: implement reserved allocation and use it for module percpu variables
      x86, percpu: setup reserved percpu area for x86_64
      percpu: replace pcpu_realloc() with pcpu_mem_alloc() and pcpu_mem_free()
      percpu: move chunk area map extension out of area allocation
      percpu: move fully free chunk reclamation into a work
      percpu: finer grained locking to break deadlock and allow atomic free
      linker script: define __per_cpu_load on all SMP capable archs
      percpu: make x86 addr <-> pcpu ptr conversion macros generic
      percpu: more flexibility for @dyn_size of pcpu_setup_first_chunk()
      percpu: generalize embedding first chunk setup helper
      percpu: fix spurious alignment WARN in legacy SMP percpu allocator

Vegard Nossum (1):
      x86: use symbolic constants for MSR_IA32_MISC_ENABLE bits

Venkatesh Pallipadi (2):
      gpu/drm, x86, PAT: routine to keep identity map in sync
      gpu/drm, x86, PAT: PAT support for io_mapping_*

Yasuaki Ishimatsu (2):
      x86: fix debug message of CPU clock speed
      x86: unify PM-Timer messages

Yinghai Lu (27):
      x86: arch_probe_nr_irqs
      x86: make 32bit MAX_HARDIRQS_PER_CPU to be NR_VECTORS
      x86: allow more than 8 cpus to be used on 32-bit
      x86, apic unification: remove left over files
      x86: fix compiling with 64bit with def_to_bigsmp
      x86: seperate default_send_IPI_mask_sequence/allbutself from logical
      x86: don't treat bigsmp as non-standard
      x86, percpu: fix kexec with vmlinux
      x86: move default_ipi_xx back to ipi.c
      x86/irq: optimize nr_irqs
      x86: use NR_IRQS_LEGACY to replace 16
      x86: check_timer cleanup
      x86: find nr_irqs_gsi with mp_ioapic_routing
      acpi/x86: introduce __apci_map_table, v4
      x86, es7000: fix ACPI table mappings
      pci, x86, acpi: fix early_ioremap() leak
      x86: fix typo in filter_cpuid_features()
      x86: make 32bit to call enable_IO_APIC early like 64bit
      [IA64] fix __apci_unmap_table
      x86: pre init pirq_entries[]
      x86: make APIC_init_uniprocessor() more like smp_prepare_cpus()
      x86: add x2apic config
      x86: fold apic_ops into genapic
      x86: check mptable physptr with max_low_pfn on 32bit
      x86: check range in reserve_early()
      x86: remove update_apic from x86_quirks
      x86: don't compile vsmp_64 for 32bit

venkatesh.pallipadi@intel.com (1):
      x86 PAT: ioremap_wc should take resource_size_t parameter


 Documentation/cputopology.txt                      |    6 +-
 Documentation/kernel-parameters.txt                |    7 +-
 Documentation/x86/boot.txt                         |   18 +-
 Makefile                                           |    3 +-
 arch/alpha/kernel/irq.c                            |    2 +-
 arch/alpha/mm/init.c                               |   20 +-
 arch/arm/kernel/irq.c                              |   18 +-
 arch/arm/kernel/vmlinux.lds.S                      |    2 +
 arch/arm/oprofile/op_model_mpcore.c                |    2 +-
 arch/avr32/Kconfig                                 |    2 +-
 arch/blackfin/include/asm/percpu.h                 |   10 -
 arch/blackfin/kernel/irqchip.c                     |    5 +
 arch/ia64/include/asm/percpu.h                     |    4 +-
 arch/ia64/include/asm/topology.h                   |    2 +-
 arch/ia64/include/asm/uv/uv.h                      |   13 +
 arch/ia64/kernel/acpi.c                            |    4 +
 arch/ia64/kernel/iosapic.c                         |    2 +-
 arch/ia64/kernel/irq.c                             |    4 +-
 arch/ia64/kernel/irq_ia64.c                        |   12 +-
 arch/ia64/kernel/msi_ia64.c                        |    4 +-
 arch/ia64/kernel/vmlinux.lds.S                     |   11 +-
 arch/ia64/sn/kernel/msi_sn.c                       |    2 +-
 arch/mips/include/asm/irq.h                        |    2 +-
 arch/mips/kernel/irq-gic.c                         |    2 +-
 arch/mips/kernel/smtc.c                            |    6 +-
 arch/mips/mti-malta/malta-smtc.c                   |    5 +-
 arch/mips/sgi-ip22/ip22-int.c                      |    2 +-
 arch/mips/sgi-ip22/ip22-time.c                     |    2 +-
 arch/mips/sibyte/bcm1480/smp.c                     |    3 +-
 arch/mips/sibyte/sb1250/smp.c                      |    3 +-
 arch/mn10300/kernel/mn10300-watchdog.c             |    3 +-
 arch/parisc/kernel/irq.c                           |    2 +-
 arch/powerpc/kernel/irq.c                          |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    8 +-
 arch/powerpc/platforms/pseries/xics.c              |    5 +-
 arch/powerpc/sysdev/mpic.c                         |    3 +-
 arch/sparc/kernel/irq_64.c                         |    5 +-
 arch/sparc/kernel/time_64.c                        |    6 +-
 arch/x86/Kconfig                                   |  657 ++++----
 arch/x86/Kconfig.cpu                               |   80 +-
 arch/x86/Kconfig.debug                             |   50 +-
 arch/x86/Makefile                                  |   43 +-
 arch/x86/boot/Makefile                             |    1 -
 arch/x86/boot/a20.c                                |   79 +-
 arch/x86/boot/boot.h                               |    3 -
 arch/x86/boot/compressed/Makefile                  |   21 +-
 arch/x86/boot/compressed/head_32.S                 |    8 +-
 arch/x86/boot/compressed/head_64.S                 |   10 +-
 arch/x86/boot/compressed/misc.c                    |  118 +--
 arch/x86/boot/copy.S                               |   40 +-
 arch/x86/boot/header.S                             |    2 +-
 arch/x86/boot/main.c                               |    5 -
 arch/x86/boot/pmjump.S                             |   16 +-
 arch/x86/boot/voyager.c                            |   40 -
 arch/x86/configs/i386_defconfig                    |  419 ++++-
 arch/x86/configs/x86_64_defconfig                  |  425 ++++-
 arch/x86/ia32/ia32_signal.c                        |  405 +++---
 arch/x86/ia32/ia32entry.S                          |    8 +-
 arch/x86/include/asm/a.out-core.h                  |    2 +-
 arch/x86/include/asm/acpi.h                        |    3 -
 arch/x86/include/asm/apic.h                        |  442 +++++-
 arch/x86/include/asm/apicnum.h                     |   12 +
 arch/x86/include/asm/{mach-default => }/apm.h      |    0
 arch/x86/include/asm/arch_hooks.h                  |   26 -
 arch/x86/include/asm/bigsmp/apic.h                 |  155 --
 arch/x86/include/asm/bigsmp/apicdef.h              |   13 -
 arch/x86/include/asm/bigsmp/ipi.h                  |   22 -
 arch/x86/include/asm/boot.h                        |   16 +-
 arch/x86/include/asm/cacheflush.h                  |   53 +-
 arch/x86/include/asm/calling.h                     |   56 +-
 arch/x86/include/asm/cpu.h                         |   17 +
 arch/x86/include/asm/cpumask.h                     |   32 +
 arch/x86/include/asm/current.h                     |   24 +-
 arch/x86/include/asm/{mach-default => }/do_timer.h |    0
 arch/x86/include/asm/elf.h                         |   15 +-
 arch/x86/include/asm/entry_arch.h                  |   57 +
 arch/x86/include/asm/es7000/apic.h                 |  242 ---
 arch/x86/include/asm/es7000/apicdef.h              |   13 -
 arch/x86/include/asm/es7000/ipi.h                  |   22 -
 arch/x86/include/asm/es7000/mpparse.h              |   29 -
 arch/x86/include/asm/es7000/wakecpu.h              |   37 -
 arch/x86/include/asm/fixmap.h                      |  139 ++-
 arch/x86/include/asm/fixmap_32.h                   |  119 --
 arch/x86/include/asm/fixmap_64.h                   |   79 -
 arch/x86/include/asm/genapic.h                     |    6 +-
 arch/x86/include/asm/genapic_32.h                  |  148 --
 arch/x86/include/asm/genapic_64.h                  |   66 -
 arch/x86/include/asm/hardirq.h                     |   49 +-
 arch/x86/include/asm/hardirq_32.h                  |   30 -
 arch/x86/include/asm/hardirq_64.h                  |   25 -
 arch/x86/include/asm/hw_irq.h                      |   24 +-
 arch/x86/include/asm/i8259.h                       |    4 +
 arch/x86/include/asm/io.h                          |   97 +-
 arch/x86/include/asm/io_32.h                       |   88 -
 arch/x86/include/asm/io_64.h                       |   61 -
 arch/x86/include/asm/io_apic.h                     |   41 +-
 arch/x86/include/asm/ipi.h                         |   75 +-
 arch/x86/include/asm/irq.h                         |    4 +-
 arch/x86/include/asm/irq_regs.h                    |   36 +-
 arch/x86/include/asm/irq_regs_32.h                 |   31 -
 arch/x86/include/asm/irq_regs_64.h                 |    1 -
 arch/x86/include/asm/irq_vectors.h                 |  209 ++--
 arch/x86/include/asm/kexec.h                       |   27 +-
 arch/x86/include/asm/linkage.h                     |   64 +-
 arch/x86/include/asm/mach-default/entry_arch.h     |   36 -
 arch/x86/include/asm/mach-default/mach_apic.h      |  168 --
 arch/x86/include/asm/mach-default/mach_apicdef.h   |   24 -
 arch/x86/include/asm/mach-default/mach_ipi.h       |   64 -
 arch/x86/include/asm/mach-default/mach_mpparse.h   |   17 -
 arch/x86/include/asm/mach-default/mach_mpspec.h    |   12 -
 arch/x86/include/asm/mach-default/mach_wakecpu.h   |   41 -
 arch/x86/include/asm/mach-generic/gpio.h           |   15 -
 arch/x86/include/asm/mach-generic/mach_apic.h      |   35 -
 arch/x86/include/asm/mach-generic/mach_apicdef.h   |   11 -
 arch/x86/include/asm/mach-generic/mach_ipi.h       |   10 -
 arch/x86/include/asm/mach-generic/mach_mpparse.h   |    9 -
 arch/x86/include/asm/mach-generic/mach_mpspec.h    |   12 -
 arch/x86/include/asm/mach-generic/mach_wakecpu.h   |   12 -
 arch/x86/include/asm/mach-rdc321x/gpio.h           |   60 -
 arch/x86/include/asm/mach-voyager/do_timer.h       |   17 -
 arch/x86/include/asm/mach-voyager/entry_arch.h     |   26 -
 arch/x86/include/asm/mach-voyager/setup_arch.h     |   12 -
 .../include/asm/{mach-default => }/mach_timer.h    |    0
 .../include/asm/{mach-default => }/mach_traps.h    |    0
 arch/x86/include/asm/mmu_context.h                 |   63 +-
 arch/x86/include/asm/mmu_context_32.h              |   55 -
 arch/x86/include/asm/mmu_context_64.h              |   54 -
 arch/x86/include/asm/mmzone_32.h                   |   43 +-
 arch/x86/include/asm/mpspec.h                      |   33 +-
 arch/x86/include/asm/mpspec_def.h                  |   23 +-
 arch/x86/include/asm/numa_32.h                     |    6 +-
 arch/x86/include/asm/numaq.h                       |    2 +
 arch/x86/include/asm/numaq/apic.h                  |  142 --
 arch/x86/include/asm/numaq/apicdef.h               |   14 -
 arch/x86/include/asm/numaq/ipi.h                   |   22 -
 arch/x86/include/asm/numaq/mpparse.h               |    6 -
 arch/x86/include/asm/numaq/wakecpu.h               |   45 -
 arch/x86/include/asm/page.h                        |  152 +--
 arch/x86/include/asm/page_32.h                     |   87 +-
 arch/x86/include/asm/page_32_types.h               |   60 +
 arch/x86/include/asm/page_64.h                     |  101 +--
 arch/x86/include/asm/page_64_types.h               |   89 +
 arch/x86/include/asm/page_types.h                  |   57 +
 arch/x86/include/asm/paravirt.h                    |  465 ++++--
 arch/x86/include/asm/pat.h                         |    5 +-
 .../include/asm/{mach-default => }/pci-functions.h |    0
 arch/x86/include/asm/pda.h                         |  137 --
 arch/x86/include/asm/percpu.h                      |  169 +-
 arch/x86/include/asm/pgtable-2level-defs.h         |   20 -
 arch/x86/include/asm/pgtable-2level.h              |    2 -
 arch/x86/include/asm/pgtable-2level_types.h        |   37 +
 arch/x86/include/asm/pgtable-3level-defs.h         |   28 -
 arch/x86/include/asm/pgtable-3level.h              |   35 -
 arch/x86/include/asm/pgtable-3level_types.h        |   48 +
 arch/x86/include/asm/pgtable.h                     |  509 +++---
 arch/x86/include/asm/pgtable_32.h                  |   88 +-
 arch/x86/include/asm/pgtable_32_types.h            |   46 +
 arch/x86/include/asm/pgtable_64.h                  |  113 +--
 arch/x86/include/asm/pgtable_64_types.h            |   63 +
 arch/x86/include/asm/pgtable_types.h               |  328 ++++
 arch/x86/include/asm/processor.h                   |   45 +-
 arch/x86/include/asm/proto.h                       |    4 -
 arch/x86/include/asm/ptrace.h                      |    4 +-
 .../include/asm/{mach-rdc321x => }/rdc321x_defs.h  |    0
 arch/x86/include/asm/segment.h                     |    9 +-
 arch/x86/include/asm/setup.h                       |   19 +-
 .../include/asm/{mach-default => }/setup_arch.h    |    0
 arch/x86/include/asm/smp.h                         |   69 +-
 .../include/asm/{mach-default => }/smpboot_hooks.h |    6 +-
 arch/x86/include/asm/spinlock.h                    |   69 +-
 arch/x86/include/asm/stackprotector.h              |  124 ++
 arch/x86/include/asm/summit/apic.h                 |  202 ---
 arch/x86/include/asm/summit/apicdef.h              |   13 -
 arch/x86/include/asm/summit/ipi.h                  |   26 -
 arch/x86/include/asm/summit/mpparse.h              |  109 --
 arch/x86/include/asm/syscalls.h                    |   22 +-
 arch/x86/include/asm/system.h                      |   70 +-
 arch/x86/include/asm/thread_info.h                 |   21 +-
 arch/x86/include/asm/timer.h                       |    4 +-
 arch/x86/include/asm/tlbflush.h                    |   17 +-
 arch/x86/include/asm/topology.h                    |   31 +-
 arch/x86/include/asm/trampoline.h                  |    1 +
 arch/x86/include/asm/traps.h                       |    2 +-
 arch/x86/include/asm/uaccess.h                     |  138 ++-
 arch/x86/include/asm/uaccess_64.h                  |   10 +-
 arch/x86/include/asm/uv/uv.h                       |   33 +
 arch/x86/include/asm/uv/uv_bau.h                   |    1 -
 arch/x86/include/asm/vic.h                         |   61 -
 arch/x86/include/asm/voyager.h                     |  529 ------
 arch/x86/include/asm/xen/events.h                  |    6 -
 arch/x86/include/asm/xen/hypervisor.h              |   28 +-
 arch/x86/include/asm/xen/page.h                    |    1 +
 arch/x86/kernel/Makefile                           |   42 +-
 arch/x86/kernel/acpi/boot.c                        |  169 +-
 arch/x86/kernel/acpi/realmode/wakeup.S             |    4 +-
 arch/x86/kernel/acpi/sleep.c                       |    1 +
 arch/x86/kernel/acpi/wakeup_32.S                   |    2 +-
 arch/x86/kernel/acpi/wakeup_64.S                   |    4 +-
 arch/x86/kernel/alternative.c                      |    6 +-
 arch/x86/kernel/apic/Makefile                      |   19 +
 arch/x86/kernel/{ => apic}/apic.c                  |  299 ++--
 .../{genapic_flat_64.c => apic/apic_flat_64.c}     |  192 ++-
 arch/x86/kernel/apic/bigsmp_32.c                   |  267 +++
 arch/x86/kernel/apic/es7000_32.c                   |  780 +++++++++
 arch/x86/kernel/{ => apic}/io_apic.c               |  443 +++---
 arch/x86/kernel/apic/ipi.c                         |  164 ++
 arch/x86/kernel/{ => apic}/nmi.c                   |   12 +-
 arch/x86/kernel/apic/numaq_32.c                    |  557 ++++++
 arch/x86/kernel/apic/probe_32.c                    |  284 +++
 arch/x86/kernel/{genapic_64.c => apic/probe_64.c}  |   55 +-
 arch/x86/kernel/apic/summit_32.c                   |  579 +++++++
 .../{genx2apic_cluster.c => apic/x2apic_cluster.c} |  153 ++-
 .../{genx2apic_phys.c => apic/x2apic_phys.c}       |  150 +-
 .../{genx2apic_uv_x.c => apic/x2apic_uv_x.c}       |  161 ++-
 arch/x86/kernel/apm_32.c                           |    2 +-
 arch/x86/kernel/asm-offsets_32.c                   |    1 +
 arch/x86/kernel/asm-offsets_64.c                   |   11 -
 arch/x86/kernel/cpu/addon_cpuid_features.c         |   54 +-
 arch/x86/kernel/cpu/amd.c                          |    2 -
 arch/x86/kernel/cpu/common.c                       |  257 ++--
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c         |    2 +-
 arch/x86/kernel/cpu/cpufreq/e_powersaver.c         |    6 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c   |    6 +-
 arch/x86/kernel/cpu/intel.c                        |   17 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   63 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c            |   21 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c          |    7 +-
 arch/x86/kernel/cpu/mcheck/p4.c                    |    4 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c             |    2 +-
 arch/x86/kernel/cpu/proc.c                         |   20 +-
 arch/x86/kernel/crash.c                            |    4 +-
 arch/x86/kernel/dumpstack.c                        |    2 +-
 arch/x86/kernel/dumpstack_64.c                     |   35 +-
 arch/x86/kernel/e820.c                             |    3 +
 arch/x86/kernel/early_printk.c                     |    2 +-
 arch/x86/kernel/efi.c                              |    2 +
 arch/x86/kernel/efi_64.c                           |    1 +
 arch/x86/kernel/efi_stub_32.S                      |    3 +-
 arch/x86/kernel/efi_stub_64.S                      |    7 +
 arch/x86/kernel/entry_32.S                         |  455 ++++--
 arch/x86/kernel/entry_64.S                         |   72 +-
 arch/x86/kernel/es7000_32.c                        |  378 ----
 arch/x86/kernel/head64.c                           |   23 -
 arch/x86/kernel/head_32.S                          |   44 +-
 arch/x86/kernel/head_64.S                          |   23 +-
 arch/x86/kernel/i8259.c                            |    1 -
 arch/x86/kernel/ioport.c                           |   14 +-
 arch/x86/kernel/ipi.c                              |  190 --
 arch/x86/kernel/irq.c                              |   44 +-
 arch/x86/kernel/irq_32.c                           |   61 +-
 arch/x86/kernel/irq_64.c                           |   43 +-
 arch/x86/kernel/irqinit_32.c                       |   36 +-
 arch/x86/kernel/kgdb.c                             |    4 +-
 arch/x86/kernel/kvmclock.c                         |    1 -
 arch/x86/kernel/machine_kexec_32.c                 |    2 +-
 arch/x86/kernel/machine_kexec_64.c                 |   82 +-
 arch/x86/kernel/mca_32.c                           |    5 +-
 arch/x86/kernel/microcode_intel.c                  |   10 +-
 arch/x86/kernel/module_32.c                        |    6 +-
 arch/x86/kernel/module_64.c                        |   32 +-
 arch/x86/kernel/mpparse.c                          |  189 +--
 arch/x86/kernel/msr.c                              |    2 +-
 arch/x86/kernel/numaq_32.c                         |  293 ----
 arch/x86/kernel/paravirt-spinlocks.c               |   10 -
 arch/x86/kernel/paravirt.c                         |   56 +-
 arch/x86/kernel/paravirt_patch_32.c                |   12 +
 arch/x86/kernel/paravirt_patch_64.c                |   15 +
 arch/x86/kernel/probe_roms_32.c                    |    2 +-
 arch/x86/kernel/process.c                          |  193 ++-
 arch/x86/kernel/process_32.c                       |  241 +---
 arch/x86/kernel/process_64.c                       |  230 +---
 arch/x86/kernel/ptrace.c                           |   21 +-
 arch/x86/kernel/reboot.c                           |    5 +-
 arch/x86/kernel/relocate_kernel_32.S               |    2 +-
 arch/x86/kernel/relocate_kernel_64.S               |  129 +--
 arch/x86/kernel/setup.c                            |  139 ++-
 arch/x86/kernel/setup_percpu.c                     |  679 ++++----
 arch/x86/kernel/signal.c                           |  467 +++---
 arch/x86/kernel/smp.c                              |   15 +-
 arch/x86/kernel/smpboot.c                          |  147 +--
 arch/x86/kernel/smpcommon.c                        |   30 -
 arch/x86/kernel/stacktrace.c                       |    2 +-
 arch/x86/kernel/summit_32.c                        |  188 --
 arch/x86/kernel/syscall_table_32.S                 |   20 +-
 arch/x86/kernel/time_32.c                          |    8 +-
 arch/x86/kernel/tlb_32.c                           |  256 ---
 arch/x86/kernel/tlb_uv.c                           |   72 +-
 arch/x86/kernel/trampoline_32.S                    |    2 +-
 arch/x86/kernel/trampoline_64.S                    |   23 +-
 arch/x86/kernel/traps.c                            |   64 +-
 arch/x86/kernel/tsc.c                              |    2 +-
 arch/x86/kernel/visws_quirks.c                     |   10 +-
 arch/x86/kernel/vm86_32.c                          |   20 +-
 arch/x86/kernel/vmi_32.c                           |   13 +-
 arch/x86/kernel/vmiclock_32.c                      |    6 +-
 arch/x86/kernel/vmlinux_32.lds.S                   |   11 +-
 arch/x86/kernel/vmlinux_64.lds.S                   |   37 +-
 arch/x86/kernel/vsmp_64.c                          |   24 +-
 arch/x86/kernel/x8664_ksyms_64.c                   |    2 -
 arch/x86/lguest/Kconfig                            |    1 -
 arch/x86/lguest/boot.c                             |   32 +-
 arch/x86/lib/getuser.S                             |    2 +-
 arch/x86/mach-default/Makefile                     |    5 -
 arch/x86/mach-default/setup.c                      |  174 --
 arch/x86/mach-generic/Makefile                     |   11 -
 arch/x86/mach-generic/bigsmp.c                     |   60 -
 arch/x86/mach-generic/default.c                    |   27 -
 arch/x86/mach-generic/es7000.c                     |  103 --
 arch/x86/mach-generic/numaq.c                      |   53 -
 arch/x86/mach-generic/probe.c                      |  152 --
 arch/x86/mach-generic/summit.c                     |   40 -
 arch/x86/mach-rdc321x/Makefile                     |    5 -
 arch/x86/mach-rdc321x/gpio.c                       |  194 ---
 arch/x86/mach-rdc321x/platform.c                   |   69 -
 arch/x86/mach-voyager/Makefile                     |    8 -
 arch/x86/mach-voyager/setup.c                      |  118 --
 arch/x86/mach-voyager/voyager_basic.c              |  317 ----
 arch/x86/mach-voyager/voyager_cat.c                | 1197 -------------
 arch/x86/mach-voyager/voyager_smp.c                | 1807 --------------------
 arch/x86/mach-voyager/voyager_thread.c             |  128 --
 arch/x86/math-emu/get_address.c                    |    6 +-
 arch/x86/mm/Makefile                               |    4 +-
 arch/x86/mm/extable.c                              |    6 +
 arch/x86/mm/fault.c                                | 1333 +++++++++------
 arch/x86/mm/highmem_32.c                           |   34 +
 arch/x86/mm/init.c                                 |   49 +
 arch/x86/mm/init_32.c                              |  213 ++--
 arch/x86/mm/init_64.c                              |  109 +-
 arch/x86/mm/ioremap.c                              |    2 +-
 arch/x86/mm/memtest.c                              |  156 +-
 arch/x86/mm/mmap.c                                 |    2 +-
 arch/x86/mm/numa_32.c                              |   28 +-
 arch/x86/mm/numa_64.c                              |  217 +++
 arch/x86/mm/pageattr.c                             |    7 +
 arch/x86/mm/pat.c                                  |   77 +-
 arch/x86/mm/pgtable.c                              |   18 +
 arch/x86/mm/pgtable_32.c                           |   18 +-
 arch/x86/mm/srat_64.c                              |    3 +-
 arch/x86/{kernel/tlb_64.c => mm/tlb.c}             |  123 +-
 arch/x86/pci/numaq_32.c                            |    6 +-
 arch/x86/pci/pcbios.c                              |    2 +-
 arch/x86/power/hibernate_asm_32.S                  |    2 +-
 arch/x86/power/hibernate_asm_64.S                  |    2 +-
 arch/x86/vdso/Makefile                             |    2 +-
 arch/x86/vdso/vma.c                                |    4 +-
 arch/x86/xen/Kconfig                               |    2 +-
 arch/x86/xen/Makefile                              |    3 +-
 arch/x86/xen/enlighten.c                           |  816 +---------
 arch/x86/xen/irq.c                                 |   39 +-
 arch/x86/xen/mmu.c                                 |  757 ++++++++-
 arch/x86/xen/mmu.h                                 |    3 +
 arch/x86/xen/multicalls.c                          |   15 +-
 arch/x86/xen/multicalls.h                          |    2 +-
 arch/x86/xen/smp.c                                 |   47 +-
 arch/x86/xen/suspend.c                             |    1 +
 arch/x86/xen/xen-asm.S                             |  142 ++
 arch/x86/xen/xen-asm.h                             |   12 +
 arch/x86/xen/xen-asm_32.S                          |  343 ++---
 arch/x86/xen/xen-asm_64.S                          |  252 +--
 arch/x86/xen/xen-head.S                            |    2 +-
 arch/x86/xen/xen-ops.h                             |   10 +
 block/blktrace.c                                   |    2 +-
 drivers/acpi/acpica/tbxface.c                      |   17 +-
 drivers/acpi/osl.c                                 |   13 +-
 drivers/acpi/processor_perflib.c                   |    4 +-
 drivers/acpi/tables.c                              |   20 +-
 drivers/base/cpu.c                                 |    2 +-
 drivers/base/topology.c                            |   33 +-
 drivers/clocksource/acpi_pm.c                      |    2 +-
 drivers/clocksource/cyclone.c                      |    2 +-
 drivers/eisa/Kconfig                               |    6 +-
 drivers/firmware/dcdbas.c                          |   12 +-
 drivers/firmware/iscsi_ibft.c                      |    4 +-
 drivers/gpu/drm/drm_info.c                         |    4 +-
 drivers/input/keyboard/Kconfig                     |    4 +-
 drivers/input/mouse/Kconfig                        |    2 +-
 drivers/lguest/Kconfig                             |    2 +-
 drivers/misc/Kconfig                               |    4 +-
 drivers/misc/sgi-gru/grufile.c                     |   18 +-
 drivers/misc/sgi-xp/xp.h                           |   24 +-
 drivers/misc/sgi-xp/xpc_main.c                     |    2 +-
 drivers/mtd/nand/Kconfig                           |    2 +-
 drivers/net/ne3210.c                               |    3 +-
 drivers/net/sfc/efx.c                              |   17 +-
 drivers/net/sfc/falcon.c                           |   24 +-
 drivers/net/wireless/arlan-main.c                  |    4 +-
 drivers/oprofile/buffer_sync.c                     |   22 +-
 drivers/oprofile/buffer_sync.h                     |    4 +
 drivers/oprofile/oprof.c                           |    9 +-
 drivers/pci/dmar.c                                 |    7 +-
 drivers/pci/intr_remapping.c                       |    1 +
 drivers/watchdog/rdc321x_wdt.c                     |    2 +-
 drivers/xen/events.c                               |  251 ++-
 drivers/xen/manage.c                               |    2 +-
 include/acpi/acpiosxf.h                            |    1 +
 include/acpi/acpixf.h                              |    4 +
 include/asm-generic/percpu.h                       |   52 +
 include/asm-generic/sections.h                     |    2 +-
 include/asm-generic/vmlinux.lds.h                  |   55 +-
 include/linux/acpi.h                               |    1 +
 include/linux/bootmem.h                            |   36 +-
 include/linux/decompress/bunzip2.h                 |   10 +
 include/linux/decompress/generic.h                 |   33 +
 include/linux/decompress/inflate.h                 |   13 +
 include/linux/decompress/mm.h                      |   87 +
 include/linux/decompress/unlzma.h                  |   12 +
 include/linux/elfcore.h                            |    9 +
 include/linux/interrupt.h                          |    1 +
 include/linux/irq.h                                |   86 +-
 include/linux/irqnr.h                              |    1 +
 include/linux/kprobes.h                            |   22 +-
 include/linux/magic.h                              |    1 +
 include/linux/mmiotrace.h                          |   78 +-
 include/linux/percpu.h                             |  159 ++-
 include/linux/sched.h                              |   16 +-
 include/linux/smp.h                                |    6 +
 include/linux/stackprotector.h                     |   16 +
 include/linux/topology.h                           |    6 +
 include/linux/vmalloc.h                            |    4 +
 init/Kconfig                                       |   60 +
 init/do_mounts_rd.c                                |  178 +--
 init/initramfs.c                                   |  122 +-
 init/main.c                                        |   19 +-
 kernel/exit.c                                      |    5 +-
 kernel/fork.c                                      |    5 +
 kernel/irq/chip.c                                  |    5 +-
 kernel/irq/handle.c                                |   54 +-
 kernel/irq/internals.h                             |    7 +
 kernel/irq/manage.c                                |   12 +-
 kernel/irq/migration.c                             |   12 +-
 kernel/irq/numa_migrate.c                          |   19 +-
 kernel/irq/proc.c                                  |    4 +-
 kernel/kexec.c                                     |    2 +-
 kernel/module.c                                    |   64 +-
 kernel/panic.c                                     |    8 +-
 kernel/sched.c                                     |   13 +-
 kernel/sched_rt.c                                  |   32 +-
 kernel/softirq.c                                   |    5 +
 kernel/stop_machine.c                              |    2 +-
 lib/Kconfig                                        |   14 +
 lib/Makefile                                       |    6 +-
 lib/decompress.c                                   |   54 +
 lib/decompress_bunzip2.c                           |  735 ++++++++
 lib/decompress_inflate.c                           |  167 ++
 lib/decompress_unlzma.c                            |  647 +++++++
 lib/zlib_inflate/inflate.h                         |    4 +
 lib/zlib_inflate/inftrees.h                        |    4 +
 mm/Makefile                                        |    4 +
 mm/allocpercpu.c                                   |   32 +-
 mm/bootmem.c                                       |   35 +-
 mm/filemap.c                                       |    7 +-
 mm/percpu.c                                        | 1326 ++++++++++++++
 mm/vmalloc.c                                       |   97 +-
 net/ipv4/af_inet.c                                 |    4 +-
 net/ipv4/route.c                                   |    2 +-
 scripts/Makefile.lib                               |   14 +
 scripts/bin_size                                   |   10 +
 scripts/gcc-x86_32-has-stack-protector.sh          |    8 +
 scripts/gcc-x86_64-has-stack-protector.sh          |    6 +-
 scripts/gen_initramfs_list.sh                      |   18 +-
 scripts/mod/modpost.c                              |    5 +-
 sound/drivers/Kconfig                              |    2 +-
 usr/Kconfig                                        |   89 +
 usr/Makefile                                       |   36 +-
 usr/initramfs_data.S                               |    2 +-
 usr/initramfs_data.bz2.S                           |   29 +
 usr/initramfs_data.gz.S                            |   29 +
 usr/initramfs_data.lzma.S                          |   29 +
 468 files changed, 17644 insertions(+), 17802 deletions(-)
 create mode 100644 arch/ia64/include/asm/uv/uv.h
 delete mode 100644 arch/x86/boot/voyager.c
 create mode 100644 arch/x86/include/asm/apicnum.h
 rename arch/x86/include/asm/{mach-default => }/apm.h (100%)
 delete mode 100644 arch/x86/include/asm/arch_hooks.h
 delete mode 100644 arch/x86/include/asm/bigsmp/apic.h
 delete mode 100644 arch/x86/include/asm/bigsmp/apicdef.h
 delete mode 100644 arch/x86/include/asm/bigsmp/ipi.h
 create mode 100644 arch/x86/include/asm/cpumask.h
 rename arch/x86/include/asm/{mach-default => }/do_timer.h (100%)
 create mode 100644 arch/x86/include/asm/entry_arch.h
 delete mode 100644 arch/x86/include/asm/es7000/apic.h
 delete mode 100644 arch/x86/include/asm/es7000/apicdef.h
 delete mode 100644 arch/x86/include/asm/es7000/ipi.h
 delete mode 100644 arch/x86/include/asm/es7000/mpparse.h
 delete mode 100644 arch/x86/include/asm/es7000/wakecpu.h
 delete mode 100644 arch/x86/include/asm/fixmap_32.h
 delete mode 100644 arch/x86/include/asm/fixmap_64.h
 delete mode 100644 arch/x86/include/asm/genapic_32.h
 delete mode 100644 arch/x86/include/asm/genapic_64.h
 delete mode 100644 arch/x86/include/asm/hardirq_32.h
 delete mode 100644 arch/x86/include/asm/hardirq_64.h
 delete mode 100644 arch/x86/include/asm/irq_regs_32.h
 delete mode 100644 arch/x86/include/asm/irq_regs_64.h
 delete mode 100644 arch/x86/include/asm/mach-default/entry_arch.h
 delete mode 100644 arch/x86/include/asm/mach-default/mach_apic.h
 delete mode 100644 arch/x86/include/asm/mach-default/mach_apicdef.h
 delete mode 100644 arch/x86/include/asm/mach-default/mach_ipi.h
 delete mode 100644 arch/x86/include/asm/mach-default/mach_mpparse.h
 delete mode 100644 arch/x86/include/asm/mach-default/mach_mpspec.h
 delete mode 100644 arch/x86/include/asm/mach-default/mach_wakecpu.h
 delete mode 100644 arch/x86/include/asm/mach-generic/gpio.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_apic.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_apicdef.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_ipi.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_mpparse.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_mpspec.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_wakecpu.h
 delete mode 100644 arch/x86/include/asm/mach-rdc321x/gpio.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/do_timer.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/entry_arch.h
 delete mode 100644 arch/x86/include/asm/mach-voyager/setup_arch.h
 rename arch/x86/include/asm/{mach-default => }/mach_timer.h (100%)
 rename arch/x86/include/asm/{mach-default => }/mach_traps.h (100%)
 delete mode 100644 arch/x86/include/asm/mmu_context_32.h
 delete mode 100644 arch/x86/include/asm/mmu_context_64.h
 delete mode 100644 arch/x86/include/asm/numaq/apic.h
 delete mode 100644 arch/x86/include/asm/numaq/apicdef.h
 delete mode 100644 arch/x86/include/asm/numaq/ipi.h
 delete mode 100644 arch/x86/include/asm/numaq/mpparse.h
 delete mode 100644 arch/x86/include/asm/numaq/wakecpu.h
 create mode 100644 arch/x86/include/asm/page_32_types.h
 create mode 100644 arch/x86/include/asm/page_64_types.h
 create mode 100644 arch/x86/include/asm/page_types.h
 rename arch/x86/include/asm/{mach-default => }/pci-functions.h (100%)
 delete mode 100644 arch/x86/include/asm/pda.h
 delete mode 100644 arch/x86/include/asm/pgtable-2level-defs.h
 create mode 100644 arch/x86/include/asm/pgtable-2level_types.h
 delete mode 100644 arch/x86/include/asm/pgtable-3level-defs.h
 create mode 100644 arch/x86/include/asm/pgtable-3level_types.h
 create mode 100644 arch/x86/include/asm/pgtable_32_types.h
 create mode 100644 arch/x86/include/asm/pgtable_64_types.h
 create mode 100644 arch/x86/include/asm/pgtable_types.h
 rename arch/x86/include/asm/{mach-rdc321x => }/rdc321x_defs.h (100%)
 rename arch/x86/include/asm/{mach-default => }/setup_arch.h (100%)
 rename arch/x86/include/asm/{mach-default => }/smpboot_hooks.h (83%)
 create mode 100644 arch/x86/include/asm/stackprotector.h
 delete mode 100644 arch/x86/include/asm/summit/apic.h
 delete mode 100644 arch/x86/include/asm/summit/apicdef.h
 delete mode 100644 arch/x86/include/asm/summit/ipi.h
 delete mode 100644 arch/x86/include/asm/summit/mpparse.h
 create mode 100644 arch/x86/include/asm/uv/uv.h
 delete mode 100644 arch/x86/include/asm/vic.h
 delete mode 100644 arch/x86/include/asm/voyager.h
 create mode 100644 arch/x86/kernel/apic/Makefile
 rename arch/x86/kernel/{ => apic}/apic.c (93%)
 rename arch/x86/kernel/{genapic_flat_64.c => apic/apic_flat_64.c} (55%)
 create mode 100644 arch/x86/kernel/apic/bigsmp_32.c
 create mode 100644 arch/x86/kernel/apic/es7000_32.c
 rename arch/x86/kernel/{ => apic}/io_apic.c (92%)
 create mode 100644 arch/x86/kernel/apic/ipi.c
 rename arch/x86/kernel/{ => apic}/nmi.c (98%)
 create mode 100644 arch/x86/kernel/apic/numaq_32.c
 create mode 100644 arch/x86/kernel/apic/probe_32.c
 rename arch/x86/kernel/{genapic_64.c => apic/probe_64.c} (50%)
 create mode 100644 arch/x86/kernel/apic/summit_32.c
 rename arch/x86/kernel/{genx2apic_cluster.c => apic/x2apic_cluster.c} (50%)
 rename arch/x86/kernel/{genx2apic_phys.c => apic/x2apic_phys.c} (51%)
 rename arch/x86/kernel/{genx2apic_uv_x.c => apic/x2apic_uv_x.c} (83%)
 delete mode 100644 arch/x86/kernel/es7000_32.c
 delete mode 100644 arch/x86/kernel/ipi.c
 delete mode 100644 arch/x86/kernel/numaq_32.c
 delete mode 100644 arch/x86/kernel/smpcommon.c
 delete mode 100644 arch/x86/kernel/summit_32.c
 delete mode 100644 arch/x86/kernel/tlb_32.c
 delete mode 100644 arch/x86/mach-default/Makefile
 delete mode 100644 arch/x86/mach-default/setup.c
 delete mode 100644 arch/x86/mach-generic/Makefile
 delete mode 100644 arch/x86/mach-generic/bigsmp.c
 delete mode 100644 arch/x86/mach-generic/default.c
 delete mode 100644 arch/x86/mach-generic/es7000.c
 delete mode 100644 arch/x86/mach-generic/numaq.c
 delete mode 100644 arch/x86/mach-generic/probe.c
 delete mode 100644 arch/x86/mach-generic/summit.c
 delete mode 100644 arch/x86/mach-rdc321x/Makefile
 delete mode 100644 arch/x86/mach-rdc321x/gpio.c
 delete mode 100644 arch/x86/mach-rdc321x/platform.c
 delete mode 100644 arch/x86/mach-voyager/Makefile
 delete mode 100644 arch/x86/mach-voyager/setup.c
 delete mode 100644 arch/x86/mach-voyager/voyager_basic.c
 delete mode 100644 arch/x86/mach-voyager/voyager_cat.c
 delete mode 100644 arch/x86/mach-voyager/voyager_smp.c
 delete mode 100644 arch/x86/mach-voyager/voyager_thread.c
 create mode 100644 arch/x86/mm/init.c
 rename arch/x86/{kernel/tlb_64.c => mm/tlb.c} (67%)
 create mode 100644 arch/x86/xen/xen-asm.S
 create mode 100644 arch/x86/xen/xen-asm.h
 create mode 100644 include/linux/decompress/bunzip2.h
 create mode 100644 include/linux/decompress/generic.h
 create mode 100644 include/linux/decompress/inflate.h
 create mode 100644 include/linux/decompress/mm.h
 create mode 100644 include/linux/decompress/unlzma.h
 create mode 100644 include/linux/stackprotector.h
 create mode 100644 lib/decompress.c
 create mode 100644 lib/decompress_bunzip2.c
 create mode 100644 lib/decompress_inflate.c
 create mode 100644 lib/decompress_unlzma.c
 create mode 100644 mm/percpu.c
 create mode 100644 scripts/bin_size
 create mode 100644 scripts/gcc-x86_32-has-stack-protector.sh
 create mode 100644 usr/initramfs_data.bz2.S
 create mode 100644 usr/initramfs_data.gz.S
 create mode 100644 usr/initramfs_data.lzma.S

----- End forwarded message -----
