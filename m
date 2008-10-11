Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbYJKSfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbYJKSfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYJKSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:35:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762443AbYJKSe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:34:58 -0400
Date: Sat, 11 Oct 2008 20:34:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 3] x86 updates for v2.6.28, phase #4, x2apic,
	unify-cpu-detect
Message-ID: <20081011183405.GA25022@elte.hu>
References: <20081010000408.GA5970@elte.hu> <20081010175613.GA20112@elte.hu> <alpine.LFD.2.00.0810111108060.3402@nehalem.linux-foundation.org> <20081011181857.GA20554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011181857.GA20554@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.3
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> indeed:
> 
>  #endif
>  #endif /* ASM_X86__DMA_MAPPING_H */
> 
> that goes away in x86-v28-for-linus-phase6-B.

please find the new pull request below for x86-v28-for-linus-phase4-D 
(relative to x86-v28-for-linus-phase3-B) - i sanity-tested it on a 
couple of systems.

	Ingo

------------->
Linus,

Please pull the latest x86-v28-for-linus-phase4-D git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase4-D


out-of-topic modifications in x86-v28-for-linus-phase4-D:
---------------------------------------------------------
arch/um/sys-x86_64/syscall_table.c # b76d69e: x86_64: uml: fix rename header gu
drivers/pci/Makefile               # ad3ad3f: x64, x2apic/intr-remap: parse ioa
drivers/pci/dma_remapping.h        # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # e61d98d: x64, x2apic/intr-remap: Intel vt-
drivers/pci/dmar.c                 # 1cb1158: x64, x2apic/intr-remap: disable D
                                   # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # fe962e9: x64, x2apic/intr-remap: Queued in
                                   # ad3ad3f: x64, x2apic/intr-remap: parse ioa
                                   # 2d6b5f8: x64, x2apic/intr-remap: Fix the n
                                   # aaa9d1d: x64, x2apic/intr-remap: use CONFI
                                   # 1886e8a: x64, x2apic/intr-remap: code re-s
                                   # c42d9f3: x64, x2apic/intr-remap: fix the n
                                   # e61d98d: x64, x2apic/intr-remap: Intel vt-
drivers/pci/intel-iommu.h          # b6fcb33: x64, x2apic/intr-remap: routines 
                                   # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # fe962e9: x64, x2apic/intr-remap: Queued in
                                   # cf1337f: x64, x2apic/intr-remap: move IOMM
                                   # ad3ad3f: x64, x2apic/intr-remap: parse ioa
                                   # 1886e8a: x64, x2apic/intr-remap: code re-s
                                   # c42d9f3: x64, x2apic/intr-remap: fix the n
                                   # e61d98d: x64, x2apic/intr-remap: Intel vt-
drivers/pci/intr_remapping.c       # 75c46fa: x64, x2apic/intr-remap: MSI and M
                                   # 89027d3: x64, x2apic/intr-remap: IO-APIC s
                                   # b6fcb33: x64, x2apic/intr-remap: routines 
                                   # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # ad3ad3f: x64, x2apic/intr-remap: parse ioa
drivers/pci/intr_remapping.h       # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # ad3ad3f: x64, x2apic/intr-remap: parse ioa
include/asm-generic/vmlinux.lds.h  # 63cc8c7: percpu: introduce DEFINE_PER_CPU_
include/linux/dmar.h               # 75c46fa: x64, x2apic/intr-remap: MSI and M
                                   # 89027d3: x64, x2apic/intr-remap: IO-APIC s
                                   # b6fcb33: x64, x2apic/intr-remap: routines 
                                   # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # ad3ad3f: x64, x2apic/intr-remap: parse ioa
                                   # 1886e8a: x64, x2apic/intr-remap: code re-s
include/linux/ioport.h             # 268364a: IO resources: add reserve_region_
include/linux/irq.h                # 72b1e22: x64, x2apic/intr-remap: generic i
include/linux/percpu.h             # 63cc8c7: percpu: introduce DEFINE_PER_CPU_
kernel/irq/manage.c                # 72b1e22: x64, x2apic/intr-remap: generic i
kernel/resource.c                  # 268364a: IO resources: add reserve_region_

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: drop -funroll-loops for csum_partial_64.c

Andreas Herrmann (2):
      x86: pda_init(): fix memory leak when using CPU hotplug
      x86: cpu_init(): fix memory leak when using CPU hotplug

Cihula, Joseph (1):
      x86, e820: add support for AddressRangeUnusuable ACPI memory type

Cyrill Gorcunov (34):
      x86: apic unification - merge down lapic_get_maxlvt
      x86: apic unification - merge down enable_NMI_through_LVT0
      x86: apic interrupts - move assignments to irqinit_32.c, v2
      x86: apic - use SET_APIC_DEST_FIELD instead of hardcoded shift
      x86: apic - unify disable_apic_timer
      x86: apic - unify __setup_APIC_LVTT
      x86: apic - do not clear APIC twice in lapic_shutdown
      x86: apic - get rid of local_apic_timer_verify_ok
      x86: apic - unify verify_local_APIC
      x86: apic - unify sync_Arb_IDs
      x86: apic - sync_Arb_IDs style fixup
      x86: apic - unify init_bsp_APIC
      x86: apic - unify clear_local_APIC
      x86: apic - unify lapic_resume
      x86: apic - unify lapic_suspend
      x86: apic - rearrange functions and comments
      x86: apic - unify lapic_is_integrated
      x86: apic - unify xapic_icr_read
      x86: apic - rearrange maxcpu definition
      x86: apic - unify setup_boot_APIC_clock
      x86: apic - unify disable_local_APIC
      x86: apic - unify lapic_shutdown
      x86: apic - unify connect_bsp_APIC
      x86: apic - unify lapic_setup_esr
      x86: apic - unify __setup_APIC_LVTT
      x86: apic - unify disconnect_bsp_APIC
      x86: apic - generic_processor_info
      x86: apic - unify end_local_APIC_setup
      x86: apic - unify local_apic_timer_interrupt
      x86: apic - unify apic_set_verbosity
      x86: apic - unify disableapic and nolapic setup handlers
      x86: apic - rearrange parse_lapic_timer_c2_ok
      x86: apic - lapic_resume 32bit - unification fix
      x86: apic - compilation warnings fix

Eric Dumazet (1):
      percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro

H. Peter Anvin (10):
      x86, xsave: add <asm/xcr.h> header file for XCR registers
      x86, xsave: keep the XSAVE feature mask as an u64
      x86: boot: stub out unimplemented CPU feature words
      x86: add NOPL as a synthetic CPU feature bit
      x86: use X86_FEATURE_NOPL in alternatives
      x86: generate names for /proc/cpuinfo from <asm/cpufeature.h>
      x86: cpufeature: add Intel features from CPUID and AVX specs
      x86: <asm/cpufeature.h>: clean up overlong lines, whitespace
      x86: cpufeature: fix SMX flag
      x86 setup: handle more than 8 CPU flag words

Hans Schou (1):
      x86, debug: print more information about unknown CPUs

Hiroshi Shimamoto (2):
      x86_32: use apic_ops at print_local_APIC()
      x86_64: uml: fix rename header guard

Huang Weiyi (1):
      arch/x86/kernel/genx2apic_uv_x.c: Removed duplicated include

Ingo Molnar (11):
      x86, xen: fix apic_ops build on UP
      x86, lguest: fix apic_ops build on UP
      x86, cyrix: debug
      x86: L3 cache index disable for 2.6.26, cleanups
      x86 l3 cache index disable for 2 6 26 fix
      x86: L3 cache index disable for 2.6.26, fix #2
      x86: fix xsave build error
      x86: split e820 reserved entries record to late v4
      x86: cpu/common*.c, merge whitespaces
      x86, init_64.c: cleanup
      x86: cpuid, fix typo

Jan Beulich (1):
      x86-64: add two __cpuinit annotations

Krzysztof Helt (1):
      x86: delay early cpu initialization until cpuid is done

Maciej W. Rozycki (1):
      x86: PIC, L-APIC and I/O APIC debug information

Mark Langsdorf (2):
      x86: L3 cache index disable for 2.6.26
      x86: L3 cache index disable for 2.6.26

Sheng Yang (2):
      x86: move VMX MSRs to msr-index.h
      x86: extended "flags" to show virtualization HW feature in /proc/cpuinfo

Suresh Siddha (51):
      x64, x2apic/intr-remap: Intel vt-d, IOMMU code reorganization
      x64, x2apic/intr-remap: fix the need for sequential array allocation of iommus
      x64, x2apic/intr-remap: code re-structuring, to be used by both DMA and Interrupt remapping
      x64, x2apic/intr-remap: use CONFIG_DMAR for DMA-remapping specific code
      x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping detection
      x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
      x64, x2apic/intr-remap: move IOMMU_WAIT_OP() macro to intel-iommu.h
      x64, x2apic/intr-remap: Queued invalidation infrastructure (part of VT-d)
      x64, x2apic/intr-remap: Interrupt remapping infrastructure
      x64, x2apic/intr-remap: routines managing Interrupt remapping table entries.
      x64, x2apic/intr-remap: generic irq migration support from process context
      x64, x2apic/intr-remap: 8259 specific mask/unmask routines
      x64, x2apic/intr-remap: ioapic routines which deal with initial io-apic RTE setup
      x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support, fix
      x64, x2apic/intr-remap: basic apic ops support
      x64, x2apic/intr-remap: cpuid bits for x2apic feature
      x64, x2apic/intr-remap: disable DMA-remapping if Interrupt-remapping is detected (temporary quirk)
      x64, x2apic/intr-remap: x2apic ops for x2apic mode support
      x64, x2apic/intr-remap: introcude self IPI to genapic routines
      x64, x2apic/intr-remap: x2apic cluster mode support
      x64, x2apic/intr-remap: setup init_apic_ldr for UV
      x64, x2apic/intr-remap: IO-APIC support for interrupt-remapping
      x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
      x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping
      x64, x2apic/intr-remap: support for x2apic physical mode support
      x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
      x2apic: uninline uv_init_apic_ldr()
      x2apic: xen64 paravirt basic apic ops
      x2apic: kernel-parameter documentation for "x2apic_phys"
      x86: let 32bit use apic_ops too - fix
      x86: apic_ops for lguest
      x86: APIC: Remove apic_write_around(); use alternatives, merge fix
      x64, apic: use generic apic_write() for ack_APIC_irq()
      x86, xsave: xsave cpuid feature bits
      x86, xsave: enable xsave/xrstor on cpus with xsave support
      x86, xsave: context switch support using xsave/xrstor
      x86, xsave: dynamically allocate sigframes fpstate instead of static allocation
      x86, xsave: reorganization of signal save/restore fpstate code layout
      x86, xsave: xsave/xrstor specific routines
      x86, xsave: struct _fpstate extensions to include extended state information
      x86, xsave: save/restore the extended state context in sigframe
      x86, xsave: update xsave header bits during ptrace fpregs set
      x86, xsave: remove the redundant access_ok() in setup_rt_frame()
      x86, xsave: clear the user buffer before doing fxsave/xsave
      x86, xsave: use BUG_ON() instead of BUILD_BUG_ON()
      x86: use cpuid vector 0xb when available for detecting cpu topology
      x86: use x2apic id reported by cpuid during topology discovery
      x86: use x2apic id reported by cpuid during topology discovery, fix
      x86: xsave: restore xcr0 during resume

Thomas Petazzoni (3):
      x86: make movsl_mask definition non-CPU specific
      x86: move cmpxchg fallbacks to a generic place
      x86: configuration options to compile out x86 CPU support code

Yinghai Lu (61):
      x86: let 32bit use apic_ops too
      x86: mach_apicdef.h need to include before smp.h
      x86: make read_apic_id return final apicid
      x86: make 64bit have get_apic_id
      x86: let 32bit use apic_ops too - fix
      x86: add apic probe for genapic 64bit, v2
      x86: move declaring x2apic_extra_bits
      x86: add setup_ioapic_ids for numaq in x86_quirks
      x86: mach-bigsmp to bigsmp
      x86: mach_es7000 to es7000
      x86: mach_summit to summit
      x86: mach-numaq to numaq
      x86: add apic probe for genapic 64bit - fix
      x86: apic - unify lapic_resume - fix
      x86: fix apic version warning
      x86: move dir es7000 to es7000_32.c
      x86: split e820 reserved entries record to late v2
      IO resources: add reserve_region_with_split()
      x86: split e820 reserved entries record to late, v7
      x86: unify using pci_mmcfg_insert_resource
      x86: move mtrr cpu cap setting early in early_init_xxxx
      x86: make (early)_identify_cpu more the same between 32bit and 64 bit
      x86: order functions in cpu/common.c and cpu/common_64.c v2
      x86: remove cpu_vendor_dev
      x86: make 32bit support show_msr like 64 bit
      x86: make get_mode_name of 64bit the same as 32bit
      x86: move 32bit related functions together
      x86: make detect_ht depend on CONFIG_X86_HT
      x86: make header file the same in arch/x86/kernel/cpu/common_xx.c
      x86: same gdt_page with macro
      x86: cpu/common.c, let 64-bit code have 32-bit only functions
      x86: cpu/common*.c, make 32-bit have 64-bit only functions
      x86: cpu/common*.c have same cpu_init(), with copying and #ifdef
      x86: cpu/common*.c, merge switch_to_new_gdt()
      x86: cpu/common.c, merge default_init()
      x86: cpu/common*.c, merge display_cacheinfo()
      x86: cpu/common*.c, merge detect_ht()
      x86: cpu/common.c: merge get_cpu_cap()
      x86: cpu/common*.c, merge early_identify_cpu()
      x86: cpu/common*.c: merge print_cpu_info()
      x86: cpu/common*.c, merge generic_identify()
      x86: cpu/common*.c, merge identify_cpu()
      x86: use cpu/common.c on 64 bit
      x86: move nonx_setup etc from common.c to init_64.c
      x86: remove duplicated get_model_name() calling
      x86, cpu init: call early_init_xxx in init_xxx
      x86: cpu make amd.c more like amd_64.c v2
      x86: remove duplicated force_mwait
      x86: add srat_detect_node for amd64
      x86: merge header in amd_64.c
      x86: make amd.c have 64bit support code
      x86: make amd_64 have 32 bit code
      x86: make 64 bit to use amd.c
      x86: little clean up of intel.c/intel_64.c
      x86: make intel.c have 64-bit support code
      x86: make intel_64.c the same as intel.c
      x86: let intel 64-bit use intel.c
      x86: intel.c put workaround for old cpus together
      x86: centaur_64.c remove duplicated setting of CONSTANT_TSC
      x86: identify_cpu_without_cpuid v2
      x86: move transmeta cap read to early_init_transmeta()


 Documentation/kernel-parameters.txt                |    6 +
 arch/um/sys-x86_64/syscall_table.c                 |    4 +-
 arch/x86/Kconfig                                   |    8 +
 arch/x86/Kconfig.cpu                               |   54 ++
 arch/x86/boot/cpu.c                                |   17 +-
 arch/x86/boot/mkcpustr.c                           |   40 +-
 arch/x86/ia32/ia32_signal.c                        |   51 +-
 arch/x86/kernel/Makefile                           |    5 +-
 arch/x86/kernel/acpi/boot.c                        |    8 +-
 arch/x86/kernel/apic_32.c                          |  437 +++++----
 arch/x86/kernel/apic_64.c                          |  626 +++++++++++--
 arch/x86/kernel/cpu/Makefile                       |   34 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c         |   88 ++
 arch/x86/kernel/cpu/amd.c                          |  548 +++++++----
 arch/x86/kernel/cpu/amd_64.c                       |  224 -----
 arch/x86/kernel/cpu/centaur.c                      |    4 +-
 arch/x86/kernel/cpu/centaur_64.c                   |    6 +-
 arch/x86/kernel/cpu/cmpxchg.c                      |   72 ++
 arch/x86/kernel/cpu/common.c                       |  973 ++++++++++++++------
 arch/x86/kernel/cpu/common_64.c                    |  763 ---------------
 arch/x86/kernel/cpu/cpu.h                          |   19 +-
 arch/x86/kernel/cpu/cyrix.c                        |   23 +-
 arch/x86/kernel/cpu/feature_names.c                |   84 --
 arch/x86/kernel/cpu/intel.c                        |  364 ++++----
 arch/x86/kernel/cpu/intel_64.c                     |   95 --
 arch/x86/kernel/cpu/intel_cacheinfo.c              |  169 +++-
 arch/x86/kernel/cpu/mcheck/mce_64.c                |    2 +-
 arch/x86/kernel/cpu/mkcapflags.pl                  |   32 +
 arch/x86/kernel/cpu/powerflags.c                   |   20 +
 arch/x86/kernel/cpu/transmeta.c                    |   32 +-
 arch/x86/kernel/cpu/umc.c                          |    3 +-
 arch/x86/kernel/e820.c                             |   28 +-
 .../es7000plat.c => kernel/es7000_32.c}            |   87 ++-
 arch/x86/kernel/genapic_64.c                       |   88 +--
 arch/x86/kernel/genapic_flat_64.c                  |   62 ++-
 arch/x86/kernel/genx2apic_cluster.c                |  159 ++++
 arch/x86/kernel/genx2apic_phys.c                   |  154 +++
 arch/x86/kernel/genx2apic_uv_x.c                   |   70 ++-
 arch/x86/kernel/i387.c                             |  154 +++-
 arch/x86/kernel/i8259.c                            |   24 +
 arch/x86/kernel/io_apic_32.c                       |   47 +-
 arch/x86/kernel/io_apic_64.c                       |  639 ++++++++++++-
 arch/x86/kernel/irqinit_32.c                       |   49 +
 arch/x86/kernel/mpparse.c                          |    2 +
 arch/x86/kernel/numaq_32.c                         |    7 +
 arch/x86/kernel/paravirt.c                         |    2 -
 arch/x86/kernel/process.c                          |    1 -
 arch/x86/kernel/setup.c                            |    2 +
 arch/x86/kernel/sigframe.h                         |   14 +-
 arch/x86/kernel/signal_32.c                        |   45 +-
 arch/x86/kernel/signal_64.c                        |   95 +--
 arch/x86/kernel/smpboot.c                          |   38 +-
 arch/x86/kernel/summit_32.c                        |    2 +-
 arch/x86/kernel/traps_32.c                         |    1 -
 arch/x86/kernel/traps_64.c                         |    6 +-
 arch/x86/kernel/vmi_32.c                           |    4 +-
 arch/x86/kernel/vmlinux_32.lds.S                   |    9 +-
 arch/x86/kernel/vmlinux_64.lds.S                   |    9 +-
 arch/x86/kernel/xsave.c                            |  316 +++++++
 arch/x86/kvm/vmx.h                                 |   15 -
 arch/x86/lguest/boot.c                             |   38 +-
 arch/x86/lib/Makefile                              |    3 -
 arch/x86/lib/usercopy_32.c                         |    7 +
 arch/x86/mach-default/setup.c                      |   15 -
 arch/x86/mach-es7000/Makefile                      |    5 -
 arch/x86/mach-es7000/es7000.h                      |  114 ---
 arch/x86/mach-generic/Makefile                     |    1 -
 arch/x86/mach-generic/bigsmp.c                     |    9 +-
 arch/x86/mach-generic/es7000.c                     |   13 +-
 arch/x86/mach-generic/numaq.c                      |   12 +-
 arch/x86/mach-generic/summit.c                     |   11 +-
 arch/x86/mm/init_64.c                              |   56 ++
 arch/x86/pci/acpi.c                                |    5 -
 arch/x86/pci/i386.c                                |    3 +
 arch/x86/pci/mmconfig-shared.c                     |   12 +-
 arch/x86/power/cpu_32.c                            |    7 +
 arch/x86/power/cpu_64.c                            |    7 +
 arch/x86/xen/enlighten.c                           |   45 +-
 drivers/pci/Makefile                               |    2 +
 drivers/pci/dma_remapping.h                        |  157 ++++
 drivers/pci/dmar.c                                 |  397 ++++++++-
 drivers/pci/intel-iommu.c                          |  185 +----
 drivers/pci/intel-iommu.h                          |  233 ++---
 drivers/pci/intr_remapping.c                       |  471 ++++++++++
 drivers/pci/intr_remapping.h                       |    8 +
 include/asm-generic/vmlinux.lds.h                  |    1 +
 include/asm-x86/apic.h                             |   65 ++-
 include/asm-x86/apicdef.h                          |    3 +
 include/asm-x86/arch_hooks.h                       |    2 -
 .../{mach-bigsmp/mach_apic.h => bigsmp/apic.h}     |   10 +-
 include/asm-x86/bigsmp/apicdef.h                   |   13 +
 .../{mach-bigsmp/mach_ipi.h => bigsmp/ipi.h}       |    6 +-
 include/asm-x86/bugs.h                             |    5 +
 include/asm-x86/cpufeature.h                       |  118 ++-
 include/asm-x86/e820.h                             |    2 +
 .../{mach-es7000/mach_apic.h => es7000/apic.h}     |   32 +-
 include/asm-x86/es7000/apicdef.h                   |   13 +
 .../{mach-es7000/mach_ipi.h => es7000/ipi.h}       |    6 +-
 .../mach_mpparse.h => es7000/mpparse.h}            |    6 +-
 .../mach_wakecpu.h => es7000/wakecpu.h}            |    8 +-
 include/asm-x86/genapic_64.h                       |    8 +
 include/asm-x86/hw_irq.h                           |    3 +-
 include/asm-x86/i387.h                             |   84 ++-
 include/asm-x86/i8259.h                            |    3 +
 include/asm-x86/io_apic.h                          |   20 +
 include/asm-x86/ipi.h                              |   16 +-
 include/asm-x86/irq_remapping.h                    |    8 +
 include/asm-x86/mach-bigsmp/mach_apicdef.h         |   13 -
 include/asm-x86/mach-default/mach_apic.h           |    4 +-
 include/asm-x86/mach-default/mach_apicdef.h        |    6 +-
 include/asm-x86/mach-es7000/mach_apicdef.h         |   13 -
 include/asm-x86/mach-numaq/mach_mpparse.h          |    7 -
 include/asm-x86/mach-summit/mach_apicdef.h         |   13 -
 include/asm-x86/mpspec.h                           |    3 +-
 include/asm-x86/msidef.h                           |    4 +
 include/asm-x86/msr-index.h                        |   16 +
 .../{mach-numaq/mach_apic.h => numaq/apic.h}       |    6 +-
 .../{mach-numaq/mach_apicdef.h => numaq/apicdef.h} |    6 +-
 .../asm-x86/{mach-numaq/mach_ipi.h => numaq/ipi.h} |    6 +-
 include/asm-x86/numaq/mpparse.h                    |    7 +
 .../{mach-numaq/mach_wakecpu.h => numaq/wakecpu.h} |    6 +-
 include/asm-x86/paravirt.h                         |   19 -
 include/asm-x86/processor-cyrix.h                  |    8 +
 include/asm-x86/processor-flags.h                  |    1 +
 include/asm-x86/processor.h                        |   27 +-
 include/asm-x86/setup.h                            |    1 +
 include/asm-x86/sigcontext.h                       |   87 ++-
 include/asm-x86/sigcontext32.h                     |    6 +-
 include/asm-x86/smp.h                              |   17 +-
 .../{mach-summit/mach_apic.h => summit/apic.h}     |   24 +-
 include/asm-x86/summit/apicdef.h                   |   13 +
 .../{mach-summit/mach_ipi.h => summit/ipi.h}       |    6 +-
 .../{mach-summit => summit}/irq_vectors_limits.h   |    6 +-
 .../mach_mpparse.h => summit/mpparse.h}            |   13 +-
 include/asm-x86/thread_info.h                      |    1 +
 include/asm-x86/ucontext.h                         |    6 +
 include/asm-x86/xcr.h                              |   49 +
 include/asm-x86/xsave.h                            |  118 +++
 include/linux/dmar.h                               |  127 ++-
 include/linux/ioport.h                             |    3 +
 include/linux/irq.h                                |    1 +
 include/linux/percpu.h                             |    7 +
 kernel/irq/manage.c                                |    9 +-
 kernel/resource.c                                  |   68 ++
 144 files changed, 6628 insertions(+), 3287 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/amd_64.c
 create mode 100644 arch/x86/kernel/cpu/cmpxchg.c
 delete mode 100644 arch/x86/kernel/cpu/common_64.c
 delete mode 100644 arch/x86/kernel/cpu/feature_names.c
 delete mode 100644 arch/x86/kernel/cpu/intel_64.c
 create mode 100644 arch/x86/kernel/cpu/mkcapflags.pl
 create mode 100644 arch/x86/kernel/cpu/powerflags.c
 rename arch/x86/{mach-es7000/es7000plat.c => kernel/es7000_32.c} (78%)
 create mode 100644 arch/x86/kernel/genx2apic_cluster.c
 create mode 100644 arch/x86/kernel/genx2apic_phys.c
 create mode 100644 arch/x86/kernel/xsave.c
 delete mode 100644 arch/x86/mach-es7000/Makefile
 delete mode 100644 arch/x86/mach-es7000/es7000.h
 create mode 100644 drivers/pci/dma_remapping.h
 create mode 100644 drivers/pci/intr_remapping.c
 create mode 100644 drivers/pci/intr_remapping.h
 rename include/asm-x86/{mach-bigsmp/mach_apic.h => bigsmp/apic.h} (94%)
 create mode 100644 include/asm-x86/bigsmp/apicdef.h
 rename include/asm-x86/{mach-bigsmp/mach_ipi.h => bigsmp/ipi.h} (77%)
 rename include/asm-x86/{mach-es7000/mach_apic.h => es7000/apic.h} (91%)
 create mode 100644 include/asm-x86/es7000/apicdef.h
 rename include/asm-x86/{mach-es7000/mach_ipi.h => es7000/ipi.h} (77%)
 rename include/asm-x86/{mach-es7000/mach_mpparse.h => es7000/mpparse.h} (81%)
 rename include/asm-x86/{mach-es7000/mach_wakecpu.h => es7000/wakecpu.h} (89%)
 create mode 100644 include/asm-x86/irq_remapping.h
 delete mode 100644 include/asm-x86/mach-bigsmp/mach_apicdef.h
 delete mode 100644 include/asm-x86/mach-es7000/mach_apicdef.h
 delete mode 100644 include/asm-x86/mach-numaq/mach_mpparse.h
 delete mode 100644 include/asm-x86/mach-summit/mach_apicdef.h
 rename include/asm-x86/{mach-numaq/mach_apic.h => numaq/apic.h} (96%)
 rename include/asm-x86/{mach-numaq/mach_apicdef.h => numaq/apicdef.h} (55%)
 rename include/asm-x86/{mach-numaq/mach_ipi.h => numaq/ipi.h} (77%)
 create mode 100644 include/asm-x86/numaq/mpparse.h
 rename include/asm-x86/{mach-numaq/mach_wakecpu.h => numaq/wakecpu.h} (88%)
 rename include/asm-x86/{mach-summit/mach_apic.h => summit/apic.h} (93%)
 create mode 100644 include/asm-x86/summit/apicdef.h
 rename include/asm-x86/{mach-summit/mach_ipi.h => summit/ipi.h} (77%)
 rename include/asm-x86/{mach-summit => summit}/irq_vectors_limits.h (65%)
 rename include/asm-x86/{mach-summit/mach_mpparse.h => summit/mpparse.h} (95%)
 create mode 100644 include/asm-x86/xcr.h
 create mode 100644 include/asm-x86/xsave.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a2701cb..c5d891f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1424,6 +1424,12 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
+	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
+
+	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
+			default x2apic cluster mode on platforms
+			supporting x2apic.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86_64/syscall_table.c
index c128eb8..32f5fbe 100644
--- a/arch/um/sys-x86_64/syscall_table.c
+++ b/arch/um/sys-x86_64/syscall_table.c
@@ -41,12 +41,12 @@
 #define stub_rt_sigreturn sys_rt_sigreturn
 
 #define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 #include <asm-x86/unistd_64.h>
 
 #undef __SYSCALL
 #define __SYSCALL(nr, sym) [ nr ] = sym,
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 
 typedef void (*sys_call_ptr_t)(void);
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0d7cdbb..44d4f21 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1689,6 +1689,14 @@ config DMAR_FLOPPY_WA
 	 workaround will setup a 1:1 mapping for the first
 	 16M to make floppy (an ISA device) work.
 
+config INTR_REMAP
+	bool "Support for Interrupt Remapping (EXPERIMENTAL)"
+	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI && EXPERIMENTAL
+	help
+	 Supports Interrupt remapping for IO-APIC and MSI devices.
+	 To use x2apic mode in the CPU's which support x2APIC enhancements or
+	 to support platforms with CPU's having > 8 bit APIC ID, say Y.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 60a8576..f8843c3 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -419,6 +419,60 @@ config X86_DEBUGCTLMSR
 	def_bool y
 	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
 
+menuconfig PROCESSOR_SELECT
+	default y
+	bool "Supported processor vendors" if EMBEDDED
+	help
+	  This lets you choose what x86 vendor support code your kernel
+	  will include.
+
+config CPU_SUP_INTEL
+	default y
+	bool "Support Intel processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for Intel processors
+
+config CPU_SUP_CYRIX_32
+	default y
+	bool "Support Cyrix processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Cyrix processors
+
+config CPU_SUP_AMD
+	default y
+	bool "Support AMD processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for AMD processors
+
+config CPU_SUP_CENTAUR_32
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_CENTAUR_64
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	depends on 64BIT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_TRANSMETA_32
+	default y
+	bool "Support Transmeta processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for Transmeta processors
+
+config CPU_SUP_UMC_32
+	default y
+	bool "Support UMC processors" if PROCESSOR_SELECT
+	depends on !64BIT
+	help
+	  This enables extended support for UMC processors
+
 config X86_DS
 	bool "Debug Store support"
 	default y
diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
index 75298fe..6ec6bb6 100644
--- a/arch/x86/boot/cpu.c
+++ b/arch/x86/boot/cpu.c
@@ -59,17 +59,18 @@ int validate_cpu(void)
 			u32 e = err_flags[i];
 
 			for (j = 0; j < 32; j++) {
-				int n = (i << 5)+j;
-				if (*msg_strs < n) {
+				if (msg_strs[0] < i ||
+				    (msg_strs[0] == i && msg_strs[1] < j)) {
 					/* Skip to the next string */
-					do {
-						msg_strs++;
-					} while (*msg_strs);
-					msg_strs++;
+					msg_strs += 2;
+					while (*msg_strs++)
+						;
 				}
 				if (e & 1) {
-					if (*msg_strs == n && msg_strs[1])
-						printf("%s ", msg_strs+1);
+					if (msg_strs[0] == i &&
+					    msg_strs[1] == j &&
+					    msg_strs[2])
+						printf("%s ", msg_strs+2);
 					else
 						printf("%d:%d ", i, j);
 				}
diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index bbe7695..8ef60f2 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -15,33 +15,33 @@
 
 #include <stdio.h>
 
-#include "../kernel/cpu/feature_names.c"
-
-#if NCAPFLAGS > 8
-# error "Need to adjust the boot code handling of CPUID strings"
-#endif
+#include "../kernel/cpu/capflags.c"
 
 int main(void)
 {
-	int i;
+	int i, j;
 	const char *str;
 
 	printf("static const char x86_cap_strs[] = \n");
 
-	for (i = 0; i < NCAPINTS*32; i++) {
-		str = x86_cap_flags[i];
-
-		if (i == NCAPINTS*32-1) {
-			/* The last entry must be unconditional; this
-			   also consumes the compiler-added null character */
-			if (!str)
-				str = "";
-			printf("\t\"\\x%02x\"\"%s\"\n", i, str);
-		} else if (str) {
-			printf("#if REQUIRED_MASK%d & (1 << %d)\n"
-			       "\t\"\\x%02x\"\"%s\\0\"\n"
-			       "#endif\n",
-			       i >> 5, i & 31, i, str);
+	for (i = 0; i < NCAPINTS; i++) {
+		for (j = 0; j < 32; j++) {
+			str = x86_cap_flags[i*32+j];
+
+			if (i == NCAPINTS-1 && j == 31) {
+				/* The last entry must be unconditional; this
+				   also consumes the compiler-added null
+				   character */
+				if (!str)
+					str = "";
+				printf("\t\"\\x%02x\\x%02x\"\"%s\"\n",
+				       i, j, str);
+			} else if (str) {
+				printf("#if REQUIRED_MASK%d & (1 << %d)\n"
+				       "\t\"\\x%02x\\x%02x\"\"%s\\0\"\n"
+				       "#endif\n",
+				       i, j, i, j, str);
+			}
 		}
 	}
 	printf("\t;\n");
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index f1a2ac7..8d64c1b 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -179,9 +179,10 @@ struct sigframe
 	u32 pretcode;
 	int sig;
 	struct sigcontext_ia32 sc;
-	struct _fpstate_ia32 fpstate;
+	struct _fpstate_ia32 fpstate_unused; /* look at kernel/sigframe.h */
 	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp state follows here */
 };
 
 struct rt_sigframe
@@ -192,8 +193,8 @@ struct rt_sigframe
 	u32 puc;
 	compat_siginfo_t info;
 	struct ucontext_ia32 uc;
-	struct _fpstate_ia32 fpstate;
 	char retcode[8];
+	/* fp state follows here */
 };
 
 #define COPY(x)		{ 		\
@@ -215,7 +216,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   unsigned int *peax)
 {
 	unsigned int tmpflags, gs, oldgs, err = 0;
-	struct _fpstate_ia32 __user *buf;
+	void __user *buf;
 	u32 tmp;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -259,26 +260,12 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 	err |= __get_user(tmp, &sc->fpstate);
 	buf = compat_ptr(tmp);
-	if (buf) {
-		if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-			goto badframe;
-		err |= restore_i387_ia32(buf);
-	} else {
-		struct task_struct *me = current;
-
-		if (used_math()) {
-			clear_fpu(me);
-			clear_used_math();
-		}
-	}
+	err |= restore_i387_xstate_ia32(buf);
 
 	err |= __get_user(tmp, &sc->ax);
 	*peax = tmp;
 
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys32_sigreturn(struct pt_regs *regs)
@@ -350,7 +337,7 @@ badframe:
  */
 
 static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
-				 struct _fpstate_ia32 __user *fpstate,
+				 void __user *fpstate,
 				 struct pt_regs *regs, unsigned int mask)
 {
 	int tmp, err = 0;
@@ -380,7 +367,7 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	err |= __put_user((u32)regs->flags, &sc->flags);
 	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
 
-	tmp = save_i387_ia32(fpstate);
+	tmp = save_i387_xstate_ia32(fpstate);
 	if (tmp < 0)
 		err = -EFAULT;
 	else {
@@ -401,7 +388,8 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
  * Determine which stack to use..
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-				 size_t frame_size)
+				 size_t frame_size,
+				 void **fpstate)
 {
 	unsigned long sp;
 
@@ -420,6 +408,11 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 		 ka->sa.sa_restorer)
 		sp = (unsigned long) ka->sa.sa_restorer;
 
+	if (used_math()) {
+		sp = sp - sig_xstate_ia32_size;
+		*fpstate = (struct _fpstate_ia32 *) sp;
+	}
+
 	sp -= frame_size;
 	/* Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0. */
@@ -433,6 +426,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	void __user *fpstate = NULL;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -447,7 +441,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -456,8 +450,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	if (err)
 		goto give_sigsegv;
 
-	err |= ia32_setup_sigcontext(&frame->sc, &frame->fpstate, regs,
-					set->sig[0]);
+	err |= ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
 		goto give_sigsegv;
 
@@ -521,6 +514,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	void __user *fpstate = NULL;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -536,7 +530,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -549,13 +543,16 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
+	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				     regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3db651f..c9be69f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -38,7 +38,7 @@ obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
-obj-y				+= i387.o
+obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
@@ -69,6 +69,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
+obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
 obj-y				+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
@@ -104,6 +105,8 @@ obj-$(CONFIG_OLPC)		+= olpc.o
 ifeq ($(CONFIG_X86_64),y)
         obj-y				+= genapic_64.o genapic_flat_64.o genx2apic_uv_x.o tlb_uv.o
 	obj-y				+= bios_uv.o
+        obj-y				+= genx2apic_cluster.o
+        obj-y				+= genx2apic_phys.o
         obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
         obj-$(CONFIG_AUDIT)		+= audit_64.o
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 7d40ef7..c2ac1b4 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -252,10 +252,8 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 		return;
 	}
 
-#ifdef CONFIG_X86_32
 	if (boot_cpu_physical_apicid != -1U)
 		ver = apic_version[boot_cpu_physical_apicid];
-#endif
 
 	generic_processor_info(id, ver);
 }
@@ -774,11 +772,9 @@ static void __init acpi_register_lapic_address(unsigned long address)
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
 	if (boot_cpu_physical_apicid == -1U) {
-		boot_cpu_physical_apicid  = GET_APIC_ID(read_apic_id());
-#ifdef CONFIG_X86_32
+		boot_cpu_physical_apicid  = read_apic_id();
 		apic_version[boot_cpu_physical_apicid] =
 			 GET_APIC_VERSION(apic_read(APIC_LVR));
-#endif
 	}
 }
 
@@ -1350,7 +1346,9 @@ static void __init acpi_process_madt(void)
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
+#ifdef CONFIG_X86_32
 				setup_apic_routing();
+#endif
 			}
 		}
 		if (error == -EINVAL) {
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index f88bd0d..a91c57c 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -60,10 +60,8 @@ unsigned long mp_lapic_addr;
 static int force_enable_local_apic;
 int disable_apic;
 
-/* Local APIC timer verification ok */
-static int local_apic_timer_verify_ok;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int local_apic_timer_disabled;
+static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -130,7 +128,11 @@ static inline int lapic_get_version(void)
  */
 static inline int lapic_is_integrated(void)
 {
+#ifdef CONFIG_X86_64
+	return 1;
+#else
 	return APIC_INTEGRATED(lapic_get_version());
+#endif
 }
 
 /*
@@ -145,13 +147,18 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
-void apic_wait_icr_idle(void)
+/*
+ * Paravirt kernels also might be using these below ops. So we still
+ * use generic apic_read()/apic_write(), which might be pointing to different
+ * ops in PARAVIRT case.
+ */
+void xapic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
 		cpu_relax();
 }
 
-u32 safe_apic_wait_icr_idle(void)
+u32 safe_xapic_wait_icr_idle(void)
 {
 	u32 send_status;
 	int timeout;
@@ -167,16 +174,48 @@ u32 safe_apic_wait_icr_idle(void)
 	return send_status;
 }
 
+void xapic_icr_write(u32 low, u32 id)
+{
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write(APIC_ICR, low);
+}
+
+u64 xapic_icr_read(void)
+{
+	u32 icr1, icr2;
+
+	icr2 = apic_read(APIC_ICR2);
+	icr1 = apic_read(APIC_ICR);
+
+	return icr1 | ((u64)icr2 << 32);
+}
+
+static struct apic_ops xapic_ops = {
+	.read = native_apic_mem_read,
+	.write = native_apic_mem_write,
+	.icr_read = xapic_icr_read,
+	.icr_write = xapic_icr_write,
+	.wait_icr_idle = xapic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_xapic_wait_icr_idle,
+};
+
+struct apic_ops __read_mostly *apic_ops = &xapic_ops;
+EXPORT_SYMBOL_GPL(apic_ops);
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
 void __cpuinit enable_NMI_through_LVT0(void)
 {
-	unsigned int v = APIC_DM_NMI;
+	unsigned int v;
 
-	/* Level triggered for 82489DX */
+	/* unmask and set to NMI */
+	v = APIC_DM_NMI;
+
+	/* Level triggered for 82489DX (32bit mode) */
 	if (!lapic_is_integrated())
 		v |= APIC_LVT_LEVEL_TRIGGER;
+
 	apic_write(APIC_LVT0, v);
 }
 
@@ -193,9 +232,13 @@ int get_physical_broadcast(void)
  */
 int lapic_get_maxlvt(void)
 {
-	unsigned int v = apic_read(APIC_LVR);
+	unsigned int v;
 
-	/* 82489DXs do not report # of LVT entries. */
+	v = apic_read(APIC_LVR);
+	/*
+	 * - we always have APIC integrated on 64bit mode
+	 * - 82489DXs do not report # of LVT entries
+	 */
 	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
 }
 
@@ -203,8 +246,12 @@ int lapic_get_maxlvt(void)
  * Local APIC timer
  */
 
-/* Clock divisor is set to 16 */
+/* Clock divisor */
+#ifdef CONFG_X86_64
+#define APIC_DIVISOR 1
+#else
 #define APIC_DIVISOR 16
+#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -212,6 +259,9 @@ int lapic_get_maxlvt(void)
  * this function twice on the boot CPU, once with a bogus timeout
  * value, second time for real. The other (noncalibrating) CPUs
  * call this function only once, with the real, calibrated value.
+ *
+ * We do reads before writes even if unnecessary, to get around the
+ * P5 APIC double write bug.
  */
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
@@ -233,14 +283,44 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	 */
 	tmp_value = apic_read(APIC_TDCR);
 	apic_write(APIC_TDCR,
-		   (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
-		   APIC_TDR_DIV_16);
+		(tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
+		APIC_TDR_DIV_16);
 
 	if (!oneshot)
 		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
 }
 
 /*
+ * Setup extended LVT, AMD specific (K8, family 10h)
+ *
+ * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
+ * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ */
+
+#define APIC_EILVT_LVTOFF_MCE 0
+#define APIC_EILVT_LVTOFF_IBS 1
+
+static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
+{
+	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
+
+	apic_write(reg, v);
+}
+
+u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_MCE;
+}
+
+u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_IBS;
+}
+
+/*
  * Program the next event, relative to now
  */
 static int lapic_next_event(unsigned long delta,
@@ -259,8 +339,8 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 	unsigned long flags;
 	unsigned int v;
 
-	/* Lapic used for broadcast ? */
-	if (!local_apic_timer_verify_ok)
+	/* Lapic used as dummy for broadcast ? */
+	if (evt->features & CLOCK_EVT_FEAT_DUMMY)
 		return;
 
 	local_irq_save(flags);
@@ -473,7 +553,7 @@ static int __init calibrate_APIC_clock(void)
 		return -1;
 	}
 
-	local_apic_timer_verify_ok = 1;
+	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
 
 	/* We trust the pm timer based calibration */
 	if (!pm_referenced) {
@@ -507,11 +587,11 @@ static int __init calibrate_APIC_clock(void)
 		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
 			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
 		else
-			local_apic_timer_verify_ok = 0;
+			levt->features |= CLOCK_EVT_FEAT_DUMMY;
 	} else
 		local_irq_enable();
 
-	if (!local_apic_timer_verify_ok) {
+	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		printk(KERN_WARNING
 		       "APIC timer disabled due to verification failure.\n");
 			return -1;
@@ -533,7 +613,8 @@ void __init setup_boot_APIC_clock(void)
 	 * timer as a dummy clock event source on SMP systems, so the
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
-	if (local_apic_timer_disabled) {
+	if (disable_apic_timer) {
+		printk(KERN_INFO "Disabling APIC timer\n");
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1) {
 			lapic_clockevent.mult = 1;
@@ -602,7 +683,11 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
+#ifdef CONFIG_X86_64
+	add_pda(apic_timer_irqs, 1);
+#else
 	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+#endif
 
 	evt->event_handler(evt);
 }
@@ -642,35 +727,6 @@ int setup_profiling_timer(unsigned int multiplier)
 }
 
 /*
- * Setup extended LVT, AMD specific (K8, family 10h)
- *
- * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
- * MCE interrupts are supported. Thus MCE offset must be set to 0.
- */
-
-#define APIC_EILVT_LVTOFF_MCE 0
-#define APIC_EILVT_LVTOFF_IBS 1
-
-static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
-{
-	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
-	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
-	apic_write(reg, v);
-}
-
-u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_MCE;
-}
-
-u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
-{
-	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
-	return APIC_EILVT_LVTOFF_IBS;
-}
-
-/*
  * Local APIC start and shutdown
  */
 
@@ -715,7 +771,7 @@ void clear_local_APIC(void)
 	}
 
 	/* lets not touch this if we didn't frob it */
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
 		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
@@ -732,10 +788,6 @@ void clear_local_APIC(void)
 	if (maxlvt >= 4)
 		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
 
-#ifdef CONFIG_X86_MCE_P4THERMAL
-	if (maxlvt >= 5)
-		apic_write(APIC_LVTTHMR, APIC_LVT_MASKED);
-#endif
 	/* Integrated APIC (!82489DX) ? */
 	if (lapic_is_integrated()) {
 		if (maxlvt > 3)
@@ -750,7 +802,7 @@ void clear_local_APIC(void)
  */
 void disable_local_APIC(void)
 {
-	unsigned long value;
+	unsigned int value;
 
 	clear_local_APIC();
 
@@ -762,6 +814,7 @@ void disable_local_APIC(void)
 	value &= ~APIC_SPIV_APIC_ENABLED;
 	apic_write(APIC_SPIV, value);
 
+#ifdef CONFIG_X86_32
 	/*
 	 * When LAPIC was disabled by the BIOS and enabled by the kernel,
 	 * restore the disabled state.
@@ -773,6 +826,7 @@ void disable_local_APIC(void)
 		l &= ~MSR_IA32_APICBASE_ENABLE;
 		wrmsr(MSR_IA32_APICBASE, l, h);
 	}
+#endif
 }
 
 /*
@@ -789,11 +843,15 @@ void lapic_shutdown(void)
 		return;
 
 	local_irq_save(flags);
-	clear_local_APIC();
 
-	if (enabled_via_apicbase)
+#ifdef CONFIG_X86_32
+	if (!enabled_via_apicbase)
+		clear_local_APIC();
+	else
+#endif
 		disable_local_APIC();
 
+
 	local_irq_restore(flags);
 }
 
@@ -838,6 +896,12 @@ int __init verify_local_APIC(void)
 	 */
 	reg0 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
+	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
+	reg1 = apic_read(APIC_ID);
+	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
+	apic_write(APIC_ID, reg0);
+	if (reg1 != (reg0 ^ APIC_ID_MASK))
+		return 0;
 
 	/*
 	 * The next two are just to see if we have sane values.
@@ -863,14 +927,15 @@ void __init sync_Arb_IDs(void)
 	 */
 	if (modern_apic() || boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
 		return;
+
 	/*
 	 * Wait for idle.
 	 */
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR,
-		   APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_DEST_ALLINC |
+			APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*
@@ -878,7 +943,7 @@ void __init sync_Arb_IDs(void)
  */
 void __init init_bsp_APIC(void)
 {
-	unsigned long value;
+	unsigned int value;
 
 	/*
 	 * Don't do the setup now if we have a SMP BIOS as the
@@ -899,11 +964,13 @@ void __init init_bsp_APIC(void)
 	value &= ~APIC_VECTOR_MASK;
 	value |= APIC_SPIV_APIC_ENABLED;
 
+#ifdef CONFIG_X86_32
 	/* This bit is reserved on P4/Xeon and should be cleared */
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
 	    (boot_cpu_data.x86 == 15))
 		value &= ~APIC_SPIV_FOCUS_DISABLED;
 	else
+#endif
 		value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
@@ -922,6 +989,16 @@ static void __cpuinit lapic_setup_esr(void)
 {
 	unsigned long oldvalue, value, maxlvt;
 	if (lapic_is_integrated() && !esr_disable) {
+		if (esr_disable) {
+			/*
+			 * Something untraceable is creating bad interrupts on
+			 * secondary quads ... for the moment, just leave the
+			 * ESR disabled - we can't do anything useful with the
+			 * errors anyway - mbligh
+			 */
+			printk(KERN_INFO "Leaving ESR disabled.\n");
+			return;
+		}
 		/* !82489DX */
 		maxlvt = lapic_get_maxlvt();
 		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
@@ -942,16 +1019,7 @@ static void __cpuinit lapic_setup_esr(void)
 				"vector: 0x%08lx  after: 0x%08lx\n",
 				oldvalue, value);
 	} else {
-		if (esr_disable)
-			/*
-			 * Something untraceable is creating bad interrupts on
-			 * secondary quads ... for the moment, just leave the
-			 * ESR disabled - we can't do anything useful with the
-			 * errors anyway - mbligh
-			 */
-			printk(KERN_INFO "Leaving ESR disabled.\n");
-		else
-			printk(KERN_INFO "No ESR for 82489DX.\n");
+		printk(KERN_INFO "No ESR for 82489DX.\n");
 	}
 }
 
@@ -1089,13 +1157,17 @@ void __cpuinit setup_local_APIC(void)
 
 void __cpuinit end_local_APIC_setup(void)
 {
-	unsigned long value;
-
 	lapic_setup_esr();
-	/* Disable the local apic timer */
-	value = apic_read(APIC_LVTT);
-	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
-	apic_write(APIC_LVTT, value);
+
+#ifdef CONFIG_X86_32
+	{
+		unsigned int value;
+		/* Disable the local apic timer */
+		value = apic_read(APIC_LVTT);
+		value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, value);
+	}
+#endif
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
@@ -1205,7 +1277,7 @@ void __init init_apic_mappings(void)
 	 * default configuration (or the MP table is broken).
 	 */
 	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+		boot_cpu_physical_apicid = read_apic_id();
 
 }
 
@@ -1242,7 +1314,7 @@ int __init APIC_init_uniprocessor(void)
 	 * might be zero if read from MP tables. Get it from LAPIC.
 	 */
 #ifdef CONFIG_CRASH_DUMP
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 #endif
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 
@@ -1321,59 +1393,12 @@ void smp_error_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
-#ifdef CONFIG_SMP
-void __init smp_intr_init(void)
-{
-	/*
-	 * IRQ0 must be given a fixed assignment and initialized,
-	 * because it's used before the IO-APIC is set up.
-	 */
-	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
-
-	/*
-	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
-	 * IPI, driven by wakeup.
-	 */
-	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
-
-	/* IPI for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
-
-	/* IPI for generic function call */
-	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
-
-	/* IPI for single call function */
-	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
-				call_function_single_interrupt);
-}
-#endif
-
-/*
- * Initialize APIC interrupts
- */
-void __init apic_intr_init(void)
-{
-#ifdef CONFIG_SMP
-	smp_intr_init();
-#endif
-	/* self generated IPI for local APIC timer */
-	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
-
-	/* IPI vectors for APIC spurious and error interrupts */
-	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
-	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-
-	/* thermal monitor LVT interrupt */
-#ifdef CONFIG_X86_MCE_P4THERMAL
-	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
-#endif
-}
-
 /**
  * connect_bsp_APIC - attach the APIC to the interrupt system
  */
 void __init connect_bsp_APIC(void)
 {
+#ifdef CONFIG_X86_32
 	if (pic_mode) {
 		/*
 		 * Do not trust the local APIC being empty at bootup.
@@ -1388,6 +1413,7 @@ void __init connect_bsp_APIC(void)
 		outb(0x70, 0x22);
 		outb(0x01, 0x23);
 	}
+#endif
 	enable_apic_mode();
 }
 
@@ -1400,6 +1426,9 @@ void __init connect_bsp_APIC(void)
  */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
+	unsigned int value;
+
+#ifdef CONFIG_X86_32
 	if (pic_mode) {
 		/*
 		 * Put the board back into PIC mode (has an effect only on
@@ -1411,54 +1440,53 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 				"entering PIC mode.\n");
 		outb(0x70, 0x22);
 		outb(0x00, 0x23);
-	} else {
-		/* Go back to Virtual Wire compatibility mode */
-		unsigned long value;
+		return;
+	}
+#endif
 
-		/* For the spurious interrupt use vector F, and enable it */
-		value = apic_read(APIC_SPIV);
-		value &= ~APIC_VECTOR_MASK;
-		value |= APIC_SPIV_APIC_ENABLED;
-		value |= 0xf;
-		apic_write(APIC_SPIV, value);
+	/* Go back to Virtual Wire compatibility mode */
 
-		if (!virt_wire_setup) {
-			/*
-			 * For LVT0 make it edge triggered, active high,
-			 * external and enabled
-			 */
-			value = apic_read(APIC_LVT0);
-			value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
-				APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
-				APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
-			value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
-			value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
-			apic_write(APIC_LVT0, value);
-		} else {
-			/* Disable LVT0 */
-			apic_write(APIC_LVT0, APIC_LVT_MASKED);
-		}
+	/* For the spurious interrupt use vector F, and enable it */
+	value = apic_read(APIC_SPIV);
+	value &= ~APIC_VECTOR_MASK;
+	value |= APIC_SPIV_APIC_ENABLED;
+	value |= 0xf;
+	apic_write(APIC_SPIV, value);
 
+	if (!virt_wire_setup) {
 		/*
-		 * For LVT1 make it edge triggered, active high, nmi and
-		 * enabled
+		 * For LVT0 make it edge triggered, active high,
+		 * external and enabled
 		 */
-		value = apic_read(APIC_LVT1);
-		value &= ~(
-			APIC_MODE_MASK | APIC_SEND_PENDING |
+		value = apic_read(APIC_LVT0);
+		value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
 			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
 			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 		value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
-		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
-		apic_write(APIC_LVT1, value);
+		value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
+		apic_write(APIC_LVT0, value);
+	} else {
+		/* Disable LVT0 */
+		apic_write(APIC_LVT0, APIC_LVT_MASKED);
 	}
+
+	/*
+	 * For LVT1 make it edge triggered, active high,
+	 * nmi and enabled
+	 */
+	value = apic_read(APIC_LVT1);
+	value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
+			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
+			APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
+	value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
+	value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_NMI);
+	apic_write(APIC_LVT1, value);
 }
 
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
 	cpumask_t tmp_map;
-	physid_mask_t phys_cpu;
 
 	/*
 	 * Validate version
@@ -1471,9 +1499,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 	apic_version[apicid] = version;
 
-	phys_cpu = apicid_to_cpu_present(apicid);
-	physids_or(phys_cpu_present_map, phys_cpu_present_map, phys_cpu);
-
 	if (num_processors >= NR_CPUS) {
 		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
 			"  Processor ignored.\n", NR_CPUS);
@@ -1484,17 +1509,19 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
 
-	if (apicid == boot_cpu_physical_apicid)
+	physid_set(apicid, phys_cpu_present_map);
+	if (apicid == boot_cpu_physical_apicid) {
 		/*
 		 * x86_bios_cpu_apicid is required to have processors listed
 		 * in same order as logical cpu numbers. Hence the first
 		 * entry is BSP, and so on.
 		 */
 		cpu = 0;
-
+	}
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
 	 * but we need to work other dependencies like SMP_SUSPEND etc
@@ -1514,7 +1541,9 @@ void __cpuinit generic_processor_info(int apicid, int version)
 			def_to_bigsmp = 1;
 		}
 	}
-#ifdef CONFIG_SMP
+#endif
+
+#if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
 	/* are we being called early in kernel startup? */
 	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
 		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
@@ -1527,6 +1556,7 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 	}
 #endif
+
 	cpu_set(cpu, cpu_possible_map);
 	cpu_set(cpu, cpu_present_map);
 }
@@ -1537,6 +1567,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 #ifdef CONFIG_PM
 
 static struct {
+	/*
+	 * 'active' is true if the local APIC was enabled by us and
+	 * not the BIOS; this signifies that we are also responsible
+	 * for disabling it before entering apm/acpi suspend
+	 */
 	int active;
 	/* r/w apic fields */
 	unsigned int apic_id;
@@ -1577,7 +1612,7 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
 	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
 	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
 #endif
@@ -1601,16 +1636,23 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_save(flags);
 
-	/*
-	 * Make sure the APICBASE points to the right address
-	 *
-	 * FIXME! This will be wrong if we ever support suspend on
-	 * SMP! We'll need to do this as part of the CPU restore!
-	 */
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	l &= ~MSR_IA32_APICBASE_BASE;
-	l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-	wrmsr(MSR_IA32_APICBASE, l, h);
+#ifdef CONFIG_X86_64
+	if (x2apic)
+		enable_x2apic();
+	else
+#endif
+	{
+		/*
+		 * Make sure the APICBASE points to the right address
+		 *
+		 * FIXME! This will be wrong if we ever support suspend on
+		 * SMP! We'll need to do this as part of the CPU restore!
+		 */
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		l &= ~MSR_IA32_APICBASE_BASE;
+		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+	}
 
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
@@ -1620,7 +1662,7 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
@@ -1634,7 +1676,9 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
+
 	local_irq_restore(flags);
+
 	return 0;
 }
 
@@ -1690,20 +1734,20 @@ static int __init parse_lapic(char *arg)
 }
 early_param("lapic", parse_lapic);
 
-static int __init parse_nolapic(char *arg)
+static int __init setup_disableapic(char *arg)
 {
 	disable_apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_APIC);
 	return 0;
 }
-early_param("nolapic", parse_nolapic);
+early_param("disableapic", setup_disableapic);
 
-static int __init parse_disable_lapic_timer(char *arg)
+/* same as disableapic, for compatibility */
+static int __init setup_nolapic(char *arg)
 {
-	local_apic_timer_disabled = 1;
-	return 0;
+	return setup_disableapic(arg);
 }
-early_param("nolapic_timer", parse_disable_lapic_timer);
+early_param("nolapic", setup_nolapic);
 
 static int __init parse_lapic_timer_c2_ok(char *arg)
 {
@@ -1712,15 +1756,40 @@ static int __init parse_lapic_timer_c2_ok(char *arg)
 }
 early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
+static int __init parse_disable_apic_timer(char *arg)
+{
+	disable_apic_timer = 1;
+	return 0;
+}
+early_param("noapictimer", parse_disable_apic_timer);
+
+static int __init parse_nolapic_timer(char *arg)
+{
+	disable_apic_timer = 1;
+	return 0;
+}
+early_param("nolapic_timer", parse_nolapic_timer);
+
 static int __init apic_set_verbosity(char *arg)
 {
-	if (!arg)
+	if (!arg)  {
+#ifdef CONFIG_X86_64
+		skip_ioapic_setup = 0;
+		ioapic_force = 1;
+		return 0;
+#endif
 		return -EINVAL;
+	}
 
-	if (strcmp(arg, "debug") == 0)
+	if (strcmp("debug", arg) == 0)
 		apic_verbosity = APIC_DEBUG;
-	else if (strcmp(arg, "verbose") == 0)
+	else if (strcmp("verbose", arg) == 0)
 		apic_verbosity = APIC_VERBOSE;
+	else {
+		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
+			" use apic=verbose or apic=debug\n", arg);
+		return -EINVAL;
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 446c062..53898b6 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -27,6 +27,7 @@
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
+#include <linux/dmar.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -39,13 +40,20 @@
 #include <asm/proto.h>
 #include <asm/timex.h>
 #include <asm/apic.h>
+#include <asm/i8259.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
 
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
+int disable_x2apic;
+int x2apic;
+
+/* x2apic enabled before OS handover */
+int x2apic_preenabled;
 
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
@@ -73,6 +81,9 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 static void lapic_timer_broadcast(cpumask_t mask);
 static void apic_pm_activate(void);
 
+/*
+ * The local apic timer can be used for any function which is CPU local.
+ */
 static struct clock_event_device lapic_clockevent = {
 	.name		= "lapic",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
@@ -99,11 +110,15 @@ static inline int lapic_get_version(void)
 }
 
 /*
- * Check, if the APIC is integrated or a seperate chip
+ * Check, if the APIC is integrated or a separate chip
  */
 static inline int lapic_is_integrated(void)
 {
+#ifdef CONFIG_X86_64
 	return 1;
+#else
+	return APIC_INTEGRATED(lapic_get_version());
+#endif
 }
 
 /*
@@ -118,13 +133,18 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
-void apic_wait_icr_idle(void)
+/*
+ * Paravirt kernels also might be using these below ops. So we still
+ * use generic apic_read()/apic_write(), which might be pointing to different
+ * ops in PARAVIRT case.
+ */
+void xapic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
 		cpu_relax();
 }
 
-u32 safe_apic_wait_icr_idle(void)
+u32 safe_xapic_wait_icr_idle(void)
 {
 	u32 send_status;
 	int timeout;
@@ -140,6 +160,68 @@ u32 safe_apic_wait_icr_idle(void)
 	return send_status;
 }
 
+void xapic_icr_write(u32 low, u32 id)
+{
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write(APIC_ICR, low);
+}
+
+u64 xapic_icr_read(void)
+{
+	u32 icr1, icr2;
+
+	icr2 = apic_read(APIC_ICR2);
+	icr1 = apic_read(APIC_ICR);
+
+	return icr1 | ((u64)icr2 << 32);
+}
+
+static struct apic_ops xapic_ops = {
+	.read = native_apic_mem_read,
+	.write = native_apic_mem_write,
+	.icr_read = xapic_icr_read,
+	.icr_write = xapic_icr_write,
+	.wait_icr_idle = xapic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_xapic_wait_icr_idle,
+};
+
+struct apic_ops __read_mostly *apic_ops = &xapic_ops;
+EXPORT_SYMBOL_GPL(apic_ops);
+
+static void x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return;
+}
+
+static u32 safe_x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return 0;
+}
+
+void x2apic_icr_write(u32 low, u32 id)
+{
+	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
+}
+
+u64 x2apic_icr_read(void)
+{
+	unsigned long val;
+
+	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+	return val;
+}
+
+static struct apic_ops x2apic_ops = {
+	.read = native_apic_msr_read,
+	.write = native_apic_msr_write,
+	.icr_read = x2apic_icr_read,
+	.icr_write = x2apic_icr_write,
+	.wait_icr_idle = x2apic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
+};
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
@@ -149,6 +231,11 @@ void __cpuinit enable_NMI_through_LVT0(void)
 
 	/* unmask and set to NMI */
 	v = APIC_DM_NMI;
+
+	/* Level triggered for 82489DX (32bit mode) */
+	if (!lapic_is_integrated())
+		v |= APIC_LVT_LEVEL_TRIGGER;
+
 	apic_write(APIC_LVT0, v);
 }
 
@@ -157,14 +244,28 @@ void __cpuinit enable_NMI_through_LVT0(void)
  */
 int lapic_get_maxlvt(void)
 {
-	unsigned int v, maxlvt;
+	unsigned int v;
 
 	v = apic_read(APIC_LVR);
-	maxlvt = GET_APIC_MAXLVT(v);
-	return maxlvt;
+	/*
+	 * - we always have APIC integrated on 64bit mode
+	 * - 82489DXs do not report # of LVT entries
+	 */
+	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
 }
 
 /*
+ * Local APIC timer
+ */
+
+/* Clock divisor */
+#ifdef CONFG_X86_64
+#define APIC_DIVISOR 1
+#else
+#define APIC_DIVISOR 16
+#endif
+
+/*
  * This function sets up the local APIC timer, with a timeout of
  * 'clocks' APIC bus clock. During calibration we actually call
  * this function twice on the boot CPU, once with a bogus timeout
@@ -174,7 +275,6 @@ int lapic_get_maxlvt(void)
  * We do reads before writes even if unnecessary, to get around the
  * P5 APIC double write bug.
  */
-
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
@@ -182,6 +282,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	lvtt_value = LOCAL_TIMER_VECTOR;
 	if (!oneshot)
 		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+	if (!lapic_is_integrated())
+		lvtt_value |= SET_APIC_TIMER_BASE(APIC_TIMER_BASE_DIV);
+
 	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
@@ -191,12 +294,12 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	 * Divide PICLK by 16
 	 */
 	tmp_value = apic_read(APIC_TDCR);
-	apic_write(APIC_TDCR, (tmp_value
-				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
-				| APIC_TDR_DIV_16);
+	apic_write(APIC_TDCR,
+		(tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
+		APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write(APIC_TMICT, clocks);
+		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
 }
 
 /*
@@ -366,7 +469,7 @@ static int __init calibrate_APIC_clock(void)
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-	calibration_result = result / HZ;
+	calibration_result = (result * APIC_DIVISOR) / HZ;
 
 	/*
 	 * Do a sanity check on the APIC calibration result
@@ -388,10 +491,10 @@ static int __init calibrate_APIC_clock(void)
 void __init setup_boot_APIC_clock(void)
 {
 	/*
-	 * The local apic timer can be disabled via the kernel commandline.
-	 * Register the lapic timer as a dummy clock event source on SMP
-	 * systems, so the broadcast mechanism is used. On UP systems simply
-	 * ignore it.
+	 * The local apic timer can be disabled via the kernel
+	 * commandline or from the CPU detection code. Register the lapic
+	 * timer as a dummy clock event source on SMP systems, so the
+	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
 	if (disable_apic_timer) {
 		printk(KERN_INFO "Disabling APIC timer\n");
@@ -403,7 +506,9 @@ void __init setup_boot_APIC_clock(void)
 		return;
 	}
 
-	printk(KERN_INFO "Using local APIC timer interrupts.\n");
+	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
+		    "calibrating APIC timer ...\n");
+
 	if (calibrate_APIC_clock()) {
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1)
@@ -422,6 +527,7 @@ void __init setup_boot_APIC_clock(void)
 		printk(KERN_WARNING "APIC timer registered as dummy,"
 			" due to nmi_watchdog=%d!\n", nmi_watchdog);
 
+	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
 }
 
@@ -460,7 +566,11 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
+#ifdef CONFIG_X86_64
 	add_pda(apic_timer_irqs, 1);
+#else
+	per_cpu(irq_stat, cpu).apic_timer_irqs++;
+#endif
 
 	evt->event_handler(evt);
 }
@@ -491,6 +601,7 @@ void smp_apic_timer_interrupt(struct pt_regs *regs)
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
+
 	set_irq_regs(old_regs);
 }
 
@@ -544,6 +655,13 @@ void clear_local_APIC(void)
 		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);
 	}
 
+	/* lets not touch this if we didn't frob it */
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
+	if (maxlvt >= 5) {
+		v = apic_read(APIC_LVTTHMR);
+		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
+	}
+#endif
 	/*
 	 * Clean APIC state for other OSs:
 	 */
@@ -554,8 +672,14 @@ void clear_local_APIC(void)
 		apic_write(APIC_LVTERR, APIC_LVT_MASKED);
 	if (maxlvt >= 4)
 		apic_write(APIC_LVTPC, APIC_LVT_MASKED);
-	apic_write(APIC_ESR, 0);
-	apic_read(APIC_ESR);
+
+	/* Integrated APIC (!82489DX) ? */
+	if (lapic_is_integrated()) {
+		if (maxlvt > 3)
+			/* Clear ESR due to Pentium errata 3AP and 11AP */
+			apic_write(APIC_ESR, 0);
+		apic_read(APIC_ESR);
+	}
 }
 
 /**
@@ -574,8 +698,28 @@ void disable_local_APIC(void)
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_SPIV_APIC_ENABLED;
 	apic_write(APIC_SPIV, value);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * When LAPIC was disabled by the BIOS and enabled by the kernel,
+	 * restore the disabled state.
+	 */
+	if (enabled_via_apicbase) {
+		unsigned int l, h;
+
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		l &= ~MSR_IA32_APICBASE_ENABLE;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+	}
+#endif
 }
 
+/*
+ * If Linux enabled the LAPIC against the BIOS default disable it down before
+ * re-entering the BIOS on shutdown.  Otherwise the BIOS may get confused and
+ * not power-off.  Additionally clear all LVT entries before disable_local_APIC
+ * for the case where Linux didn't enable the LAPIC.
+ */
 void lapic_shutdown(void)
 {
 	unsigned long flags;
@@ -585,7 +729,13 @@ void lapic_shutdown(void)
 
 	local_irq_save(flags);
 
-	disable_local_APIC();
+#ifdef CONFIG_X86_32
+	if (!enabled_via_apicbase)
+		clear_local_APIC();
+	else
+#endif
+		disable_local_APIC();
+
 
 	local_irq_restore(flags);
 }
@@ -629,10 +779,10 @@ int __init verify_local_APIC(void)
 	/*
 	 * The ID register is read/write in a real APIC.
 	 */
-	reg0 = read_apic_id();
+	reg0 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
 	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
-	reg1 = read_apic_id();
+	reg1 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
 	apic_write(APIC_ID, reg0);
 	if (reg1 != (reg0 ^ APIC_ID_MASK))
@@ -656,8 +806,11 @@ int __init verify_local_APIC(void)
  */
 void __init sync_Arb_IDs(void)
 {
-	/* Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 */
-	if (modern_apic())
+	/*
+	 * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
+	 * needed on AMD.
+	 */
+	if (modern_apic() || boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
 		return;
 
 	/*
@@ -666,8 +819,8 @@ void __init sync_Arb_IDs(void)
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
-				| APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_DEST_ALLINC |
+			APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*
@@ -684,8 +837,6 @@ void __init init_bsp_APIC(void)
 	if (smp_found_config || !cpu_has_apic)
 		return;
 
-	value = apic_read(APIC_LVR);
-
 	/*
 	 * Do not trust the local APIC being empty at bootup.
 	 */
@@ -697,7 +848,15 @@ void __init init_bsp_APIC(void)
 	value = apic_read(APIC_SPIV);
 	value &= ~APIC_VECTOR_MASK;
 	value |= APIC_SPIV_APIC_ENABLED;
-	value |= APIC_SPIV_FOCUS_DISABLED;
+
+#ifdef CONFIG_X86_32
+	/* This bit is reserved on P4/Xeon and should be cleared */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
+	    (boot_cpu_data.x86 == 15))
+		value &= ~APIC_SPIV_FOCUS_DISABLED;
+	else
+#endif
+		value |= APIC_SPIV_FOCUS_DISABLED;
 	value |= SPURIOUS_APIC_VECTOR;
 	apic_write(APIC_SPIV, value);
 
@@ -706,9 +865,50 @@ void __init init_bsp_APIC(void)
 	 */
 	apic_write(APIC_LVT0, APIC_DM_EXTINT);
 	value = APIC_DM_NMI;
+	if (!lapic_is_integrated())		/* 82489DX */
+		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write(APIC_LVT1, value);
 }
 
+static void __cpuinit lapic_setup_esr(void)
+{
+	unsigned long oldvalue, value, maxlvt;
+	if (lapic_is_integrated() && !esr_disable) {
+		if (esr_disable) {
+			/*
+			 * Something untraceable is creating bad interrupts on
+			 * secondary quads ... for the moment, just leave the
+			 * ESR disabled - we can't do anything useful with the
+			 * errors anyway - mbligh
+			 */
+			printk(KERN_INFO "Leaving ESR disabled.\n");
+			return;
+		}
+		/* !82489DX */
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
+			apic_write(APIC_ESR, 0);
+		oldvalue = apic_read(APIC_ESR);
+
+		/* enables sending errors */
+		value = ERROR_APIC_VECTOR;
+		apic_write(APIC_LVTERR, value);
+		/*
+		 * spec says clear errors after enabling vector.
+		 */
+		if (maxlvt > 3)
+			apic_write(APIC_ESR, 0);
+		value = apic_read(APIC_ESR);
+		if (value != oldvalue)
+			apic_printk(APIC_VERBOSE, "ESR value before enabling "
+				"vector: 0x%08lx  after: 0x%08lx\n",
+				oldvalue, value);
+	} else {
+		printk(KERN_INFO "No ESR for 82489DX.\n");
+	}
+}
+
+
 /**
  * setup_local_APIC - setup the local APIC
  */
@@ -814,25 +1014,143 @@ void __cpuinit setup_local_APIC(void)
 	preempt_enable();
 }
 
-static void __cpuinit lapic_setup_esr(void)
-{
-	unsigned maxlvt = lapic_get_maxlvt();
-
-	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR);
-	/*
-	 * spec says clear errors after enabling vector.
-	 */
-	if (maxlvt > 3)
-		apic_write(APIC_ESR, 0);
-}
-
 void __cpuinit end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
+
+#ifdef CONFIG_X86_32
+	{
+		unsigned int value;
+		/* Disable the local apic timer */
+		value = apic_read(APIC_LVTT);
+		value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, value);
+	}
+#endif
+
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
 
+void check_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+
+	if (msr & X2APIC_ENABLE) {
+		printk("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_preenabled = x2apic = 1;
+		apic_ops = &x2apic_ops;
+	}
+}
+
+void enable_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (!(msr & X2APIC_ENABLE)) {
+		printk("Enabling x2apic\n");
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+	}
+}
+
+void enable_IR_x2apic(void)
+{
+#ifdef CONFIG_INTR_REMAP
+	int ret;
+	unsigned long flags;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	if (!x2apic_preenabled && disable_x2apic) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of nox2apic\n");
+		return;
+	}
+
+	if (x2apic_preenabled && disable_x2apic)
+		panic("Bios already enabled x2apic, can't enforce nox2apic");
+
+	if (!x2apic_preenabled && skip_ioapic_setup) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of skipping io-apic setup\n");
+		return;
+	}
+
+	ret = dmar_table_init();
+	if (ret) {
+		printk(KERN_INFO
+		       "dmar_table_init() failed with %d:\n", ret);
+
+		if (x2apic_preenabled)
+			panic("x2apic enabled by bios. But IR enabling failed");
+		else
+			printk(KERN_INFO
+			       "Not enabling x2apic,Intr-remapping\n");
+		return;
+	}
+
+	local_irq_save(flags);
+	mask_8259A();
+	save_mask_IO_APIC_setup();
+
+	ret = enable_intr_remapping(1);
+
+	if (ret && x2apic_preenabled) {
+		local_irq_restore(flags);
+		panic("x2apic enabled by bios. But IR enabling failed");
+	}
+
+	if (ret)
+		goto end;
+
+	if (!x2apic) {
+		x2apic = 1;
+		apic_ops = &x2apic_ops;
+		enable_x2apic();
+	}
+end:
+	if (ret)
+		/*
+		 * IR enabling failed
+		 */
+		restore_IO_APIC_setup();
+	else
+		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
+
+	unmask_8259A();
+	local_irq_restore(flags);
+
+	if (!ret) {
+		if (!x2apic_preenabled)
+			printk(KERN_INFO
+			       "Enabled x2apic and interrupt-remapping\n");
+		else
+			printk(KERN_INFO
+			       "Enabled Interrupt-remapping\n");
+	} else
+		printk(KERN_ERR
+		       "Failed to enable Interrupt-remapping and x2apic\n");
+#else
+	if (!cpu_has_x2apic)
+		return;
+
+	if (x2apic_preenabled)
+		panic("x2apic enabled prior OS handover,"
+		      " enable CONFIG_INTR_REMAP");
+
+	printk(KERN_INFO "Enable CONFIG_INTR_REMAP for enabling intr-remapping "
+	       " and x2apic\n");
+#endif
+
+	return;
+}
+
 /*
  * Detect and enable local APICs on non-SMP boards.
  * Original code written by Keir Fraser.
@@ -872,7 +1190,7 @@ void __init early_init_lapic_mapping(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 }
 
 /**
@@ -880,6 +1198,11 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
+	if (x2apic) {
+		boot_cpu_physical_apicid = read_apic_id();
+		return;
+	}
+
 	/*
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
@@ -899,13 +1222,15 @@ void __init init_apic_mappings(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 }
 
 /*
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
+int apic_version[MAX_APICS];
+
 int __init APIC_init_uniprocessor(void)
 {
 	if (disable_apic) {
@@ -918,6 +1243,9 @@ int __init APIC_init_uniprocessor(void)
 		return -1;
 	}
 
+	enable_IR_x2apic();
+	setup_apic_routing();
+
 	verify_local_APIC();
 
 	connect_bsp_APIC();
@@ -1004,17 +1332,57 @@ asmlinkage void smp_error_interrupt(void)
 }
 
 /**
- *  * connect_bsp_APIC - attach the APIC to the interrupt system
- *   */
+ * connect_bsp_APIC - attach the APIC to the interrupt system
+ */
 void __init connect_bsp_APIC(void)
 {
+#ifdef CONFIG_X86_32
+	if (pic_mode) {
+		/*
+		 * Do not trust the local APIC being empty at bootup.
+		 */
+		clear_local_APIC();
+		/*
+		 * PIC mode, enable APIC mode in the IMCR, i.e.  connect BSP's
+		 * local APIC to INT and NMI lines.
+		 */
+		apic_printk(APIC_VERBOSE, "leaving PIC mode, "
+				"enabling APIC mode.\n");
+		outb(0x70, 0x22);
+		outb(0x01, 0x23);
+	}
+#endif
 	enable_apic_mode();
 }
 
+/**
+ * disconnect_bsp_APIC - detach the APIC from the interrupt system
+ * @virt_wire_setup:	indicates, whether virtual wire mode is selected
+ *
+ * Virtual wire mode is necessary to deliver legacy interrupts even when the
+ * APIC is disabled.
+ */
 void disconnect_bsp_APIC(int virt_wire_setup)
 {
+	unsigned int value;
+
+#ifdef CONFIG_X86_32
+	if (pic_mode) {
+		/*
+		 * Put the board back into PIC mode (has an effect only on
+		 * certain older boards).  Note that APIC interrupts, including
+		 * IPIs, won't work beyond this point!  The only exception are
+		 * INIT IPIs.
+		 */
+		apic_printk(APIC_VERBOSE, "disabling APIC mode, "
+				"entering PIC mode.\n");
+		outb(0x70, 0x22);
+		outb(0x00, 0x23);
+		return;
+	}
+#endif
+
 	/* Go back to Virtual Wire compatibility mode */
-	unsigned long value;
 
 	/* For the spurious interrupt use vector F, and enable it */
 	value = apic_read(APIC_SPIV);
@@ -1040,7 +1408,10 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 		apic_write(APIC_LVT0, APIC_LVT_MASKED);
 	}
 
-	/* For LVT1 make it edge triggered, active high, nmi and enabled */
+	/*
+	 * For LVT1 make it edge triggered, active high,
+	 * nmi and enabled
+	 */
 	value = apic_read(APIC_LVT1);
 	value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
 			APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
@@ -1055,9 +1426,20 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	int cpu;
 	cpumask_t tmp_map;
 
+	/*
+	 * Validate version
+	 */
+	if (version == 0x0) {
+		printk(KERN_WARNING "BIOS bug, APIC version is 0 for CPU#%d! "
+				"fixing up to 0x10. (tell your hw vendor)\n",
+				version);
+		version = 0x10;
+	}
+	apic_version[apicid] = version;
+
 	if (num_processors >= NR_CPUS) {
 		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
-		       " Processor ignored.\n", NR_CPUS);
+			"  Processor ignored.\n", NR_CPUS);
 		return;
 	}
 
@@ -1077,6 +1459,29 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
+#ifdef CONFIG_X86_32
+	/*
+	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
+	 * but we need to work other dependencies like SMP_SUSPEND etc
+	 * before this can be done without some confusion.
+	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
+	 *       - Ashok Raj <ashok.raj@intel.com>
+	 */
+	if (max_physical_apicid >= 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+#endif
+
+#if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
 	/* are we being called early in kernel startup? */
 	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
 		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
@@ -1088,20 +1493,28 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 	}
+#endif
 
 	cpu_set(cpu, cpu_possible_map);
 	cpu_set(cpu, cpu_present_map);
 }
 
+int hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+
 /*
  * Power management
  */
 #ifdef CONFIG_PM
 
 static struct {
-	/* 'active' is true if the local APIC was enabled by us and
-	   not the BIOS; this signifies that we are also responsible
-	   for disabling it before entering apm/acpi suspend */
+	/*
+	 * 'active' is true if the local APIC was enabled by us and
+	 * not the BIOS; this signifies that we are also responsible
+	 * for disabling it before entering apm/acpi suspend
+	 */
 	int active;
 	/* r/w apic fields */
 	unsigned int apic_id;
@@ -1129,7 +1542,7 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 
 	maxlvt = lapic_get_maxlvt();
 
-	apic_pm_state.apic_id = read_apic_id();
+	apic_pm_state.apic_id = apic_read(APIC_ID);
 	apic_pm_state.apic_taskpri = apic_read(APIC_TASKPRI);
 	apic_pm_state.apic_ldr = apic_read(APIC_LDR);
 	apic_pm_state.apic_dfr = apic_read(APIC_DFR);
@@ -1142,10 +1555,11 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
 	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
 	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#ifdef CONFIG_X86_MCE_INTEL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
 #endif
+
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
@@ -1164,10 +1578,25 @@ static int lapic_resume(struct sys_device *dev)
 	maxlvt = lapic_get_maxlvt();
 
 	local_irq_save(flags);
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	l &= ~MSR_IA32_APICBASE_BASE;
-	l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-	wrmsr(MSR_IA32_APICBASE, l, h);
+
+#ifdef CONFIG_X86_64
+	if (x2apic)
+		enable_x2apic();
+	else
+#endif
+	{
+		/*
+		 * Make sure the APICBASE points to the right address
+		 *
+		 * FIXME! This will be wrong if we ever support suspend on
+		 * SMP! We'll need to do this as part of the CPU restore!
+		 */
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		l &= ~MSR_IA32_APICBASE_BASE;
+		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+	}
+
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
 	apic_write(APIC_DFR, apic_pm_state.apic_dfr);
@@ -1176,7 +1605,7 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#ifdef CONFIG_X86_MCE_INTEL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
@@ -1190,10 +1619,17 @@ static int lapic_resume(struct sys_device *dev)
 	apic_write(APIC_LVTERR, apic_pm_state.apic_lvterr);
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
+
 	local_irq_restore(flags);
+
 	return 0;
 }
 
+/*
+ * This device has no shutdown method - fully functioning local APICs
+ * are needed on every CPU up until machine_halt/restart/poweroff.
+ */
+
 static struct sysdev_class lapic_sysclass = {
 	.name		= "lapic",
 	.resume		= lapic_resume,
@@ -1307,31 +1743,19 @@ __cpuinit int apic_is_clustered_box(void)
 	return (clusters > 2);
 }
 
-/*
- * APIC command line parameters
- */
-static int __init apic_set_verbosity(char *str)
+static __init int setup_nox2apic(char *str)
 {
-	if (str == NULL)  {
-		skip_ioapic_setup = 0;
-		ioapic_force = 1;
-		return 0;
-	}
-	if (strcmp("debug", str) == 0)
-		apic_verbosity = APIC_DEBUG;
-	else if (strcmp("verbose", str) == 0)
-		apic_verbosity = APIC_VERBOSE;
-	else {
-		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
-				" use apic=verbose or apic=debug\n", str);
-		return -EINVAL;
-	}
-
+	disable_x2apic = 1;
+	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_X2APIC);
 	return 0;
 }
-early_param("apic", apic_set_verbosity);
+early_param("nox2apic", setup_nox2apic);
+
 
-static __init int setup_disableapic(char *str)
+/*
+ * APIC command line parameters
+ */
+static int __init setup_disableapic(char *arg)
 {
 	disable_apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_APIC);
@@ -1340,9 +1764,9 @@ static __init int setup_disableapic(char *str)
 early_param("disableapic", setup_disableapic);
 
 /* same as disableapic, for compatibility */
-static __init int setup_nolapic(char *str)
+static int __init setup_nolapic(char *arg)
 {
-	return setup_disableapic(str);
+	return setup_disableapic(arg);
 }
 early_param("nolapic", setup_nolapic);
 
@@ -1353,14 +1777,19 @@ static int __init parse_lapic_timer_c2_ok(char *arg)
 }
 early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
-static __init int setup_noapictimer(char *str)
+static int __init parse_disable_apic_timer(char *arg)
 {
-	if (str[0] != ' ' && str[0] != 0)
-		return 0;
 	disable_apic_timer = 1;
-	return 1;
+	return 0;
 }
-__setup("noapictimer", setup_noapictimer);
+early_param("noapictimer", parse_disable_apic_timer);
+
+static int __init parse_nolapic_timer(char *arg)
+{
+	disable_apic_timer = 1;
+	return 0;
+}
+early_param("nolapic_timer", parse_nolapic_timer);
 
 static __init int setup_apicpmtimer(char *s)
 {
@@ -1370,6 +1799,31 @@ static __init int setup_apicpmtimer(char *s)
 }
 __setup("apicpmtimer", setup_apicpmtimer);
 
+static int __init apic_set_verbosity(char *arg)
+{
+	if (!arg)  {
+#ifdef CONFIG_X86_64
+		skip_ioapic_setup = 0;
+		ioapic_force = 1;
+		return 0;
+#endif
+		return -EINVAL;
+	}
+
+	if (strcmp("debug", arg) == 0)
+		apic_verbosity = APIC_DEBUG;
+	else if (strcmp("verbose", arg) == 0)
+		apic_verbosity = APIC_VERBOSE;
+	else {
+		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
+			" use apic=verbose or apic=debug\n", arg);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+early_param("apic", apic_set_verbosity);
+
 static int __init lapic_insert_resource(void)
 {
 	if (!apic_phys)
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ee76eaa..7f0b45a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -3,22 +3,30 @@
 #
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= proc.o feature_names.o
-
-obj-$(CONFIG_X86_32)	+= common.o bugs.o
-obj-$(CONFIG_X86_64)	+= common_64.o bugs_64.o
-obj-$(CONFIG_X86_32)	+= amd.o
-obj-$(CONFIG_X86_64)	+= amd_64.o
-obj-$(CONFIG_X86_32)	+= cyrix.o
-obj-$(CONFIG_X86_32)	+= centaur.o
-obj-$(CONFIG_X86_64)	+= centaur_64.o
-obj-$(CONFIG_X86_32)	+= transmeta.o
-obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_64)	+= intel_64.o
-obj-$(CONFIG_X86_32)	+= umc.o
+obj-y			+= proc.o capflags.o powerflags.o common.o
+
+obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
+obj-$(CONFIG_X86_64)	+= bugs_64.o
+
+obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
+obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_32)	+= centaur.o
+obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
+obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
+obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
 obj-$(CONFIG_MTRR)	+= mtrr/
 obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
 
 obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+
+quiet_cmd_mkcapflags = MKCAP   $@
+      cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
+
+cpufeature = $(src)/../../../../include/asm-x86/cpufeature.h
+
+targets += capflags.c
+$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.pl FORCE
+	$(call if_changed,mkcapflags)
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index a6ef672..0d9c993 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -7,6 +7,8 @@
 #include <asm/pat.h>
 #include <asm/processor.h>
 
+#include <mach_apic.h>
+
 struct cpuid_bit {
 	u16 feature;
 	u8 reg;
@@ -48,6 +50,92 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	}
 }
 
+/* leaf 0xb SMT level */
+#define SMT_LEVEL	0
+
+/* leaf 0xb sub-leaf types */
+#define INVALID_TYPE	0
+#define SMT_TYPE	1
+#define CORE_TYPE	2
+
+#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
+#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
+#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
+
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned int eax, ebx, ecx, edx, sub_index;
+	unsigned int ht_mask_width, core_plus_mask_width;
+	unsigned int core_select_mask, core_level_siblings;
+
+	if (c->cpuid_level < 0xb)
+		return;
+
+	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
+
+	/*
+	 * check if the cpuid leaf 0xb is actually implemented.
+	 */
+	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
+
+	/*
+	 * initial apic id, which also represents 32-bit extended x2apic id.
+	 */
+	c->initial_apicid = edx;
+
+	/*
+	 * Populate HT related information from sub-leaf level 0.
+	 */
+	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
+	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+
+	sub_index = 1;
+	do {
+		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * Check for the Core type in the implemented sub leaves.
+		 */
+		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
+			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
+			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+			break;
+		}
+
+		sub_index++;
+	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+
+	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+
+#ifdef CONFIG_X86_32
+	c->cpu_core_id = phys_pkg_id(c->initial_apicid, ht_mask_width)
+						 & core_select_mask;
+	c->phys_proc_id = phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+#else
+	c->cpu_core_id = phys_pkg_id(ht_mask_width) & core_select_mask;
+	c->phys_proc_id = phys_pkg_id(core_plus_mask_width);
+#endif
+	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
+
+
+	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+	       c->phys_proc_id);
+	if (c->x86_max_cores > 1)
+		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+		       c->cpu_core_id);
+	return;
+#endif
+}
+
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 18514ed..32e7352 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,13 +1,22 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/mm.h>
+
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
 
+#ifdef CONFIG_X86_64
+# include <asm/numa_64.h>
+# include <asm/mmconfig.h>
+# include <asm/cacheflush.h>
+#endif
+
 #include <mach_apic.h>
+
 #include "cpu.h"
 
+#ifdef CONFIG_X86_32
 /*
  *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
  *	misexecution of code under Linux. Owners of such processors should
@@ -24,26 +33,273 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
 {
-	if (cpuid_eax(0x80000000) >= 0x80000007) {
-		c->x86_power = cpuid_edx(0x80000007);
-		if (c->x86_power & (1<<8))
-			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+/*
+ * General Systems BIOSen alias the cpu frequency registers
+ * of the Elan at 0x000df000. Unfortuantly, one of the Linux
+ * drivers subsequently pokes it, and changes the CPU speed.
+ * Workaround : Remove the unneeded alias.
+ */
+#define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
+#define CBAR_ENB	(0x80000000)
+#define CBAR_KEY	(0X000000CB)
+	if (c->x86_model == 9 || c->x86_model == 10) {
+		if (inl (CBAR) & CBAR_ENB)
+			outl (0 | CBAR_KEY, CBAR);
 	}
-
-	/*  Set MTRR capability flag if appropriate */
-	if (c->x86_model == 13 || c->x86_model == 9 ||
-	   (c->x86_model == 8 && c->x86_mask >= 8))
-		set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 }
 
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
+
+static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int mbytes = num_physpages >> (20-PAGE_SHIFT);
-	int r;
 
+	if (c->x86_model < 6) {
+		/* Based on AMD doc 20734R - June 2000 */
+		if (c->x86_model == 0) {
+			clear_cpu_cap(c, X86_FEATURE_APIC);
+			set_cpu_cap(c, X86_FEATURE_PGE);
+		}
+		return;
+	}
+
+	if (c->x86_model == 6 && c->x86_mask == 1) {
+		const int K6_BUG_LOOP = 1000000;
+		int n;
+		void (*f_vide)(void);
+		unsigned long d, d2;
+
+		printk(KERN_INFO "AMD K6 stepping B detected - ");
+
+		/*
+		 * It looks like AMD fixed the 2.6.2 bug and improved indirect
+		 * calls at the same time.
+		 */
+
+		n = K6_BUG_LOOP;
+		f_vide = vide;
+		rdtscl(d);
+		while (n--)
+			f_vide();
+		rdtscl(d2);
+		d = d2-d;
+
+		if (d > 20*K6_BUG_LOOP)
+			printk("system stability may be impaired when more than 32 MB are used.\n");
+		else
+			printk("probably OK (after B9730xxxx).\n");
+		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
+	}
+
+	/* K6 with old style WHCR */
+	if (c->x86_model < 8 ||
+	   (c->x86_model == 8 && c->x86_mask < 8)) {
+		/* We can only write allocate on the low 508Mb */
+		if (mbytes > 508)
+			mbytes = 508;
+
+		rdmsr(MSR_K6_WHCR, l, h);
+		if ((l&0x0000FFFF) == 0) {
+			unsigned long flags;
+			l = (1<<0)|((mbytes/4)<<1);
+			local_irq_save(flags);
+			wbinvd();
+			wrmsr(MSR_K6_WHCR, l, h);
+			local_irq_restore(flags);
+			printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
+				mbytes);
+		}
+		return;
+	}
+
+	if ((c->x86_model == 8 && c->x86_mask > 7) ||
+	     c->x86_model == 9 || c->x86_model == 13) {
+		/* The more serious chips .. */
+
+		if (mbytes > 4092)
+			mbytes = 4092;
+
+		rdmsr(MSR_K6_WHCR, l, h);
+		if ((l&0xFFFF0000) == 0) {
+			unsigned long flags;
+			l = ((mbytes>>2)<<22)|(1<<16);
+			local_irq_save(flags);
+			wbinvd();
+			wrmsr(MSR_K6_WHCR, l, h);
+			local_irq_restore(flags);
+			printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
+				mbytes);
+		}
+
+		return;
+	}
+
+	if (c->x86_model == 10) {
+		/* AMD Geode LX is model 10 */
+		/* placeholder for any needed mods */
+		return;
+	}
+}
+
+static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
+{
+	u32 l, h;
+
+	/*
+	 * Bit 15 of Athlon specific MSR 15, needs to be 0
+	 * to enable SSE on Palomino/Morgan/Barton CPU's.
+	 * If the BIOS didn't enable it already, enable it here.
+	 */
+	if (c->x86_model >= 6 && c->x86_model <= 10) {
+		if (!cpu_has(c, X86_FEATURE_XMM)) {
+			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
+			rdmsr(MSR_K7_HWCR, l, h);
+			l &= ~0x00008000;
+			wrmsr(MSR_K7_HWCR, l, h);
+			set_cpu_cap(c, X86_FEATURE_XMM);
+		}
+	}
+
+	/*
+	 * It's been determined by AMD that Athlons since model 8 stepping 1
+	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
+	 * As per AMD technical note 27212 0.2
+	 */
+	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
+		rdmsr(MSR_K7_CLK_CTL, l, h);
+		if ((l & 0xfff00000) != 0x20000000) {
+			printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
+				((l & 0x000fffff)|0x20000000));
+			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
+		}
+	}
+
+	set_cpu_cap(c, X86_FEATURE_K7);
+}
+#endif
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+static int __cpuinit nearby_node(int apicid)
+{
+	int i, node;
+
+	for (i = apicid - 1; i >= 0; i--) {
+		node = apicid_to_node[i];
+		if (node != NUMA_NO_NODE && node_online(node))
+			return node;
+	}
+	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
+		node = apicid_to_node[i];
+		if (node != NUMA_NO_NODE && node_online(node))
+			return node;
+	}
+	return first_node(node_online_map); /* Shouldn't happen */
+}
+#endif
+
+/*
+ * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
+ * Assumes number of cores is a power of two.
+ */
+static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_HT
+	unsigned bits;
+
+	bits = c->x86_coreid_bits;
+
+	/* Low order bits define the core id (index of core in socket) */
+	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
+	/* Convert the initial APIC ID into the socket ID */
+	c->phys_proc_id = c->initial_apicid >> bits;
+#endif
+}
+
+static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+{
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	int cpu = smp_processor_id();
+	int node;
+	unsigned apicid = hard_smp_processor_id();
+
+	node = c->phys_proc_id;
+	if (apicid_to_node[apicid] != NUMA_NO_NODE)
+		node = apicid_to_node[apicid];
+	if (!node_online(node)) {
+		/* Two possibilities here:
+		   - The CPU is missing memory and no node was created.
+		   In that case try picking one from a nearby CPU
+		   - The APIC IDs differ from the HyperTransport node IDs
+		   which the K8 northbridge parsing fills in.
+		   Assume they are all increased by a constant offset,
+		   but in the same order as the HT nodeids.
+		   If that doesn't result in a usable node fall back to the
+		   path for the previous case.  */
+
+		int ht_nodeid = c->initial_apicid;
+
+		if (ht_nodeid >= 0 &&
+		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
+			node = apicid_to_node[ht_nodeid];
+		/* Pick a nearby node */
+		if (!node_online(node))
+			node = nearby_node(apicid);
+	}
+	numa_set_node(cpu, node);
+
+	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+}
+
+static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_HT
+	unsigned bits, ecx;
+
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level < 0x80000008)
+		return;
+
+	ecx = cpuid_ecx(0x80000008);
+
+	c->x86_max_cores = (ecx & 0xff) + 1;
+
+	/* CPU telling us the core id bits shift? */
+	bits = (ecx >> 12) & 0xF;
+
+	/* Otherwise recompute */
+	if (bits == 0) {
+		while ((1 << bits) < c->x86_max_cores)
+			bits++;
+	}
+
+	c->x86_coreid_bits = bits;
+#endif
+}
+
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+	early_init_amd_mc(c);
+
+	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
+	if (c->x86_power & (1<<8))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
+#else
+	/*  Set MTRR capability flag if appropriate */
+	if (c->x86 == 5)
+		if (c->x86_model == 13 || c->x86_model == 9 ||
+		    (c->x86_model == 8 && c->x86_mask >= 8))
+			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
+#endif
+}
+
+static void __cpuinit init_amd(struct cpuinfo_x86 *c)
+{
 #ifdef CONFIG_SMP
 	unsigned long long value;
 
@@ -54,7 +310,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	 * Errata 63 for SH-B3 steppings
 	 * Errata 122 for all steppings (F+ have it disabled by default)
 	 */
-	if (c->x86 == 15) {
+	if (c->x86 == 0xf) {
 		rdmsrl(MSR_K7_HWCR, value);
 		value |= 1 << 6;
 		wrmsrl(MSR_K7_HWCR, value);
@@ -64,209 +320,119 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	early_init_amd(c);
 
 	/*
-	 *	FIXME: We should handle the K5 here. Set up the write
-	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
-	 *	no bus pipeline)
-	 */
-
-	/*
 	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
 	 */
 	clear_cpu_cap(c, 0*32+31);
 
-	r = get_model_name(c);
+#ifdef CONFIG_X86_64
+	/* On C+ stepping K8 rep microcode works well for copy/memset */
+	if (c->x86 == 0xf) {
+		u32 level;
 
-	switch (c->x86) {
-	case 4:
-		/*
-		 * General Systems BIOSen alias the cpu frequency registers
-		 * of the Elan at 0x000df000. Unfortuantly, one of the Linux
-		 * drivers subsequently pokes it, and changes the CPU speed.
-		 * Workaround : Remove the unneeded alias.
-		 */
-#define CBAR		(0xfffc) /* Configuration Base Address  (32-bit) */
-#define CBAR_ENB	(0x80000000)
-#define CBAR_KEY	(0X000000CB)
-			if (c->x86_model == 9 || c->x86_model == 10) {
-				if (inl (CBAR) & CBAR_ENB)
-					outl (0 | CBAR_KEY, CBAR);
-			}
-			break;
-	case 5:
-			if (c->x86_model < 6) {
-				/* Based on AMD doc 20734R - June 2000 */
-				if (c->x86_model == 0) {
-					clear_cpu_cap(c, X86_FEATURE_APIC);
-					set_cpu_cap(c, X86_FEATURE_PGE);
-				}
-				break;
-			}
-
-			if (c->x86_model == 6 && c->x86_mask == 1) {
-				const int K6_BUG_LOOP = 1000000;
-				int n;
-				void (*f_vide)(void);
-				unsigned long d, d2;
-
-				printk(KERN_INFO "AMD K6 stepping B detected - ");
-
-				/*
-				 * It looks like AMD fixed the 2.6.2 bug and improved indirect
-				 * calls at the same time.
-				 */
-
-				n = K6_BUG_LOOP;
-				f_vide = vide;
-				rdtscl(d);
-				while (n--)
-					f_vide();
-				rdtscl(d2);
-				d = d2-d;
-
-				if (d > 20*K6_BUG_LOOP)
-					printk("system stability may be impaired when more than 32 MB are used.\n");
-				else
-					printk("probably OK (after B9730xxxx).\n");
-				printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
-			}
-
-			/* K6 with old style WHCR */
-			if (c->x86_model < 8 ||
-			   (c->x86_model == 8 && c->x86_mask < 8)) {
-				/* We can only write allocate on the low 508Mb */
-				if (mbytes > 508)
-					mbytes = 508;
-
-				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0x0000FFFF) == 0) {
-					unsigned long flags;
-					l = (1<<0)|((mbytes/4)<<1);
-					local_irq_save(flags);
-					wbinvd();
-					wrmsr(MSR_K6_WHCR, l, h);
-					local_irq_restore(flags);
-					printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
-						mbytes);
-				}
-				break;
-			}
-
-			if ((c->x86_model == 8 && c->x86_mask > 7) ||
-			     c->x86_model == 9 || c->x86_model == 13) {
-				/* The more serious chips .. */
-
-				if (mbytes > 4092)
-					mbytes = 4092;
-
-				rdmsr(MSR_K6_WHCR, l, h);
-				if ((l&0xFFFF0000) == 0) {
-					unsigned long flags;
-					l = ((mbytes>>2)<<22)|(1<<16);
-					local_irq_save(flags);
-					wbinvd();
-					wrmsr(MSR_K6_WHCR, l, h);
-					local_irq_restore(flags);
-					printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
-						mbytes);
-				}
-
-				break;
-			}
-
-			if (c->x86_model == 10) {
-				/* AMD Geode LX is model 10 */
-				/* placeholder for any needed mods */
-				break;
-			}
-			break;
-	case 6: /* An Athlon/Duron */
-
-			/*
-			 * Bit 15 of Athlon specific MSR 15, needs to be 0
-			 * to enable SSE on Palomino/Morgan/Barton CPU's.
-			 * If the BIOS didn't enable it already, enable it here.
-			 */
-			if (c->x86_model >= 6 && c->x86_model <= 10) {
-				if (!cpu_has(c, X86_FEATURE_XMM)) {
-					printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-					rdmsr(MSR_K7_HWCR, l, h);
-					l &= ~0x00008000;
-					wrmsr(MSR_K7_HWCR, l, h);
-					set_cpu_cap(c, X86_FEATURE_XMM);
-				}
-			}
-
-			/*
-			 * It's been determined by AMD that Athlons since model 8 stepping 1
-			 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
-			 * As per AMD technical note 27212 0.2
-			 */
-			if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
-				rdmsr(MSR_K7_CLK_CTL, l, h);
-				if ((l & 0xfff00000) != 0x20000000) {
-					printk ("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n", l,
-						((l & 0x000fffff)|0x20000000));
-					wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
-				}
-			}
-			break;
+		level = cpuid_eax(1);
+		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
+	if (c->x86 == 0x10 || c->x86 == 0x11)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
+
+	/*
+	 *	FIXME: We should handle the K5 here. Set up the write
+	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
+	 *	no bus pipeline)
+	 */
 
 	switch (c->x86) {
-	case 15:
-	/* Use K8 tuning for Fam10h and Fam11h */
-	case 0x10:
-	case 0x11:
-		set_cpu_cap(c, X86_FEATURE_K8);
+	case 4:
+		init_amd_k5(c);
 		break;
-	case 6:
-		set_cpu_cap(c, X86_FEATURE_K7);
+	case 5:
+		init_amd_k6(c);
+		break;
+	case 6: /* An Athlon/Duron */
+		init_amd_k7(c);
 		break;
 	}
+
+	/* K6s reports MCEs but don't actually have all the MSRs */
+	if (c->x86 < 6)
+		clear_cpu_cap(c, X86_FEATURE_MCE);
+#endif
+
+	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
-	display_cacheinfo(c);
-
-	if (cpuid_eax(0x80000000) >= 0x80000008)
-		c->x86_max_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
+	if (!c->x86_model_id[0]) {
+		switch (c->x86) {
+		case 0xf:
+			/* Should distinguish Models here, but this is only
+			   a fallback anyways. */
+			strcpy(c->x86_model_id, "Hammer");
+			break;
+		}
+	}
 
-#ifdef CONFIG_X86_HT
-	/*
-	 * On a AMD multi core setup the lower bits of the APIC id
-	 * distinguish the cores.
-	 */
-	if (c->x86_max_cores > 1) {
-		int cpu = smp_processor_id();
-		unsigned bits = (cpuid_ecx(0x80000008) >> 12) & 0xf;
+	display_cacheinfo(c);
 
-		if (bits == 0) {
-			while ((1 << bits) < c->x86_max_cores)
-				bits++;
-		}
-		c->cpu_core_id = c->phys_proc_id & ((1<<bits)-1);
-		c->phys_proc_id >>= bits;
-		printk(KERN_INFO "CPU %d(%d) -> Core %d\n",
-		       cpu, c->x86_max_cores, c->cpu_core_id);
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level >= 0x80000008) {
+		amd_detect_cmp(c);
+		srat_detect_node(c);
 	}
+
+#ifdef CONFIG_X86_32
+	detect_ht(c);
 #endif
 
-	if (cpuid_eax(0x80000000) >= 0x80000006) {
-		if ((c->x86 == 0x10) && (cpuid_edx(0x80000006) & 0xf000))
+	if (c->extended_cpuid_level >= 0x80000006) {
+		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
 			num_cache_leaves = 4;
 		else
 			num_cache_leaves = 3;
 	}
 
-	/* K6s reports MCEs but don't actually have all the MSRs */
-	if (c->x86 < 6)
-		clear_cpu_cap(c, X86_FEATURE_MCE);
+	if (c->x86 >= 0xf && c->x86 <= 0x11)
+		set_cpu_cap(c, X86_FEATURE_K8);
 
-	if (cpu_has_xmm2)
+	if (cpu_has_xmm2) {
+		/* MFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+	}
+
+#ifdef CONFIG_X86_64
+	if (c->x86 == 0x10) {
+		/* do this for boot cpu */
+		if (c == &boot_cpu_data)
+			check_enable_amd_mmconf_dmi();
+
+		fam10h_check_enable_mmcfg();
+	}
+
+	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
+		unsigned long long tseg;
+
+		/*
+		 * Split up direct mapping around the TSEG SMM area.
+		 * Don't do it for gbpages because there seems very little
+		 * benefit in doing so.
+		 */
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+		    if ((tseg>>PMD_SHIFT) <
+				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
+			((tseg>>PMD_SHIFT) <
+				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
+			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+			set_memory_4k((unsigned long)__va(tseg), 1);
+		}
+	}
+#endif
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
@@ -279,10 +445,12 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int
 	}
 	return size;
 }
+#endif
 
 static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
+#ifdef CONFIG_X86_32
 	.c_models = {
 		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
 		  {
@@ -295,9 +463,11 @@ static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_size_cache	= amd_size_cache,
+#endif
 	.c_early_init   = early_init_amd,
 	.c_init		= init_amd,
-	.c_size_cache	= amd_size_cache,
+	.c_x86_vendor	= X86_VENDOR_AMD,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
+cpu_dev_register(amd_cpu_dev);
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
deleted file mode 100644
index d1692b2..0000000
--- a/arch/x86/kernel/cpu/amd_64.c
+++ /dev/null
@@ -1,224 +0,0 @@
-#include <linux/init.h>
-#include <linux/mm.h>
-
-#include <asm/numa_64.h>
-#include <asm/mmconfig.h>
-#include <asm/cacheflush.h>
-
-#include <mach_apic.h>
-
-#include "cpu.h"
-
-int force_mwait __cpuinitdata;
-
-#ifdef CONFIG_NUMA
-static int __cpuinit nearby_node(int apicid)
-{
-	int i, node;
-
-	for (i = apicid - 1; i >= 0; i--) {
-		node = apicid_to_node[i];
-		if (node != NUMA_NO_NODE && node_online(node))
-			return node;
-	}
-	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
-		node = apicid_to_node[i];
-		if (node != NUMA_NO_NODE && node_online(node))
-			return node;
-	}
-	return first_node(node_online_map); /* Shouldn't happen */
-}
-#endif
-
-/*
- * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
- * Assumes number of cores is a power of two.
- */
-static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned bits;
-#ifdef CONFIG_NUMA
-	int cpu = smp_processor_id();
-	int node = 0;
-	unsigned apicid = hard_smp_processor_id();
-#endif
-	bits = c->x86_coreid_bits;
-
-	/* Low order bits define the core id (index of core in socket) */
-	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
-	/* Convert the initial APIC ID into the socket ID */
-	c->phys_proc_id = c->initial_apicid >> bits;
-
-#ifdef CONFIG_NUMA
-	node = c->phys_proc_id;
-	if (apicid_to_node[apicid] != NUMA_NO_NODE)
-		node = apicid_to_node[apicid];
-	if (!node_online(node)) {
-		/* Two possibilities here:
-		   - The CPU is missing memory and no node was created.
-		   In that case try picking one from a nearby CPU
-		   - The APIC IDs differ from the HyperTransport node IDs
-		   which the K8 northbridge parsing fills in.
-		   Assume they are all increased by a constant offset,
-		   but in the same order as the HT nodeids.
-		   If that doesn't result in a usable node fall back to the
-		   path for the previous case.  */
-
-		int ht_nodeid = c->initial_apicid;
-
-		if (ht_nodeid >= 0 &&
-		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
-			node = apicid_to_node[ht_nodeid];
-		/* Pick a nearby node */
-		if (!node_online(node))
-			node = nearby_node(apicid);
-	}
-	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
-#endif
-#endif
-}
-
-static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	unsigned bits, ecx;
-
-	/* Multi core CPU? */
-	if (c->extended_cpuid_level < 0x80000008)
-		return;
-
-	ecx = cpuid_ecx(0x80000008);
-
-	c->x86_max_cores = (ecx & 0xff) + 1;
-
-	/* CPU telling us the core id bits shift? */
-	bits = (ecx >> 12) & 0xF;
-
-	/* Otherwise recompute */
-	if (bits == 0) {
-		while ((1 << bits) < c->x86_max_cores)
-			bits++;
-	}
-
-	c->x86_coreid_bits = bits;
-
-#endif
-}
-
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
-{
-	early_init_amd_mc(c);
-
-	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
-	if (c->x86_power & (1<<8))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
-	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
-}
-
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-{
-	unsigned level;
-
-#ifdef CONFIG_SMP
-	unsigned long value;
-
-	/*
-	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
-	 * bit 6 of msr C001_0015
-	 *
-	 * Errata 63 for SH-B3 steppings
-	 * Errata 122 for all steppings (F+ have it disabled by default)
-	 */
-	if (c->x86 == 0xf) {
-		rdmsrl(MSR_K8_HWCR, value);
-		value |= 1 << 6;
-		wrmsrl(MSR_K8_HWCR, value);
-	}
-#endif
-
-	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_cpu_cap(c, 0*32+31);
-
-	/* On C+ stepping K8 rep microcode works well for copy/memset */
-	if (c->x86 == 0xf) {
-		level = cpuid_eax(1);
-		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
-			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	}
-	if (c->x86 == 0x10 || c->x86 == 0x11)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-
-	/* Enable workaround for FXSAVE leak */
-	if (c->x86 >= 6)
-		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
-
-	level = get_model_name(c);
-	if (!level) {
-		switch (c->x86) {
-		case 0xf:
-			/* Should distinguish Models here, but this is only
-			   a fallback anyways. */
-			strcpy(c->x86_model_id, "Hammer");
-			break;
-		}
-	}
-	display_cacheinfo(c);
-
-	/* Multi core CPU? */
-	if (c->extended_cpuid_level >= 0x80000008)
-		amd_detect_cmp(c);
-
-	if (c->extended_cpuid_level >= 0x80000006 &&
-		(cpuid_edx(0x80000006) & 0xf000))
-		num_cache_leaves = 4;
-	else
-		num_cache_leaves = 3;
-
-	if (c->x86 >= 0xf && c->x86 <= 0x11)
-		set_cpu_cap(c, X86_FEATURE_K8);
-
-	/* MFENCE stops RDTSC speculation */
-	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
-
-	if (c->x86 == 0x10) {
-		/* do this for boot cpu */
-		if (c == &boot_cpu_data)
-			check_enable_amd_mmconf_dmi();
-
-		fam10h_check_enable_mmcfg();
-	}
-
-	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
-		unsigned long long tseg;
-
-		/*
-		 * Split up direct mapping around the TSEG SMM area.
-		 * Don't do it for gbpages because there seems very little
-		 * benefit in doing so.
-		 */
-		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
-		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-		    if ((tseg>>PMD_SHIFT) <
-				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
-			((tseg>>PMD_SHIFT) <
-				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
-			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
-			set_memory_4k((unsigned long)__va(tseg), 1);
-		}
-	}
-}
-
-static struct cpu_dev amd_cpu_dev __cpuinitdata = {
-	.c_vendor	= "AMD",
-	.c_ident	= { "AuthenticAMD" },
-	.c_early_init   = early_init_amd,
-	.c_init		= init_amd,
-};
-
-cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
-
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index a0534c0..89bfdd9 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -289,7 +289,6 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 	if (c->x86_model >= 6 && c->x86_model < 9)
 		set_cpu_cap(c, X86_FEATURE_3DNOW);
 
-	get_model_name(c);
 	display_cacheinfo(c);
 }
 
@@ -475,6 +474,7 @@ static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
 	.c_size_cache	= centaur_size_cache,
+	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+cpu_dev_register(centaur_cpu_dev);
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
index 1d181c4..a1625f5 100644
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -16,9 +16,10 @@ static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
+	early_init_centaur(c);
+
 	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
@@ -29,7 +30,8 @@ static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
+	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+cpu_dev_register(centaur_cpu_dev);
 
diff --git a/arch/x86/kernel/cpu/cmpxchg.c b/arch/x86/kernel/cpu/cmpxchg.c
new file mode 100644
index 0000000..2056ccf
--- /dev/null
+++ b/arch/x86/kernel/cpu/cmpxchg.c
@@ -0,0 +1,72 @@
+/*
+ * cmpxchg*() fallbacks for CPU not supporting these instructions
+ */
+
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+
+#ifndef CONFIG_X86_CMPXCHG
+unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
+{
+	u8 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u8 *)ptr;
+	if (prev == old)
+		*(u8 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u8);
+
+unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
+{
+	u16 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u16 *)ptr;
+	if (prev == old)
+		*(u16 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u16);
+
+unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
+{
+	u32 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u32 *)ptr;
+	if (prev == old)
+		*(u32 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u32);
+#endif
+
+#ifndef CONFIG_X86_CMPXCHG64
+unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
+{
+	u64 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u64 *)ptr;
+	if (prev == old)
+		*(u64 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_486_u64);
+#endif
+
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4e456bd..7581b62 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,28 +1,62 @@
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
+#include <linux/bootmem.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kgdb.h>
+#include <linux/topology.h>
 #include <linux/delay.h>
 #include <linux/smp.h>
-#include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/bootmem.h>
-#include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/linkage.h>
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/pat.h>
 #include <asm/asm.h>
+#include <asm/numa.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
 #include <mach_apic.h>
+#include <asm/genapic.h>
 #endif
 
+#include <asm/pda.h>
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/desc.h>
+#include <asm/atomic.h>
+#include <asm/proto.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
 #include "cpu.h"
 
+static struct cpu_dev *this_cpu __cpuinitdata;
+
+#ifdef CONFIG_X86_64
+/* We need valid kernel segments for data and code in long mode too
+ * IRET will check the segment types  kkeil 2000/10/28
+ * Also sysret mandates a special GDT layout
+ */
+/* The TLS descriptors are currently at a different place compared to i386.
+   Hopefully nobody expects them at a fixed place (Wine?) */
 DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
+	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
+	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
+	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
+	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
+	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
+	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
+} };
+#else
+DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00cf9a00 } } },
 	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00cffa00 } } },
@@ -56,17 +90,150 @@ DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_ESPFIX_SS] = { { { 0x00000000, 0x00c09200 } } },
 	[GDT_ENTRY_PERCPU] = { { { 0x00000000, 0x00000000 } } },
 } };
+#endif
 EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
-
+#ifdef CONFIG_X86_32
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 
-struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
+static int __init cachesize_setup(char *str)
+{
+	get_option(&str, &cachesize_override);
+	return 1;
+}
+__setup("cachesize=", cachesize_setup);
+
+static int __init x86_fxsr_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_FXSR);
+	setup_clear_cpu_cap(X86_FEATURE_XMM);
+	return 1;
+}
+__setup("nofxsr", x86_fxsr_setup);
+
+static int __init x86_sep_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SEP);
+	return 1;
+}
+__setup("nosep", x86_sep_setup);
+
+/* Standard macro to see if a specific flag is changeable */
+static inline int flag_is_changeable_p(u32 flag)
+{
+	u32 f1, f2;
+
+	asm("pushfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "movl %0,%1\n\t"
+	    "xorl %2,%0\n\t"
+	    "pushl %0\n\t"
+	    "popfl\n\t"
+	    "pushfl\n\t"
+	    "popl %0\n\t"
+	    "popfl\n\t"
+	    : "=&r" (f1), "=&r" (f2)
+	    : "ir" (flag));
+
+	return ((f1^f2) & flag) != 0;
+}
+
+/* Probe for the CPUID instruction */
+static int __cpuinit have_cpuid_p(void)
+{
+	return flag_is_changeable_p(X86_EFLAGS_ID);
+}
+
+static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
+		/* Disable processor serial number */
+		unsigned long lo, hi;
+		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		lo |= 0x200000;
+		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
+		printk(KERN_NOTICE "CPU serial number disabled.\n");
+		clear_cpu_cap(c, X86_FEATURE_PN);
+
+		/* Disabling the serial number may affect the cpuid level */
+		c->cpuid_level = cpuid_eax(0);
+	}
+}
+
+static int __init x86_serial_nr_setup(char *s)
+{
+	disable_x86_serial_nr = 0;
+	return 1;
+}
+__setup("serialnumber", x86_serial_nr_setup);
+#else
+static inline int flag_is_changeable_p(u32 flag)
+{
+	return 1;
+}
+/* Probe for the CPUID instruction */
+static inline int have_cpuid_p(void)
+{
+	return 1;
+}
+static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+{
+}
+#endif
+
+/*
+ * Naming convention should be: <Name> [(<Codename>)]
+ * This table only is used unless init_<vendor>() below doesn't set it;
+ * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
+ *
+ */
+
+/* Look up CPU names by table lookup. */
+static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+{
+	struct cpu_model_info *info;
+
+	if (c->x86_model >= 16)
+		return NULL;	/* Range check */
+
+	if (!this_cpu)
+		return NULL;
+
+	info = this_cpu->c_models;
+
+	while (info && info->family) {
+		if (info->family == c->x86)
+			return info->model_names[c->x86_model];
+		info++;
+	}
+	return NULL;		/* Not found */
+}
+
+__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+
+/* Current gdt points %fs at the "master" per-cpu area: after this,
+ * it's on the real one. */
+void switch_to_new_gdt(void)
+{
+	struct desc_ptr gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
+#ifdef CONFIG_X86_32
+	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+#endif
+}
+
+static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_64
+	display_cacheinfo(c);
+#else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
 	if (c->cpuid_level == -1) {
@@ -76,28 +243,22 @@ static void __cpuinit default_init(struct cpuinfo_x86 *c)
 		else if (c->x86 == 3)
 			strcpy(c->x86_model_id, "386");
 	}
+#endif
 }
 
 static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
+	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
-static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
-static int __init cachesize_setup(char *str)
-{
-	get_option(&str, &cachesize_override);
-	return 1;
-}
-__setup("cachesize=", cachesize_setup);
-
-int __cpuinit get_model_name(struct cpuinfo_x86 *c)
+static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
 	char *p, *q;
 
-	if (cpuid_eax(0x80000000) < 0x80000004)
-		return 0;
+	if (c->extended_cpuid_level < 0x80000004)
+		return;
 
 	v = (unsigned int *) c->x86_model_id;
 	cpuid(0x80000002, &v[0], &v[1], &v[2], &v[3]);
@@ -116,30 +277,34 @@ int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	     while (q <= &c->x86_model_id[48])
 		  *q++ = '\0';	/* Zero-pad the rest */
 	}
-
-	return 1;
 }
 
-
 void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 {
-	unsigned int n, dummy, ecx, edx, l2size;
+	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
-	n = cpuid_eax(0x80000000);
+	n = c->extended_cpuid_level;
 
 	if (n >= 0x80000005) {
-		cpuid(0x80000005, &dummy, &dummy, &ecx, &edx);
+		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
 		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
-			edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
-		c->x86_cache_size = (ecx>>24)+(edx>>24);
+				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
+		c->x86_cache_size = (ecx>>24) + (edx>>24);
+#ifdef CONFIG_X86_64
+		/* On K8 L1 TLB is inclusive, so don't count it */
+		c->x86_tlbsize = 0;
+#endif
 	}
 
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
 		return;
 
-	ecx = cpuid_ecx(0x80000006);
+	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
 	l2size = ecx >> 16;
 
+#ifdef CONFIG_X86_64
+	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+#else
 	/* do processor-specific cache resizing */
 	if (this_cpu->c_size_cache)
 		l2size = this_cpu->c_size_cache(c, l2size);
@@ -150,116 +315,106 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (l2size == 0)
 		return;		/* Again, no L2 cache is possible */
+#endif
 
 	c->x86_cache_size = l2size;
 
 	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-	       l2size, ecx & 0xFF);
+			l2size, ecx & 0xFF);
 }
 
-/*
- * Naming convention should be: <Name> [(<Codename>)]
- * This table only is used unless init_<vendor>() below doesn't set it;
- * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
- *
- */
-
-/* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
-	struct cpu_model_info *info;
+#ifdef CONFIG_X86_HT
+	u32 eax, ebx, ecx, edx;
+	int index_msb, core_bits;
 
-	if (c->x86_model >= 16)
-		return NULL;	/* Range check */
+	if (!cpu_has(c, X86_FEATURE_HT))
+		return;
 
-	if (!this_cpu)
-		return NULL;
+	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
+		goto out;
 
-	info = this_cpu->c_models;
+	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
+		return;
 
-	while (info && info->family) {
-		if (info->family == c->x86)
-			return info->model_names[c->x86_model];
-		info++;
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+
+	smp_num_siblings = (ebx & 0xff0000) >> 16;
+
+	if (smp_num_siblings == 1) {
+		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
+	} else if (smp_num_siblings > 1) {
+
+		if (smp_num_siblings > NR_CPUS) {
+			printk(KERN_WARNING "CPU: Unsupported number of siblings %d",
+					smp_num_siblings);
+			smp_num_siblings = 1;
+			return;
+		}
+
+		index_msb = get_count_order(smp_num_siblings);
+#ifdef CONFIG_X86_64
+		c->phys_proc_id = phys_pkg_id(index_msb);
+#else
+		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
+#endif
+
+		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
+
+		index_msb = get_count_order(smp_num_siblings);
+
+		core_bits = get_count_order(c->x86_max_cores);
+
+#ifdef CONFIG_X86_64
+		c->cpu_core_id = phys_pkg_id(index_msb) &
+					       ((1 << core_bits) - 1);
+#else
+		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
+					       ((1 << core_bits) - 1);
+#endif
 	}
-	return NULL;		/* Not found */
-}
 
+out:
+	if ((c->x86_max_cores * smp_num_siblings) > 1) {
+		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+		       c->phys_proc_id);
+		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+		       c->cpu_core_id);
+	}
+#endif
+}
 
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
+static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
 	static int printed;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		if (cpu_devs[i]) {
-			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] &&
-			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
-				c->x86_vendor = i;
-				if (!early)
-					this_cpu = cpu_devs[i];
-				return;
-			}
+		if (!cpu_devs[i])
+			break;
+
+		if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
+		    (cpu_devs[i]->c_ident[1] &&
+		     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+			this_cpu = cpu_devs[i];
+			c->x86_vendor = this_cpu->c_x86_vendor;
+			return;
 		}
 	}
+
 	if (!printed) {
 		printed++;
-		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
+		printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
+
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
 }
 
-
-static int __init x86_fxsr_setup(char *s)
-{
-	setup_clear_cpu_cap(X86_FEATURE_FXSR);
-	setup_clear_cpu_cap(X86_FEATURE_XMM);
-	return 1;
-}
-__setup("nofxsr", x86_fxsr_setup);
-
-
-static int __init x86_sep_setup(char *s)
-{
-	setup_clear_cpu_cap(X86_FEATURE_SEP);
-	return 1;
-}
-__setup("nosep", x86_sep_setup);
-
-
-/* Standard macro to see if a specific flag is changeable */
-static inline int flag_is_changeable_p(u32 flag)
-{
-	u32 f1, f2;
-
-	asm("pushfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "movl %0,%1\n\t"
-	    "xorl %2,%0\n\t"
-	    "pushl %0\n\t"
-	    "popfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "popfl\n\t"
-	    : "=&r" (f1), "=&r" (f2)
-	    : "ir" (flag));
-
-	return ((f1^f2) & flag) != 0;
-}
-
-
-/* Probe for the CPUID instruction */
-static int __cpuinit have_cpuid_p(void)
-{
-	return flag_is_changeable_p(X86_EFLAGS_ID);
-}
-
-void __init cpu_detect(struct cpuinfo_x86 *c)
+void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
 	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
@@ -268,50 +423,87 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 	      (unsigned int *)&c->x86_vendor_id[4]);
 
 	c->x86 = 4;
+	/* Intel-defined flags: level 0x00000001 */
 	if (c->cpuid_level >= 0x00000001) {
 		u32 junk, tfms, cap0, misc;
 		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
-		c->x86 = (tfms >> 8) & 15;
-		c->x86_model = (tfms >> 4) & 15;
+		c->x86 = (tfms >> 8) & 0xf;
+		c->x86_model = (tfms >> 4) & 0xf;
+		c->x86_mask = tfms & 0xf;
 		if (c->x86 == 0xf)
 			c->x86 += (tfms >> 20) & 0xff;
 		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		c->x86_mask = tfms & 15;
+			c->x86_model += ((tfms >> 16) & 0xf) << 4;
 		if (cap0 & (1<<19)) {
-			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+			c->x86_cache_alignment = c->x86_clflush_size;
 		}
 	}
 }
-static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
+
+static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
-	unsigned int ebx;
+	u32 ebx;
 
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-	if (have_cpuid_p()) {
-		/* Intel-defined flags: level 0x00000001 */
-		if (c->cpuid_level >= 0x00000001) {
-			u32 capability, excap;
-			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
-			c->x86_capability[0] = capability;
-			c->x86_capability[4] = excap;
-		}
+	/* Intel-defined flags: level 0x00000001 */
+	if (c->cpuid_level >= 0x00000001) {
+		u32 capability, excap;
+		cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
+		c->x86_capability[0] = capability;
+		c->x86_capability[4] = excap;
+	}
 
-		/* AMD-defined flags: level 0x80000001 */
-		xlvl = cpuid_eax(0x80000000);
-		if ((xlvl & 0xffff0000) == 0x80000000) {
-			if (xlvl >= 0x80000001) {
-				c->x86_capability[1] = cpuid_edx(0x80000001);
-				c->x86_capability[6] = cpuid_ecx(0x80000001);
-			}
+	/* AMD-defined flags: level 0x80000001 */
+	xlvl = cpuid_eax(0x80000000);
+	c->extended_cpuid_level = xlvl;
+	if ((xlvl & 0xffff0000) == 0x80000000) {
+		if (xlvl >= 0x80000001) {
+			c->x86_capability[1] = cpuid_edx(0x80000001);
+			c->x86_capability[6] = cpuid_ecx(0x80000001);
 		}
+	}
 
+#ifdef CONFIG_X86_64
+	if (c->extended_cpuid_level >= 0x80000008) {
+		u32 eax = cpuid_eax(0x80000008);
+
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
 	}
+#endif
+
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
 
 }
 
+static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_32
+	int i;
+
+	/*
+	 * First of all, decide if this is a 486 or higher
+	 * It's a 486 if we can modify the AC flag
+	 */
+	if (flag_is_changeable_p(X86_EFLAGS_AC))
+		c->x86 = 4;
+	else
+		c->x86 = 3;
+
+	for (i = 0; i < X86_VENDOR_NUM; i++)
+		if (cpu_devs[i] && cpu_devs[i]->c_identify) {
+			c->x86_vendor_id[0] = 0;
+			cpu_devs[i]->c_identify(c);
+			if (c->x86_vendor_id[0]) {
+				get_cpu_vendor(c);
+				break;
+			}
+		}
+#endif
+}
+
 /*
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
@@ -321,25 +513,61 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
  * WARNING: this function is only called on the BP.  Don't add code here
  * that is supposed to run on all CPUs.
  */
-static void __init early_cpu_detect(void)
+static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
-	c->x86_cache_alignment = 32;
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+#else
 	c->x86_clflush_size = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
+
+	memset(&c->x86_capability, 0, sizeof c->x86_capability);
+	c->extended_cpuid_level = 0;
 
 	if (!have_cpuid_p())
+		identify_cpu_without_cpuid(c);
+
+	/* cyrix could have cpuid enabled via c_identify()*/
+	if (!have_cpuid_p())
 		return;
 
 	cpu_detect(c);
 
-	get_cpu_vendor(c, 1);
+	get_cpu_vendor(c);
 
-	early_get_cap(c);
+	get_cpu_cap(c);
 
-	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
-	    cpu_devs[c->x86_vendor]->c_early_init)
-		cpu_devs[c->x86_vendor]->c_early_init(c);
+	if (this_cpu->c_early_init)
+		this_cpu->c_early_init(c);
+
+	validate_pat_support(c);
+}
+
+void __init early_cpu_init(void)
+{
+	struct cpu_dev **cdev;
+	int count = 0;
+
+	printk("KERNEL supported cpus:\n");
+	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
+		struct cpu_dev *cpudev = *cdev;
+		unsigned int j;
+
+		if (count >= X86_VENDOR_NUM)
+			break;
+		cpu_devs[count] = cpudev;
+		count++;
+
+		for (j = 0; j < 2; j++) {
+			if (!cpudev->c_ident[j])
+				continue;
+			printk("  %s %s\n", cpudev->c_vendor,
+				cpudev->c_ident[j]);
+		}
+	}
+
+	early_identify_cpu(&boot_cpu_data);
 }
 
 /*
@@ -357,86 +585,41 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
-	u32 tfms, xlvl;
-	unsigned int ebx;
-
-	if (have_cpuid_p()) {
-		/* Get vendor name */
-		cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
-		      (unsigned int *)&c->x86_vendor_id[0],
-		      (unsigned int *)&c->x86_vendor_id[8],
-		      (unsigned int *)&c->x86_vendor_id[4]);
-
-		get_cpu_vendor(c, 0);
-		/* Initialize the standard set of capabilities */
-		/* Note that the vendor-specific code below might override */
-		/* Intel-defined flags: level 0x00000001 */
-		if (c->cpuid_level >= 0x00000001) {
-			u32 capability, excap;
-			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
-			c->x86_capability[0] = capability;
-			c->x86_capability[4] = excap;
-			c->x86 = (tfms >> 8) & 15;
-			c->x86_model = (tfms >> 4) & 15;
-			if (c->x86 == 0xf)
-				c->x86 += (tfms >> 20) & 0xff;
-			if (c->x86 >= 0x6)
-				c->x86_model += ((tfms >> 16) & 0xF) << 4;
-			c->x86_mask = tfms & 15;
-			c->initial_apicid = (ebx >> 24) & 0xFF;
-#ifdef CONFIG_X86_HT
-			c->apicid = phys_pkg_id(c->initial_apicid, 0);
-			c->phys_proc_id = c->initial_apicid;
-#else
-			c->apicid = c->initial_apicid;
-#endif
-			if (test_cpu_cap(c, X86_FEATURE_CLFLSH))
-				c->x86_clflush_size = ((ebx >> 8) & 0xff) * 8;
-		} else {
-			/* Have CPUID level 0 only - unheard of */
-			c->x86 = 4;
-		}
+	c->extended_cpuid_level = 0;
 
-		/* AMD-defined flags: level 0x80000001 */
-		xlvl = cpuid_eax(0x80000000);
-		if ((xlvl & 0xffff0000) == 0x80000000) {
-			if (xlvl >= 0x80000001) {
-				c->x86_capability[1] = cpuid_edx(0x80000001);
-				c->x86_capability[6] = cpuid_ecx(0x80000001);
-			}
-			if (xlvl >= 0x80000004)
-				get_model_name(c); /* Default name */
-		}
+	if (!have_cpuid_p())
+		identify_cpu_without_cpuid(c);
 
-		init_scattered_cpuid_features(c);
-		detect_nopl(c);
-	}
-}
+	/* cyrix could have cpuid enabled via c_identify()*/
+	if (!have_cpuid_p())
+		return;
 
-static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
-{
-	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
-		/* Disable processor serial number */
-		unsigned long lo, hi;
-		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
-		lo |= 0x200000;
-		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
-		printk(KERN_NOTICE "CPU serial number disabled.\n");
-		clear_cpu_cap(c, X86_FEATURE_PN);
+	cpu_detect(c);
 
-		/* Disabling the serial number may affect the cpuid level */
-		c->cpuid_level = cpuid_eax(0);
-	}
-}
+	get_cpu_vendor(c);
 
-static int __init x86_serial_nr_setup(char *s)
-{
-	disable_x86_serial_nr = 0;
-	return 1;
-}
-__setup("serialnumber", x86_serial_nr_setup);
+	get_cpu_cap(c);
 
+	if (c->cpuid_level >= 0x00000001) {
+		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_HT
+		c->apicid = phys_pkg_id(c->initial_apicid, 0);
+# else
+		c->apicid = c->initial_apicid;
+# endif
+#endif
 
+#ifdef CONFIG_X86_HT
+		c->phys_proc_id = c->initial_apicid;
+#endif
+	}
+
+	get_model_name(c); /* Default name */
+
+	init_scattered_cpuid_features(c);
+	detect_nopl(c);
+}
 
 /*
  * This does the hard work of actually picking apart the CPU stuff...
@@ -448,30 +631,29 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
+	c->x86_coreid_bits = 0;
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+#else
+	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_clflush_size = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
-	if (!have_cpuid_p()) {
-		/*
-		 * First of all, decide if this is a 486 or higher
-		 * It's a 486 if we can modify the AC flag
-		 */
-		if (flag_is_changeable_p(X86_EFLAGS_AC))
-			c->x86 = 4;
-		else
-			c->x86 = 3;
-	}
-
 	generic_identify(c);
 
 	if (this_cpu->c_identify)
 		this_cpu->c_identify(c);
 
+#ifdef CONFIG_X86_64
+	c->apicid = phys_pkg_id(0);
+#endif
+
 	/*
 	 * Vendor-specific initialization.  In this section we
 	 * canonicalize the feature flags, meaning if there are
@@ -505,6 +687,10 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 				c->x86, c->x86_model);
 	}
 
+#ifdef CONFIG_X86_64
+	detect_ht(c);
+#endif
+
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -513,7 +699,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	 */
 	if (c != &boot_cpu_data) {
 		/* AND the already accumulated flags with these */
-		for (i = 0 ; i < NCAPINTS ; i++)
+		for (i = 0; i < NCAPINTS; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
@@ -521,72 +707,79 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	for (i = 0; i < NCAPINTS; i++)
 		c->x86_capability[i] &= ~cleared_cpu_caps[i];
 
+#ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+#endif
 
 	select_idle_routine(c);
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	numa_add_cpu(smp_processor_id());
+#endif
 }
 
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+#ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
+#endif
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
 	identify_cpu(c);
+#ifdef CONFIG_X86_32
 	enable_sep_cpu();
+#endif
 	mtrr_ap_init();
 }
 
-#ifdef CONFIG_X86_HT
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
-{
-	u32 	eax, ebx, ecx, edx;
-	int 	index_msb, core_bits;
-
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-
-	if (!cpu_has(c, X86_FEATURE_HT) || cpu_has(c, X86_FEATURE_CMP_LEGACY))
-		return;
-
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
+struct msr_range {
+	unsigned min;
+	unsigned max;
+};
 
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1) {
+static struct msr_range msr_range_array[] __cpuinitdata = {
+	{ 0x00000000, 0x00000418},
+	{ 0xc0000000, 0xc000040b},
+	{ 0xc0010000, 0xc0010142},
+	{ 0xc0011000, 0xc001103b},
+};
 
-		if (smp_num_siblings > NR_CPUS) {
-			printk(KERN_WARNING "CPU: Unsupported number of the "
-					"siblings %d", smp_num_siblings);
-			smp_num_siblings = 1;
-			return;
+static void __cpuinit print_cpu_msr(void)
+{
+	unsigned index;
+	u64 val;
+	int i;
+	unsigned index_min, index_max;
+
+	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
+		index_min = msr_range_array[i].min;
+		index_max = msr_range_array[i].max;
+		for (index = index_min; index < index_max; index++) {
+			if (rdmsrl_amd_safe(index, &val))
+				continue;
+			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
 		}
+	}
+}
 
-		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
-
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-
-		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
-
-		index_msb = get_count_order(smp_num_siblings) ;
+static int show_msr __cpuinitdata;
+static __init int setup_show_msr(char *arg)
+{
+	int num;
 
-		core_bits = get_count_order(c->x86_max_cores);
+	get_option(&arg, &num);
 
-		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
-					       ((1 << core_bits) - 1);
-
-		if (c->x86_max_cores > 1)
-			printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-			       c->cpu_core_id);
-	}
+	if (num > 0)
+		show_msr = num;
+	return 1;
 }
-#endif
+__setup("show_msr=", setup_show_msr);
 
 static __init int setup_noclflush(char *arg)
 {
@@ -605,17 +798,25 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 		vendor = c->x86_vendor_id;
 
 	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
-		printk("%s ", vendor);
+		printk(KERN_CONT "%s ", vendor);
 
-	if (!c->x86_model_id[0])
-		printk("%d86", c->x86);
+	if (c->x86_model_id[0])
+		printk(KERN_CONT "%s", c->x86_model_id);
 	else
-		printk("%s", c->x86_model_id);
+		printk(KERN_CONT "%d86", c->x86);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(" stepping %02x\n", c->x86_mask);
+		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
 	else
-		printk("\n");
+		printk(KERN_CONT "\n");
+
+#ifdef CONFIG_SMP
+	if (c->cpu_index < show_msr)
+		print_cpu_msr();
+#else
+	if (show_msr)
+		print_cpu_msr();
+#endif
 }
 
 static __init int setup_disablecpuid(char *arg)
@@ -631,19 +832,89 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
-void __init early_cpu_init(void)
+#ifdef CONFIG_X86_64
+struct x8664_pda **_cpu_pda __read_mostly;
+EXPORT_SYMBOL(_cpu_pda);
+
+struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
+
+char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+
+void __cpuinit pda_init(int cpu)
+{
+	struct x8664_pda *pda = cpu_pda(cpu);
+
+	/* Setup up data that may be needed in __get_free_pages early */
+	loadsegment(fs, 0);
+	loadsegment(gs, 0);
+	/* Memory clobbers used to order PDA accessed */
+	mb();
+	wrmsrl(MSR_GS_BASE, pda);
+	mb();
+
+	pda->cpunumber = cpu;
+	pda->irqcount = -1;
+	pda->kernelstack = (unsigned long)stack_thread_info() -
+				 PDA_STACKOFFSET + THREAD_SIZE;
+	pda->active_mm = &init_mm;
+	pda->mmu_state = 0;
+
+	if (cpu == 0) {
+		/* others are initialized in smpboot.c */
+		pda->pcurrent = &init_task;
+		pda->irqstackptr = boot_cpu_stack;
+		pda->irqstackptr += IRQSTACKSIZE - 64;
+	} else {
+		if (!pda->irqstackptr) {
+			pda->irqstackptr = (char *)
+				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+			if (!pda->irqstackptr)
+				panic("cannot allocate irqstack for cpu %d",
+				      cpu);
+			pda->irqstackptr += IRQSTACKSIZE - 64;
+		}
+
+		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
+			pda->nodenumber = cpu_to_node(cpu);
+	}
+}
+
+char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
+			   DEBUG_STKSZ] __page_aligned_bss;
+
+extern asmlinkage void ignore_sysret(void);
+
+/* May not be marked __init: used by software suspend */
+void syscall_init(void)
 {
-	struct cpu_vendor_dev *cvdev;
+	/*
+	 * LSTAR and STAR live in a bit strange symbiosis.
+	 * They both write to the same internal register. STAR allows to
+	 * set CS/DS but only a 32bit target. LSTAR sets the 64bit rip.
+	 */
+	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);
+	wrmsrl(MSR_LSTAR, system_call);
+	wrmsrl(MSR_CSTAR, ignore_sysret);
 
-	for (cvdev = __x86cpuvendor_start ;
-	     cvdev < __x86cpuvendor_end   ;
-	     cvdev++)
-		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+#ifdef CONFIG_IA32_EMULATION
+	syscall32_cpu_init();
+#endif
 
-	early_cpu_detect();
-	validate_pat_support(&boot_cpu_data);
+	/* Flags to clear on syscall */
+	wrmsrl(MSR_SYSCALL_MASK,
+	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
 }
 
+unsigned long kernel_eflags;
+
+/*
+ * Copies of the original ist values from the tss are only accessed during
+ * debugging, no special alignment required.
+ */
+DEFINE_PER_CPU(struct orig_ist, orig_ist);
+
+#else
+
 /* Make sure %fs is initialized properly in idle threads */
 struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
@@ -651,25 +922,136 @@ struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 	regs->fs = __KERNEL_PERCPU;
 	return regs;
 }
-
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
-void switch_to_new_gdt(void)
-{
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
-}
+#endif
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
  * and IDT. We reload them nevertheless, this function acts as a
  * 'CPU state barrier', nothing should get across.
+ * A lot of state is already set up in PDA init for 64 bit
  */
+#ifdef CONFIG_X86_64
+void __cpuinit cpu_init(void)
+{
+	int cpu = stack_smp_processor_id();
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
+	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
+	unsigned long v;
+	char *estacks = NULL;
+	struct task_struct *me;
+	int i;
+
+	/* CPU 0 is initialised in head64.c */
+	if (cpu != 0)
+		pda_init(cpu);
+	else
+		estacks = boot_exception_stacks;
+
+	me = current;
+
+	if (cpu_test_and_set(cpu, cpu_initialized))
+		panic("CPU#%d already initialized!\n", cpu);
+
+	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+
+	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+
+	/*
+	 * Initialize the per-CPU GDT with the boot GDT,
+	 * and set up the GDT descriptor:
+	 */
+
+	switch_to_new_gdt();
+	load_idt((const struct desc_ptr *)&idt_descr);
+
+	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
+	syscall_init();
+
+	wrmsrl(MSR_FS_BASE, 0);
+	wrmsrl(MSR_KERNEL_GS_BASE, 0);
+	barrier();
+
+	check_efer();
+	if (cpu != 0 && x2apic)
+		enable_x2apic();
+
+	/*
+	 * set up and load the per-CPU TSS
+	 */
+	if (!orig_ist->ist[0]) {
+		static const unsigned int order[N_EXCEPTION_STACKS] = {
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		};
+		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (cpu) {
+				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
+				if (!estacks)
+					panic("Cannot allocate exception "
+					      "stack %ld %d\n", v, cpu);
+			}
+			estacks += PAGE_SIZE << order[v];
+			orig_ist->ist[v] = t->x86_tss.ist[v] =
+					(unsigned long)estacks;
+		}
+	}
+
+	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+	/*
+	 * <= is required because the CPU will access up to
+	 * 8 bits beyond the end of the IO permission bitmap.
+	 */
+	for (i = 0; i <= IO_BITMAP_LONGS; i++)
+		t->io_bitmap[i] = ~0UL;
+
+	atomic_inc(&init_mm.mm_count);
+	me->active_mm = &init_mm;
+	if (me->mm)
+		BUG();
+	enter_lazy_tlb(&init_mm, me);
+
+	load_sp0(t, &current->thread);
+	set_tss_desc(cpu, t);
+	load_TR_desc();
+	load_LDT(&init_mm.context);
+
+#ifdef CONFIG_KGDB
+	/*
+	 * If the kgdb is connected no debug regs should be altered.  This
+	 * is only applicable when KGDB and a KGDB I/O module are built
+	 * into the kernel and you are using early debugging with
+	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
+	 */
+	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
+	else {
+#endif
+	/*
+	 * Clear all 6 debug registers:
+	 */
+
+	set_debugreg(0UL, 0);
+	set_debugreg(0UL, 1);
+	set_debugreg(0UL, 2);
+	set_debugreg(0UL, 3);
+	set_debugreg(0UL, 6);
+	set_debugreg(0UL, 7);
+#ifdef CONFIG_KGDB
+	/* If the kgdb is connected no debug regs should be altered. */
+	}
+#endif
+
+	fpu_init();
+
+	raw_local_save_flags(kernel_eflags);
+
+	if (is_uv_system())
+		uv_cpu_init();
+}
+
+#else
+
 void __cpuinit cpu_init(void)
 {
 	int cpu = smp_processor_id();
@@ -723,9 +1105,20 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Force FPU initialization:
 	 */
-	current_thread_info()->status = 0;
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
+
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+
+	xsave_init();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -739,3 +1132,5 @@ void __cpuinit cpu_uninit(void)
 	per_cpu(cpu_tlbstate, cpu).active_mm = &init_mm;
 }
 #endif
+
+#endif
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
deleted file mode 100644
index 305b465..0000000
--- a/arch/x86/kernel/cpu/common_64.c
+++ /dev/null
@@ -1,763 +0,0 @@
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/string.h>
-#include <linux/bootmem.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/kgdb.h>
-#include <linux/topology.h>
-#include <linux/delay.h>
-#include <linux/smp.h>
-#include <linux/percpu.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/io.h>
-#include <asm/linkage.h>
-#include <asm/mmu_context.h>
-#include <asm/mtrr.h>
-#include <asm/mce.h>
-#include <asm/pat.h>
-#include <asm/asm.h>
-#include <asm/numa.h>
-#ifdef CONFIG_X86_LOCAL_APIC
-#include <asm/mpspec.h>
-#include <asm/apic.h>
-#include <mach_apic.h>
-#endif
-#include <asm/pda.h>
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/desc.h>
-#include <asm/atomic.h>
-#include <asm/proto.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
-#include <asm/genapic.h>
-
-#include "cpu.h"
-
-/* We need valid kernel segments for data and code in long mode too
- * IRET will check the segment types  kkeil 2000/10/28
- * Also sysret mandates a special GDT layout
- */
-/* The TLS descriptors are currently at a different place compared to i386.
-   Hopefully nobody expects them at a fixed place (Wine?) */
-DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
-	[GDT_ENTRY_KERNEL32_CS] = { { { 0x0000ffff, 0x00cf9b00 } } },
-	[GDT_ENTRY_KERNEL_CS] = { { { 0x0000ffff, 0x00af9b00 } } },
-	[GDT_ENTRY_KERNEL_DS] = { { { 0x0000ffff, 0x00cf9300 } } },
-	[GDT_ENTRY_DEFAULT_USER32_CS] = { { { 0x0000ffff, 0x00cffb00 } } },
-	[GDT_ENTRY_DEFAULT_USER_DS] = { { { 0x0000ffff, 0x00cff300 } } },
-	[GDT_ENTRY_DEFAULT_USER_CS] = { { { 0x0000ffff, 0x00affb00 } } },
-} };
-EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
-
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
-
-/* Current gdt points %fs at the "master" per-cpu area: after this,
- * it's on the real one. */
-void switch_to_new_gdt(void)
-{
-	struct desc_ptr gdt_descr;
-
-	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
-	gdt_descr.size = GDT_SIZE - 1;
-	load_gdt(&gdt_descr);
-}
-
-struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
-
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
-{
-	display_cacheinfo(c);
-}
-
-static struct cpu_dev __cpuinitdata default_cpu = {
-	.c_init	= default_init,
-	.c_vendor = "Unknown",
-};
-static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
-
-int __cpuinit get_model_name(struct cpuinfo_x86 *c)
-{
-	unsigned int *v;
-
-	if (c->extended_cpuid_level < 0x80000004)
-		return 0;
-
-	v = (unsigned int *) c->x86_model_id;
-	cpuid(0x80000002, &v[0], &v[1], &v[2], &v[3]);
-	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
-	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
-	c->x86_model_id[48] = 0;
-	return 1;
-}
-
-
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
-{
-	unsigned int n, dummy, ebx, ecx, edx;
-
-	n = c->extended_cpuid_level;
-
-	if (n >= 0x80000005) {
-		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), "
-		       "D cache %dK (%d bytes/line)\n",
-		       edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
-		c->x86_cache_size = (ecx>>24) + (edx>>24);
-		/* On K8 L1 TLB is inclusive, so don't count it */
-		c->x86_tlbsize = 0;
-	}
-
-	if (n >= 0x80000006) {
-		cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
-		ecx = cpuid_ecx(0x80000006);
-		c->x86_cache_size = ecx >> 16;
-		c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
-
-		printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-		c->x86_cache_size, ecx & 0xFF);
-	}
-}
-
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_SMP
-	u32 eax, ebx, ecx, edx;
-	int index_msb, core_bits;
-
-	cpuid(1, &eax, &ebx, &ecx, &edx);
-
-
-	if (!cpu_has(c, X86_FEATURE_HT))
-		return;
-	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
-		goto out;
-
-	smp_num_siblings = (ebx & 0xff0000) >> 16;
-
-	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1) {
-
-		if (smp_num_siblings > NR_CPUS) {
-			printk(KERN_WARNING "CPU: Unsupported number of "
-			       "siblings %d", smp_num_siblings);
-			smp_num_siblings = 1;
-			return;
-		}
-
-		index_msb = get_count_order(smp_num_siblings);
-		c->phys_proc_id = phys_pkg_id(index_msb);
-
-		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
-
-		index_msb = get_count_order(smp_num_siblings);
-
-		core_bits = get_count_order(c->x86_max_cores);
-
-		c->cpu_core_id = phys_pkg_id(index_msb) &
-					       ((1 << core_bits) - 1);
-	}
-out:
-	if ((c->x86_max_cores * smp_num_siblings) > 1) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
-	}
-
-#endif
-}
-
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
-{
-	char *v = c->x86_vendor_id;
-	int i;
-	static int printed;
-
-	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		if (cpu_devs[i]) {
-			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] &&
-			    !strcmp(v, cpu_devs[i]->c_ident[1]))) {
-				c->x86_vendor = i;
-				this_cpu = cpu_devs[i];
-				return;
-			}
-		}
-	}
-	if (!printed) {
-		printed++;
-		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
-		printk(KERN_ERR "CPU: Your system may be unstable.\n");
-	}
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-}
-
-static void __init early_cpu_support_print(void)
-{
-	int i,j;
-	struct cpu_dev *cpu_devx;
-
-	printk("KERNEL supported cpus:\n");
-	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		cpu_devx = cpu_devs[i];
-		if (!cpu_devx)
-			continue;
-		for (j = 0; j < 2; j++) {
-			if (!cpu_devx->c_ident[j])
-				continue;
-			printk("  %s %s\n", cpu_devx->c_vendor,
-				cpu_devx->c_ident[j]);
-		}
-	}
-}
-
-/*
- * The NOPL instruction is supposed to exist on all CPUs with
- * family >= 6, unfortunately, that's not true in practice because
- * of early VIA chips and (more importantly) broken virtualizers that
- * are not easy to detect.  Hence, probe for it based on first
- * principles.
- *
- * Note: no 64-bit chip is known to lack these, but put the code here
- * for consistency with 32 bits, and to make it utterly trivial to
- * diagnose the problem should it ever surface.
- */
-static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
-{
-	const u32 nopl_signature = 0x888c53b1; /* Random number */
-	u32 has_nopl = nopl_signature;
-
-	clear_cpu_cap(c, X86_FEATURE_NOPL);
-	if (c->x86 >= 6) {
-		asm volatile("\n"
-			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
-			     "2:\n"
-			     "        .section .fixup,\"ax\"\n"
-			     "3:      xor %0,%0\n"
-			     "        jmp 2b\n"
-			     "        .previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : "+a" (has_nopl));
-
-		if (has_nopl == nopl_signature)
-			set_cpu_cap(c, X86_FEATURE_NOPL);
-	}
-}
-
-static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
-
-void __init early_cpu_init(void)
-{
-        struct cpu_vendor_dev *cvdev;
-
-        for (cvdev = __x86cpuvendor_start ;
-             cvdev < __x86cpuvendor_end   ;
-             cvdev++)
-                cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
-	early_cpu_support_print();
-	early_identify_cpu(&boot_cpu_data);
-}
-
-/* Do some early cpuid on the boot CPU to get some parameter that are
-   needed before check_bugs. Everything advanced is in identify_cpu
-   below. */
-static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
-{
-	u32 tfms, xlvl;
-
-	c->loops_per_jiffy = loops_per_jiffy;
-	c->x86_cache_size = -1;
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
-	c->x86_vendor_id[0] = '\0'; /* Unset */
-	c->x86_model_id[0] = '\0';  /* Unset */
-	c->x86_clflush_size = 64;
-	c->x86_cache_alignment = c->x86_clflush_size;
-	c->x86_max_cores = 1;
-	c->x86_coreid_bits = 0;
-	c->extended_cpuid_level = 0;
-	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-
-	/* Get vendor name */
-	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
-	      (unsigned int *)&c->x86_vendor_id[0],
-	      (unsigned int *)&c->x86_vendor_id[8],
-	      (unsigned int *)&c->x86_vendor_id[4]);
-
-	get_cpu_vendor(c);
-
-	/* Initialize the standard set of capabilities */
-	/* Note that the vendor-specific code below might override */
-
-	/* Intel-defined flags: level 0x00000001 */
-	if (c->cpuid_level >= 0x00000001) {
-		__u32 misc;
-		cpuid(0x00000001, &tfms, &misc, &c->x86_capability[4],
-		      &c->x86_capability[0]);
-		c->x86 = (tfms >> 8) & 0xf;
-		c->x86_model = (tfms >> 4) & 0xf;
-		c->x86_mask = tfms & 0xf;
-		if (c->x86 == 0xf)
-			c->x86 += (tfms >> 20) & 0xff;
-		if (c->x86 >= 0x6)
-			c->x86_model += ((tfms >> 16) & 0xF) << 4;
-		if (test_cpu_cap(c, X86_FEATURE_CLFLSH))
-			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
-	} else {
-		/* Have CPUID level 0 only - unheard of */
-		c->x86 = 4;
-	}
-
-	c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xff;
-#ifdef CONFIG_SMP
-	c->phys_proc_id = c->initial_apicid;
-#endif
-	/* AMD-defined flags: level 0x80000001 */
-	xlvl = cpuid_eax(0x80000000);
-	c->extended_cpuid_level = xlvl;
-	if ((xlvl & 0xffff0000) == 0x80000000) {
-		if (xlvl >= 0x80000001) {
-			c->x86_capability[1] = cpuid_edx(0x80000001);
-			c->x86_capability[6] = cpuid_ecx(0x80000001);
-		}
-		if (xlvl >= 0x80000004)
-			get_model_name(c); /* Default name */
-	}
-
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		/* Don't set x86_cpuid_level here for now to not confuse. */
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
-	}
-
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
-	if (c->extended_cpuid_level >= 0x80000008) {
-		u32 eax = cpuid_eax(0x80000008);
-
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-	}
-
-	detect_nopl(c);
-
-	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
-	    cpu_devs[c->x86_vendor]->c_early_init)
-		cpu_devs[c->x86_vendor]->c_early_init(c);
-
-	validate_pat_support(c);
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-
-	early_identify_cpu(c);
-
-	init_scattered_cpuid_features(c);
-
-	c->apicid = phys_pkg_id(0);
-
-	/*
-	 * Vendor-specific initialization.  In this section we
-	 * canonicalize the feature flags, meaning if there are
-	 * features a certain CPU supports which CPUID doesn't
-	 * tell us, CPUID claiming incorrect flags, or other bugs,
-	 * we handle them here.
-	 *
-	 * At the end of this section, c->x86_capability better
-	 * indicate the features this CPU genuinely supports!
-	 */
-	if (this_cpu->c_init)
-		this_cpu->c_init(c);
-
-	detect_ht(c);
-
-	/*
-	 * On SMP, boot_cpu_data holds the common feature set between
-	 * all CPUs; so make sure that we indicate which features are
-	 * common between the CPUs.  The first time this routine gets
-	 * executed, c == &boot_cpu_data.
-	 */
-	if (c != &boot_cpu_data) {
-		/* AND the already accumulated flags with these */
-		for (i = 0; i < NCAPINTS; i++)
-			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
-	}
-
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
-#ifdef CONFIG_X86_MCE
-	mcheck_init(c);
-#endif
-	select_idle_routine(c);
-
-#ifdef CONFIG_NUMA
-	numa_add_cpu(smp_processor_id());
-#endif
-
-}
-
-void __cpuinit identify_boot_cpu(void)
-{
-	identify_cpu(&boot_cpu_data);
-}
-
-void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
-{
-	BUG_ON(c == &boot_cpu_data);
-	identify_cpu(c);
-	mtrr_ap_init();
-}
-
-static __init int setup_noclflush(char *arg)
-{
-	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
-	return 1;
-}
-__setup("noclflush", setup_noclflush);
-
-struct msr_range {
-	unsigned min;
-	unsigned max;
-};
-
-static struct msr_range msr_range_array[] __cpuinitdata = {
-	{ 0x00000000, 0x00000418},
-	{ 0xc0000000, 0xc000040b},
-	{ 0xc0010000, 0xc0010142},
-	{ 0xc0011000, 0xc001103b},
-};
-
-static void __cpuinit print_cpu_msr(void)
-{
-	unsigned index;
-	u64 val;
-	int i;
-	unsigned index_min, index_max;
-
-	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
-		index_min = msr_range_array[i].min;
-		index_max = msr_range_array[i].max;
-		for (index = index_min; index < index_max; index++) {
-			if (rdmsrl_amd_safe(index, &val))
-				continue;
-			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
-		}
-	}
-}
-
-static int show_msr __cpuinitdata;
-static __init int setup_show_msr(char *arg)
-{
-	int num;
-
-	get_option(&arg, &num);
-
-	if (num > 0)
-		show_msr = num;
-	return 1;
-}
-__setup("show_msr=", setup_show_msr);
-
-void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
-{
-	if (c->x86_model_id[0])
-		printk(KERN_CONT "%s", c->x86_model_id);
-
-	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
-	else
-		printk(KERN_CONT "\n");
-
-#ifdef CONFIG_SMP
-	if (c->cpu_index < show_msr)
-		print_cpu_msr();
-#else
-	if (show_msr)
-		print_cpu_msr();
-#endif
-}
-
-static __init int setup_disablecpuid(char *arg)
-{
-	int bit;
-	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
-		setup_clear_cpu_cap(bit);
-	else
-		return 0;
-	return 1;
-}
-__setup("clearcpuid=", setup_disablecpuid);
-
-cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
-
-struct x8664_pda **_cpu_pda __read_mostly;
-EXPORT_SYMBOL(_cpu_pda);
-
-struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
-
-char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
-
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
-EXPORT_SYMBOL_GPL(__supported_pte_mask);
-
-static int do_not_nx __cpuinitdata;
-
-/* noexec=on|off
-Control non executable mappings for 64bit processes.
-
-on	Enable(default)
-off	Disable
-*/
-static int __init nonx_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		do_not_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		do_not_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", nonx_setup);
-
-int force_personality32;
-
-/* noexec32=on|off
-Control non executable heap for 32bit processes.
-To control the stack too use noexec=off
-
-on	PROT_READ does not imply PROT_EXEC for 32bit processes (default)
-off	PROT_READ implies PROT_EXEC
-*/
-static int __init nonx32_setup(char *str)
-{
-	if (!strcmp(str, "on"))
-		force_personality32 &= ~READ_IMPLIES_EXEC;
-	else if (!strcmp(str, "off"))
-		force_personality32 |= READ_IMPLIES_EXEC;
-	return 1;
-}
-__setup("noexec32=", nonx32_setup);
-
-void pda_init(int cpu)
-{
-	struct x8664_pda *pda = cpu_pda(cpu);
-
-	/* Setup up data that may be needed in __get_free_pages early */
-	loadsegment(fs, 0);
-	loadsegment(gs, 0);
-	/* Memory clobbers used to order PDA accessed */
-	mb();
-	wrmsrl(MSR_GS_BASE, pda);
-	mb();
-
-	pda->cpunumber = cpu;
-	pda->irqcount = -1;
-	pda->kernelstack = (unsigned long)stack_thread_info() -
-				 PDA_STACKOFFSET + THREAD_SIZE;
-	pda->active_mm = &init_mm;
-	pda->mmu_state = 0;
-
-	if (cpu == 0) {
-		/* others are initialized in smpboot.c */
-		pda->pcurrent = &init_task;
-		pda->irqstackptr = boot_cpu_stack;
-		pda->irqstackptr += IRQSTACKSIZE - 64;
-	} else {
-		if (!pda->irqstackptr) {
-			pda->irqstackptr = (char *)
-				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-			if (!pda->irqstackptr)
-				panic("cannot allocate irqstack for cpu %d",
-				      cpu);
-			pda->irqstackptr += IRQSTACKSIZE - 64;
-		}
-
-		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
-			pda->nodenumber = cpu_to_node(cpu);
-	}
-}
-
-char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-			   DEBUG_STKSZ] __page_aligned_bss;
-
-extern asmlinkage void ignore_sysret(void);
-
-/* May not be marked __init: used by software suspend */
-void syscall_init(void)
-{
-	/*
-	 * LSTAR and STAR live in a bit strange symbiosis.
-	 * They both write to the same internal register. STAR allows to
-	 * set CS/DS but only a 32bit target. LSTAR sets the 64bit rip.
-	 */
-	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);
-	wrmsrl(MSR_LSTAR, system_call);
-	wrmsrl(MSR_CSTAR, ignore_sysret);
-
-#ifdef CONFIG_IA32_EMULATION
-	syscall32_cpu_init();
-#endif
-
-	/* Flags to clear on syscall */
-	wrmsrl(MSR_SYSCALL_MASK,
-	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|X86_EFLAGS_IOPL);
-}
-
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || do_not_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-
-unsigned long kernel_eflags;
-
-/*
- * Copies of the original ist values from the tss are only accessed during
- * debugging, no special alignment required.
- */
-DEFINE_PER_CPU(struct orig_ist, orig_ist);
-
-/*
- * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
- * A lot of state is already set up in PDA init.
- */
-void __cpuinit cpu_init(void)
-{
-	int cpu = stack_smp_processor_id();
-	struct tss_struct *t = &per_cpu(init_tss, cpu);
-	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
-	unsigned long v;
-	char *estacks = NULL;
-	struct task_struct *me;
-	int i;
-
-	/* CPU 0 is initialised in head64.c */
-	if (cpu != 0)
-		pda_init(cpu);
-	else
-		estacks = boot_exception_stacks;
-
-	me = current;
-
-	if (cpu_test_and_set(cpu, cpu_initialized))
-		panic("CPU#%d already initialized!\n", cpu);
-
-	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
-
-	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
-
-	/*
-	 * Initialize the per-CPU GDT with the boot GDT,
-	 * and set up the GDT descriptor:
-	 */
-
-	switch_to_new_gdt();
-	load_idt((const struct desc_ptr *)&idt_descr);
-
-	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
-	syscall_init();
-
-	wrmsrl(MSR_FS_BASE, 0);
-	wrmsrl(MSR_KERNEL_GS_BASE, 0);
-	barrier();
-
-	check_efer();
-
-	/*
-	 * set up and load the per-CPU TSS
-	 */
-	if (!orig_ist->ist[0]) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
-		};
-		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-			if (cpu) {
-				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-				if (!estacks)
-					panic("Cannot allocate exception "
-					      "stack %ld %d\n", v, cpu);
-			}
-			estacks += PAGE_SIZE << order[v];
-			orig_ist->ist[v] = t->x86_tss.ist[v] =
-					(unsigned long)estacks;
-		}
-	}
-
-	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
-	/*
-	 * <= is required because the CPU will access up to
-	 * 8 bits beyond the end of the IO permission bitmap.
-	 */
-	for (i = 0; i <= IO_BITMAP_LONGS; i++)
-		t->io_bitmap[i] = ~0UL;
-
-	atomic_inc(&init_mm.mm_count);
-	me->active_mm = &init_mm;
-	if (me->mm)
-		BUG();
-	enter_lazy_tlb(&init_mm, me);
-
-	load_sp0(t, &current->thread);
-	set_tss_desc(cpu, t);
-	load_TR_desc();
-	load_LDT(&init_mm.context);
-
-#ifdef CONFIG_KGDB
-	/*
-	 * If the kgdb is connected no debug regs should be altered.  This
-	 * is only applicable when KGDB and a KGDB I/O module are built
-	 * into the kernel and you are using early debugging with
-	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
-	 */
-	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
-		arch_kgdb_ops.correct_hw_break();
-	else {
-#endif
-	/*
-	 * Clear all 6 debug registers:
-	 */
-
-	set_debugreg(0UL, 0);
-	set_debugreg(0UL, 1);
-	set_debugreg(0UL, 2);
-	set_debugreg(0UL, 3);
-	set_debugreg(0UL, 6);
-	set_debugreg(0UL, 7);
-#ifdef CONFIG_KGDB
-	/* If the kgdb is connected no debug regs should be altered. */
-	}
-#endif
-
-	fpu_init();
-
-	raw_local_save_flags(kernel_eflags);
-
-	if (is_uv_system())
-		uv_cpu_init();
-}
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 4d894e8..de4094a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -21,23 +21,16 @@ struct cpu_dev {
 	void		(*c_init)(struct cpuinfo_x86 * c);
 	void		(*c_identify)(struct cpuinfo_x86 * c);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
+	int	c_x86_vendor;
 };
 
-extern struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
+#define cpu_dev_register(cpu_devX) \
+	static struct cpu_dev *__cpu_dev_##cpu_devX __used \
+	__attribute__((__section__(".x86_cpu_dev.init"))) = \
+	&cpu_devX;
 
-struct cpu_vendor_dev {
-	int vendor;
-	struct cpu_dev *cpu_dev;
-};
-
-#define cpu_vendor_dev_register(cpu_vendor_id, cpu_dev) \
-	static struct cpu_vendor_dev __cpu_vendor_dev_##cpu_vendor_id __used \
-	__attribute__((__section__(".x86cpuvendor.init"))) = \
-	{ cpu_vendor_id, cpu_dev }
-
-extern struct cpu_vendor_dev __x86cpuvendor_start[], __x86cpuvendor_end[];
+extern struct cpu_dev *__x86_cpu_dev_start[], *__x86_cpu_dev_end[];
 
-extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 898a5a2..ffd0f5e 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -121,7 +121,7 @@ static void __cpuinit set_cx86_reorder(void)
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
 
 	/* Load/Store Serialize to mem access disable (=reorder it) */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) & ~0x80);
+	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) & ~0x80);
 	/* set load/store serialize from 1GB to 4GB */
 	ccr3 |= 0xe0;
 	setCx86(CX86_CCR3, ccr3);
@@ -132,11 +132,11 @@ static void __cpuinit set_cx86_memwb(void)
 	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
 	/* CCR2 bit 2: unlock NW bit */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) & ~0x04);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) & ~0x04);
 	/* set 'Not Write-through' */
 	write_cr0(read_cr0() | X86_CR0_NW);
 	/* CCR2 bit 2: lock NW bit and set WT1 */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x14);
 }
 
 /*
@@ -150,14 +150,14 @@ static void __cpuinit geode_configure(void)
 	local_irq_save(flags);
 
 	/* Suspend on halt power saving and enable #SUSP pin */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x88);
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
 
 
 	/* FPU fast, DTE cache, Mem bypass */
-	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
+	setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x38);
 	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 
 	set_cx86_memwb();
@@ -291,7 +291,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		/* GXm supports extended cpuid levels 'ala' AMD */
 		if (c->cpuid_level == 2) {
 			/* Enable cxMMX extensions (GX1 Datasheet 54) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
+			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7) | 1);
 
 			/*
 			 * GXm : 0x30 ... 0x5f GXm  datasheet 51
@@ -301,7 +301,6 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 			 */
 			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
 				geode_configure();
-			get_model_name(c);  /* get CPU marketing name */
 			return;
 		} else { /* MediaGX */
 			Cx86_cb[2] = (dir0_lsn & 1) ? '3' : '4';
@@ -314,7 +313,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		if (dir1 > 7) {
 			dir0_msn++;  /* M II */
 			/* Enable MMX extensions (App note 108) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
+			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7)|1);
 		} else {
 			c->coma_bug = 1;      /* 6x86MX, it has the bug. */
 		}
@@ -429,7 +428,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
 			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
-			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */
+			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);  /* enable cpuid  */
 			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
 			local_irq_restore(flags);
 		}
@@ -442,14 +441,16 @@ static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_early_init	= early_init_cyrix,
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
+	.c_x86_vendor	= X86_VENDOR_CYRIX,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CYRIX, &cyrix_cpu_dev);
+cpu_dev_register(cyrix_cpu_dev);
 
 static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
 	.c_vendor	= "NSC",
 	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
+	.c_x86_vendor	= X86_VENDOR_NSC,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_NSC, &nsc_cpu_dev);
+cpu_dev_register(nsc_cpu_dev);
diff --git a/arch/x86/kernel/cpu/feature_names.c b/arch/x86/kernel/cpu/feature_names.c
deleted file mode 100644
index c901779..0000000
--- a/arch/x86/kernel/cpu/feature_names.c
+++ /dev/null
@@ -1,84 +0,0 @@
-/*
- * Strings for the various x86 capability flags.
- *
- * This file must not contain any executable code.
- */
-
-#include <asm/cpufeature.h>
-
-/*
- * These flag bits must match the definitions in <asm/cpufeature.h>.
- * NULL means this bit is undefined or reserved; either way it doesn't
- * have meaning as far as Linux is concerned.  Note that it's important
- * to realize there is a difference between this table and CPUID -- if
- * applications want to get the raw CPUID data, they should access
- * /dev/cpu/<cpu_nr>/cpuid instead.
- */
-const char * const x86_cap_flags[NCAPINTS*32] = {
-	/* Intel-defined */
-	"fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
-	"cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
-	"pat", "pse36", "pn", "clflush", NULL, "dts", "acpi", "mmx",
-	"fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", "pbe",
-
-	/* AMD-defined */
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, "mp", "nx", NULL, "mmxext", NULL,
-	NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm",
-	"3dnowext", "3dnow",
-
-	/* Transmeta-defined */
-	"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* Other (Linux-defined) */
-	"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
-	NULL, NULL, NULL, NULL,
-	"constant_tsc", "up", NULL, "arch_perfmon",
-	"pebs", "bts", NULL, NULL,
-	"rep_good", NULL, NULL, NULL,
-	"nopl", NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* Intel-defined (#2) */
-	"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
-	"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-	NULL, NULL, "dca", "sse4_1", "sse4_2", NULL, NULL, "popcnt",
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* VIA/Cyrix/Centaur-defined */
-	NULL, NULL, "rng", "rng_en", NULL, NULL, "ace", "ace_en",
-	"ace2", "ace2_en", "phe", "phe_en", "pmm", "pmm_en", NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* AMD-defined (#2) */
-	"lahf_lm", "cmp_legacy", "svm", "extapic",
-	"cr8_legacy", "abm", "sse4a", "misalignsse",
-	"3dnowprefetch", "osvw", "ibs", "sse5",
-	"skinit", "wdt", NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-
-	/* Auxiliary (Linux-defined) */
-	"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-};
-
-const char *const x86_power_flags[32] = {
-	"ts",	/* temperature sensor */
-	"fid",  /* frequency id control */
-	"vid",  /* voltage id control */
-	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
-	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
-};
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index f113ef4..99468db 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -15,6 +15,11 @@
 #include <asm/ds.h>
 #include <asm/bugs.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/topology.h>
+#include <asm/numa_64.h>
+#endif
+
 #include "cpu.h"
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -23,23 +28,22 @@
 #include <mach_apic.h>
 #endif
 
-#ifdef CONFIG_X86_INTEL_USERCOPY
-/*
- * Alignment at which movsl is preferred for bulk memory copies.
- */
-struct movsl_mask movsl_mask __read_mostly;
-#endif
-
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
-	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
-	if (c->x86 == 15 && c->x86_cache_alignment == 64)
-		c->x86_cache_alignment = 128;
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
+#else
+	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
+	if (c->x86 == 15 && c->x86_cache_alignment == 64)
+		c->x86_cache_alignment = 128;
+#endif
 }
 
+#ifdef CONFIG_X86_32
 /*
  *	Early probe support logic for ppro memory erratum #50
  *
@@ -59,15 +63,54 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+static void __cpuinit trap_init_f00f_bug(void)
+{
+	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
 
-/*
- * P4 Xeon errata 037 workaround.
- * Hardware prefetcher may cause stale data to be loaded into the cache.
- */
-static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
+	/*
+	 * Update the IDT descriptor and reload the IDT so that
+	 * it uses the read-only mapped virtual address.
+	 */
+	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
+	load_idt(&idt_descr);
+}
+#endif
+
+static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
+#ifdef CONFIG_X86_F00F_BUG
+	/*
+	 * All current models of Pentium and Pentium with MMX technology CPUs
+	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
+	 * Note that the workaround only should be initialized once...
+	 */
+	c->f00f_bug = 0;
+	if (!paravirt_enabled() && c->x86 == 5) {
+		static int f00f_workaround_enabled;
+
+		c->f00f_bug = 1;
+		if (!f00f_workaround_enabled) {
+			trap_init_f00f_bug();
+			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
+			f00f_workaround_enabled = 1;
+		}
+	}
+#endif
+
+	/*
+	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
+	 * model 3 mask 3
+	 */
+	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+		clear_cpu_cap(c, X86_FEATURE_SEP);
+
+	/*
+	 * P4 Xeon errata 037 workaround.
+	 * Hardware prefetcher may cause stale data to be loaded into the cache.
+	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
 		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		if ((lo & (1<<9)) == 0) {
@@ -77,13 +120,68 @@ static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
 			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
 		}
 	}
+
+	/*
+	 * See if we have a good local APIC by checking for buggy Pentia,
+	 * i.e. all B steppings and the C2 stepping of P54C when using their
+	 * integrated APIC (see 11AP erratum in "Pentium Processor
+	 * Specification Update").
+	 */
+	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
+	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
+		set_cpu_cap(c, X86_FEATURE_11AP);
+
+
+#ifdef CONFIG_X86_INTEL_USERCOPY
+	/*
+	 * Set up the preferred alignment for movsl bulk memory moves
+	 */
+	switch (c->x86) {
+	case 4:		/* 486: untested */
+		break;
+	case 5:		/* Old Pentia: untested */
+		break;
+	case 6:		/* PII/PIII only like movsl with 8-byte alignment */
+		movsl_mask.mask = 7;
+		break;
+	case 15:	/* P4 is OK down to 8-byte alignment */
+		movsl_mask.mask = 7;
+		break;
+	}
+#endif
+
+#ifdef CONFIG_X86_NUMAQ
+	numaq_tsc_disable();
+#endif
 }
+#else
+static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+{
+}
+#endif
 
+static void __cpuinit srat_detect_node(void)
+{
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	unsigned node;
+	int cpu = smp_processor_id();
+	int apicid = hard_smp_processor_id();
+
+	/* Don't do the funky fallback heuristics the AMD version employs
+	   for now. */
+	node = apicid_to_node[apicid];
+	if (node == NUMA_NO_NODE || !node_online(node))
+		node = first_node(node_online_map);
+	numa_set_node(cpu, node);
+
+	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+}
 
 /*
  * find out the number of processor cores on the die
  */
-static int __cpuinit num_cpu_cores(struct cpuinfo_x86 *c)
+static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -98,45 +196,51 @@ static int __cpuinit num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
+static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 {
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
+	/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+
+	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
+
+	clear_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	clear_cpu_cap(c, X86_FEATURE_VNMI);
+	clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
+	clear_cpu_cap(c, X86_FEATURE_EPT);
+	clear_cpu_cap(c, X86_FEATURE_VPID);
+
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
+	msr_ctl = vmx_msr_high | vmx_msr_low;
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
+		set_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
+		set_cpu_cap(c, X86_FEATURE_VNMI);
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      vmx_msr_low, vmx_msr_high);
+		msr_ctl2 = vmx_msr_high | vmx_msr_low;
+		if ((msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC) &&
+		    (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW))
+			set_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_EPT)
+			set_cpu_cap(c, X86_FEATURE_EPT);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
+			set_cpu_cap(c, X86_FEATURE_VPID);
+	}
 }
-#endif
 
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
-	char *p = NULL;
 
 	early_init_intel(c);
 
-#ifdef CONFIG_X86_F00F_BUG
-	/*
-	 * All current models of Pentium and Pentium with MMX technology CPUs
-	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
-	 * Note that the workaround only should be initialized once...
-	 */
-	c->f00f_bug = 0;
-	if (!paravirt_enabled() && c->x86 == 5) {
-		static int f00f_workaround_enabled;
-
-		c->f00f_bug = 1;
-		if (!f00f_workaround_enabled) {
-			trap_init_f00f_bug();
-			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
-			f00f_workaround_enabled = 1;
-		}
-	}
-#endif
+	intel_workarounds(c);
 
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
@@ -146,16 +250,32 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-	/* SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until model 3 mask 3 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
-		clear_cpu_cap(c, X86_FEATURE_SEP);
+	if (cpu_has_xmm2)
+		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+	if (cpu_has_ds) {
+		unsigned int l1;
+		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
+		if (!(l1 & (1<<11)))
+			set_cpu_cap(c, X86_FEATURE_BTS);
+		if (!(l1 & (1<<12)))
+			set_cpu_cap(c, X86_FEATURE_PEBS);
+		ds_init_intel(c);
+	}
 
+#ifdef CONFIG_X86_64
+	if (c->x86 == 15)
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+	if (c->x86 == 6)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
 	/*
 	 * Names for the Pentium II/Celeron processors
 	 * detectable only by also checking the cache size.
 	 * Dixon is NOT a Celeron.
 	 */
 	if (c->x86 == 6) {
+		char *p = NULL;
+
 		switch (c->x86_model) {
 		case 5:
 			if (c->x86_mask == 0) {
@@ -178,71 +298,41 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 				p = "Celeron (Coppermine)";
 			break;
 		}
-	}
-
-	if (p)
-		strcpy(c->x86_model_id, p);
-
-	c->x86_max_cores = num_cpu_cores(c);
-
-	detect_ht(c);
 
-	/* Work around errata */
-	Intel_errata_workarounds(c);
-
-#ifdef CONFIG_X86_INTEL_USERCOPY
-	/*
-	 * Set up the preferred alignment for movsl bulk memory moves
-	 */
-	switch (c->x86) {
-	case 4:		/* 486: untested */
-		break;
-	case 5:		/* Old Pentia: untested */
-		break;
-	case 6:		/* PII/PIII only like movsl with 8-byte alignment */
-		movsl_mask.mask = 7;
-		break;
-	case 15:	/* P4 is OK down to 8-byte alignment */
-		movsl_mask.mask = 7;
-		break;
+		if (p)
+			strcpy(c->x86_model_id, p);
 	}
-#endif
 
-	if (cpu_has_xmm2)
-		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	if (c->x86 == 15) {
+	if (c->x86 == 15)
 		set_cpu_cap(c, X86_FEATURE_P4);
-	}
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_P3);
-	if (cpu_has_ds) {
-		unsigned int l1;
-		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
-		if (!(l1 & (1<<11)))
-			set_cpu_cap(c, X86_FEATURE_BTS);
-		if (!(l1 & (1<<12)))
-			set_cpu_cap(c, X86_FEATURE_PEBS);
-		ds_init_intel(c);
-	}
 
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
 
-	/*
-	 * See if we have a good local APIC by checking for buggy Pentia,
-	 * i.e. all B steppings and the C2 stepping of P54C when using their
-	 * integrated APIC (see 11AP erratum in "Pentium Processor
-	 * Specification Update").
-	 */
-	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
-	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
-		set_cpu_cap(c, X86_FEATURE_11AP);
+#endif
 
-#ifdef CONFIG_X86_NUMAQ
-	numaq_tsc_disable();
+	detect_extended_topology(c);
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = intel_num_cpu_cores(c);
+#ifdef CONFIG_X86_32
+		detect_ht(c);
 #endif
+	}
+
+	/* Work around errata */
+	srat_detect_node();
+
+	if (cpu_has(c, X86_FEATURE_VMX))
+		detect_vmx_virtcap(c);
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/*
@@ -255,10 +345,12 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 		size = 256;
 	return size;
 }
+#endif
 
 static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
+#ifdef CONFIG_X86_32
 	.c_models = {
 		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names =
 		  {
@@ -308,76 +400,12 @@ static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_size_cache	= intel_size_cache,
+#endif
 	.c_early_init   = early_init_intel,
 	.c_init		= init_intel,
-	.c_size_cache	= intel_size_cache,
+	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
-
-#ifndef CONFIG_X86_CMPXCHG
-unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
-{
-	u8 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u8 *)ptr;
-	if (prev == old)
-		*(u8 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u8);
-
-unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
-{
-	u16 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u16 *)ptr;
-	if (prev == old)
-		*(u16 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u16);
-
-unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
-{
-	u32 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u32 *)ptr;
-	if (prev == old)
-		*(u32 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u32);
-#endif
-
-#ifndef CONFIG_X86_CMPXCHG64
-unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
-{
-	u64 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u64 *)ptr;
-	if (prev == old)
-		*(u64 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_486_u64);
-#endif
-
-/* arch_initcall(intel_cpu_init); */
+cpu_dev_register(intel_cpu_dev);
 
diff --git a/arch/x86/kernel/cpu/intel_64.c b/arch/x86/kernel/cpu/intel_64.c
deleted file mode 100644
index 1019c58..0000000
--- a/arch/x86/kernel/cpu/intel_64.c
+++ /dev/null
@@ -1,95 +0,0 @@
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <asm/processor.h>
-#include <asm/ptrace.h>
-#include <asm/topology.h>
-#include <asm/numa_64.h>
-
-#include "cpu.h"
-
-static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
-{
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-}
-
-/*
- * find out the number of processor cores on the die
- */
-static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
-{
-	unsigned int eax, t;
-
-	if (c->cpuid_level < 4)
-		return 1;
-
-	cpuid_count(4, 0, &eax, &t, &t, &t);
-
-	if (eax & 0x1f)
-		return ((eax >> 26) + 1);
-	else
-		return 1;
-}
-
-static void __cpuinit srat_detect_node(void)
-{
-#ifdef CONFIG_NUMA
-	unsigned node;
-	int cpu = smp_processor_id();
-	int apicid = hard_smp_processor_id();
-
-	/* Don't do the funky fallback heuristics the AMD version employs
-	   for now. */
-	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE || !node_online(node))
-		node = first_node(node_online_map);
-	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
-#endif
-}
-
-static void __cpuinit init_intel(struct cpuinfo_x86 *c)
-{
-	init_intel_cacheinfo(c);
-	if (c->cpuid_level > 9) {
-		unsigned eax = cpuid_eax(10);
-		/* Check for version and the number of counters */
-		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
-			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-	}
-
-	if (cpu_has_ds) {
-		unsigned int l1, l2;
-		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
-		if (!(l1 & (1<<11)))
-			set_cpu_cap(c, X86_FEATURE_BTS);
-		if (!(l1 & (1<<12)))
-			set_cpu_cap(c, X86_FEATURE_PEBS);
-	}
-
-
-	if (cpu_has_bts)
-		ds_init_intel(c);
-
-	if (c->x86 == 15)
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if (c->x86 == 6)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	c->x86_max_cores = intel_num_cpu_cores(c);
-
-	srat_detect_node();
-}
-
-static struct cpu_dev intel_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Intel",
-	.c_ident	= { "GenuineIntel" },
-	.c_early_init   = early_init_intel,
-	.c_init		= init_intel,
-};
-cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
-
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6b0a10b..3f46afb 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1,8 +1,8 @@
 /*
- *      Routines to indentify caches on Intel CPU.
+ *	Routines to indentify caches on Intel CPU.
  *
- *      Changes:
- *      Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
+ *	Changes:
+ *	Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
  *		Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
  *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
@@ -13,6 +13,7 @@
 #include <linux/compiler.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/pci.h>
 
 #include <asm/processor.h>
 #include <asm/smp.h>
@@ -130,9 +131,18 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
+	unsigned long can_disable;
 	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
 };
 
+#ifdef CONFIG_PCI
+static struct pci_device_id k8_nb_id[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+	{}
+};
+#endif
+
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -182,9 +192,10 @@ static unsigned short assocs[] __cpuinitdata = {
 static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
 static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
 
-static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
-		       union _cpuid4_leaf_ebx *ebx,
-		       union _cpuid4_leaf_ecx *ecx)
+static void __cpuinit
+amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
+		     union _cpuid4_leaf_ebx *ebx,
+		     union _cpuid4_leaf_ecx *ecx)
 {
 	unsigned dummy;
 	unsigned line_size, lines_per_tag, assoc, size_in_kb;
@@ -251,27 +262,40 @@ static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
-static int __cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+static void __cpuinit
+amd_check_l3_disable(int index, struct _cpuid4_info *this_leaf)
+{
+	if (index < 3)
+		return;
+	this_leaf->can_disable = 1;
+}
+
+static int
+__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
 {
 	union _cpuid4_leaf_eax 	eax;
 	union _cpuid4_leaf_ebx 	ebx;
 	union _cpuid4_leaf_ecx 	ecx;
 	unsigned		edx;
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-	else
-		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full,  &edx);
+		if (boot_cpu_data.x86 >= 0x10)
+			amd_check_l3_disable(index, this_leaf);
+	} else {
+		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
+	}
+
 	if (eax.split.type == CACHE_TYPE_NULL)
 		return -EIO; /* better error ? */
 
 	this_leaf->eax = eax;
 	this_leaf->ebx = ebx;
 	this_leaf->ecx = ecx;
-	this_leaf->size = (ecx.split.number_of_sets + 1) *
-		(ebx.split.coherency_line_size + 1) *
-		(ebx.split.physical_line_partition + 1) *
-		(ebx.split.ways_of_associativity + 1);
+	this_leaf->size = (ecx.split.number_of_sets          + 1) *
+			  (ebx.split.coherency_line_size     + 1) *
+			  (ebx.split.physical_line_partition + 1) *
+			  (ebx.split.ways_of_associativity   + 1);
 	return 0;
 }
 
@@ -453,7 +477,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
-#define CPUID4_INFO_IDX(x, y)    (&((per_cpu(cpuid4_info, x))[y]))
+#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
@@ -490,7 +514,7 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
-		sibling_leaf = CPUID4_INFO_IDX(sibling, index);	
+		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
 }
@@ -572,7 +596,7 @@ struct _index_kobject {
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
 static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)    (&((per_cpu(index_kobject, x))[y]))
+#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
 static ssize_t show_##file_name						\
@@ -637,6 +661,99 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf) {
 	}
 }
 
+#define to_object(k)	container_of(k, struct _index_kobject, kobj)
+#define to_attr(a)	container_of(a, struct _cache_attr, attr)
+
+#ifdef CONFIG_PCI
+static struct pci_dev *get_k8_northbridge(int node)
+{
+	struct pci_dev *dev = NULL;
+	int i;
+
+	for (i = 0; i <= node; i++) {
+		do {
+			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
+			if (!dev)
+				break;
+		} while (!pci_match_id(&k8_nb_id[0], dev));
+		if (!dev)
+			break;
+	}
+	return dev;
+}
+#else
+static struct pci_dev *get_k8_northbridge(int node)
+{
+	return NULL;
+}
+#endif
+
+static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
+{
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	struct pci_dev *dev = NULL;
+	ssize_t ret = 0;
+	int i;
+
+	if (!this_leaf->can_disable)
+		return sprintf(buf, "Feature not enabled\n");
+
+	dev = get_k8_northbridge(node);
+	if (!dev) {
+		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 2; i++) {
+		unsigned int reg;
+
+		pci_read_config_dword(dev, 0x1BC + i * 4, &reg);
+
+		ret += sprintf(buf, "%sEntry: %d\n", buf, i);
+		ret += sprintf(buf, "%sReads:  %s\tNew Entries: %s\n",  
+			buf,
+			reg & 0x80000000 ? "Disabled" : "Allowed",
+			reg & 0x40000000 ? "Disabled" : "Allowed");
+		ret += sprintf(buf, "%sSubCache: %x\tIndex: %x\n",
+			buf, (reg & 0x30000) >> 16, reg & 0xfff);
+	}
+	return ret;
+}
+
+static ssize_t
+store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
+		    size_t count)
+{
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	struct pci_dev *dev = NULL;
+	unsigned int ret, index, val;
+
+	if (!this_leaf->can_disable)
+		return 0;
+
+	if (strlen(buf) > 15)
+		return -EINVAL;
+
+	ret = sscanf(buf, "%x %x", &index, &val);
+	if (ret != 2)
+		return -EINVAL;
+	if (index > 1)
+		return -EINVAL;
+
+	val |= 0xc0000000;
+	dev = get_k8_northbridge(node);
+	if (!dev) {
+		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
+		return -EINVAL;
+	}
+
+	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
+	wbinvd();
+	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+
+	return 1;
+}
+
 struct _cache_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct _cpuid4_info *, char *);
@@ -657,6 +774,8 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
+static struct _cache_attr cache_disable = __ATTR(cache_disable, 0644, show_cache_disable, store_cache_disable);
+
 static struct attribute * default_attrs[] = {
 	&type.attr,
 	&level.attr,
@@ -667,12 +786,10 @@ static struct attribute * default_attrs[] = {
 	&size.attr,
 	&shared_cpu_map.attr,
 	&shared_cpu_list.attr,
+	&cache_disable.attr,
 	NULL
 };
 
-#define to_object(k) container_of(k, struct _index_kobject, kobj)
-#define to_attr(a) container_of(a, struct _cache_attr, attr)
-
 static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
 {
 	struct _cache_attr *fattr = to_attr(attr);
@@ -682,14 +799,22 @@ static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
 	ret = fattr->show ?
 		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
 			buf) :
-	       	0;
+		0;
 	return ret;
 }
 
 static ssize_t store(struct kobject * kobj, struct attribute * attr,
 		     const char * buf, size_t count)
 {
-	return 0;
+	struct _cache_attr *fattr = to_attr(attr);
+	struct _index_kobject *this_leaf = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->store ?
+		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
+			buf, count) :
+		0;
+	return ret;
 }
 
 static struct sysfs_ops sysfs_ops = {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 726a5fc..4b031a4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -860,7 +860,7 @@ error:
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
diff --git a/arch/x86/kernel/cpu/mkcapflags.pl b/arch/x86/kernel/cpu/mkcapflags.pl
new file mode 100644
index 0000000..dfea390
--- /dev/null
+++ b/arch/x86/kernel/cpu/mkcapflags.pl
@@ -0,0 +1,32 @@
+#!/usr/bin/perl
+#
+# Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
+#
+
+($in, $out) = @ARGV;
+
+open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
+open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
+
+print OUT "#include <asm/cpufeature.h>\n\n";
+print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
+
+while (defined($line = <IN>)) {
+	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
+		$macro = $1;
+		$feature = $2;
+		$tail = $3;
+		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
+			$feature = $1;
+		}
+
+		if ($feature ne '') {
+			printf OUT "\t%-32s = \"%s\",\n",
+				"[$macro]", "\L$feature";
+		}
+	}
+}
+print OUT "};\n";
+
+close(IN);
+close(OUT);
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
new file mode 100644
index 0000000..5abbea2
--- /dev/null
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -0,0 +1,20 @@
+/*
+ * Strings for the various x86 power flags
+ *
+ * This file must not contain any executable code.
+ */
+
+#include <asm/cpufeature.h>
+
+const char *const x86_power_flags[32] = {
+	"ts",	/* temperature sensor */
+	"fid",  /* frequency id control */
+	"vid",  /* voltage id control */
+	"ttp",  /* thermal trip */
+	"tm",
+	"stc",
+	"100mhzsteps",
+	"hwpstate",
+	"",	/* tsc invariant mapped to constant_tsc */
+		/* nothing */
+};
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index b911a2c..52b3fef 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -5,6 +5,18 @@
 #include <asm/msr.h>
 #include "cpu.h"
 
+static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
+{
+	u32 xlvl;
+
+	/* Transmeta-defined flags: level 0x80860001 */
+	xlvl = cpuid_eax(0x80860000);
+	if ((xlvl & 0xffff0000) == 0x80860000) {
+		if (xlvl >= 0x80860001)
+			c->x86_capability[2] = cpuid_edx(0x80860001);
+	}
+}
+
 static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 {
 	unsigned int cap_mask, uk, max, dummy;
@@ -12,7 +24,8 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	unsigned int cpu_rev, cpu_freq = 0, cpu_flags, new_cpu_rev;
 	char cpu_info[65];
 
-	get_model_name(c);	/* Same as AMD/Cyrix */
+	early_init_transmeta(c);
+
 	display_cacheinfo(c);
 
 	/* Print CMS and CPU revision */
@@ -85,23 +98,12 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit transmeta_identify(struct cpuinfo_x86 *c)
-{
-	u32 xlvl;
-
-	/* Transmeta-defined flags: level 0x80860001 */
-	xlvl = cpuid_eax(0x80860000);
-	if ((xlvl & 0xffff0000) == 0x80860000) {
-		if (xlvl >= 0x80860001)
-			c->x86_capability[2] = cpuid_edx(0x80860001);
-	}
-}
-
 static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
+	.c_early_init	= early_init_transmeta,
 	.c_init		= init_transmeta,
-	.c_identify	= transmeta_identify,
+	.c_x86_vendor	= X86_VENDOR_TRANSMETA,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_TRANSMETA, &transmeta_cpu_dev);
+cpu_dev_register(transmeta_cpu_dev);
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index b1fc909..e777f79 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -19,7 +19,8 @@ static struct cpu_dev umc_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_x86_vendor	= X86_VENDOR_UMC,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_UMC, &umc_cpu_dev);
+cpu_dev_register(umc_cpu_dev);
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 66e48aa..78e642f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -148,6 +148,9 @@ void __init e820_print_map(char *who)
 		case E820_NVS:
 			printk(KERN_CONT "(ACPI NVS)\n");
 			break;
+		case E820_UNUSABLE:
+			printk("(unusable)\n");
+			break;
 		default:
 			printk(KERN_CONT "type %u\n", e820.map[i].type);
 			break;
@@ -1260,6 +1263,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_RAM:	return "System RAM";
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
+	case E820_UNUSABLE:	return "Unusable memory";
 	default:	return "reserved";
 	}
 }
@@ -1267,6 +1271,7 @@ static inline const char *e820_type_to_string(int e820_type)
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
+static struct resource __initdata *e820_res;
 void __init e820_reserve_resources(void)
 {
 	int i;
@@ -1274,6 +1279,7 @@ void __init e820_reserve_resources(void)
 	u64 end;
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
@@ -1287,7 +1293,14 @@ void __init e820_reserve_resources(void)
 		res->end = end;
 
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
+
+		/*
+		 * don't register the region that could be conflicted with
+		 * pci device BAR resource and insert them later in
+		 * pcibios_resource_survey()
+		 */
+		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
+			insert_resource(&iomem_resource, res);
 		res++;
 	}
 
@@ -1299,6 +1312,19 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+void __init e820_reserve_resources_late(void)
+{
+	int i;
+	struct resource *res;
+
+	res = e820_res;
+	for (i = 0; i < e820.nr_map; i++) {
+		if (!res->parent && res->end)
+			reserve_region_with_split(&iomem_resource, res->start, res->end, res->name);
+		res++;
+	}
+}
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
diff --git a/arch/x86/mach-es7000/es7000plat.c b/arch/x86/kernel/es7000_32.c
similarity index 78%
rename from arch/x86/mach-es7000/es7000plat.c
rename to arch/x86/kernel/es7000_32.c
index 50189af..849e5cd 100644
--- a/arch/x86/mach-es7000/es7000plat.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -39,10 +39,93 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/apicdef.h>
-#include "es7000.h"
 #include <mach_mpparse.h>
 
 /*
+ * ES7000 chipsets
+ */
+
+#define NON_UNISYS		0
+#define ES7000_CLASSIC		1
+#define ES7000_ZORRO		2
+
+
+#define	MIP_REG			1
+#define	MIP_PSAI_REG		4
+
+#define	MIP_BUSY		1
+#define	MIP_SPIN		0xf0000
+#define	MIP_VALID		0x0100000000000000ULL
+#define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
+
+#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)
+
+struct mip_reg_info {
+	unsigned long long mip_info;
+	unsigned long long delivery_info;
+	unsigned long long host_reg;
+	unsigned long long mip_reg;
+};
+
+struct part_info {
+	unsigned char type;
+	unsigned char length;
+	unsigned char part_id;
+	unsigned char apic_mode;
+	unsigned long snum;
+	char ptype[16];
+	char sname[64];
+	char pname[64];
+};
+
+struct psai {
+	unsigned long long entry_type;
+	unsigned long long addr;
+	unsigned long long bep_addr;
+};
+
+struct es7000_mem_info {
+	unsigned char type;
+	unsigned char length;
+	unsigned char resv[6];
+	unsigned long long  start;
+	unsigned long long  size;
+};
+
+struct es7000_oem_table {
+	unsigned long long hdr;
+	struct mip_reg_info mip;
+	struct part_info pif;
+	struct es7000_mem_info shm;
+	struct psai psai;
+};
+
+#ifdef CONFIG_ACPI
+
+struct oem_table {
+	struct acpi_table_header Header;
+	u32 OEMTableAddr;
+	u32 OEMTableSize;
+};
+
+extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+#endif
+
+struct mip_reg {
+	unsigned long long off_0;
+	unsigned long long off_8;
+	unsigned long long off_10;
+	unsigned long long off_18;
+	unsigned long long off_20;
+	unsigned long long off_28;
+	unsigned long long off_30;
+	unsigned long long off_38;
+};
+
+#define	MIP_SW_APIC		0x1020b
+#define	MIP_FUNC(VALUE)		(VALUE & 0xff)
+
+/*
  * ES7000 Globals
  */
 
@@ -72,7 +155,7 @@ es7000_rename_gsi(int ioapic, int gsi)
 			base += nr_ioapic_registers[i];
 	}
 
-	if (!ioapic && (gsi < 16)) 
+	if (!ioapic && (gsi < 16))
 		gsi += base;
 	return gsi;
 }
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index eaff0bb..6c9bfc9 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -16,87 +16,63 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/hardirq.h>
+#include <linux/dmar.h>
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 
-#ifdef CONFIG_ACPI
-#include <acpi/acpi_bus.h>
-#endif
-
-DEFINE_PER_CPU(int, x2apic_extra_bits);
+extern struct genapic apic_flat;
+extern struct genapic apic_physflat;
+extern struct genapic apic_x2xpic_uv_x;
+extern struct genapic apic_x2apic_phys;
+extern struct genapic apic_x2apic_cluster;
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
-static enum uv_system_type uv_system_type;
+static struct genapic *apic_probe[] __initdata = {
+	&apic_x2apic_uv_x,
+	&apic_x2apic_phys,
+	&apic_x2apic_cluster,
+	&apic_physflat,
+	NULL,
+};
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
 void __init setup_apic_routing(void)
 {
-	if (uv_system_type == UV_NON_UNIQUE_APIC)
-		genapic = &apic_x2apic_uv_x;
-	else
-#ifdef CONFIG_ACPI
-	/*
-	 * Quirk: some x86_64 machines can only use physical APIC mode
-	 * regardless of how many processors are present (x86_64 ES7000
-	 * is an example).
-	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
-			(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
-		genapic = &apic_physflat;
-	else
-#endif
-
-	if (max_physical_apicid < 8)
-		genapic = &apic_flat;
-	else
-		genapic = &apic_physflat;
+	if (genapic == &apic_x2apic_phys || genapic == &apic_x2apic_cluster) {
+		if (!intr_remapping_enabled)
+			genapic = &apic_flat;
+	}
 
-	printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+	if (genapic == &apic_flat) {
+		if (max_physical_apicid >= 8)
+			genapic = &apic_physflat;
+		printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+	}
 }
 
 /* Same for both flat and physical. */
 
-void send_IPI_self(int vector)
+void apic_send_IPI_self(int vector)
 {
 	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
 int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (!strcmp(oem_id, "SGI")) {
-		if (!strcmp(oem_table_id, "UVL"))
-			uv_system_type = UV_LEGACY_APIC;
-		else if (!strcmp(oem_table_id, "UVX"))
-			uv_system_type = UV_X2APIC;
-		else if (!strcmp(oem_table_id, "UVH"))
-			uv_system_type = UV_NON_UNIQUE_APIC;
+	int i;
+
+	for (i = 0; apic_probe[i]; ++i) {
+		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
+			genapic = apic_probe[i];
+			printk(KERN_INFO "Setting APIC routing to %s.\n",
+				genapic->name);
+			return 1;
+		}
 	}
 	return 0;
 }
-
-unsigned int read_apic_id(void)
-{
-	unsigned int id;
-
-	WARN_ON(preemptible() && num_online_cpus() > 1);
-	id = apic_read(APIC_ID);
-	if (uv_system_type >= UV_X2APIC)
-		id  |= __get_cpu_var(x2apic_extra_bits);
-	return id;
-}
-
-enum uv_system_type get_uv_system_type(void)
-{
-	return uv_system_type;
-}
-
-int is_uv_system(void)
-{
-	return uv_system_type != UV_NONE;
-}
-EXPORT_SYMBOL_GPL(is_uv_system);
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 786548a..9eca5ba 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -15,9 +15,20 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/hardirq.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <mach_apicdef.h>
+
+#ifdef CONFIG_ACPI
+#include <acpi/acpi_bus.h>
+#endif
+
+static int __init flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 1;
+}
 
 static cpumask_t flat_target_cpus(void)
 {
@@ -95,9 +106,33 @@ static void flat_send_IPI_all(int vector)
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
 
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	id = (((x)>>24) & 0xFFu);
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = ((id & 0xFFu)<<24);
+	return x;
+}
+
+static unsigned int read_xapic_id(void)
+{
+	unsigned int id;
+
+	id = get_apic_id(apic_read(APIC_ID));
+	return id;
+}
+
 static int flat_apic_id_registered(void)
 {
-	return physid_isset(GET_APIC_ID(read_apic_id()), phys_cpu_present_map);
+	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
 static unsigned int flat_cpu_mask_to_apicid(cpumask_t cpumask)
@@ -112,6 +147,7 @@ static unsigned int phys_pkg_id(int index_msb)
 
 struct genapic apic_flat =  {
 	.name = "flat",
+	.acpi_madt_oem_check = flat_acpi_madt_oem_check,
 	.int_delivery_mode = dest_LowestPrio,
 	.int_dest_mode = (APIC_DEST_LOGICAL != 0),
 	.target_cpus = flat_target_cpus,
@@ -121,8 +157,12 @@ struct genapic apic_flat =  {
 	.send_IPI_all = flat_send_IPI_all,
 	.send_IPI_allbutself = flat_send_IPI_allbutself,
 	.send_IPI_mask = flat_send_IPI_mask,
+	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFu<<24),
 };
 
 /*
@@ -130,6 +170,21 @@ struct genapic apic_flat =  {
  * We cannot use logical delivery in this case because the mask
  * overflows, so use physical mode.
  */
+static int __init physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+#ifdef CONFIG_ACPI
+	/*
+	 * Quirk: some x86_64 machines can only use physical APIC mode
+	 * regardless of how many processors are present (x86_64 ES7000
+	 * is an example).
+	 */
+	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
+		return 1;
+#endif
+
+	return 0;
+}
 
 static cpumask_t physflat_target_cpus(void)
 {
@@ -176,6 +231,7 @@ static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
 
 struct genapic apic_physflat =  {
 	.name = "physical flat",
+	.acpi_madt_oem_check = physflat_acpi_madt_oem_check,
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = physflat_target_cpus,
@@ -185,6 +241,10 @@ struct genapic apic_physflat =  {
 	.send_IPI_all = physflat_send_IPI_all,
 	.send_IPI_allbutself = physflat_send_IPI_allbutself,
 	.send_IPI_mask = physflat_send_IPI_mask,
+	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFu<<24),
 };
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
new file mode 100644
index 0000000..e4bf2cc
--- /dev/null
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -0,0 +1,159 @@
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/dmar.h>
+
+#include <asm/smp.h>
+#include <asm/ipi.h>
+#include <asm/genapic.h>
+
+DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+
+static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (cpu_has_x2apic)
+		return 1;
+
+	return 0;
+}
+
+/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
+
+static cpumask_t x2apic_target_cpus(void)
+{
+	return cpumask_of_cpu(0);
+}
+
+/*
+ * for now each logical cpu is in its own vector allocation domain.
+ */
+static cpumask_t x2apic_vector_allocation_domain(int cpu)
+{
+	cpumask_t domain = CPU_MASK_NONE;
+	cpu_set(cpu, domain);
+	return domain;
+}
+
+static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
+				   unsigned int dest)
+{
+	unsigned long cfg;
+
+	cfg = __prepare_ICR(0, vector, dest);
+
+	/*
+	 * send the IPI.
+	 */
+	x2apic_icr_write(cfg, apicid);
+}
+
+/*
+ * for now, we send the IPI's one by one in the cpumask.
+ * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
+ * at once. We have 16 cpu's in a cluster. This will minimize IPI register
+ * writes.
+ */
+static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+
+	local_irq_save(flags);
+	for_each_cpu_mask(query_cpu, mask) {
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+				       vector, APIC_DEST_LOGICAL);
+	}
+	local_irq_restore(flags);
+}
+
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		x2apic_send_IPI_mask(mask, vector);
+}
+
+static void x2apic_send_IPI_all(int vector)
+{
+	x2apic_send_IPI_mask(cpu_online_map, vector);
+}
+
+static int x2apic_apic_id_registered(void)
+{
+	return 1;
+}
+
+static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	cpu = first_cpu(cpumask);
+	if ((unsigned)cpu < NR_CPUS)
+		return per_cpu(x86_cpu_to_logical_apicid, cpu);
+	else
+		return BAD_APICID;
+}
+
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	id = x;
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = id;
+	return x;
+}
+
+static unsigned int phys_pkg_id(int index_msb)
+{
+	return current_cpu_data.initial_apicid >> index_msb;
+}
+
+static void x2apic_send_IPI_self(int vector)
+{
+	apic_write(APIC_SELF_IPI, vector);
+}
+
+static void init_x2apic_ldr(void)
+{
+	int cpu = smp_processor_id();
+
+	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
+	return;
+}
+
+struct genapic apic_x2apic_cluster = {
+	.name = "cluster x2apic",
+	.acpi_madt_oem_check = x2apic_acpi_madt_oem_check,
+	.int_delivery_mode = dest_LowestPrio,
+	.int_dest_mode = (APIC_DEST_LOGICAL != 0),
+	.target_cpus = x2apic_target_cpus,
+	.vector_allocation_domain = x2apic_vector_allocation_domain,
+	.apic_id_registered = x2apic_apic_id_registered,
+	.init_apic_ldr = init_x2apic_ldr,
+	.send_IPI_all = x2apic_send_IPI_all,
+	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
+	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_self = x2apic_send_IPI_self,
+	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.phys_pkg_id = phys_pkg_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFFFFFFFu),
+};
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
new file mode 100644
index 0000000..8f1343d
--- /dev/null
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -0,0 +1,154 @@
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/dmar.h>
+
+#include <asm/smp.h>
+#include <asm/ipi.h>
+#include <asm/genapic.h>
+
+static int x2apic_phys;
+
+static int set_x2apic_phys_mode(char *arg)
+{
+	x2apic_phys = 1;
+	return 0;
+}
+early_param("x2apic_phys", set_x2apic_phys_mode);
+
+static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (cpu_has_x2apic && x2apic_phys)
+		return 1;
+
+	return 0;
+}
+
+/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
+
+static cpumask_t x2apic_target_cpus(void)
+{
+	return cpumask_of_cpu(0);
+}
+
+static cpumask_t x2apic_vector_allocation_domain(int cpu)
+{
+	cpumask_t domain = CPU_MASK_NONE;
+	cpu_set(cpu, domain);
+	return domain;
+}
+
+static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
+				   unsigned int dest)
+{
+	unsigned long cfg;
+
+	cfg = __prepare_ICR(0, vector, dest);
+
+	/*
+	 * send the IPI.
+	 */
+	x2apic_icr_write(cfg, apicid);
+}
+
+static void x2apic_send_IPI_mask(cpumask_t mask, int vector)
+{
+	unsigned long flags;
+	unsigned long query_cpu;
+
+	local_irq_save(flags);
+	for_each_cpu_mask(query_cpu, mask) {
+		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+				       vector, APIC_DEST_PHYSICAL);
+	}
+	local_irq_restore(flags);
+}
+
+static void x2apic_send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		x2apic_send_IPI_mask(mask, vector);
+}
+
+static void x2apic_send_IPI_all(int vector)
+{
+	x2apic_send_IPI_mask(cpu_online_map, vector);
+}
+
+static int x2apic_apic_id_registered(void)
+{
+	return 1;
+}
+
+static unsigned int x2apic_cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	cpu = first_cpu(cpumask);
+	if ((unsigned)cpu < NR_CPUS)
+		return per_cpu(x86_cpu_to_apicid, cpu);
+	else
+		return BAD_APICID;
+}
+
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	id = x;
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = id;
+	return x;
+}
+
+static unsigned int phys_pkg_id(int index_msb)
+{
+	return current_cpu_data.initial_apicid >> index_msb;
+}
+
+void x2apic_send_IPI_self(int vector)
+{
+	apic_write(APIC_SELF_IPI, vector);
+}
+
+void init_x2apic_ldr(void)
+{
+	return;
+}
+
+struct genapic apic_x2apic_phys = {
+	.name = "physical x2apic",
+	.acpi_madt_oem_check = x2apic_acpi_madt_oem_check,
+	.int_delivery_mode = dest_Fixed,
+	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
+	.target_cpus = x2apic_target_cpus,
+	.vector_allocation_domain = x2apic_vector_allocation_domain,
+	.apic_id_registered = x2apic_apic_id_registered,
+	.init_apic_ldr = init_x2apic_ldr,
+	.send_IPI_all = x2apic_send_IPI_all,
+	.send_IPI_allbutself = x2apic_send_IPI_allbutself,
+	.send_IPI_mask = x2apic_send_IPI_mask,
+	.send_IPI_self = x2apic_send_IPI_self,
+	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
+	.phys_pkg_id = phys_pkg_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFFFFFFFu),
+};
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index bfa837c..ae2ffc8 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -12,12 +12,12 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
-#include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -26,6 +26,36 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
 
+DEFINE_PER_CPU(int, x2apic_extra_bits);
+
+static enum uv_system_type uv_system_type;
+
+static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (!strcmp(oem_id, "SGI")) {
+		if (!strcmp(oem_table_id, "UVL"))
+			uv_system_type = UV_LEGACY_APIC;
+		else if (!strcmp(oem_table_id, "UVX"))
+			uv_system_type = UV_X2APIC;
+		else if (!strcmp(oem_table_id, "UVH")) {
+			uv_system_type = UV_NON_UNIQUE_APIC;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+enum uv_system_type get_uv_system_type(void)
+{
+	return uv_system_type;
+}
+
+int is_uv_system(void)
+{
+	return uv_system_type != UV_NONE;
+}
+EXPORT_SYMBOL_GPL(is_uv_system);
+
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
 
@@ -123,6 +153,10 @@ static int uv_apic_id_registered(void)
 	return 1;
 }
 
+static void uv_init_apic_ldr(void)
+{
+}
+
 static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
 {
 	int cpu;
@@ -138,9 +172,34 @@ static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
 		return BAD_APICID;
 }
 
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	WARN_ON(preemptible() && num_online_cpus() > 1);
+	id = x | __get_cpu_var(x2apic_extra_bits);
+
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	/* maskout x2apic_extra_bits ? */
+	x = id;
+	return x;
+}
+
+static unsigned int uv_read_apic_id(void)
+{
+
+	return get_apic_id(apic_read(APIC_ID));
+}
+
 static unsigned int phys_pkg_id(int index_msb)
 {
-	return GET_APIC_ID(read_apic_id()) >> index_msb;
+	return uv_read_apic_id() >> index_msb;
 }
 
 #ifdef ZZZ		/* Needs x2apic patch */
@@ -152,17 +211,22 @@ static void uv_send_IPI_self(int vector)
 
 struct genapic apic_x2apic_uv_x = {
 	.name = "UV large system",
+	.acpi_madt_oem_check = uv_acpi_madt_oem_check,
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = uv_target_cpus,
 	.vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
 	.apic_id_registered = uv_apic_id_registered,
+	.init_apic_ldr = uv_init_apic_ldr,
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,
 	/* ZZZ.send_IPI_self = uv_send_IPI_self, */
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFFFFFFFu),
 };
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
@@ -401,3 +465,5 @@ void __cpuinit uv_cpu_init(void)
 	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
+
+
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index eb9ddd8..45723f1 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -21,9 +21,12 @@
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 #else
-# define save_i387_ia32		save_i387
-# define restore_i387_ia32	restore_i387
+# define save_i387_xstate_ia32		save_i387_xstate
+# define restore_i387_xstate_ia32	restore_i387_xstate
 # define _fpstate_ia32		_fpstate
+# define _xstate_ia32		_xstate
+# define sig_xstate_ia32_size   sig_xstate_size
+# define fx_sw_reserved_ia32	fx_sw_reserved
 # define user_i387_ia32_struct	user_i387_struct
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
@@ -36,6 +39,7 @@
 
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
+unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
 void __cpuinit mxcsr_feature_mask_init(void)
@@ -61,6 +65,11 @@ void __init init_thread_xstate(void)
 		return;
 	}
 
+	if (cpu_has_xsave) {
+		xsave_cntxt_init();
+		return;
+	}
+
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -83,9 +92,19 @@ void __cpuinit fpu_init(void)
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
+	/*
+	 * Boot processor to setup the FP and extended state context info.
+	 */
+	if (!smp_processor_id())
+		init_thread_xstate();
+	xsave_init();
+
 	mxcsr_feature_mask_init();
 	/* clean state in init */
-	current_thread_info()->status = 0;
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
 	clear_used_math();
 }
 #endif	/* CONFIG_X86_64 */
@@ -195,6 +214,13 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	 */
 	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 
+	/*
+	 * update the header bits in the xsave header, indicating the
+	 * presence of FP and SSE state.
+	 */
+	if (cpu_has_xsave)
+		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+
 	return ret;
 }
 
@@ -395,6 +421,12 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!ret)
 		convert_to_fxsr(target, &env);
 
+	/*
+	 * update the header bit in the xsave header, indicating the
+	 * presence of FP.
+	 */
+	if (cpu_has_xsave)
+		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
 	return ret;
 }
 
@@ -407,7 +439,6 @@ static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 	struct task_struct *tsk = current;
 	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
 
-	unlazy_fpu(tsk);
 	fp->status = fp->swd;
 	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
 		return -1;
@@ -421,8 +452,6 @@ static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
-	unlazy_fpu(tsk);
-
 	convert_from_fxsr(&env, tsk);
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
@@ -432,16 +461,40 @@ static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], fx,
-			   sizeof(struct i387_fxsave_struct)))
+	if (__copy_to_user(&buf->_fxsr_env[0], fx, xstate_size))
 		return -1;
 	return 1;
 }
 
-int save_i387_ia32(struct _fpstate_ia32 __user *buf)
+static int save_i387_xsave(void __user *buf)
+{
+	struct _fpstate_ia32 __user *fx = buf;
+	int err = 0;
+
+	if (save_i387_fxsave(fx) < 0)
+		return -1;
+
+	err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved_ia32,
+			     sizeof(struct _fpx_sw_bytes));
+	err |= __put_user(FP_XSTATE_MAGIC2,
+			  (__u32 __user *) (buf + sig_xstate_ia32_size
+					    - FP_XSTATE_MAGIC2_SIZE));
+	if (err)
+		return -1;
+
+	return 1;
+}
+
+int save_i387_xstate_ia32(void __user *buf)
 {
+	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
+	struct task_struct *tsk = current;
+
 	if (!used_math())
 		return 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_ia32_size))
+		return -EACCES;
 	/*
 	 * This will cause a "finit" to be triggered by the next
 	 * attempted FPU operation by the 'current' process.
@@ -451,13 +504,17 @@ int save_i387_ia32(struct _fpstate_ia32 __user *buf)
 	if (!HAVE_HWFP) {
 		return fpregs_soft_get(current, NULL,
 				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) ? -1 : 1;
+				       NULL, fp) ? -1 : 1;
 	}
 
+	unlazy_fpu(tsk);
+
+	if (cpu_has_xsave)
+		return save_i387_xsave(fp);
 	if (cpu_has_fxsr)
-		return save_i387_fxsave(buf);
+		return save_i387_fxsave(fp);
 	else
-		return save_i387_fsave(buf);
+		return save_i387_fsave(fp);
 }
 
 static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
@@ -468,14 +525,15 @@ static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 				sizeof(struct i387_fsave_struct));
 }
 
-static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
+static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
+			       unsigned int size)
 {
 	struct task_struct *tsk = current;
 	struct user_i387_ia32_struct env;
 	int err;
 
 	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
-			       sizeof(struct i387_fxsave_struct));
+			       size);
 	/* mxcsr reserved bits must be masked to zero for security reasons */
 	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
@@ -485,14 +543,69 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 	return 0;
 }
 
-int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
+static int restore_i387_xsave(void __user *buf)
+{
+	struct _fpx_sw_bytes fx_sw_user;
+	struct _fpstate_ia32 __user *fx_user =
+			((struct _fpstate_ia32 __user *) buf);
+	struct i387_fxsave_struct __user *fx =
+		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
+	struct xsave_hdr_struct *xsave_hdr =
+				&current->thread.xstate->xsave.xsave_hdr;
+	u64 mask;
+	int err;
+
+	if (check_for_xstate(fx, buf, &fx_sw_user))
+		goto fx_only;
+
+	mask = fx_sw_user.xstate_bv;
+
+	err = restore_i387_fxsave(buf, fx_sw_user.xstate_size);
+
+	xsave_hdr->xstate_bv &= pcntxt_mask;
+	/*
+	 * These bits must be zero.
+	 */
+	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
+	/*
+	 * Init the state that is not present in the memory layout
+	 * and enabled by the OS.
+	 */
+	mask = ~(pcntxt_mask & ~mask);
+	xsave_hdr->xstate_bv &= mask;
+
+	return err;
+fx_only:
+	/*
+	 * Couldn't find the extended state information in the memory
+	 * layout. Restore the FP/SSE and init the other extended state
+	 * enabled by the OS.
+	 */
+	xsave_hdr->xstate_bv = XSTATE_FPSSE;
+	return restore_i387_fxsave(buf, sizeof(struct i387_fxsave_struct));
+}
+
+int restore_i387_xstate_ia32(void __user *buf)
 {
 	int err;
 	struct task_struct *tsk = current;
+	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
 
 	if (HAVE_HWFP)
 		clear_fpu(tsk);
 
+	if (!buf) {
+		if (used_math()) {
+			clear_fpu(tsk);
+			clear_used_math();
+		}
+
+		return 0;
+	} else
+		if (!access_ok(VERIFY_READ, buf, sig_xstate_ia32_size))
+			return -EACCES;
+
 	if (!used_math()) {
 		err = init_fpu(tsk);
 		if (err)
@@ -500,14 +613,17 @@ int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 	}
 
 	if (HAVE_HWFP) {
-		if (cpu_has_fxsr)
-			err = restore_i387_fxsave(buf);
+		if (cpu_has_xsave)
+			err = restore_i387_xsave(buf);
+		else if (cpu_has_fxsr)
+			err = restore_i387_fxsave(fp, sizeof(struct
+							   i387_fxsave_struct));
 		else
-			err = restore_i387_fsave(buf);
+			err = restore_i387_fsave(fp);
 	} else {
 		err = fpregs_soft_set(current, NULL,
 				      0, sizeof(struct user_i387_ia32_struct),
-				      NULL, buf) != 0;
+				      NULL, fp) != 0;
 	}
 	set_used_math();
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index dc92b49..4b8a53d 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -282,6 +282,30 @@ static int __init i8259A_init_sysfs(void)
 
 device_initcall(i8259A_init_sysfs);
 
+void mask_8259A(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
+void unmask_8259A(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	outb(cached_master_mask, PIC_MASTER_IMR); /* restore master IRQ mask */
+	outb(cached_slave_mask, PIC_SLAVE_IMR);	  /* restore slave IRQ mask */
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+}
+
 void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 09cddb5..e710289 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -46,10 +46,13 @@
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/setup.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
 
+#define __apicdebuginit(type) static type __init
+
 int (*ioapic_renumber_irq)(int ioapic, int irq);
 atomic_t irq_mis_count;
 
@@ -1341,7 +1344,8 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 	ioapic_write_entry(apic, pin, entry);
 }
 
-void __init print_IO_APIC(void)
+
+__apicdebuginit(void) print_IO_APIC(void)
 {
 	int apic, i;
 	union IO_APIC_reg_00 reg_00;
@@ -1456,9 +1460,7 @@ void __init print_IO_APIC(void)
 	return;
 }
 
-#if 0
-
-static void print_APIC_bitfield(int base)
+__apicdebuginit(void) print_APIC_bitfield(int base)
 {
 	unsigned int v;
 	int i, j;
@@ -1479,9 +1481,10 @@ static void print_APIC_bitfield(int base)
 	}
 }
 
-void /*__init*/ print_local_APIC(void *dummy)
+__apicdebuginit(void) print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
+	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1490,7 +1493,7 @@ void /*__init*/ print_local_APIC(void *dummy)
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
-			GET_APIC_ID(read_apic_id()));
+			GET_APIC_ID(v));
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
@@ -1532,10 +1535,9 @@ void /*__init*/ print_local_APIC(void *dummy)
 		printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
 	}
 
-	v = apic_read(APIC_ICR);
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", v);
-	v = apic_read(APIC_ICR2);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", v);
+	icr = apic_icr_read();
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
@@ -1563,12 +1565,12 @@ void /*__init*/ print_local_APIC(void *dummy)
 	printk("\n");
 }
 
-void print_all_local_APICs(void)
+__apicdebuginit(void) print_all_local_APICs(void)
 {
 	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
-void /*__init*/ print_PIC(void)
+__apicdebuginit(void) print_PIC(void)
 {
 	unsigned int v;
 	unsigned long flags;
@@ -1600,7 +1602,17 @@ void /*__init*/ print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-#endif  /*  0  */
+__apicdebuginit(int) print_all_ICs(void)
+{
+	print_PIC();
+	print_all_local_APICs();
+	print_IO_APIC();
+
+	return 0;
+}
+
+fs_initcall(print_all_ICs);
+
 
 static void __init enable_IO_APIC(void)
 {
@@ -1698,8 +1710,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest.physical.physical_dest =
-					GET_APIC_ID(read_apic_id());
+		entry.dest.physical.physical_dest = read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1725,10 +1736,8 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	unsigned char old_id;
 	unsigned long flags;
 
-#ifdef CONFIG_X86_NUMAQ
-	if (found_numaq)
+	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
 		return;
-#endif
 
 	/*
 	 * Don't check I/O APIC IDs for xAPIC systems.  They have
@@ -2329,8 +2338,6 @@ void __init setup_IO_APIC(void)
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
-	if (!acpi_ioapic)
-		print_IO_APIC();
 }
 
 /*
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 61a83b7..a1bec29 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -37,6 +37,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <linux/bootmem.h>
+#include <linux/dmar.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -49,10 +50,13 @@
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/irq_remapping.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
 
+#define __apicdebuginit(type) static type __init
+
 struct irq_cfg {
 	cpumask_t domain;
 	cpumask_t old_domain;
@@ -87,8 +91,6 @@ int first_system_vector = 0xfe;
 
 char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
 
-#define __apicdebuginit  __init
-
 int sis_apic_bug; /* not actually supported, dummy for compile */
 
 static int no_timer_check;
@@ -108,6 +110,9 @@ static DEFINE_SPINLOCK(vector_lock);
  */
 int nr_ioapic_registers[MAX_IO_APICS];
 
+/* I/O APIC RTE contents at the OS boot up */
+struct IO_APIC_route_entry *early_ioapic_entries[MAX_IO_APICS];
+
 /* I/O APIC entries */
 struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
@@ -303,7 +308,12 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 		pin = entry->pin;
 		if (pin == -1)
 			break;
-		io_apic_write(apic, 0x11 + pin*2, dest);
+		/*
+		 * With interrupt-remapping, destination information comes
+		 * from interrupt-remapping table entry.
+		 */
+		if (!irq_remapped(irq))
+			io_apic_write(apic, 0x11 + pin*2, dest);
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
@@ -440,6 +450,69 @@ static void clear_IO_APIC (void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
+/*
+ * Saves and masks all the unmasked IO-APIC RTE's
+ */
+int save_mask_IO_APIC_setup(void)
+{
+	union IO_APIC_reg_01 reg_01;
+	unsigned long flags;
+	int apic, pin;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		spin_lock_irqsave(&ioapic_lock, flags);
+		reg_01.raw = io_apic_read(apic, 1);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
+	}
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		early_ioapic_entries[apic] =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				nr_ioapic_registers[apic], GFP_KERNEL);
+		if (!early_ioapic_entries[apic])
+			return -ENOMEM;
+	}
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+			struct IO_APIC_route_entry entry;
+
+			entry = early_ioapic_entries[apic][pin] =
+				ioapic_read_entry(apic, pin);
+			if (!entry.mask) {
+				entry.mask = 1;
+				ioapic_write_entry(apic, pin, entry);
+			}
+		}
+	return 0;
+}
+
+void restore_IO_APIC_setup(void)
+{
+	int apic, pin;
+
+	for (apic = 0; apic < nr_ioapics; apic++)
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+			ioapic_write_entry(apic, pin,
+					   early_ioapic_entries[apic][pin]);
+}
+
+void reinit_intr_remapped_IO_APIC(int intr_remapping)
+{
+	/*
+	 * for now plain restore of previous settings.
+	 * TBD: In the case of OS enabling interrupt-remapping,
+	 * IO-APIC RTE's need to be setup to point to interrupt-remapping
+	 * table entries. for now, do a plain restore, and wait for
+	 * the setup_IO_APIC_irqs() to do proper initialization.
+	 */
+	restore_IO_APIC_setup();
+}
+
 int skip_ioapic_setup;
 int ioapic_force;
 
@@ -839,18 +912,98 @@ void __setup_vector_irq(int cpu)
 }
 
 static struct irq_chip ioapic_chip;
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip ir_ioapic_chip;
+#endif
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
-	if (trigger) {
+	if (trigger)
 		irq_desc[irq].status |= IRQ_LEVEL;
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					      handle_fasteoi_irq, "fasteoi");
-	} else {
+	else
 		irq_desc[irq].status &= ~IRQ_LEVEL;
+
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		irq_desc[irq].status |= IRQ_MOVE_PCNTXT;
+		if (trigger)
+			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
+						      handle_fasteoi_irq,
+						     "fasteoi");
+		else
+			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
+						      handle_edge_irq, "edge");
+		return;
+	}
+#endif
+	if (trigger)
+		set_irq_chip_and_handler_name(irq, &ioapic_chip,
+					      handle_fasteoi_irq,
+					      "fasteoi");
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
+}
+
+static int setup_ioapic_entry(int apic, int irq,
+			      struct IO_APIC_route_entry *entry,
+			      unsigned int destination, int trigger,
+			      int polarity, int vector)
+{
+	/*
+	 * add it to the IO-APIC irq-routing table:
+	 */
+	memset(entry,0,sizeof(*entry));
+
+#ifdef CONFIG_INTR_REMAP
+	if (intr_remapping_enabled) {
+		struct intel_iommu *iommu = map_ioapic_to_ir(apic);
+		struct irte irte;
+		struct IR_IO_APIC_route_entry *ir_entry =
+			(struct IR_IO_APIC_route_entry *) entry;
+		int index;
+
+		if (!iommu)
+			panic("No mapping iommu for ioapic %d\n", apic);
+
+		index = alloc_irte(iommu, irq, 1);
+		if (index < 0)
+			panic("Failed to allocate IRTE for ioapic %d\n", apic);
+
+		memset(&irte, 0, sizeof(irte));
+
+		irte.present = 1;
+		irte.dst_mode = INT_DEST_MODE;
+		irte.trigger_mode = trigger;
+		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.vector = vector;
+		irte.dest_id = IRTE_DEST(destination);
+
+		modify_irte(irq, &irte);
+
+		ir_entry->index2 = (index >> 15) & 0x1;
+		ir_entry->zero = 0;
+		ir_entry->format = 1;
+		ir_entry->index = (index & 0x7fff);
+	} else
+#endif
+	{
+		entry->delivery_mode = INT_DELIVERY_MODE;
+		entry->dest_mode = INT_DEST_MODE;
+		entry->dest = destination;
 	}
+
+	entry->mask = 0;				/* enable IRQ */
+	entry->trigger = trigger;
+	entry->polarity = polarity;
+	entry->vector = vector;
+
+	/* Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (trigger)
+		entry->mask = 1;
+	return 0;
 }
 
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
@@ -875,24 +1028,15 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
-	/*
-	 * add it to the IO-APIC irq-routing table:
-	 */
-	memset(&entry,0,sizeof(entry));
-
-	entry.delivery_mode = INT_DELIVERY_MODE;
-	entry.dest_mode = INT_DEST_MODE;
-	entry.dest = cpu_mask_to_apicid(mask);
-	entry.mask = 0;				/* enable IRQ */
-	entry.trigger = trigger;
-	entry.polarity = polarity;
-	entry.vector = cfg->vector;
 
-	/* Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
-	 */
-	if (trigger)
-		entry.mask = 1;
+	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
+			       cpu_mask_to_apicid(mask), trigger, polarity,
+			       cfg->vector)) {
+		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+		       mp_ioapics[apic].mp_apicid, pin);
+		__clear_irq_vector(irq);
+		return;
+	}
 
 	ioapic_register_intr(irq, trigger);
 	if (irq < 16)
@@ -944,6 +1088,9 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 {
 	struct IO_APIC_route_entry entry;
 
+	if (intr_remapping_enabled)
+		return;
+
 	memset(&entry, 0, sizeof(entry));
 
 	/*
@@ -970,7 +1117,8 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 	ioapic_write_entry(apic, pin, entry);
 }
 
-void __apicdebuginit print_IO_APIC(void)
+
+__apicdebuginit(void) print_IO_APIC(void)
 {
 	int apic, i;
 	union IO_APIC_reg_00 reg_00;
@@ -1064,9 +1212,7 @@ void __apicdebuginit print_IO_APIC(void)
 	return;
 }
 
-#if 0
-
-static __apicdebuginit void print_APIC_bitfield (int base)
+__apicdebuginit(void) print_APIC_bitfield(int base)
 {
 	unsigned int v;
 	int i, j;
@@ -1087,9 +1233,10 @@ static __apicdebuginit void print_APIC_bitfield (int base)
 	}
 }
 
-void __apicdebuginit print_local_APIC(void * dummy)
+__apicdebuginit(void) print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
+	unsigned long icr;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1097,7 +1244,7 @@ void __apicdebuginit print_local_APIC(void * dummy)
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(read_apic_id()));
+	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
@@ -1133,10 +1280,9 @@ void __apicdebuginit print_local_APIC(void * dummy)
 	v = apic_read(APIC_ESR);
 	printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
 
-	v = apic_read(APIC_ICR);
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", v);
-	v = apic_read(APIC_ICR2);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", v);
+	icr = apic_icr_read();
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
@@ -1164,12 +1310,12 @@ void __apicdebuginit print_local_APIC(void * dummy)
 	printk("\n");
 }
 
-void print_all_local_APICs (void)
+__apicdebuginit(void) print_all_local_APICs(void)
 {
 	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
-void __apicdebuginit print_PIC(void)
+__apicdebuginit(void) print_PIC(void)
 {
 	unsigned int v;
 	unsigned long flags;
@@ -1201,7 +1347,17 @@ void __apicdebuginit print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-#endif  /*  0  */
+__apicdebuginit(int) print_all_ICs(void)
+{
+	print_PIC();
+	print_all_local_APICs();
+	print_IO_APIC();
+
+	return 0;
+}
+
+fs_initcall(print_all_ICs);
+
 
 void __init enable_IO_APIC(void)
 {
@@ -1291,7 +1447,7 @@ void disable_IO_APIC(void)
 		entry.dest_mode       = 0; /* Physical */
 		entry.delivery_mode   = dest_ExtINT; /* ExtInt */
 		entry.vector          = 0;
-		entry.dest          = GET_APIC_ID(read_apic_id());
+		entry.dest            = read_apic_id();
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1397,6 +1553,147 @@ static int ioapic_retrigger_irq(unsigned int irq)
  */
 
 #ifdef CONFIG_SMP
+
+#ifdef CONFIG_INTR_REMAP
+static void ir_irq_migration(struct work_struct *work);
+
+static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
+
+/*
+ * Migrate the IO-APIC irq in the presence of intr-remapping.
+ *
+ * For edge triggered, irq migration is a simple atomic update(of vector
+ * and cpu destination) of IRTE and flush the hardware cache.
+ *
+ * For level triggered, we need to modify the io-apic RTE aswell with the update
+ * vector information, along with modifying IRTE with vector and destination.
+ * So irq migration for level triggered is little  bit more complex compared to
+ * edge triggered migration. But the good news is, we use the same algorithm
+ * for level triggered migration as we have today, only difference being,
+ * we now initiate the irq migration from process context instead of the
+ * interrupt context.
+ *
+ * In future, when we do a directed EOI (combined with cpu EOI broadcast
+ * suppression) to the IO-APIC, level triggered irq migration will also be
+ * as simple as edge triggered migration and we can do the irq migration
+ * with a simple atomic update to IO-APIC RTE.
+ */
+static void migrate_ioapic_irq(int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_desc *desc = irq_desc + irq;
+	cpumask_t tmp, cleanup_mask;
+	struct irte irte;
+	int modify_ioapic_rte = desc->status & IRQ_LEVEL;
+	unsigned int dest;
+	unsigned long flags;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (get_irte(irq, &irte))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	if (modify_ioapic_rte) {
+		spin_lock_irqsave(&ioapic_lock, flags);
+		__target_IO_APIC_irq(irq, dest, cfg->vector);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+	}
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * Modified the IRTE and flushes the Interrupt entry cache.
+	 */
+	modify_irte(irq, &irte);
+
+	if (cfg->move_in_progress) {
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+
+	irq_desc[irq].affinity = mask;
+}
+
+static int migrate_irq_remapped_level(int irq)
+{
+	int ret = -1;
+
+	mask_IO_APIC_irq(irq);
+
+	if (io_apic_level_ack_pending(irq)) {
+		/*
+	 	 * Interrupt in progress. Migrating irq now will change the
+		 * vector information in the IO-APIC RTE and that will confuse
+		 * the EOI broadcast performed by cpu.
+		 * So, delay the irq migration to the next instance.
+		 */
+		schedule_delayed_work(&ir_migration_work, 1);
+		goto unmask;
+	}
+
+	/* everthing is clear. we have right of way */
+	migrate_ioapic_irq(irq, irq_desc[irq].pending_mask);
+
+	ret = 0;
+	irq_desc[irq].status &= ~IRQ_MOVE_PENDING;
+	cpus_clear(irq_desc[irq].pending_mask);
+
+unmask:
+	unmask_IO_APIC_irq(irq);
+	return ret;
+}
+
+static void ir_irq_migration(struct work_struct *work)
+{
+	int irq;
+
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		struct irq_desc *desc = irq_desc + irq;
+		if (desc->status & IRQ_MOVE_PENDING) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&desc->lock, flags);
+			if (!desc->chip->set_affinity ||
+			    !(desc->status & IRQ_MOVE_PENDING)) {
+				desc->status &= ~IRQ_MOVE_PENDING;
+				spin_unlock_irqrestore(&desc->lock, flags);
+				continue;
+			}
+
+			desc->chip->set_affinity(irq,
+					         irq_desc[irq].pending_mask);
+			spin_unlock_irqrestore(&desc->lock, flags);
+		}
+	}
+}
+
+/*
+ * Migrates the IRQ destination in the process context.
+ */
+static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	if (irq_desc[irq].status & IRQ_LEVEL) {
+		irq_desc[irq].status |= IRQ_MOVE_PENDING;
+		irq_desc[irq].pending_mask = mask;
+		migrate_irq_remapped_level(irq);
+		return;
+	}
+
+	migrate_ioapic_irq(irq, mask);
+}
+#endif
+
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
@@ -1453,6 +1750,17 @@ static void irq_complete_move(unsigned int irq)
 #else
 static inline void irq_complete_move(unsigned int irq) {}
 #endif
+#ifdef CONFIG_INTR_REMAP
+static void ack_x2apic_level(unsigned int irq)
+{
+	ack_x2APIC_irq();
+}
+
+static void ack_x2apic_edge(unsigned int irq)
+{
+	ack_x2APIC_irq();
+}
+#endif
 
 static void ack_apic_edge(unsigned int irq)
 {
@@ -1527,6 +1835,21 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip ir_ioapic_chip __read_mostly = {
+	.name 		= "IR-IO-APIC",
+	.startup 	= startup_ioapic_irq,
+	.mask	 	= mask_IO_APIC_irq,
+	.unmask	 	= unmask_IO_APIC_irq,
+	.ack 		= ack_x2apic_edge,
+	.eoi 		= ack_x2apic_level,
+#ifdef CONFIG_SMP
+	.set_affinity 	= set_ir_ioapic_affinity_irq,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
+#endif
+
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
@@ -1712,6 +2035,8 @@ static inline void __init check_timer(void)
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
+		if (intr_remapping_enabled)
+			panic("BIOS bug: timer not connected to IO-APIC");
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -1738,6 +2063,8 @@ static inline void __init check_timer(void)
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
+		if (intr_remapping_enabled)
+			panic("timer doesn't work through Interrupt-remapped IO-APIC");
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
 			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
@@ -1854,8 +2181,6 @@ void __init setup_IO_APIC(void)
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
-	if (!acpi_ioapic)
-		print_IO_APIC();
 }
 
 struct sysfs_ioapic_data {
@@ -1977,6 +2302,9 @@ void destroy_irq(unsigned int irq)
 
 	dynamic_irq_cleanup(irq);
 
+#ifdef CONFIG_INTR_REMAP
+	free_irte(irq);
+#endif
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq);
 	spin_unlock_irqrestore(&vector_lock, flags);
@@ -1995,11 +2323,42 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 
 	tmp = TARGET_CPUS;
 	err = assign_irq_vector(irq, tmp);
-	if (!err) {
-		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(tmp);
+	if (err)
+		return err;
+
+	cpus_and(tmp, cfg->domain, tmp);
+	dest = cpu_mask_to_apicid(tmp);
+
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		struct irte irte;
+		int ir_index;
+		u16 sub_handle;
+
+		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
+		BUG_ON(ir_index == -1);
+
+		memset (&irte, 0, sizeof(irte));
+
+		irte.present = 1;
+		irte.dst_mode = INT_DEST_MODE;
+		irte.trigger_mode = 0; /* edge */
+		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.vector = cfg->vector;
+		irte.dest_id = IRTE_DEST(dest);
+
+		modify_irte(irq, &irte);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->data = sub_handle;
+		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+				  MSI_ADDR_IR_SHV |
+				  MSI_ADDR_IR_INDEX1(ir_index) |
+				  MSI_ADDR_IR_INDEX2(ir_index);
+	} else
+#endif
+	{
+		msg->address_hi = MSI_ADDR_BASE_HI;
 		msg->address_lo =
 			MSI_ADDR_BASE_LO |
 			((INT_DEST_MODE == 0) ?
@@ -2049,6 +2408,55 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	write_msi_msg(irq, &msg);
 	irq_desc[irq].affinity = mask;
 }
+
+#ifdef CONFIG_INTR_REMAP
+/*
+ * Migrate the MSI irq to another cpumask. This migration is
+ * done in the process context using interrupt-remapping hardware.
+ */
+static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	unsigned int dest;
+	cpumask_t tmp, cleanup_mask;
+	struct irte irte;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (get_irte(irq, &irte))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * atomically update the IRTE with the new destination and vector.
+	 */
+	modify_irte(irq, &irte);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress) {
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+
+	irq_desc[irq].affinity = mask;
+}
+#endif
 #endif /* CONFIG_SMP */
 
 /*
@@ -2066,26 +2474,157 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip msi_ir_chip = {
+	.name		= "IR-PCI-MSI",
+	.unmask		= unmask_msi_irq,
+	.mask		= mask_msi_irq,
+	.ack		= ack_x2apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity	= ir_set_msi_irq_affinity,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
+
+/*
+ * Map the PCI dev to the corresponding remapping hardware unit
+ * and allocate 'nvec' consecutive interrupt-remapping table entries
+ * in it.
+ */
+static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 {
+	struct intel_iommu *iommu;
+	int index;
+
+	iommu = map_dev_to_ir(dev);
+	if (!iommu) {
+		printk(KERN_ERR
+		       "Unable to map PCI %s to iommu\n", pci_name(dev));
+		return -ENOENT;
+	}
+
+	index = alloc_irte(iommu, irq, nvec);
+	if (index < 0) {
+		printk(KERN_ERR
+		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
+		        pci_name(dev));
+		return -ENOSPC;
+	}
+	return index;
+}
+#endif
+
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+{
+	int ret;
 	struct msi_msg msg;
+
+	ret = msi_compose_msg(dev, irq, &msg);
+	if (ret < 0)
+		return ret;
+
+	set_irq_msi(irq, desc);
+	write_msi_msg(irq, &msg);
+
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		struct irq_desc *desc = irq_desc + irq;
+		/*
+		 * irq migration in process context
+		 */
+		desc->status |= IRQ_MOVE_PCNTXT;
+		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
+	} else
+#endif
+		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+
+	return 0;
+}
+
+int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+{
 	int irq, ret;
+
 	irq = create_irq();
 	if (irq < 0)
 		return irq;
 
-	ret = msi_compose_msg(dev, irq, &msg);
+#ifdef CONFIG_INTR_REMAP
+	if (!intr_remapping_enabled)
+		goto no_ir;
+
+	ret = msi_alloc_irte(dev, irq, 1);
+	if (ret < 0)
+		goto error;
+no_ir:
+#endif
+	ret = setup_msi_irq(dev, desc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
 	}
+	return 0;
 
-	set_irq_msi(irq, desc);
-	write_msi_msg(irq, &msg);
+#ifdef CONFIG_INTR_REMAP
+error:
+	destroy_irq(irq);
+	return ret;
+#endif
+}
 
-	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	int irq, ret, sub_handle;
+	struct msi_desc *desc;
+#ifdef CONFIG_INTR_REMAP
+	struct intel_iommu *iommu = 0;
+	int index = 0;
+#endif
+
+	sub_handle = 0;
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		irq = create_irq();
+		if (irq < 0)
+			return irq;
+#ifdef CONFIG_INTR_REMAP
+		if (!intr_remapping_enabled)
+			goto no_ir;
 
+		if (!sub_handle) {
+			/*
+			 * allocate the consecutive block of IRTE's
+			 * for 'nvec'
+			 */
+			index = msi_alloc_irte(dev, irq, nvec);
+			if (index < 0) {
+				ret = index;
+				goto error;
+			}
+		} else {
+			iommu = map_dev_to_ir(dev);
+			if (!iommu) {
+				ret = -ENOENT;
+				goto error;
+			}
+			/*
+			 * setup the mapping between the irq and the IRTE
+			 * base index, the sub_handle pointing to the
+			 * appropriate interrupt remap table entry.
+			 */
+			set_irte_irq(irq, iommu, index, sub_handle);
+		}
+no_ir:
+#endif
+		ret = setup_msi_irq(dev, desc, irq);
+		if (ret < 0)
+			goto error;
+		sub_handle++;
+	}
 	return 0;
+
+error:
+	destroy_irq(irq);
+	return ret;
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
@@ -2333,6 +2872,10 @@ void __init setup_ioapic_dest(void)
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
+#ifdef CONFIG_INTR_REMAP
+			else if (intr_remapping_enabled)
+				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
+#endif
 			else
 				set_ioapic_affinity_irq(irq, TARGET_CPUS);
 		}
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index d669142..9200a1e 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -74,6 +74,15 @@ void __init init_ISA_irqs (void)
 	}
 }
 
+/*
+ * IRQ2 is cascade interrupt to second interrupt controller
+ */
+static struct irqaction irq2 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "cascade",
+};
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
@@ -98,6 +107,46 @@ void __init native_init_IRQ(void)
 			set_intr_gate(vector, interrupt[i]);
 	}
 
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
+	/*
+	 * IRQ0 must be given a fixed assignment and initialized,
+	 * because it's used before the IO-APIC is set up.
+	 */
+	set_intr_gate(FIRST_DEVICE_VECTOR, interrupt[0]);
+
+	/*
+	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
+	 * IPI, driven by wakeup.
+	 */
+	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
+
+	/* IPI for invalidation */
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
+
+	/* IPI for generic function call */
+	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
+
+	/* IPI for single call function */
+	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR, call_function_single_interrupt);
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	/* self generated IPI for local APIC timer */
+	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
+
+	/* IPI vectors for APIC spurious and error interrupts */
+	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
+	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+#endif
+
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
+	/* thermal monitor LVT interrupt */
+	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
+#endif
+
+	if (!acpi_ioapic)
+		setup_irq(2, &irq2);
+
 	/* setup after call gates are initialised (usually add in
 	 * the architecture specific gates)
 	 */
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b3fb430..f98f4e1 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -397,7 +397,9 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
        generic_bigsmp_probe();
 #endif
 
+#ifdef CONFIG_X86_32
 	setup_apic_routing();
+#endif
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index eecc8c1..4caff39 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -229,6 +229,12 @@ static void __init smp_read_mpc_oem(struct mp_config_oemtable *oemtable,
 	}
 }
 
+static int __init numaq_setup_ioapic_ids(void)
+{
+	/* so can skip it */
+	return 1;
+}
+
 static struct x86_quirks numaq_x86_quirks __initdata = {
 	.arch_pre_time_init	= numaq_pre_time_init,
 	.arch_time_init		= NULL,
@@ -243,6 +249,7 @@ static struct x86_quirks numaq_x86_quirks __initdata = {
 	.mpc_oem_bus_info	= mpc_oem_bus_info,
 	.mpc_oem_pci_bus	= mpc_oem_pci_bus,
 	.smp_read_mpc_oem	= smp_read_mpc_oem,
+	.setup_ioapic_ids	= numaq_setup_ioapic_ids,
 };
 
 void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index e2f4376..6b0bb73 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -374,8 +374,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
-	.apic_write = native_apic_write,
-	.apic_read = native_apic_read,
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 	.startup_ipi_hook = paravirt_nop,
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ec7a2ba..c622772 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,7 +15,6 @@ unsigned long idle_nomwait;
 EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
-static int force_mwait __cpuinitdata;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 141efab..46c98ef 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -758,6 +758,8 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
+ 	if (cpu_has_x2apic)
+ 		check_x2apic();
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
diff --git a/arch/x86/kernel/sigframe.h b/arch/x86/kernel/sigframe.h
index 8b4956e..cc673aa 100644
--- a/arch/x86/kernel/sigframe.h
+++ b/arch/x86/kernel/sigframe.h
@@ -3,9 +3,18 @@ struct sigframe {
 	char __user *pretcode;
 	int sig;
 	struct sigcontext sc;
-	struct _fpstate fpstate;
+	/*
+	 * fpstate is unused. fpstate is moved/allocated after
+	 * retcode[] below. This movement allows to have the FP state and the
+	 * future state extensions (xsave) stay together.
+	 * And at the same time retaining the unused fpstate, prevents changing
+	 * the offset of extramask[] in the sigframe and thus prevent any
+	 * legacy application accessing/modifying it.
+	 */
+	struct _fpstate fpstate_unused;
 	unsigned long extramask[_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp state follows here */
 };
 
 struct rt_sigframe {
@@ -15,14 +24,15 @@ struct rt_sigframe {
 	void __user *puc;
 	struct siginfo info;
 	struct ucontext uc;
-	struct _fpstate fpstate;
 	char retcode[8];
+	/* fp state follows here */
 };
 #else
 struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
+	/* fp state follows here */
 };
 
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 2a2435d..b21070e 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -161,28 +161,14 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	}
 
 	{
-		struct _fpstate __user *buf;
+		void __user *buf;
 
 		err |= __get_user(buf, &sc->fpstate);
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
@@ -264,7 +250,7 @@ badframe:
  * Set up a signal frame.
  */
 static int
-setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
+setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
 {
 	int tmp, err = 0;
@@ -291,7 +277,7 @@ setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
-	tmp = save_i387(fpstate);
+	tmp = save_i387_xstate(fpstate);
 	if (tmp < 0)
 		err = 1;
 	else
@@ -308,7 +294,8 @@ setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
  * Determine which stack to use..
  */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
+	     void **fpstate)
 {
 	unsigned long sp;
 
@@ -334,6 +321,11 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 			sp = (unsigned long) ka->sa.sa_restorer;
 	}
 
+	if (used_math()) {
+		sp = sp - sig_xstate_size;
+		*fpstate = (struct _fpstate *) sp;
+	}
+
 	sp -= frame_size;
 	/*
 	 * Align the stack pointer according to the i386 ABI,
@@ -352,8 +344,9 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	void __user *fpstate = NULL;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -368,7 +361,7 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	if (err)
 		goto give_sigsegv;
 
-	err = setup_sigcontext(&frame->sc, &frame->fpstate, regs, set->sig[0]);
+	err = setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
 		goto give_sigsegv;
 
@@ -429,8 +422,9 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	void __user *fpstate = NULL;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -449,13 +443,16 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 694aa88..823a55b 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -53,69 +53,6 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 }
 
 /*
- * Signal frame handlers.
- */
-
-static inline int save_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
-
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
-				   sizeof(struct i387_fxsave_struct)))
-			return -1;
-	}
-	return 1;
-}
-
-/*
- * This restores directly out of user space. Exceptions are handled.
- */
-static inline int restore_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	err = restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-	if (unlikely(err)) {
-		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
-		 */
-		clear_fpu(tsk);
-		clear_used_math();
-	}
-	return err;
-}
-
-/*
  * Do a signal return; undo the signal stack.
  */
 static int
@@ -159,25 +96,11 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	{
 		struct _fpstate __user *buf;
 		err |= __get_user(buf, &sc->fpstate);
-
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
@@ -269,26 +192,23 @@ get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	return (void __user *)round_down(sp - size, 16);
+	return (void __user *)round_down(sp - size, 64);
 }
 
 static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			   sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	struct _fpstate __user *fp = NULL;
+	void __user *fp = NULL;
 	int err = 0;
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sizeof(struct _fpstate));
+		fp = get_stack(ka, regs, sig_xstate_size);
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
-		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
-			goto give_sigsegv;
-
-		if (save_i387(fp) < 0)
+		if (save_i387_xstate(fp) < 0)
 			err |= -1;
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
@@ -303,7 +223,10 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 45531e3..2ff0bbc 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -123,7 +123,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 static atomic_t init_deasserted;
 
-static int boot_cpu_logical_apicid;
 
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
@@ -165,6 +164,8 @@ static void unmap_cpu_to_node(int cpu)
 #endif
 
 #ifdef CONFIG_X86_32
+static int boot_cpu_logical_apicid;
+
 u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
 					{ [0 ... NR_CPUS-1] = BAD_APICID };
 
@@ -210,7 +211,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * (This works even if the APIC is not enabled.)
 	 */
-	phys_id = GET_APIC_ID(read_apic_id());
+	phys_id = read_apic_id();
 	cpuid = smp_processor_id();
 	if (cpu_isset(cpuid, cpu_callin_map)) {
 		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
@@ -550,8 +551,7 @@ static inline void __inquire_remote_apic(int apicid)
 			printk(KERN_CONT
 			       "a previous APIC delivery may have failed\n");
 
-		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
-		apic_write(APIC_ICR, APIC_DM_REMRD | regs[i]);
+		apic_icr_write(APIC_DM_REMRD | regs[i], apicid);
 
 		timeout = 0;
 		do {
@@ -583,11 +583,9 @@ wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 	int maxlvt;
 
 	/* Target chip */
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
-
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_write(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
+	apic_icr_write(APIC_DM_NMI | APIC_DEST_LOGICAL, logical_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -640,13 +638,11 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	/*
 	 * Turn INIT on target chip
 	 */
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
 	/*
 	 * Send IPI
 	 */
-	apic_write(APIC_ICR,
-		   APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT);
+	apic_icr_write(APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT,
+		       phys_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -656,10 +652,8 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	pr_debug("Deasserting INIT.\n");
 
 	/* Target chip */
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
 	/* Send IPI */
-	apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_icr_write(APIC_INT_LEVELTRIG | APIC_DM_INIT, phys_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -702,11 +696,10 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 		 */
 
 		/* Target chip */
-		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
 		/* Boot on the stack */
 		/* Kick the second */
-		apic_write(APIC_ICR, APIC_DM_STARTUP | (start_eip >> 12));
+		apic_icr_write(APIC_DM_STARTUP | (start_eip >> 12),
+			       phys_apicid);
 
 		/*
 		 * Give the other CPU some time to accept the IPI.
@@ -1175,10 +1168,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
+#ifdef CONFIG_X86_32
 	boot_cpu_logical_apicid = logical_smp_processor_id();
+#endif
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
 
+#ifdef CONFIG_X86_64
+	enable_IR_x2apic();
+	setup_apic_routing();
+#endif
+
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
 		disable_smp();
@@ -1186,9 +1186,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 
 	preempt_disable();
-	if (GET_APIC_ID(read_apic_id()) != boot_cpu_physical_apicid) {
+	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-		     GET_APIC_ID(read_apic_id()), boot_cpu_physical_apicid);
+		     read_apic_id(), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
 	preempt_enable();
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index d67ce5f..7b98785 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -30,7 +30,7 @@
 #include <linux/init.h>
 #include <asm/io.h>
 #include <asm/bios_ebda.h>
-#include <asm/mach-summit/mach_mpparse.h>
+#include <asm/summit/mpparse.h>
 
 static struct rio_table_hdr *rio_table_hdr __initdata;
 static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 03df8e4..da5a596 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1228,7 +1228,6 @@ void __init trap_init(void)
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
-	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 7a31f10..2887a78 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1138,7 +1138,7 @@ asmlinkage void math_state_restore(void)
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
-	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
+	if (unlikely(restore_fpu_checking(me))) {
 		stts();
 		force_sig(SIGSEGV, me);
 		return;
@@ -1179,10 +1179,6 @@ void __init trap_init(void)
 	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
 	/*
-	 * initialize the per thread extended state:
-	 */
-	init_thread_xstate();
-	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 8c9ad02..8b6c393 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -905,8 +905,8 @@ static inline int __init activate_vmi(void)
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	para_fill(pv_apic_ops.apic_read, APICRead);
-	para_fill(pv_apic_ops.apic_write, APICWrite);
+       para_fill(apic_ops->read, APICRead);
+       para_fill(apic_ops->write, APICWrite);
 #endif
 
 	/*
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index af5bdad..a9b8560 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -140,10 +140,10 @@ SECTIONS
 	*(.con_initcall.init)
   	__con_initcall_end = .;
   }
-  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
-	__x86cpuvendor_start = .;
-	*(.x86cpuvendor.init)
-	__x86cpuvendor_end = .;
+  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	__x86_cpu_dev_start = .;
+	*(.x86_cpu_dev.init)
+	__x86_cpu_dev_end = .;
   }
   SECURITY_INIT
   . = ALIGN(4);
@@ -180,6 +180,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
+	*(.data.percpu.page_aligned)
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 63e5c1a..201e81a 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -168,13 +168,12 @@ SECTIONS
 	*(.con_initcall.init)
   }
   __con_initcall_end = .;
-  . = ALIGN(16);
-  __x86cpuvendor_start = .;
-  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
-	*(.x86cpuvendor.init)
+  __x86_cpu_dev_start = .;
+  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	*(.x86_cpu_dev.init)
   }
-  __x86cpuvendor_end = .;
   SECURITY_INIT
+  __x86_cpu_dev_end = .;
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
new file mode 100644
index 0000000..07713d6
--- /dev/null
+++ b/arch/x86/kernel/xsave.c
@@ -0,0 +1,316 @@
+/*
+ * xsave/xrstor support.
+ *
+ * Author: Suresh Siddha <suresh.b.siddha@intel.com>
+ */
+#include <linux/bootmem.h>
+#include <linux/compat.h>
+#include <asm/i387.h>
+#ifdef CONFIG_IA32_EMULATION
+#include <asm/sigcontext32.h>
+#endif
+#include <asm/xcr.h>
+
+/*
+ * Supported feature mask by the CPU and the kernel.
+ */
+u64 pcntxt_mask;
+
+struct _fpx_sw_bytes fx_sw_reserved;
+#ifdef CONFIG_IA32_EMULATION
+struct _fpx_sw_bytes fx_sw_reserved_ia32;
+#endif
+
+/*
+ * Check for the presence of extended state information in the
+ * user fpstate pointer in the sigcontext.
+ */
+int check_for_xstate(struct i387_fxsave_struct __user *buf,
+		     void __user *fpstate,
+		     struct _fpx_sw_bytes *fx_sw_user)
+{
+	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
+			      sizeof(struct xsave_hdr_struct);
+	unsigned int magic2;
+	int err;
+
+	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
+			       sizeof(struct _fpx_sw_bytes));
+
+	if (err)
+		return err;
+
+	/*
+	 * First Magic check failed.
+	 */
+	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
+		return -1;
+
+	/*
+	 * Check for error scenarios.
+	 */
+	if (fx_sw_user->xstate_size < min_xstate_size ||
+	    fx_sw_user->xstate_size > xstate_size ||
+	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
+		return -1;
+
+	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
+					    fx_sw_user->extended_size -
+					    FP_XSTATE_MAGIC2_SIZE));
+	/*
+	 * Check for the presence of second magic word at the end of memory
+	 * layout. This detects the case where the user just copied the legacy
+	 * fpstate layout with out copying the extended state information
+	 * in the memory layout.
+	 */
+	if (err || magic2 != FP_XSTATE_MAGIC2)
+		return -1;
+
+	return 0;
+}
+
+#ifdef CONFIG_X86_64
+/*
+ * Signal frame handlers.
+ */
+
+int save_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
+		return -EACCES;
+
+	BUG_ON(sig_xstate_size < xstate_size);
+
+	if ((unsigned long)buf % 64)
+		printk("save_i387_xstate: bad fpstate %p\n", buf);
+
+	if (!used_math())
+		return 0;
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		/*
+	 	 * Start with clearing the user buffer. This will present a
+	 	 * clean context for the bytes not touched by the fxsave/xsave.
+		 */
+		__clear_user(buf, sig_xstate_size);
+
+		if (task_thread_info(tsk)->status & TS_XSAVE)
+			err = xsave_user(buf);
+		else
+			err = fxsave_user(buf);
+
+		if (err)
+			return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+				   xstate_size))
+			return -1;
+	}
+
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		struct _fpstate __user *fx = buf;
+
+		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
+				     sizeof(struct _fpx_sw_bytes));
+
+		err |= __put_user(FP_XSTATE_MAGIC2,
+				  (__u32 __user *) (buf + sig_xstate_size
+						    - FP_XSTATE_MAGIC2_SIZE));
+	}
+
+	return 1;
+}
+
+/*
+ * Restore the extended state if present. Otherwise, restore the FP/SSE
+ * state.
+ */
+int restore_user_xstate(void __user *buf)
+{
+	struct _fpx_sw_bytes fx_sw_user;
+	u64 mask;
+	int err;
+
+	if (((unsigned long)buf % 64) ||
+	     check_for_xstate(buf, buf, &fx_sw_user))
+		goto fx_only;
+
+	mask = fx_sw_user.xstate_bv;
+
+	/*
+	 * restore the state passed by the user.
+	 */
+	err = xrestore_user(buf, mask);
+	if (err)
+		return err;
+
+	/*
+	 * init the state skipped by the user.
+	 */
+	mask = pcntxt_mask & ~mask;
+
+	xrstor_state(init_xstate_buf, mask);
+
+	return 0;
+
+fx_only:
+	/*
+	 * couldn't find the extended state information in the
+	 * memory layout. Restore just the FP/SSE and init all
+	 * the other extended state.
+	 */
+	xrstor_state(init_xstate_buf, pcntxt_mask & ~XSTATE_FPSSE);
+	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+}
+
+/*
+ * This restores directly out of user space. Exceptions are handled.
+ */
+int restore_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	if (!buf) {
+		if (used_math())
+			goto clear;
+		return 0;
+	} else
+		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
+			return -EACCES;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		err = restore_user_xstate(buf);
+	else
+		err = fxrstor_checking((__force struct i387_fxsave_struct *)
+				       buf);
+	if (unlikely(err)) {
+		/*
+		 * Encountered an error while doing the restore from the
+		 * user buffer, clear the fpu state.
+		 */
+clear:
+		clear_fpu(tsk);
+		clear_used_math();
+	}
+	return err;
+}
+#endif
+
+/*
+ * Prepare the SW reserved portion of the fxsave memory layout, indicating
+ * the presence of the extended state information in the memory layout
+ * pointed by the fpstate pointer in the sigcontext.
+ * This will be saved when ever the FP and extended state context is
+ * saved on the user stack during the signal handler delivery to the user.
+ */
+void prepare_fx_sw_frame(void)
+{
+	int size_extended = (xstate_size - sizeof(struct i387_fxsave_struct)) +
+			     FP_XSTATE_MAGIC2_SIZE;
+
+	sig_xstate_size = sizeof(struct _fpstate) + size_extended;
+
+#ifdef CONFIG_IA32_EMULATION
+	sig_xstate_ia32_size = sizeof(struct _fpstate_ia32) + size_extended;
+#endif
+
+	memset(&fx_sw_reserved, 0, sizeof(fx_sw_reserved));
+
+	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
+	fx_sw_reserved.extended_size = sig_xstate_size;
+	fx_sw_reserved.xstate_bv = pcntxt_mask;
+	fx_sw_reserved.xstate_size = xstate_size;
+#ifdef CONFIG_IA32_EMULATION
+	memcpy(&fx_sw_reserved_ia32, &fx_sw_reserved,
+	       sizeof(struct _fpx_sw_bytes));
+	fx_sw_reserved_ia32.extended_size = sig_xstate_ia32_size;
+#endif
+}
+
+/*
+ * Represents init state for the supported extended state.
+ */
+struct xsave_struct *init_xstate_buf;
+
+#ifdef CONFIG_X86_64
+unsigned int sig_xstate_size = sizeof(struct _fpstate);
+#endif
+
+/*
+ * Enable the extended processor state save/restore feature
+ */
+void __cpuinit xsave_init(void)
+{
+	if (!cpu_has_xsave)
+		return;
+
+	set_in_cr4(X86_CR4_OSXSAVE);
+
+	/*
+	 * Enable all the features that the HW is capable of
+	 * and the Linux kernel is aware of.
+	 */
+	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+}
+
+/*
+ * setup the xstate image representing the init state
+ */
+void setup_xstate_init(void)
+{
+	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+}
+
+/*
+ * Enable and initialize the xsave feature.
+ */
+void __init xsave_cntxt_init(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	pcntxt_mask = eax + ((u64)edx << 32);
+
+	if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
+		printk(KERN_ERR "FP/SSE not shown under xsave features 0x%llx\n",
+		       pcntxt_mask);
+		BUG();
+	}
+
+	/*
+	 * for now OS knows only about FP/SSE
+	 */
+	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
+	xsave_init();
+
+	/*
+	 * Recompute the context size for enabled features
+	 */
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+	xstate_size = ebx;
+
+	prepare_fx_sw_frame();
+
+	setup_xstate_init();
+
+	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv 0x%llx, "
+	       "cntxt size 0x%x\n",
+	       pcntxt_mask, xstate_size);
+}
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 23e8373..17e2599 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,21 +331,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define MSR_IA32_VMX_BASIC                      0x480
-#define MSR_IA32_VMX_PINBASED_CTLS              0x481
-#define MSR_IA32_VMX_PROCBASED_CTLS             0x482
-#define MSR_IA32_VMX_EXIT_CTLS                  0x483
-#define MSR_IA32_VMX_ENTRY_CTLS                 0x484
-#define MSR_IA32_VMX_MISC                       0x485
-#define MSR_IA32_VMX_CR0_FIXED0                 0x486
-#define MSR_IA32_VMX_CR0_FIXED1                 0x487
-#define MSR_IA32_VMX_CR4_FIXED0                 0x488
-#define MSR_IA32_VMX_CR4_FIXED1                 0x489
-#define MSR_IA32_VMX_VMCS_ENUM                  0x48a
-#define MSR_IA32_VMX_PROCBASED_CTLS2            0x48b
-#define MSR_IA32_VMX_EPT_VPID_CAP               0x48c
-
-#define MSR_IA32_FEATURE_CONTROL                0x3a
 #define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
 #define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x4
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index d9249a8..65f0b8a 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -55,6 +55,7 @@
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
 #include <linux/pm.h>
+#include <asm/apic.h>
 #include <asm/lguest.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
@@ -783,14 +784,44 @@ static void lguest_wbinvd(void)
  * code qualifies for Advanced.  It will also never interrupt anything.  It
  * does, however, allow us to get through the Linux boot code. */
 #ifdef CONFIG_X86_LOCAL_APIC
-static void lguest_apic_write(unsigned long reg, u32 v)
+static void lguest_apic_write(u32 reg, u32 v)
 {
 }
 
-static u32 lguest_apic_read(unsigned long reg)
+static u32 lguest_apic_read(u32 reg)
 {
 	return 0;
 }
+
+static u64 lguest_apic_icr_read(void)
+{
+	return 0;
+}
+
+static void lguest_apic_icr_write(u32 low, u32 id)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static void lguest_apic_wait_icr_idle(void)
+{
+	return;
+}
+
+static u32 lguest_apic_safe_wait_icr_idle(void)
+{
+	return 0;
+}
+
+static struct apic_ops lguest_basic_apic_ops = {
+	.read = lguest_apic_read,
+	.write = lguest_apic_write,
+	.icr_read = lguest_apic_icr_read,
+	.icr_write = lguest_apic_icr_write,
+	.wait_icr_idle = lguest_apic_wait_icr_idle,
+	.safe_wait_icr_idle = lguest_apic_safe_wait_icr_idle,
+};
 #endif
 
 /* STOP!  Until an interrupt comes in. */
@@ -990,8 +1021,7 @@ __init void lguest_init(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */
-	pv_apic_ops.apic_write = lguest_apic_write;
-	pv_apic_ops.apic_read = lguest_apic_read;
+	apic_ops = &lguest_basic_apic_ops;
 #endif
 
 	/* time operations */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index aa3fa41..55e11aa 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -17,9 +17,6 @@ ifeq ($(CONFIG_X86_32),y)
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
         obj-y += io_64.o iomap_copy_64.o
-
-        CFLAGS_csum-partial_64.o := -funroll-loops
-
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 24e6094..9e68075 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -14,6 +14,13 @@
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
 
+#ifdef CONFIG_X86_INTEL_USERCOPY
+/*
+ * Alignment at which movsl is preferred for bulk memory copies.
+ */
+struct movsl_mask movsl_mask __read_mostly;
+#endif
+
 static inline int __movsl_is_ok(unsigned long a1, unsigned long a2, unsigned long n)
 {
 #ifdef CONFIG_X86_INTEL_USERCOPY
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index 3f2cf11..37b9ae4 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -38,15 +38,6 @@ void __init pre_intr_init_hook(void)
 	init_ISA_irqs();
 }
 
-/*
- * IRQ2 is cascade interrupt to second interrupt controller
- */
-static struct irqaction irq2 = {
-	.handler = no_action,
-	.mask = CPU_MASK_NONE,
-	.name = "cascade",
-};
-
 /**
  * intr_init_hook - post gate setup interrupt initialisation
  *
@@ -62,12 +53,6 @@ void __init intr_init_hook(void)
 		if (x86_quirks->arch_intr_init())
 			return;
 	}
-#ifdef CONFIG_X86_LOCAL_APIC
-	apic_intr_init();
-#endif
-
-	if (!acpi_ioapic)
-		setup_irq(2, &irq2);
 }
 
 /**
diff --git a/arch/x86/mach-es7000/Makefile b/arch/x86/mach-es7000/Makefile
deleted file mode 100644
index 3ef8b43..0000000
--- a/arch/x86/mach-es7000/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-obj-$(CONFIG_X86_ES7000)	:= es7000plat.o
diff --git a/arch/x86/mach-es7000/es7000.h b/arch/x86/mach-es7000/es7000.h
deleted file mode 100644
index c8d5aa1..0000000
--- a/arch/x86/mach-es7000/es7000.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Written by: Garry Forsgren, Unisys Corporation
- *             Natalie Protasevich, Unisys Corporation
- * This file contains the code to configure and interface 
- * with Unisys ES7000 series hardware system manager.
- *
- * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * Contact information: Unisys Corporation, Township Line & Union Meeting 
- * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
- *
- * http://www.unisys.com
- */
-
-/*
- * ES7000 chipsets
- */
-
-#define NON_UNISYS		0
-#define ES7000_CLASSIC		1
-#define ES7000_ZORRO		2
-
-
-#define	MIP_REG			1
-#define	MIP_PSAI_REG		4
-
-#define	MIP_BUSY		1
-#define	MIP_SPIN		0xf0000
-#define	MIP_VALID		0x0100000000000000ULL
-#define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
-
-#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)   
-
-struct mip_reg_info {
-	unsigned long long mip_info;
-	unsigned long long delivery_info;
-	unsigned long long host_reg;
-	unsigned long long mip_reg;
-};
-
-struct part_info {
-	unsigned char type;   
-	unsigned char length;
-	unsigned char part_id;
-	unsigned char apic_mode;
-	unsigned long snum;    
-	char ptype[16];
-	char sname[64];
-	char pname[64];
-};
-
-struct psai {
-	unsigned long long entry_type;
-	unsigned long long addr;
-	unsigned long long bep_addr;
-};
-
-struct es7000_mem_info {
-	unsigned char type;   
-	unsigned char length;
-	unsigned char resv[6];
-	unsigned long long  start; 
-	unsigned long long  size; 
-};
-
-struct es7000_oem_table {
-	unsigned long long hdr;
-	struct mip_reg_info mip;
-	struct part_info pif;
-	struct es7000_mem_info shm;
-	struct psai psai;
-};
-
-#ifdef CONFIG_ACPI
-
-struct oem_table {
-	struct acpi_table_header Header;
-	u32 OEMTableAddr;
-	u32 OEMTableSize;
-};
-
-extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
-#endif
-
-struct mip_reg {
-	unsigned long long off_0;
-	unsigned long long off_8;
-	unsigned long long off_10;
-	unsigned long long off_18;
-	unsigned long long off_20;
-	unsigned long long off_28;
-	unsigned long long off_30;
-	unsigned long long off_38;
-};
-
-#define	MIP_SW_APIC		0x1020b
-#define	MIP_FUNC(VALUE) 	(VALUE & 0xff)
-
-extern int parse_unisys_oem (char *oemptr);
-extern void setup_unisys(void);
-extern int es7000_start_cpu(int cpu, unsigned long eip);
-extern void es7000_sw_apic(void);
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
index 0dbd780..6730f4e 100644
--- a/arch/x86/mach-generic/Makefile
+++ b/arch/x86/mach-generic/Makefile
@@ -9,4 +9,3 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT)	+= summit.o
 obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
 obj-$(CONFIG_X86_ES7000)	+= es7000.o
-obj-$(CONFIG_X86_ES7000)	+= ../../x86/mach-es7000/
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 59d7717..df37fc9 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -5,18 +5,17 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <linux/kernel.h>
-#include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/mach-bigsmp/mach_apic.h>
-#include <asm/mach-bigsmp/mach_apicdef.h>
-#include <asm/mach-bigsmp/mach_ipi.h>
+#include <asm/bigsmp/apicdef.h>
+#include <linux/smp.h>
+#include <asm/bigsmp/apic.h>
+#include <asm/bigsmp/ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 4742626..520cca0 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -4,20 +4,19 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/smp.h>
 #include <linux/init.h>
-#include <asm/mach-es7000/mach_apicdef.h>
-#include <asm/mach-es7000/mach_apic.h>
-#include <asm/mach-es7000/mach_ipi.h>
-#include <asm/mach-es7000/mach_mpparse.h>
-#include <asm/mach-es7000/mach_wakecpu.h>
+#include <asm/es7000/apicdef.h>
+#include <linux/smp.h>
+#include <asm/es7000/apic.h>
+#include <asm/es7000/ipi.h>
+#include <asm/es7000/mpparse.h>
+#include <asm/es7000/wakecpu.h>
 
 static int probe_es7000(void)
 {
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 8091e68..8cf5839 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -4,7 +4,6 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <linux/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
@@ -12,11 +11,12 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/mach-numaq/mach_apic.h>
-#include <asm/mach-numaq/mach_apicdef.h>
-#include <asm/mach-numaq/mach_ipi.h>
-#include <asm/mach-numaq/mach_mpparse.h>
-#include <asm/mach-numaq/mach_wakecpu.h>
+#include <asm/numaq/apicdef.h>
+#include <linux/smp.h>
+#include <asm/numaq/apic.h>
+#include <asm/numaq/ipi.h>
+#include <asm/numaq/mpparse.h>
+#include <asm/numaq/wakecpu.h>
 #include <asm/numaq.h>
 
 static int mps_oem_check(struct mp_config_table *mpc, char *oem,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index a97ea0f..6ad6b67 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -4,19 +4,18 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/smp.h>
 #include <linux/init.h>
-#include <asm/mach-summit/mach_apic.h>
-#include <asm/mach-summit/mach_apicdef.h>
-#include <asm/mach-summit/mach_ipi.h>
-#include <asm/mach-summit/mach_mpparse.h>
+#include <asm/summit/apicdef.h>
+#include <linux/smp.h>
+#include <asm/summit/apic.h>
+#include <asm/summit/ipi.h>
+#include <asm/summit/mpparse.h>
 
 static int probe_summit(void)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index fb30486..83e13f2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -88,6 +88,62 @@ early_param("gbpages", parse_direct_gbpages_on);
 
 int after_bootmem;
 
+unsigned long __supported_pte_mask __read_mostly = ~0UL;
+EXPORT_SYMBOL_GPL(__supported_pte_mask);
+
+static int do_not_nx __cpuinitdata;
+
+/*
+ * noexec=on|off
+ * Control non-executable mappings for 64-bit processes.
+ *
+ * on	Enable (default)
+ * off	Disable
+ */
+static int __init nonx_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		do_not_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		do_not_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", nonx_setup);
+
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || do_not_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+
+int force_personality32;
+
+/*
+ * noexec32=on|off
+ * Control non executable heap for 32bit processes.
+ * To control the stack too use noexec=off
+ *
+ * on	PROT_READ does not imply PROT_EXEC for 32-bit processes (default)
+ * off	PROT_READ implies PROT_EXEC
+ */
+static int __init nonx32_setup(char *str)
+{
+	if (!strcmp(str, "on"))
+		force_personality32 &= ~READ_IMPLIES_EXEC;
+	else if (!strcmp(str, "off"))
+		force_personality32 |= READ_IMPLIES_EXEC;
+	return 1;
+}
+__setup("noexec32=", nonx32_setup);
+
 /*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 19af069..1d88d2b 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -250,10 +250,5 @@ int __init pci_acpi_init(void)
 			acpi_pci_irq_enable(dev);
 	}
 
-#ifdef CONFIG_X86_IO_APIC
-	if (acpi_ioapic)
-		print_IO_APIC();
-#endif
-
 	return 0;
 }
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 8791fc5..844df0c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 
 #include <asm/pat.h>
+#include <asm/e820.h>
 
 #include "pci.h"
 
@@ -227,6 +228,8 @@ void __init pcibios_resource_survey(void)
 	pcibios_allocate_bus_resources(&pci_root_buses);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
+
+	e820_reserve_resources_late();
 }
 
 /**
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index d963576..654a223 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -209,7 +209,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
+static void __init pci_mmcfg_insert_resources(void)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -233,7 +233,7 @@ static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | resource_flags;
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
@@ -434,11 +434,9 @@ static void __init __pci_mmcfg_init(int early)
 	    (pci_mmcfg_config[0].address == 0))
 		return;
 
-	if (pci_mmcfg_arch_init()) {
-		if (known_bridge)
-			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
+	if (pci_mmcfg_arch_init())
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	} else {
+	else {
 		/*
 		 * Signal not to attempt to insert mmcfg resources because
 		 * the architecture mmcfg setup could not initialize.
@@ -475,7 +473,7 @@ static int __init pci_mmcfg_late_insert_resources(void)
 	 * marked so it won't cause request errors when __request_region is
 	 * called.
 	 */
-	pci_mmcfg_insert_resources(0);
+	pci_mmcfg_insert_resources();
 
 	return 0;
 }
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index d3e083d..274d060 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/xcr.h>
 
 static struct saved_context saved_context;
 
@@ -126,6 +127,12 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	if (boot_cpu_has(X86_FEATURE_SEP))
 		enable_sep_cpu();
 
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
 	fix_processor_context();
 	do_fpu_end();
 	mtrr_ap_init();
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 66bdfb5..e3b6cf7 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/xcr.h>
 
 static void fix_processor_context(void);
 
@@ -122,6 +123,12 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	wrmsrl(MSR_GS_BASE, ctxt->gs_base);
 	wrmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
 
+	/*
+	 * restore XCR0 for xsave capable cpu's.
+	 */
+	if (cpu_has_xsave)
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
+
 	fix_processor_context();
 
 	do_fpu_end();
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7dcd321..a27d562 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -36,6 +36,7 @@
 #include <xen/hvc-console.h>
 
 #include <asm/paravirt.h>
+#include <asm/apic.h>
 #include <asm/page.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -580,16 +581,47 @@ static void xen_io_delay(void)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-static u32 xen_apic_read(unsigned long reg)
+static u32 xen_apic_read(u32 reg)
 {
 	return 0;
 }
 
-static void xen_apic_write(unsigned long reg, u32 val)
+static void xen_apic_write(u32 reg, u32 val)
 {
 	/* Warn to see if there's any stray references */
 	WARN_ON(1);
 }
+
+static u64 xen_apic_icr_read(void)
+{
+	return 0;
+}
+
+static void xen_apic_icr_write(u32 low, u32 id)
+{
+	/* Warn to see if there's any stray references */
+	WARN_ON(1);
+}
+
+static void xen_apic_wait_icr_idle(void)
+{
+        return;
+}
+
+static u32 xen_safe_apic_wait_icr_idle(void)
+{
+        return 0;
+}
+
+static struct apic_ops xen_basic_apic_ops = {
+	.read = xen_apic_read,
+	.write = xen_apic_write,
+	.icr_read = xen_apic_icr_read,
+	.icr_write = xen_apic_icr_write,
+	.wait_icr_idle = xen_apic_wait_icr_idle,
+	.safe_wait_icr_idle = xen_safe_apic_wait_icr_idle,
+};
+
 #endif
 
 static void xen_flush_tlb(void)
@@ -1273,8 +1305,6 @@ static const struct pv_irq_ops xen_irq_ops __initdata = {
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
-	.apic_write = xen_apic_write,
-	.apic_read = xen_apic_read,
 	.setup_boot_clock = paravirt_nop,
 	.setup_secondary_clock = paravirt_nop,
 	.startup_ipi_hook = paravirt_nop,
@@ -1677,6 +1707,13 @@ asmlinkage void __init xen_start_kernel(void)
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
 
+#ifdef CONFIG_X86_LOCAL_APIC
+	/*
+	 * set up the basic apic ops.
+	 */
+	apic_ops = &xen_basic_apic_ops;
+#endif
+
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start = xen_ptep_modify_prot_start;
 		pv_mmu_ops.ptep_modify_prot_commit = xen_ptep_modify_prot_commit;
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 7d63f8c..4b47f4e 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -26,6 +26,8 @@ obj-$(CONFIG_HT_IRQ) += htirq.o
 # Build Intel IOMMU support
 obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
 
+obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
+
 #
 # Some architectures use the generic PCI setup functions
 #
diff --git a/drivers/pci/dma_remapping.h b/drivers/pci/dma_remapping.h
new file mode 100644
index 0000000..bff5c65
--- /dev/null
+++ b/drivers/pci/dma_remapping.h
@@ -0,0 +1,157 @@
+#ifndef _DMA_REMAPPING_H
+#define _DMA_REMAPPING_H
+
+/*
+ * We need a fixed PAGE_SIZE of 4K irrespective of
+ * arch PAGE_SIZE for IOMMU page tables.
+ */
+#define PAGE_SHIFT_4K		(12)
+#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
+#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
+#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
+
+#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
+#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
+#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
+
+
+/*
+ * 0: Present
+ * 1-11: Reserved
+ * 12-63: Context Ptr (12 - (haw-1))
+ * 64-127: Reserved
+ */
+struct root_entry {
+	u64	val;
+	u64	rsvd1;
+};
+#define ROOT_ENTRY_NR (PAGE_SIZE_4K/sizeof(struct root_entry))
+static inline bool root_present(struct root_entry *root)
+{
+	return (root->val & 1);
+}
+static inline void set_root_present(struct root_entry *root)
+{
+	root->val |= 1;
+}
+static inline void set_root_value(struct root_entry *root, unsigned long value)
+{
+	root->val |= value & PAGE_MASK_4K;
+}
+
+struct context_entry;
+static inline struct context_entry *
+get_context_addr_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root)?phys_to_virt(
+		root->val & PAGE_MASK_4K):
+		NULL);
+}
+
+/*
+ * low 64 bits:
+ * 0: present
+ * 1: fault processing disable
+ * 2-3: translation type
+ * 12-63: address space root
+ * high 64 bits:
+ * 0-2: address width
+ * 3-6: aval
+ * 8-23: domain id
+ */
+struct context_entry {
+	u64 lo;
+	u64 hi;
+};
+#define context_present(c) ((c).lo & 1)
+#define context_fault_disable(c) (((c).lo >> 1) & 1)
+#define context_translation_type(c) (((c).lo >> 2) & 3)
+#define context_address_root(c) ((c).lo & PAGE_MASK_4K)
+#define context_address_width(c) ((c).hi &  7)
+#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
+
+#define context_set_present(c) do {(c).lo |= 1;} while (0)
+#define context_set_fault_enable(c) \
+	do {(c).lo &= (((u64)-1) << 2) | 1;} while (0)
+#define context_set_translation_type(c, val) \
+	do { \
+		(c).lo &= (((u64)-1) << 4) | 3; \
+		(c).lo |= ((val) & 3) << 2; \
+	} while (0)
+#define CONTEXT_TT_MULTI_LEVEL 0
+#define context_set_address_root(c, val) \
+	do {(c).lo |= (val) & PAGE_MASK_4K;} while (0)
+#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;} while (0)
+#define context_set_domain_id(c, val) \
+	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
+#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)
+
+/*
+ * 0: readable
+ * 1: writable
+ * 2-6: reserved
+ * 7: super page
+ * 8-11: available
+ * 12-63: Host physcial address
+ */
+struct dma_pte {
+	u64 val;
+};
+#define dma_clear_pte(p)	do {(p).val = 0;} while (0)
+
+#define DMA_PTE_READ (1)
+#define DMA_PTE_WRITE (2)
+
+#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while (0)
+#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while (0)
+#define dma_set_pte_prot(p, prot) \
+		do {(p).val = ((p).val & ~3) | ((prot) & 3); } while (0)
+#define dma_pte_addr(p) ((p).val & PAGE_MASK_4K)
+#define dma_set_pte_addr(p, addr) do {\
+		(p).val |= ((addr) & PAGE_MASK_4K); } while (0)
+#define dma_pte_present(p) (((p).val & 3) != 0)
+
+struct intel_iommu;
+
+struct dmar_domain {
+	int	id;			/* domain id */
+	struct intel_iommu *iommu;	/* back pointer to owning iommu */
+
+	struct list_head devices; 	/* all devices' list */
+	struct iova_domain iovad;	/* iova's that belong to this domain */
+
+	struct dma_pte	*pgd;		/* virtual address */
+	spinlock_t	mapping_lock;	/* page table lock */
+	int		gaw;		/* max guest address width */
+
+	/* adjusted guest address width, 0 is level 2 30-bit */
+	int		agaw;
+
+#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
+	int		flags;
+};
+
+/* PCI domain-device relationship */
+struct device_domain_info {
+	struct list_head link;	/* link to domain siblings */
+	struct list_head global; /* link to global list */
+	u8 bus;			/* PCI bus numer */
+	u8 devfn;		/* PCI devfn number */
+	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
+	struct dmar_domain *domain; /* pointer to domain */
+};
+
+extern int init_dmars(void);
+extern void free_dmar_iommu(struct intel_iommu *iommu);
+
+extern int dmar_disabled;
+
+#ifndef CONFIG_DMAR_GFX_WA
+static inline void iommu_prepare_gfx_mapping(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_GFX_WA */
+
+#endif
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 8bf86ae..bd2c016 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -19,13 +19,16 @@
  * Author: Shaohua Li <shaohua.li@intel.com>
  * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  *
- * This file implements early detection/parsing of DMA Remapping Devices
+ * This file implements early detection/parsing of Remapping Devices
  * reported to OS through BIOS via DMA remapping reporting (DMAR) ACPI
  * tables.
+ *
+ * These routines are used by both DMA-remapping and Interrupt-remapping
  */
 
 #include <linux/pci.h>
 #include <linux/dmar.h>
+#include <linux/timer.h>
 #include "iova.h"
 #include "intel-iommu.h"
 
@@ -37,7 +40,6 @@
  * these units are not supported by the architecture.
  */
 LIST_HEAD(dmar_drhd_units);
-LIST_HEAD(dmar_rmrr_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
 
@@ -53,11 +55,6 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 		list_add(&drhd->list, &dmar_drhd_units);
 }
 
-static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
-{
-	list_add(&rmrr->list, &dmar_rmrr_units);
-}
-
 static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 					   struct pci_dev **dev, u16 segment)
 {
@@ -172,19 +169,37 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 	struct acpi_dmar_hardware_unit *drhd;
 	struct dmar_drhd_unit *dmaru;
 	int ret = 0;
-	static int include_all;
 
 	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
 	if (!dmaru)
 		return -ENOMEM;
 
+	dmaru->hdr = header;
 	drhd = (struct acpi_dmar_hardware_unit *)header;
 	dmaru->reg_base_addr = drhd->address;
 	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
 
+	ret = alloc_iommu(dmaru);
+	if (ret) {
+		kfree(dmaru);
+		return ret;
+	}
+	dmar_register_drhd_unit(dmaru);
+	return 0;
+}
+
+static int __init
+dmar_parse_dev(struct dmar_drhd_unit *dmaru)
+{
+	struct acpi_dmar_hardware_unit *drhd;
+	static int include_all;
+	int ret;
+
+	drhd = (struct acpi_dmar_hardware_unit *) dmaru->hdr;
+
 	if (!dmaru->include_all)
 		ret = dmar_parse_dev_scope((void *)(drhd + 1),
-				((void *)drhd) + header->length,
+				((void *)drhd) + drhd->header.length,
 				&dmaru->devices_cnt, &dmaru->devices,
 				drhd->segment);
 	else {
@@ -197,37 +212,59 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 		include_all = 1;
 	}
 
-	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all))
+	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all)) {
+		list_del(&dmaru->list);
 		kfree(dmaru);
-	else
-		dmar_register_drhd_unit(dmaru);
+	}
 	return ret;
 }
 
+#ifdef CONFIG_DMAR
+LIST_HEAD(dmar_rmrr_units);
+
+static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
+{
+	list_add(&rmrr->list, &dmar_rmrr_units);
+}
+
+
 static int __init
 dmar_parse_one_rmrr(struct acpi_dmar_header *header)
 {
 	struct acpi_dmar_reserved_memory *rmrr;
 	struct dmar_rmrr_unit *rmrru;
-	int ret = 0;
 
 	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
 	if (!rmrru)
 		return -ENOMEM;
 
+	rmrru->hdr = header;
 	rmrr = (struct acpi_dmar_reserved_memory *)header;
 	rmrru->base_address = rmrr->base_address;
 	rmrru->end_address = rmrr->end_address;
+
+	dmar_register_rmrr_unit(rmrru);
+	return 0;
+}
+
+static int __init
+rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	int ret;
+
+	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
 	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
-		((void *)rmrr) + header->length,
+		((void *)rmrr) + rmrr->header.length,
 		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
 
-	if (ret || (rmrru->devices_cnt == 0))
+	if (ret || (rmrru->devices_cnt == 0)) {
+		list_del(&rmrru->list);
 		kfree(rmrru);
-	else
-		dmar_register_rmrr_unit(rmrru);
+	}
 	return ret;
 }
+#endif
 
 static void __init
 dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
@@ -252,6 +289,7 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 	}
 }
 
+
 /**
  * parse_dmar_table - parses the DMA reporting table
  */
@@ -284,7 +322,9 @@ parse_dmar_table(void)
 			ret = dmar_parse_one_drhd(entry_header);
 			break;
 		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
+#ifdef CONFIG_DMAR
 			ret = dmar_parse_one_rmrr(entry_header);
+#endif
 			break;
 		default:
 			printk(KERN_WARNING PREFIX
@@ -300,15 +340,77 @@ parse_dmar_table(void)
 	return ret;
 }
 
+int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
+			  struct pci_dev *dev)
+{
+	int index;
+
+	while (dev) {
+		for (index = 0; index < cnt; index++)
+			if (dev == devices[index])
+				return 1;
 
-int __init dmar_table_init(void)
+		/* Check our parent */
+		dev = dev->bus->self;
+	}
+
+	return 0;
+}
+
+struct dmar_drhd_unit *
+dmar_find_matched_drhd_unit(struct pci_dev *dev)
 {
+	struct dmar_drhd_unit *drhd = NULL;
+
+	list_for_each_entry(drhd, &dmar_drhd_units, list) {
+		if (drhd->include_all || dmar_pci_device_match(drhd->devices,
+						drhd->devices_cnt, dev))
+			return drhd;
+	}
+
+	return NULL;
+}
+
+int __init dmar_dev_scope_init(void)
+{
+	struct dmar_drhd_unit *drhd;
+	int ret = -ENODEV;
+
+	for_each_drhd_unit(drhd) {
+		ret = dmar_parse_dev(drhd);
+		if (ret)
+			return ret;
+	}
+
+#ifdef CONFIG_DMAR
+	{
+		struct dmar_rmrr_unit *rmrr;
+		for_each_rmrr_units(rmrr) {
+			ret = rmrr_parse_dev(rmrr);
+			if (ret)
+				return ret;
+		}
+	}
+#endif
+
+	return ret;
+}
 
+
+int __init dmar_table_init(void)
+{
+	static int dmar_table_initialized;
 	int ret;
 
+	if (dmar_table_initialized)
+		return 0;
+
+	dmar_table_initialized = 1;
+
 	ret = parse_dmar_table();
 	if (ret) {
-		printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
+		if (ret != -ENODEV)
+			printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
 		return ret;
 	}
 
@@ -317,9 +419,14 @@ int __init dmar_table_init(void)
 		return -ENODEV;
 	}
 
+#ifdef CONFIG_DMAR
 	if (list_empty(&dmar_rmrr_units))
 		printk(KERN_INFO PREFIX "No RMRR found\n");
+#endif
 
+#ifdef CONFIG_INTR_REMAP
+	parse_ioapics_under_ir();
+#endif
 	return 0;
 }
 
@@ -341,3 +448,255 @@ int __init early_dmar_detect(void)
 
 	return (ACPI_SUCCESS(status) ? 1 : 0);
 }
+
+void __init detect_intel_iommu(void)
+{
+	int ret;
+
+	ret = early_dmar_detect();
+
+#ifdef CONFIG_DMAR
+	{
+		struct acpi_table_dmar *dmar;
+		/*
+		 * for now we will disable dma-remapping when interrupt
+		 * remapping is enabled.
+		 * When support for queued invalidation for IOTLB invalidation
+		 * is added, we will not need this any more.
+		 */
+		dmar = (struct acpi_table_dmar *) dmar_tbl;
+		if (ret && cpu_has_x2apic && dmar->flags & 0x1) {
+			printk(KERN_INFO
+			       "Queued invalidation will be enabled to support "
+			       "x2apic and Intr-remapping.\n");
+			printk(KERN_INFO
+			       "Disabling IOMMU detection, because of missing "
+			       "queued invalidation support for IOTLB "
+			       "invalidation\n");
+			printk(KERN_INFO
+			       "Use \"nox2apic\", if you want to use Intel "
+			       " IOMMU for DMA-remapping and don't care about "
+			       " x2apic support\n");
+
+			dmar_disabled = 1;
+			return;
+		}
+
+		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
+		    !dmar_disabled)
+			iommu_detected = 1;
+	}
+#endif
+}
+
+
+int alloc_iommu(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu;
+	int map_size;
+	u32 ver;
+	static int iommu_allocated = 0;
+
+	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
+	if (!iommu)
+		return -ENOMEM;
+
+	iommu->seq_id = iommu_allocated++;
+
+	iommu->reg = ioremap(drhd->reg_base_addr, PAGE_SIZE_4K);
+	if (!iommu->reg) {
+		printk(KERN_ERR "IOMMU: can't map the region\n");
+		goto error;
+	}
+	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
+	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
+
+	/* the registers might be more than one page */
+	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
+		cap_max_fault_reg_offset(iommu->cap));
+	map_size = PAGE_ALIGN_4K(map_size);
+	if (map_size > PAGE_SIZE_4K) {
+		iounmap(iommu->reg);
+		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
+		if (!iommu->reg) {
+			printk(KERN_ERR "IOMMU: can't map the region\n");
+			goto error;
+		}
+	}
+
+	ver = readl(iommu->reg + DMAR_VER_REG);
+	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+		drhd->reg_base_addr, DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
+		iommu->cap, iommu->ecap);
+
+	spin_lock_init(&iommu->register_lock);
+
+	drhd->iommu = iommu;
+	return 0;
+error:
+	kfree(iommu);
+	return -1;
+}
+
+void free_iommu(struct intel_iommu *iommu)
+{
+	if (!iommu)
+		return;
+
+#ifdef CONFIG_DMAR
+	free_dmar_iommu(iommu);
+#endif
+
+	if (iommu->reg)
+		iounmap(iommu->reg);
+	kfree(iommu);
+}
+
+/*
+ * Reclaim all the submitted descriptors which have completed its work.
+ */
+static inline void reclaim_free_desc(struct q_inval *qi)
+{
+	while (qi->desc_status[qi->free_tail] == QI_DONE) {
+		qi->desc_status[qi->free_tail] = QI_FREE;
+		qi->free_tail = (qi->free_tail + 1) % QI_LENGTH;
+		qi->free_cnt++;
+	}
+}
+
+/*
+ * Submit the queued invalidation descriptor to the remapping
+ * hardware unit and wait for its completion.
+ */
+void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
+{
+	struct q_inval *qi = iommu->qi;
+	struct qi_desc *hw, wait_desc;
+	int wait_index, index;
+	unsigned long flags;
+
+	if (!qi)
+		return;
+
+	hw = qi->desc;
+
+	spin_lock(&qi->q_lock);
+	while (qi->free_cnt < 3) {
+		spin_unlock(&qi->q_lock);
+		cpu_relax();
+		spin_lock(&qi->q_lock);
+	}
+
+	index = qi->free_head;
+	wait_index = (index + 1) % QI_LENGTH;
+
+	qi->desc_status[index] = qi->desc_status[wait_index] = QI_IN_USE;
+
+	hw[index] = *desc;
+
+	wait_desc.low = QI_IWD_STATUS_DATA(2) | QI_IWD_STATUS_WRITE | QI_IWD_TYPE;
+	wait_desc.high = virt_to_phys(&qi->desc_status[wait_index]);
+
+	hw[wait_index] = wait_desc;
+
+	__iommu_flush_cache(iommu, &hw[index], sizeof(struct qi_desc));
+	__iommu_flush_cache(iommu, &hw[wait_index], sizeof(struct qi_desc));
+
+	qi->free_head = (qi->free_head + 2) % QI_LENGTH;
+	qi->free_cnt -= 2;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	/*
+	 * update the HW tail register indicating the presence of
+	 * new descriptors.
+	 */
+	writel(qi->free_head << 4, iommu->reg + DMAR_IQT_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+
+	while (qi->desc_status[wait_index] != QI_DONE) {
+		spin_unlock(&qi->q_lock);
+		cpu_relax();
+		spin_lock(&qi->q_lock);
+	}
+
+	qi->desc_status[index] = QI_DONE;
+
+	reclaim_free_desc(qi);
+	spin_unlock(&qi->q_lock);
+}
+
+/*
+ * Flush the global interrupt entry cache.
+ */
+void qi_global_iec(struct intel_iommu *iommu)
+{
+	struct qi_desc desc;
+
+	desc.low = QI_IEC_TYPE;
+	desc.high = 0;
+
+	qi_submit_sync(&desc, iommu);
+}
+
+/*
+ * Enable Queued Invalidation interface. This is a must to support
+ * interrupt-remapping. Also used by DMA-remapping, which replaces
+ * register based IOTLB invalidation.
+ */
+int dmar_enable_qi(struct intel_iommu *iommu)
+{
+	u32 cmd, sts;
+	unsigned long flags;
+	struct q_inval *qi;
+
+	if (!ecap_qis(iommu->ecap))
+		return -ENOENT;
+
+	/*
+	 * queued invalidation is already setup and enabled.
+	 */
+	if (iommu->qi)
+		return 0;
+
+	iommu->qi = kmalloc(sizeof(*qi), GFP_KERNEL);
+	if (!iommu->qi)
+		return -ENOMEM;
+
+	qi = iommu->qi;
+
+	qi->desc = (void *)(get_zeroed_page(GFP_KERNEL));
+	if (!qi->desc) {
+		kfree(qi);
+		iommu->qi = 0;
+		return -ENOMEM;
+	}
+
+	qi->desc_status = kmalloc(QI_LENGTH * sizeof(int), GFP_KERNEL);
+	if (!qi->desc_status) {
+		free_page((unsigned long) qi->desc);
+		kfree(qi);
+		iommu->qi = 0;
+		return -ENOMEM;
+	}
+
+	qi->free_head = qi->free_tail = 0;
+	qi->free_cnt = QI_LENGTH;
+
+	spin_lock_init(&qi->q_lock);
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	/* write zero to the tail reg */
+	writel(0, iommu->reg + DMAR_IQT_REG);
+
+	dmar_writeq(iommu->reg + DMAR_IQA_REG, virt_to_phys(qi->desc));
+
+	cmd = iommu->gcmd | DMA_GCMD_QIE;
+	iommu->gcmd |= DMA_GCMD_QIE;
+	writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl, (sts & DMA_GSTS_QIES), sts);
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+
+	return 0;
+}
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 6c4c1c3..389fdd6 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -49,8 +49,6 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
 
-#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
-
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
 
@@ -58,8 +56,6 @@ static void flush_unmaps_timeout(unsigned long data);
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
-static struct intel_iommu *g_iommus;
-
 #define HIGH_WATER_MARK 250
 struct deferred_flush_tables {
 	int next;
@@ -185,13 +181,6 @@ void free_iova_mem(struct iova *iova)
 	kmem_cache_free(iommu_iova_cache, iova);
 }
 
-static inline void __iommu_flush_cache(
-	struct intel_iommu *iommu, void *addr, int size)
-{
-	if (!ecap_coherent(iommu->ecap))
-		clflush_cache_range(addr, size);
-}
-
 /* Gets context entry for a given bus and devfn */
 static struct context_entry * device_to_context_entry(struct intel_iommu *iommu,
 		u8 bus, u8 devfn)
@@ -488,19 +477,6 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 	return 0;
 }
 
-#define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
-{\
-	cycles_t start_time = get_cycles();\
-	while (1) {\
-		sts = op (iommu->reg + offset);\
-		if (cond)\
-			break;\
-		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
-			panic("DMAR hardware is malfunctioning\n");\
-		cpu_relax();\
-	}\
-}
-
 static void iommu_set_root_entry(struct intel_iommu *iommu)
 {
 	void *addr;
@@ -990,6 +966,8 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 		return -ENOMEM;
 	}
 
+	spin_lock_init(&iommu->lock);
+
 	/*
 	 * if Caching mode is set, then invalid translations are tagged
 	 * with domainid 0. Hence we need to pre-allocate it.
@@ -998,62 +976,15 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 		set_bit(0, iommu->domain_ids);
 	return 0;
 }
-static struct intel_iommu *alloc_iommu(struct intel_iommu *iommu,
-					struct dmar_drhd_unit *drhd)
-{
-	int ret;
-	int map_size;
-	u32 ver;
-
-	iommu->reg = ioremap(drhd->reg_base_addr, PAGE_SIZE_4K);
-	if (!iommu->reg) {
-		printk(KERN_ERR "IOMMU: can't map the region\n");
-		goto error;
-	}
-	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
-	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
-
-	/* the registers might be more than one page */
-	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
-		cap_max_fault_reg_offset(iommu->cap));
-	map_size = PAGE_ALIGN_4K(map_size);
-	if (map_size > PAGE_SIZE_4K) {
-		iounmap(iommu->reg);
-		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
-		if (!iommu->reg) {
-			printk(KERN_ERR "IOMMU: can't map the region\n");
-			goto error;
-		}
-	}
-
-	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
-		drhd->reg_base_addr, DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
-		iommu->cap, iommu->ecap);
-	ret = iommu_init_domains(iommu);
-	if (ret)
-		goto error_unmap;
-	spin_lock_init(&iommu->lock);
-	spin_lock_init(&iommu->register_lock);
 
-	drhd->iommu = iommu;
-	return iommu;
-error_unmap:
-	iounmap(iommu->reg);
-error:
-	kfree(iommu);
-	return NULL;
-}
 
 static void domain_exit(struct dmar_domain *domain);
-static void free_iommu(struct intel_iommu *iommu)
+
+void free_dmar_iommu(struct intel_iommu *iommu)
 {
 	struct dmar_domain *domain;
 	int i;
 
-	if (!iommu)
-		return;
-
 	i = find_first_bit(iommu->domain_ids, cap_ndoms(iommu->cap));
 	for (; i < cap_ndoms(iommu->cap); ) {
 		domain = iommu->domains[i];
@@ -1078,10 +1009,6 @@ static void free_iommu(struct intel_iommu *iommu)
 
 	/* free context mapping */
 	free_context_table(iommu);
-
-	if (iommu->reg)
-		iounmap(iommu->reg);
-	kfree(iommu);
 }
 
 static struct dmar_domain * iommu_alloc_domain(struct intel_iommu *iommu)
@@ -1426,37 +1353,6 @@ find_domain(struct pci_dev *pdev)
 	return NULL;
 }
 
-static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
-     struct pci_dev *dev)
-{
-	int index;
-
-	while (dev) {
-		for (index = 0; index < cnt; index++)
-			if (dev == devices[index])
-				return 1;
-
-		/* Check our parent */
-		dev = dev->bus->self;
-	}
-
-	return 0;
-}
-
-static struct dmar_drhd_unit *
-dmar_find_matched_drhd_unit(struct pci_dev *dev)
-{
-	struct dmar_drhd_unit *drhd = NULL;
-
-	list_for_each_entry(drhd, &dmar_drhd_units, list) {
-		if (drhd->include_all || dmar_pci_device_match(drhd->devices,
-						drhd->devices_cnt, dev))
-			return drhd;
-	}
-
-	return NULL;
-}
-
 /* domain is initialized */
 static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 {
@@ -1729,8 +1625,6 @@ int __init init_dmars(void)
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
-		if (drhd->ignored)
-			continue;
 		g_num_of_iommus++;
 		/*
 		 * lock not needed as this is only incremented in the single
@@ -1739,12 +1633,6 @@ int __init init_dmars(void)
 		 */
 	}
 
-	g_iommus = kzalloc(g_num_of_iommus * sizeof(*iommu), GFP_KERNEL);
-	if (!g_iommus) {
-		ret = -ENOMEM;
-		goto error;
-	}
-
 	deferred_flush = kzalloc(g_num_of_iommus *
 		sizeof(struct deferred_flush_tables), GFP_KERNEL);
 	if (!deferred_flush) {
@@ -1752,16 +1640,15 @@ int __init init_dmars(void)
 		goto error;
 	}
 
-	i = 0;
 	for_each_drhd_unit(drhd) {
 		if (drhd->ignored)
 			continue;
-		iommu = alloc_iommu(&g_iommus[i], drhd);
-		i++;
-		if (!iommu) {
-			ret = -ENOMEM;
+
+		iommu = drhd->iommu;
+
+		ret = iommu_init_domains(iommu);
+		if (ret)
 			goto error;
-		}
 
 		/*
 		 * TBD:
@@ -1845,7 +1732,6 @@ error:
 		iommu = drhd->iommu;
 		free_iommu(iommu);
 	}
-	kfree(g_iommus);
 	return ret;
 }
 
@@ -2002,7 +1888,10 @@ static void flush_unmaps(void)
 	/* just flush them all */
 	for (i = 0; i < g_num_of_iommus; i++) {
 		if (deferred_flush[i].next) {
-			iommu_flush_iotlb_global(&g_iommus[i], 0);
+			struct intel_iommu *iommu =
+				deferred_flush[i].domain[0]->iommu;
+
+			iommu_flush_iotlb_global(iommu, 0);
 			for (j = 0; j < deferred_flush[i].next; j++) {
 				__free_iova(&deferred_flush[i].domain[j]->iovad,
 						deferred_flush[i].iova[j]);
@@ -2032,7 +1921,8 @@ static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 	if (list_size == HIGH_WATER_MARK)
 		flush_unmaps();
 
-	iommu_id = dom->iommu - g_iommus;
+	iommu_id = dom->iommu->seq_id;
+
 	next = deferred_flush[iommu_id].next;
 	deferred_flush[iommu_id].domain[next] = dom;
 	deferred_flush[iommu_id].iova[next] = iova;
@@ -2348,38 +2238,6 @@ static void __init iommu_exit_mempool(void)
 
 }
 
-static int blacklist_iommu(const struct dmi_system_id *id)
-{
-	printk(KERN_INFO "%s detected; disabling IOMMU\n",
-	       id->ident);
-	dmar_disabled = 1;
-	return 0;
-}
-
-static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
-	{	/* Some DG33BU BIOS revisions advertised non-existent VT-d */
-		.callback = blacklist_iommu,
-		.ident = "Intel DG33BU",
-		{	DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "DG33BU"),
-		}
-	},
-	{ }
-};
-
-
-void __init detect_intel_iommu(void)
-{
-	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
-		return;
-	if (early_dmar_detect()) {
-		dmi_check_system(intel_iommu_dmi_table);
-		if (dmar_disabled)
-			return;
-		iommu_detected = 1;
-	}
-}
-
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2426,12 +2284,19 @@ int __init intel_iommu_init(void)
 {
 	int ret = 0;
 
-	if (no_iommu || swiotlb || dmar_disabled)
-		return -ENODEV;
-
 	if (dmar_table_init())
 		return 	-ENODEV;
 
+	if (dmar_dev_scope_init())
+		return 	-ENODEV;
+
+	/*
+	 * Check the need for DMA-remapping initialization now.
+	 * Above initialization will also be used by Interrupt-remapping.
+	 */
+	if (no_iommu || swiotlb || dmar_disabled)
+		return -ENODEV;
+
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
diff --git a/drivers/pci/intel-iommu.h b/drivers/pci/intel-iommu.h
index afc0ad9..2142c01 100644
--- a/drivers/pci/intel-iommu.h
+++ b/drivers/pci/intel-iommu.h
@@ -27,19 +27,8 @@
 #include <linux/sysdev.h>
 #include "iova.h"
 #include <linux/io.h>
-
-/*
- * We need a fixed PAGE_SIZE of 4K irrespective of
- * arch PAGE_SIZE for IOMMU page tables.
- */
-#define PAGE_SHIFT_4K		(12)
-#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
-#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
-#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
-
-#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
-#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
-#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
+#include <asm/cacheflush.h>
+#include "dma_remapping.h"
 
 /*
  * Intel IOMMU register specification per version 1.0 public spec.
@@ -63,6 +52,11 @@
 #define	DMAR_PLMLIMIT_REG 0x6c	/* PMRR low limit */
 #define	DMAR_PHMBASE_REG 0x70	/* pmrr high base addr */
 #define	DMAR_PHMLIMIT_REG 0x78	/* pmrr high limit */
+#define DMAR_IQH_REG	0x80	/* Invalidation queue head register */
+#define DMAR_IQT_REG	0x88	/* Invalidation queue tail register */
+#define DMAR_IQA_REG	0x90	/* Invalidation queue addr register */
+#define DMAR_ICS_REG	0x98	/* Invalidation complete status register */
+#define DMAR_IRTA_REG	0xb8    /* Interrupt remapping table addr register */
 
 #define OFFSET_STRIDE		(9)
 /*
@@ -126,6 +120,10 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define ecap_max_iotlb_offset(e) \
 	(ecap_iotlb_offset(e) + ecap_niotlb_iunits(e) * 16)
 #define ecap_coherent(e)	((e) & 0x1)
+#define ecap_qis(e)		((e) & 0x2)
+#define ecap_eim_support(e)	((e >> 4) & 0x1)
+#define ecap_ir_support(e)	((e >> 3) & 0x1)
+#define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
 
 
 /* IOTLB_REG */
@@ -141,6 +139,17 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define DMA_TLB_IH_NONLEAF (((u64)1) << 6)
 #define DMA_TLB_MAX_SIZE (0x3f)
 
+/* INVALID_DESC */
+#define DMA_ID_TLB_GLOBAL_FLUSH	(((u64)1) << 3)
+#define DMA_ID_TLB_DSI_FLUSH	(((u64)2) << 3)
+#define DMA_ID_TLB_PSI_FLUSH	(((u64)3) << 3)
+#define DMA_ID_TLB_READ_DRAIN	(((u64)1) << 7)
+#define DMA_ID_TLB_WRITE_DRAIN	(((u64)1) << 6)
+#define DMA_ID_TLB_DID(id)	(((u64)((id & 0xffff) << 16)))
+#define DMA_ID_TLB_IH_NONLEAF	(((u64)1) << 6)
+#define DMA_ID_TLB_ADDR(addr)	(addr)
+#define DMA_ID_TLB_ADDR_MASK(mask)	(mask)
+
 /* PMEN_REG */
 #define DMA_PMEN_EPM (((u32)1)<<31)
 #define DMA_PMEN_PRS (((u32)1)<<0)
@@ -151,6 +160,9 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define DMA_GCMD_SFL (((u32)1) << 29)
 #define DMA_GCMD_EAFL (((u32)1) << 28)
 #define DMA_GCMD_WBF (((u32)1) << 27)
+#define DMA_GCMD_QIE (((u32)1) << 26)
+#define DMA_GCMD_SIRTP (((u32)1) << 24)
+#define DMA_GCMD_IRE (((u32) 1) << 25)
 
 /* GSTS_REG */
 #define DMA_GSTS_TES (((u32)1) << 31)
@@ -158,6 +170,9 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define DMA_GSTS_FLS (((u32)1) << 29)
 #define DMA_GSTS_AFLS (((u32)1) << 28)
 #define DMA_GSTS_WBFS (((u32)1) << 27)
+#define DMA_GSTS_QIES (((u32)1) << 26)
+#define DMA_GSTS_IRTPS (((u32)1) << 24)
+#define DMA_GSTS_IRES (((u32)1) << 25)
 
 /* CCMD_REG */
 #define DMA_CCMD_ICC (((u64)1) << 63)
@@ -187,158 +202,106 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define dma_frcd_source_id(c) (c & 0xffff)
 #define dma_frcd_page_addr(d) (d & (((u64)-1) << 12)) /* low 64 bit */
 
-/*
- * 0: Present
- * 1-11: Reserved
- * 12-63: Context Ptr (12 - (haw-1))
- * 64-127: Reserved
- */
-struct root_entry {
-	u64	val;
-	u64	rsvd1;
-};
-#define ROOT_ENTRY_NR (PAGE_SIZE_4K/sizeof(struct root_entry))
-static inline bool root_present(struct root_entry *root)
-{
-	return (root->val & 1);
-}
-static inline void set_root_present(struct root_entry *root)
-{
-	root->val |= 1;
-}
-static inline void set_root_value(struct root_entry *root, unsigned long value)
-{
-	root->val |= value & PAGE_MASK_4K;
+#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
+
+#define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
+{\
+	cycles_t start_time = get_cycles();\
+	while (1) {\
+		sts = op (iommu->reg + offset);\
+		if (cond)\
+			break;\
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
+			panic("DMAR hardware is malfunctioning\n");\
+		cpu_relax();\
+	}\
 }
 
-struct context_entry;
-static inline struct context_entry *
-get_context_addr_from_root(struct root_entry *root)
-{
-	return (struct context_entry *)
-		(root_present(root)?phys_to_virt(
-		root->val & PAGE_MASK_4K):
-		NULL);
-}
-
-/*
- * low 64 bits:
- * 0: present
- * 1: fault processing disable
- * 2-3: translation type
- * 12-63: address space root
- * high 64 bits:
- * 0-2: address width
- * 3-6: aval
- * 8-23: domain id
- */
-struct context_entry {
-	u64 lo;
-	u64 hi;
-};
-#define context_present(c) ((c).lo & 1)
-#define context_fault_disable(c) (((c).lo >> 1) & 1)
-#define context_translation_type(c) (((c).lo >> 2) & 3)
-#define context_address_root(c) ((c).lo & PAGE_MASK_4K)
-#define context_address_width(c) ((c).hi &  7)
-#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
-
-#define context_set_present(c) do {(c).lo |= 1;} while (0)
-#define context_set_fault_enable(c) \
-	do {(c).lo &= (((u64)-1) << 2) | 1;} while (0)
-#define context_set_translation_type(c, val) \
-	do { \
-		(c).lo &= (((u64)-1) << 4) | 3; \
-		(c).lo |= ((val) & 3) << 2; \
-	} while (0)
-#define CONTEXT_TT_MULTI_LEVEL 0
-#define context_set_address_root(c, val) \
-	do {(c).lo |= (val) & PAGE_MASK_4K;} while (0)
-#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;} while (0)
-#define context_set_domain_id(c, val) \
-	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
-#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)
+#define QI_LENGTH	256	/* queue length */
 
-/*
- * 0: readable
- * 1: writable
- * 2-6: reserved
- * 7: super page
- * 8-11: available
- * 12-63: Host physcial address
- */
-struct dma_pte {
-	u64 val;
+enum {
+	QI_FREE,
+	QI_IN_USE,
+	QI_DONE
 };
-#define dma_clear_pte(p)	do {(p).val = 0;} while (0)
-
-#define DMA_PTE_READ (1)
-#define DMA_PTE_WRITE (2)
 
-#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while (0)
-#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while (0)
-#define dma_set_pte_prot(p, prot) \
-		do {(p).val = ((p).val & ~3) | ((prot) & 3); } while (0)
-#define dma_pte_addr(p) ((p).val & PAGE_MASK_4K)
-#define dma_set_pte_addr(p, addr) do {\
-		(p).val |= ((addr) & PAGE_MASK_4K); } while (0)
-#define dma_pte_present(p) (((p).val & 3) != 0)
+#define QI_CC_TYPE		0x1
+#define QI_IOTLB_TYPE		0x2
+#define QI_DIOTLB_TYPE		0x3
+#define QI_IEC_TYPE		0x4
+#define QI_IWD_TYPE		0x5
 
-struct intel_iommu;
+#define QI_IEC_SELECTIVE	(((u64)1) << 4)
+#define QI_IEC_IIDEX(idx)	(((u64)(idx & 0xffff) << 32))
+#define QI_IEC_IM(m)		(((u64)(m & 0x1f) << 27))
 
-struct dmar_domain {
-	int	id;			/* domain id */
-	struct intel_iommu *iommu;	/* back pointer to owning iommu */
+#define QI_IWD_STATUS_DATA(d)	(((u64)d) << 32)
+#define QI_IWD_STATUS_WRITE	(((u64)1) << 5)
 
-	struct list_head devices; 	/* all devices' list */
-	struct iova_domain iovad;	/* iova's that belong to this domain */
+struct qi_desc {
+	u64 low, high;
+};
 
-	struct dma_pte	*pgd;		/* virtual address */
-	spinlock_t	mapping_lock;	/* page table lock */
-	int		gaw;		/* max guest address width */
+struct q_inval {
+	spinlock_t      q_lock;
+	struct qi_desc  *desc;          /* invalidation queue */
+	int             *desc_status;   /* desc status */
+	int             free_head;      /* first free entry */
+	int             free_tail;      /* last free entry */
+	int             free_cnt;
+};
 
-	/* adjusted guest address width, 0 is level 2 30-bit */
-	int		agaw;
+#ifdef CONFIG_INTR_REMAP
+/* 1MB - maximum possible interrupt remapping table size */
+#define INTR_REMAP_PAGE_ORDER	8
+#define INTR_REMAP_TABLE_REG_SIZE	0xf
 
-#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
-	int		flags;
-};
+#define INTR_REMAP_TABLE_ENTRIES	65536
 
-/* PCI domain-device relationship */
-struct device_domain_info {
-	struct list_head link;	/* link to domain siblings */
-	struct list_head global; /* link to global list */
-	u8 bus;			/* PCI bus numer */
-	u8 devfn;		/* PCI devfn number */
-	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
-	struct dmar_domain *domain; /* pointer to domain */
+struct ir_table {
+	struct irte *base;
 };
-
-extern int init_dmars(void);
+#endif
 
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
 	u64		cap;
 	u64		ecap;
-	unsigned long 	*domain_ids; /* bitmap of domains */
-	struct dmar_domain **domains; /* ptr to domains */
 	int		seg;
 	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
-	spinlock_t	lock; /* protect context, domain ids */
 	spinlock_t	register_lock; /* protect register handling */
+	int		seq_id;	/* sequence id of the iommu */
+
+#ifdef CONFIG_DMAR
+	unsigned long 	*domain_ids; /* bitmap of domains */
+	struct dmar_domain **domains; /* ptr to domains */
+	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
 
 	unsigned int irq;
 	unsigned char name[7];    /* Device Name */
 	struct msi_msg saved_msg;
 	struct sys_device sysdev;
+#endif
+	struct q_inval  *qi;            /* Queued invalidation info */
+#ifdef CONFIG_INTR_REMAP
+	struct ir_table *ir_table;	/* Interrupt remapping info */
+#endif
 };
 
-#ifndef CONFIG_DMAR_GFX_WA
-static inline void iommu_prepare_gfx_mapping(void)
+static inline void __iommu_flush_cache(
+	struct intel_iommu *iommu, void *addr, int size)
 {
-	return;
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(addr, size);
 }
-#endif /* !CONFIG_DMAR_GFX_WA */
 
+extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
+
+extern int alloc_iommu(struct dmar_drhd_unit *drhd);
+extern void free_iommu(struct intel_iommu *iommu);
+extern int dmar_enable_qi(struct intel_iommu *iommu);
+extern void qi_global_iec(struct intel_iommu *iommu);
+
+extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 #endif
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
new file mode 100644
index 0000000..bb642cc
--- /dev/null
+++ b/drivers/pci/intr_remapping.c
@@ -0,0 +1,471 @@
+#include <linux/dmar.h>
+#include <linux/spinlock.h>
+#include <linux/jiffies.h>
+#include <linux/pci.h>
+#include <linux/irq.h>
+#include <asm/io_apic.h>
+#include "intel-iommu.h"
+#include "intr_remapping.h"
+
+static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
+static int ir_ioapic_num;
+int intr_remapping_enabled;
+
+static struct {
+	struct intel_iommu *iommu;
+	u16 irte_index;
+	u16 sub_handle;
+	u8  irte_mask;
+} irq_2_iommu[NR_IRQS];
+
+static DEFINE_SPINLOCK(irq_2_ir_lock);
+
+int irq_remapped(int irq)
+{
+	if (irq > NR_IRQS)
+		return 0;
+
+	if (!irq_2_iommu[irq].iommu)
+		return 0;
+
+	return 1;
+}
+
+int get_irte(int irq, struct irte *entry)
+{
+	int index;
+
+	if (!entry || irq > NR_IRQS)
+		return -1;
+
+	spin_lock(&irq_2_ir_lock);
+	if (!irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	*entry = *(irq_2_iommu[irq].iommu->ir_table->base + index);
+
+	spin_unlock(&irq_2_ir_lock);
+	return 0;
+}
+
+int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+{
+	struct ir_table *table = iommu->ir_table;
+	u16 index, start_index;
+	unsigned int mask = 0;
+	int i;
+
+	if (!count)
+		return -1;
+
+	/*
+	 * start the IRTE search from index 0.
+	 */
+	index = start_index = 0;
+
+	if (count > 1) {
+		count = __roundup_pow_of_two(count);
+		mask = ilog2(count);
+	}
+
+	if (mask > ecap_max_handle_mask(iommu->ecap)) {
+		printk(KERN_ERR
+		       "Requested mask %x exceeds the max invalidation handle"
+		       " mask value %Lx\n", mask,
+		       ecap_max_handle_mask(iommu->ecap));
+		return -1;
+	}
+
+	spin_lock(&irq_2_ir_lock);
+	do {
+		for (i = index; i < index + count; i++)
+			if  (table->base[i].present)
+				break;
+		/* empty index found */
+		if (i == index + count)
+			break;
+
+		index = (index + count) % INTR_REMAP_TABLE_ENTRIES;
+
+		if (index == start_index) {
+			spin_unlock(&irq_2_ir_lock);
+			printk(KERN_ERR "can't allocate an IRTE\n");
+			return -1;
+		}
+	} while (1);
+
+	for (i = index; i < index + count; i++)
+		table->base[i].present = 1;
+
+	irq_2_iommu[irq].iommu = iommu;
+	irq_2_iommu[irq].irte_index =  index;
+	irq_2_iommu[irq].sub_handle = 0;
+	irq_2_iommu[irq].irte_mask = mask;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return index;
+}
+
+static void qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
+{
+	struct qi_desc desc;
+
+	desc.low = QI_IEC_IIDEX(index) | QI_IEC_TYPE | QI_IEC_IM(mask)
+		   | QI_IEC_SELECTIVE;
+	desc.high = 0;
+
+	qi_submit_sync(&desc, iommu);
+}
+
+int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+{
+	int index;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	*sub_handle = irq_2_iommu[irq].sub_handle;
+	index = irq_2_iommu[irq].irte_index;
+	spin_unlock(&irq_2_ir_lock);
+	return index;
+}
+
+int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
+{
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	irq_2_iommu[irq].iommu = iommu;
+	irq_2_iommu[irq].irte_index = index;
+	irq_2_iommu[irq].sub_handle = subhandle;
+	irq_2_iommu[irq].irte_mask = 0;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
+{
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	irq_2_iommu[irq].iommu = NULL;
+	irq_2_iommu[irq].irte_index = 0;
+	irq_2_iommu[irq].sub_handle = 0;
+	irq_2_iommu[irq].irte_mask = 0;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+int modify_irte(int irq, struct irte *irte_modified)
+{
+	int index;
+	struct irte *irte;
+	struct intel_iommu *iommu;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	iommu = irq_2_iommu[irq].iommu;
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	irte = &iommu->ir_table->base[index];
+
+	set_64bit((unsigned long *)irte, irte_modified->low | (1 << 1));
+	__iommu_flush_cache(iommu, irte, sizeof(*irte));
+
+	qi_flush_iec(iommu, index, 0);
+
+	spin_unlock(&irq_2_ir_lock);
+	return 0;
+}
+
+int flush_irte(int irq)
+{
+	int index;
+	struct intel_iommu *iommu;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	iommu = irq_2_iommu[irq].iommu;
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+
+	qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+struct intel_iommu *map_ioapic_to_ir(int apic)
+{
+	int i;
+
+	for (i = 0; i < MAX_IO_APICS; i++)
+		if (ir_ioapic[i].id == apic)
+			return ir_ioapic[i].iommu;
+	return NULL;
+}
+
+struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd;
+
+	drhd = dmar_find_matched_drhd_unit(dev);
+	if (!drhd)
+		return NULL;
+
+	return drhd->iommu;
+}
+
+int free_irte(int irq)
+{
+	int index, i;
+	struct irte *irte;
+	struct intel_iommu *iommu;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	iommu = irq_2_iommu[irq].iommu;
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	irte = &iommu->ir_table->base[index];
+
+	if (!irq_2_iommu[irq].sub_handle) {
+		for (i = 0; i < (1 << irq_2_iommu[irq].irte_mask); i++)
+			set_64bit((unsigned long *)irte, 0);
+		qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+	}
+
+	irq_2_iommu[irq].iommu = NULL;
+	irq_2_iommu[irq].irte_index = 0;
+	irq_2_iommu[irq].sub_handle = 0;
+	irq_2_iommu[irq].irte_mask = 0;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
+{
+	u64 addr;
+	u32 cmd, sts;
+	unsigned long flags;
+
+	addr = virt_to_phys((void *)iommu->ir_table->base);
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+
+	dmar_writeq(iommu->reg + DMAR_IRTA_REG,
+		    (addr) | IR_X2APIC_MODE(mode) | INTR_REMAP_TABLE_REG_SIZE);
+
+	/* Set interrupt-remapping table pointer */
+	cmd = iommu->gcmd | DMA_GCMD_SIRTP;
+	writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+		      readl, (sts & DMA_GSTS_IRTPS), sts);
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+
+	/*
+	 * global invalidation of interrupt entry cache before enabling
+	 * interrupt-remapping.
+	 */
+	qi_global_iec(iommu);
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+
+	/* Enable interrupt-remapping */
+	cmd = iommu->gcmd | DMA_GCMD_IRE;
+	iommu->gcmd |= DMA_GCMD_IRE;
+	writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+		      readl, (sts & DMA_GSTS_IRES), sts);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
+
+static int setup_intr_remapping(struct intel_iommu *iommu, int mode)
+{
+	struct ir_table *ir_table;
+	struct page *pages;
+
+	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
+					     GFP_KERNEL);
+
+	if (!iommu->ir_table)
+		return -ENOMEM;
+
+	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, INTR_REMAP_PAGE_ORDER);
+
+	if (!pages) {
+		printk(KERN_ERR "failed to allocate pages of order %d\n",
+		       INTR_REMAP_PAGE_ORDER);
+		kfree(iommu->ir_table);
+		return -ENOMEM;
+	}
+
+	ir_table->base = page_address(pages);
+
+	iommu_set_intr_remapping(iommu, mode);
+	return 0;
+}
+
+int __init enable_intr_remapping(int eim)
+{
+	struct dmar_drhd_unit *drhd;
+	int setup = 0;
+
+	/*
+	 * check for the Interrupt-remapping support
+	 */
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (!ecap_ir_support(iommu->ecap))
+			continue;
+
+		if (eim && !ecap_eim_support(iommu->ecap)) {
+			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
+			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
+			return -1;
+		}
+	}
+
+	/*
+	 * Enable queued invalidation for all the DRHD's.
+	 */
+	for_each_drhd_unit(drhd) {
+		int ret;
+		struct intel_iommu *iommu = drhd->iommu;
+		ret = dmar_enable_qi(iommu);
+
+		if (ret) {
+			printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
+			       " invalidation, ecap %Lx, ret %d\n",
+			       drhd->reg_base_addr, iommu->ecap, ret);
+			return -1;
+		}
+	}
+
+	/*
+	 * Setup Interrupt-remapping for all the DRHD's now.
+	 */
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (!ecap_ir_support(iommu->ecap))
+			continue;
+
+		if (setup_intr_remapping(iommu, eim))
+			goto error;
+
+		setup = 1;
+	}
+
+	if (!setup)
+		goto error;
+
+	intr_remapping_enabled = 1;
+
+	return 0;
+
+error:
+	/*
+	 * handle error condition gracefully here!
+	 */
+	return -1;
+}
+
+static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
+				 struct intel_iommu *iommu)
+{
+	struct acpi_dmar_hardware_unit *drhd;
+	struct acpi_dmar_device_scope *scope;
+	void *start, *end;
+
+	drhd = (struct acpi_dmar_hardware_unit *)header;
+
+	start = (void *)(drhd + 1);
+	end = ((void *)drhd) + header->length;
+
+	while (start < end) {
+		scope = start;
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
+			if (ir_ioapic_num == MAX_IO_APICS) {
+				printk(KERN_WARNING "Exceeded Max IO APICS\n");
+				return -1;
+			}
+
+			printk(KERN_INFO "IOAPIC id %d under DRHD base"
+			       " 0x%Lx\n", scope->enumeration_id,
+			       drhd->address);
+
+			ir_ioapic[ir_ioapic_num].iommu = iommu;
+			ir_ioapic[ir_ioapic_num].id = scope->enumeration_id;
+			ir_ioapic_num++;
+		}
+		start += scope->length;
+	}
+
+	return 0;
+}
+
+/*
+ * Finds the assocaition between IOAPIC's and its Interrupt-remapping
+ * hardware unit.
+ */
+int __init parse_ioapics_under_ir(void)
+{
+	struct dmar_drhd_unit *drhd;
+	int ir_supported = 0;
+
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (ecap_ir_support(iommu->ecap)) {
+			if (ir_parse_ioapic_scope(drhd->hdr, iommu))
+				return -1;
+
+			ir_supported = 1;
+		}
+	}
+
+	if (ir_supported && ir_ioapic_num != nr_ioapics) {
+		printk(KERN_WARNING
+		       "Not all IO-APIC's listed under remapping hardware\n");
+		return -1;
+	}
+
+	return ir_supported;
+}
diff --git a/drivers/pci/intr_remapping.h b/drivers/pci/intr_remapping.h
new file mode 100644
index 0000000..05f2635
--- /dev/null
+++ b/drivers/pci/intr_remapping.h
@@ -0,0 +1,8 @@
+#include "intel-iommu.h"
+
+struct ioapic_scope {
+	struct intel_iommu *iommu;
+	unsigned int id;
+};
+
+#define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index cb752ba..7440a0d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -385,6 +385,7 @@
 	. = ALIGN(align);						\
 	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
+		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 65590c9..d76a083 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -9,6 +9,8 @@
 #include <asm/apicdef.h>
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/cpufeature.h>
+#include <asm/msr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -47,8 +49,6 @@ extern int disable_apic;
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define apic_write native_apic_write
-#define apic_read native_apic_read
 #define setup_boot_clock setup_boot_APIC_clock
 #define setup_secondary_clock setup_secondary_APIC_clock
 #endif
@@ -60,7 +60,7 @@ extern u64 xapic_icr_read(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 
-static inline void native_apic_write(unsigned long reg, u32 v)
+static inline void native_apic_mem_write(u32 reg, u32 v)
 {
 	volatile u32 *addr = (volatile u32 *)(APIC_BASE + reg);
 
@@ -69,15 +69,68 @@ static inline void native_apic_write(unsigned long reg, u32 v)
 		       ASM_OUTPUT2("0" (v), "m" (*addr)));
 }
 
-static inline u32 native_apic_read(unsigned long reg)
+static inline u32 native_apic_mem_read(u32 reg)
 {
 	return *((volatile u32 *)(APIC_BASE + reg));
 }
 
-extern void apic_wait_icr_idle(void);
-extern u32 safe_apic_wait_icr_idle(void);
+static inline void native_apic_msr_write(u32 reg, u32 v)
+{
+	if (reg == APIC_DFR || reg == APIC_ID || reg == APIC_LDR ||
+	    reg == APIC_LVR)
+		return;
+
+	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
+}
+
+static inline u32 native_apic_msr_read(u32 reg)
+{
+	u32 low, high;
+
+	if (reg == APIC_DFR)
+		return -1;
+
+	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
+	return low;
+}
+
+#ifndef CONFIG_X86_32
+extern int x2apic, x2apic_preenabled;
+extern void check_x2apic(void);
+extern void enable_x2apic(void);
+extern void enable_IR_x2apic(void);
+extern void x2apic_icr_write(u32 low, u32 id);
+#endif
+
+struct apic_ops {
+	u32 (*read)(u32 reg);
+	void (*write)(u32 reg, u32 v);
+	u64 (*icr_read)(void);
+	void (*icr_write)(u32 low, u32 high);
+	void (*wait_icr_idle)(void);
+	u32 (*safe_wait_icr_idle)(void);
+};
+
+extern struct apic_ops *apic_ops;
+
+#define apic_read (apic_ops->read)
+#define apic_write (apic_ops->write)
+#define apic_icr_read (apic_ops->icr_read)
+#define apic_icr_write (apic_ops->icr_write)
+#define apic_wait_icr_idle (apic_ops->wait_icr_idle)
+#define safe_apic_wait_icr_idle (apic_ops->safe_wait_icr_idle)
+
 extern int get_physical_broadcast(void);
 
+#ifdef CONFIG_X86_64
+static inline void ack_x2APIC_irq(void)
+{
+	/* Docs say use 0 for future compatibility */
+	native_apic_msr_write(APIC_EOI, 0);
+}
+#endif
+
+
 static inline void ack_APIC_irq(void)
 {
 	/*
diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index c40687d..b922c85 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -105,6 +105,7 @@
 #define	APIC_TMICT	0x380
 #define	APIC_TMCCT	0x390
 #define	APIC_TDCR	0x3E0
+#define APIC_SELF_IPI	0x3F0
 #define		APIC_TDR_DIV_TMBASE	(1 << 2)
 #define		APIC_TDR_DIV_1		0xB
 #define		APIC_TDR_DIV_2		0x0
@@ -128,6 +129,8 @@
 #define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
+#define APIC_BASE_MSR	0x800
+#define X2APIC_ENABLE	(1UL << 10)
 
 #ifdef CONFIG_X86_32
 # define MAX_IO_APICS 64
diff --git a/include/asm-x86/arch_hooks.h b/include/asm-x86/arch_hooks.h
index 72adc3a..de4596b 100644
--- a/include/asm-x86/arch_hooks.h
+++ b/include/asm-x86/arch_hooks.h
@@ -12,8 +12,6 @@
 /* these aren't arch hooks, they are generic routines
  * that can be used by the hooks */
 extern void init_ISA_irqs(void);
-extern void apic_intr_init(void);
-extern void smp_intr_init(void);
 extern irqreturn_t timer_interrupt(int irq, void *dev_id);
 
 /* these are the defined hooks */
diff --git a/include/asm-x86/mach-bigsmp/mach_apic.h b/include/asm-x86/bigsmp/apic.h
similarity index 94%
rename from include/asm-x86/mach-bigsmp/mach_apic.h
rename to include/asm-x86/bigsmp/apic.h
index 05362d4..0a9cd7c 100644
--- a/include/asm-x86/mach-bigsmp/mach_apic.h
+++ b/include/asm-x86/bigsmp/apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_BIGSMP__MACH_APIC_H
-#define ASM_X86__MACH_BIGSMP__MACH_APIC_H
+#ifndef __ASM_MACH_APIC_H
+#define __ASM_MACH_APIC_H
 
 #define xapic_phys_to_log_apicid(cpu) (per_cpu(x86_bios_cpu_apicid, cpu))
 #define esr_disable (1)
@@ -11,7 +11,7 @@ static inline int apic_id_registered(void)
 
 /* Round robin the irqs amoung the online cpus */
 static inline cpumask_t target_cpus(void)
-{ 
+{
 	static unsigned long cpu = NR_CPUS;
 	do {
 		if (cpu >= NR_CPUS)
@@ -23,7 +23,7 @@ static inline cpumask_t target_cpus(void)
 }
 
 #undef APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL 	0
+#define APIC_DEST_LOGICAL	0
 #define TARGET_CPUS		(target_cpus())
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define INT_DELIVERY_MODE	(dest_Fixed)
@@ -141,4 +141,4 @@ static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-#endif /* ASM_X86__MACH_BIGSMP__MACH_APIC_H */
+#endif /* __ASM_MACH_APIC_H */
diff --git a/include/asm-x86/bigsmp/apicdef.h b/include/asm-x86/bigsmp/apicdef.h
new file mode 100644
index 0000000..392c3f5
--- /dev/null
+++ b/include/asm-x86/bigsmp/apicdef.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_MACH_APICDEF_H
+#define __ASM_MACH_APICDEF_H
+
+#define		APIC_ID_MASK		(0xFF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	return (((x)>>24)&0xFF);
+}
+
+#define		GET_APIC_ID(x)	get_apic_id(x)
+
+#endif
diff --git a/include/asm-x86/mach-bigsmp/mach_ipi.h b/include/asm-x86/bigsmp/ipi.h
similarity index 77%
rename from include/asm-x86/mach-bigsmp/mach_ipi.h
rename to include/asm-x86/bigsmp/ipi.h
index b1b0f96..9404c53 100644
--- a/include/asm-x86/mach-bigsmp/mach_ipi.h
+++ b/include/asm-x86/bigsmp/ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_BIGSMP__MACH_IPI_H
-#define ASM_X86__MACH_BIGSMP__MACH_IPI_H
+#ifndef __ASM_MACH_IPI_H
+#define __ASM_MACH_IPI_H
 
 void send_IPI_mask_sequence(cpumask_t mask, int vector);
 
@@ -22,4 +22,4 @@ static inline void send_IPI_all(int vector)
 	send_IPI_mask(cpu_online_map, vector);
 }
 
-#endif /* ASM_X86__MACH_BIGSMP__MACH_IPI_H */
+#endif /* __ASM_MACH_IPI_H */
diff --git a/include/asm-x86/bugs.h b/include/asm-x86/bugs.h
index 4761c46..dc60498 100644
--- a/include/asm-x86/bugs.h
+++ b/include/asm-x86/bugs.h
@@ -2,6 +2,11 @@
 #define ASM_X86__BUGS_H
 
 extern void check_bugs(void);
+
+#if defined(CONFIG_CPU_SUP_INTEL) && defined(CONFIG_X86_32)
 int ppro_with_ram_bug(void);
+#else
+static inline int ppro_with_ram_bug(void) { return 0; }
+#endif
 
 #endif /* ASM_X86__BUGS_H */
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 250fa0c..adfeae6 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -6,7 +6,13 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	8	/* N 32-bit words worth of info */
+#define NCAPINTS	9	/* N 32-bit words worth of info */
+
+/*
+ * Note: If the comment begins with a quoted string, that string is used
+ * in /proc/cpuinfo instead of the macro name.  If the string is "",
+ * this feature bit is not displayed in /proc/cpuinfo at all.
+ */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
 #define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
@@ -14,7 +20,7 @@
 #define X86_FEATURE_DE		(0*32+ 2) /* Debugging Extensions */
 #define X86_FEATURE_PSE		(0*32+ 3) /* Page Size Extensions */
 #define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
-#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers, RDMSR, WRMSR */
+#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
 #define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
 #define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
 #define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
@@ -23,22 +29,23 @@
 #define X86_FEATURE_MTRR	(0*32+12) /* Memory Type Range Registers */
 #define X86_FEATURE_PGE		(0*32+13) /* Page Global Enable */
 #define X86_FEATURE_MCA		(0*32+14) /* Machine Check Architecture */
-#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instruction (FCMOVCC and FCOMI too if FPU present) */
+#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instructions */
+					  /* (plus FCMOVcc, FCOMI with FPU) */
 #define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
 #define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
 #define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLSH	(0*32+19) /* Supports the CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* Debug Store */
+#define X86_FEATURE_CLFLSH	(0*32+19) /* "clflush" CLFLUSH instruction */
+#define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
 #define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
 #define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions (fast save and restore */
-					  /* of FPU context), and CR4.OSFXSR available */
-#define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
-#define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
-#define X86_FEATURE_SELFSNOOP	(0*32+27) /* CPU self snoop */
+#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
+#define X86_FEATURE_XMM		(0*32+25) /* "sse" */
+#define X86_FEATURE_XMM2	(0*32+26) /* "sse2" */
+#define X86_FEATURE_SELFSNOOP	(0*32+27) /* "ss" CPU self snoop */
 #define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
-#define X86_FEATURE_ACC		(0*32+29) /* Automatic clock control */
+#define X86_FEATURE_ACC		(0*32+29) /* "tm" Automatic clock control */
 #define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
+#define X86_FEATURE_PBE		(0*32+31) /* Pending Break Enable */
 
 /* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
 /* Don't duplicate feature flags which are redundant with Intel! */
@@ -46,7 +53,8 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_GBPAGES	(1*32+26) /* GB pages */
+#define X86_FEATURE_FXSR_OPT	(1*32+25) /* FXSAVE/FXRSTOR optimizations */
+#define X86_FEATURE_GBPAGES	(1*32+26) /* "pdpe1gb" GB pages */
 #define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
@@ -64,53 +72,79 @@
 #define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
 #define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
 /* cpu types for specific tunings: */
-#define X86_FEATURE_K8		(3*32+ 4) /* Opteron, Athlon64 */
-#define X86_FEATURE_K7		(3*32+ 5) /* Athlon */
-#define X86_FEATURE_P3		(3*32+ 6) /* P3 */
-#define X86_FEATURE_P4		(3*32+ 7) /* P4 */
+#define X86_FEATURE_K8		(3*32+ 4) /* "" Opteron, Athlon64 */
+#define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
+#define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
+#define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
 #define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* FXSAVE leaks FOP/FIP/FOP */
+#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
+#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
-#define X86_FEATURE_SYSCALL32	(3*32+14) /* syscall in ia32 userspace */
-#define X86_FEATURE_SYSENTER32	(3*32+15) /* sysenter in ia32 userspace */
-#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
-#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
-#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
-#define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
+#define X86_FEATURE_SYSCALL32	(3*32+14) /* "" syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	(3*32+15) /* "" sysenter in ia32 userspace */
+#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well */
+#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* "" Mfence synchronizes RDTSC */
+#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
+#define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
+#define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
-#define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
-#define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
+#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
+#define X86_FEATURE_PCLMULQDQ	(4*32+ 1) /* PCLMULQDQ instruction */
+#define X86_FEATURE_DTES64	(4*32+ 2) /* 64-bit Debug Store */
+#define X86_FEATURE_MWAIT	(4*32+ 3) /* "monitor" Monitor/Mwait support */
+#define X86_FEATURE_DSCPL	(4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
+#define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
+#define X86_FEATURE_SMX		(4*32+ 6) /* Safer mode */
 #define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
 #define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
+#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
 #define X86_FEATURE_CID		(4*32+10) /* Context ID */
+#define X86_FEATURE_FMA		(4*32+12) /* Fused multiply-add */
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
+#define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
-#define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 */
+#define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
+#define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
+#define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
+#define X86_FEATURE_AES		(4*32+25) /* AES instructions */
+#define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
+#define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
+#define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
-#define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
-#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* on-CPU RNG enabled */
-#define X86_FEATURE_XCRYPT	(5*32+ 6) /* on-CPU crypto (xcrypt insn) */
-#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* on-CPU crypto enabled */
+#define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
+#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* "rng_en" RNG enabled */
+#define X86_FEATURE_XCRYPT	(5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
+#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* "ace_en" on-CPU crypto enabled */
 #define X86_FEATURE_ACE2	(5*32+ 8) /* Advanced Cryptography Engine v2 */
 #define X86_FEATURE_ACE2_EN	(5*32+ 9) /* ACE v2 enabled */
-#define X86_FEATURE_PHE		(5*32+ 10) /* PadLock Hash Engine */
-#define X86_FEATURE_PHE_EN	(5*32+ 11) /* PHE enabled */
-#define X86_FEATURE_PMM		(5*32+ 12) /* PadLock Montgomery Multiplier */
-#define X86_FEATURE_PMM_EN	(5*32+ 13) /* PMM enabled */
+#define X86_FEATURE_PHE		(5*32+10) /* PadLock Hash Engine */
+#define X86_FEATURE_PHE_EN	(5*32+11) /* PHE enabled */
+#define X86_FEATURE_PMM		(5*32+12) /* PadLock Montgomery Multiplier */
+#define X86_FEATURE_PMM_EN	(5*32+13) /* PMM enabled */
 
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
-#define X86_FEATURE_IBS		(6*32+ 10) /* Instruction Based Sampling */
+#define X86_FEATURE_SVM		(6*32+ 2) /* Secure virtual machine */
+#define X86_FEATURE_EXTAPIC	(6*32+ 3) /* Extended APIC space */
+#define X86_FEATURE_CR8_LEGACY	(6*32+ 4) /* CR8 in 32-bit mode */
+#define X86_FEATURE_ABM		(6*32+ 5) /* Advanced bit manipulation */
+#define X86_FEATURE_SSE4A	(6*32+ 6) /* SSE-4A */
+#define X86_FEATURE_MISALIGNSSE (6*32+ 7) /* Misaligned SSE mode */
+#define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
+#define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
+#define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
+#define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
+#define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
+#define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -118,6 +152,13 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 
+/* Virtualization flags: Linux defined */
+#define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
@@ -151,7 +192,7 @@ extern const char * const x86_power_flags[32];
 } while (0)
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
-	clear_bit(bit, (unsigned long *)cleared_cpu_caps); 	\
+	clear_bit(bit, (unsigned long *)cleared_cpu_caps);	\
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
@@ -192,7 +233,10 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_xmm4_1		boot_cpu_has(X86_FEATURE_XMM4_1)
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
+#define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
+#define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index f52daf1..5abbdec 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -43,6 +43,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
@@ -121,6 +122,7 @@ extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 extern u64 e820_hole_size(u64 start, u64 end);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
+extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
diff --git a/include/asm-x86/mach-es7000/mach_apic.h b/include/asm-x86/es7000/apic.h
similarity index 91%
rename from include/asm-x86/mach-es7000/mach_apic.h
rename to include/asm-x86/es7000/apic.h
index c1f6f68..bd2c44d 100644
--- a/include/asm-x86/mach-es7000/mach_apic.h
+++ b/include/asm-x86/es7000/apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_ES7000__MACH_APIC_H
-#define ASM_X86__MACH_ES7000__MACH_APIC_H
+#ifndef __ASM_ES7000_APIC_H
+#define __ASM_ES7000_APIC_H
 
 #define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
 #define esr_disable (1)
@@ -10,7 +10,7 @@ static inline int apic_id_registered(void)
 }
 
 static inline cpumask_t target_cpus(void)
-{ 
+{
 #if defined CONFIG_ES7000_CLUSTERED_APIC
 	return CPU_MASK_ALL;
 #else
@@ -23,24 +23,24 @@ static inline cpumask_t target_cpus(void)
 #define APIC_DFR_VALUE		(APIC_DFR_CLUSTER)
 #define INT_DELIVERY_MODE	(dest_LowestPrio)
 #define INT_DEST_MODE		(1)    /* logical delivery broadcast to all procs */
-#define NO_BALANCE_IRQ 		(1)
+#define NO_BALANCE_IRQ		(1)
 #undef  WAKE_SECONDARY_VIA_INIT
 #define WAKE_SECONDARY_VIA_MIP
 #else
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define INT_DELIVERY_MODE	(dest_Fixed)
 #define INT_DEST_MODE		(0)    /* phys delivery to target procs */
-#define NO_BALANCE_IRQ 		(0)
+#define NO_BALANCE_IRQ		(0)
 #undef  APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0x0
 #define WAKE_SECONDARY_VIA_INIT
 #endif
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
-{ 
+{
 	return 0;
-} 
-static inline unsigned long check_apicid_present(int bit) 
+}
+static inline unsigned long check_apicid_present(int bit)
 {
 	return physid_isset(bit, phys_cpu_present_map);
 }
@@ -80,7 +80,7 @@ static inline void setup_apic_routing(void)
 {
 	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
-		(apic_version[apic] == 0x14) ? 
+		(apic_version[apic] == 0x14) ?
 		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(TARGET_CPUS)[0]);
 }
 
@@ -141,7 +141,7 @@ static inline void setup_portio_remap(void)
 extern unsigned int boot_cpu_physical_apicid;
 static inline int check_phys_apicid_present(int cpu_physical_apicid)
 {
-	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+	boot_cpu_physical_apicid = read_apic_id();
 	return (1);
 }
 
@@ -150,7 +150,7 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
-	int apicid;	
+	int apicid;
 
 	num_bits_set = cpus_weight(cpumask);
 	/* Return id to all */
@@ -160,16 +160,16 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 #else
 		return cpu_to_logical_apicid(0);
 #endif
-	/* 
-	 * The cpus in the mask must all be on the apic cluster.  If are not 
-	 * on the same apicid cluster return default value of TARGET_CPUS. 
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
 	cpu = first_cpu(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
 		if (cpu_isset(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
-			if (apicid_cluster(apicid) != 
+			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
 				printk ("%s: Not a valid mask!\n",__FUNCTION__);
 #if defined CONFIG_ES7000_CLUSTERED_APIC
@@ -191,4 +191,4 @@ static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-#endif /* ASM_X86__MACH_ES7000__MACH_APIC_H */
+#endif /* __ASM_ES7000_APIC_H */
diff --git a/include/asm-x86/es7000/apicdef.h b/include/asm-x86/es7000/apicdef.h
new file mode 100644
index 0000000..8b234a3
--- /dev/null
+++ b/include/asm-x86/es7000/apicdef.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_ES7000_APICDEF_H
+#define __ASM_ES7000_APICDEF_H
+
+#define		APIC_ID_MASK		(0xFF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	return (((x)>>24)&0xFF);
+}
+
+#define		GET_APIC_ID(x)	get_apic_id(x)
+
+#endif
diff --git a/include/asm-x86/mach-es7000/mach_ipi.h b/include/asm-x86/es7000/ipi.h
similarity index 77%
rename from include/asm-x86/mach-es7000/mach_ipi.h
rename to include/asm-x86/es7000/ipi.h
index 3a21240..632a955 100644
--- a/include/asm-x86/mach-es7000/mach_ipi.h
+++ b/include/asm-x86/es7000/ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_ES7000__MACH_IPI_H
-#define ASM_X86__MACH_ES7000__MACH_IPI_H
+#ifndef __ASM_ES7000_IPI_H
+#define __ASM_ES7000_IPI_H
 
 void send_IPI_mask_sequence(cpumask_t mask, int vector);
 
@@ -21,4 +21,4 @@ static inline void send_IPI_all(int vector)
 	send_IPI_mask(cpu_online_map, vector);
 }
 
-#endif /* ASM_X86__MACH_ES7000__MACH_IPI_H */
+#endif /* __ASM_ES7000_IPI_H */
diff --git a/include/asm-x86/mach-es7000/mach_mpparse.h b/include/asm-x86/es7000/mpparse.h
similarity index 81%
rename from include/asm-x86/mach-es7000/mach_mpparse.h
rename to include/asm-x86/es7000/mpparse.h
index befde24..7b5c889 100644
--- a/include/asm-x86/mach-es7000/mach_mpparse.h
+++ b/include/asm-x86/es7000/mpparse.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_ES7000__MACH_MPPARSE_H
-#define ASM_X86__MACH_ES7000__MACH_MPPARSE_H
+#ifndef __ASM_ES7000_MPPARSE_H
+#define __ASM_ES7000_MPPARSE_H
 
 #include <linux/acpi.h>
 
@@ -26,4 +26,4 @@ static inline int es7000_check_dsdt(void)
 }
 #endif
 
-#endif /* ASM_X86__MACH_ES7000__MACH_MPPARSE_H */
+#endif /* __ASM_MACH_MPPARSE_H */
diff --git a/include/asm-x86/mach-es7000/mach_wakecpu.h b/include/asm-x86/es7000/wakecpu.h
similarity index 89%
rename from include/asm-x86/mach-es7000/mach_wakecpu.h
rename to include/asm-x86/es7000/wakecpu.h
index 97c776c..3ffc5a7 100644
--- a/include/asm-x86/mach-es7000/mach_wakecpu.h
+++ b/include/asm-x86/es7000/wakecpu.h
@@ -1,7 +1,7 @@
-#ifndef ASM_X86__MACH_ES7000__MACH_WAKECPU_H
-#define ASM_X86__MACH_ES7000__MACH_WAKECPU_H
+#ifndef __ASM_ES7000_WAKECPU_H
+#define __ASM_ES7000_WAKECPU_H
 
-/* 
+/*
  * This file copes with machines that wakeup secondary CPUs by the
  * INIT, INIT, STARTUP sequence.
  */
@@ -56,4 +56,4 @@ static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
  #define inquire_remote_apic(apicid) {}
 #endif
 
-#endif /* ASM_X86__MACH_ES7000__MACH_WAKECPU_H */
+#endif /* __ASM_MACH_WAKECPU_H */
diff --git a/include/asm-x86/genapic_64.h b/include/asm-x86/genapic_64.h
index 25097a8..ed6a488 100644
--- a/include/asm-x86/genapic_64.h
+++ b/include/asm-x86/genapic_64.h
@@ -14,6 +14,7 @@
 
 struct genapic {
 	char *name;
+	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
@@ -24,17 +25,24 @@ struct genapic {
 	void (*send_IPI_mask)(cpumask_t mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
+	void (*send_IPI_self)(int vector);
 	/* */
 	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
+	unsigned int (*get_apic_id)(unsigned long x);
+	unsigned long (*set_apic_id)(unsigned int id);
+	unsigned long apic_id_mask;
 };
 
 extern struct genapic *genapic;
 
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
+extern struct genapic apic_x2apic_cluster;
+extern struct genapic apic_x2apic_phys;
 extern int acpi_madt_oem_check(char *, char *);
 
+extern void apic_send_IPI_self(int vector);
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 65997b1..50f6e03 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -64,7 +64,6 @@ extern unsigned long io_apic_irqs;
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
-extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
 extern void setup_ioapic_dest(void);
 
@@ -73,7 +72,9 @@ extern void enable_IO_APIC(void);
 #endif
 
 /* IPI functions */
+#ifdef CONFIG_X86_32
 extern void send_IPI_self(int vector);
+#endif
 extern void send_IPI(int dest, int vector);
 
 /* Statistics */
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 1ecdc3e..9ba862a 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -19,7 +19,9 @@
 #include <asm/sigcontext.h>
 #include <asm/user.h>
 #include <asm/uaccess.h>
+#include <asm/xsave.h>
 
+extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
@@ -31,12 +33,18 @@ extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
 
+extern struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
+extern unsigned int sig_xstate_ia32_size;
+extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
 struct _fpstate_ia32;
-extern int save_i387_ia32(struct _fpstate_ia32 __user *buf);
-extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
+struct _xstate_ia32;
+extern int save_i387_xstate_ia32(void __user *buf);
+extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
+#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -47,7 +55,7 @@ static inline void tolerant_fwait(void)
 		     _ASM_EXTABLE(1b, 2b));
 }
 
-static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
 
@@ -67,15 +75,31 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 	return err;
 }
 
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
+	else
+		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+}
 
 /* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
    is pending. Clear the x87 state here by setting it to fixed
    values. The kernel data segment can be sometimes 0 and sometimes
    new user value. Both should be ok.
    Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
+static inline void clear_fpu_state(struct task_struct *tsk)
 {
+	struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+	/*
+	 * xsave header may indicate the init state of the FP.
+	 */
+	if ((task_thread_info(tsk)->status & TS_XSAVE) &&
+	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+		return;
+
 	if (unlikely(fx->swd & X87_FSW_ES))
 		asm volatile("fnclex");
 	alternative_input(ASM_NOP8 ASM_NOP2,
@@ -84,7 +108,7 @@ static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
 			  X86_FEATURE_FXSAVE_LEAK);
 }
 
-static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
+static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
 
@@ -108,7 +132,7 @@ static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
 	return err;
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fxsave(struct task_struct *tsk)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -133,7 +157,16 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 			     : "=m" (tsk->thread.xstate->fxsave)
 			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
 #endif
-	clear_fpu_state(&tsk->thread.xstate->fxsave);
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		xsave(tsk);
+	else
+		fxsave(tsk);
+
+	clear_fpu_state(tsk);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -148,6 +181,10 @@ static inline void tolerant_fwait(void)
 
 static inline void restore_fpu(struct task_struct *tsk)
 {
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		xrstor_checking(&tsk->thread.xstate->xsave);
+		return;
+	}
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -173,6 +210,27 @@ static inline void restore_fpu(struct task_struct *tsk)
  */
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+		xsave(tsk);
+
+		/*
+		 * xsave header may indicate the init state of the FP.
+		 */
+		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+			goto end;
+
+		if (unlikely(fx->swd & X87_FSW_ES))
+			asm volatile("fnclex");
+
+		/*
+		 * we can do a simple return here or be paranoid :)
+		 */
+		goto clear_state;
+	}
+
 	/* Use more nops than strictly needed in case the compiler
 	   varies code */
 	alternative_input(
@@ -182,6 +240,7 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 		X86_FEATURE_FXSR,
 		[fx] "m" (tsk->thread.xstate->fxsave),
 		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -191,16 +250,17 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 		"fildl %[addr]", 	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
+end:
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
+#endif	/* CONFIG_X86_64 */
+
 /*
  * Signal frame handlers...
  */
-extern int save_i387(struct _fpstate __user *buf);
-extern int restore_i387(struct _fpstate __user *buf);
-
-#endif	/* CONFIG_X86_64 */
+extern int save_i387_xstate(void __user *buf);
+extern int restore_i387_xstate(void __user *buf);
 
 static inline void __unlazy_fpu(struct task_struct *tsk)
 {
diff --git a/include/asm-x86/i8259.h b/include/asm-x86/i8259.h
index c586559..23c1b3b 100644
--- a/include/asm-x86/i8259.h
+++ b/include/asm-x86/i8259.h
@@ -57,4 +57,7 @@ static inline void outb_pic(unsigned char value, unsigned int port)
 
 extern struct irq_chip i8259A_chip;
 
+extern void mask_8259A(void);
+extern void unmask_8259A(void);
+
 #endif /* ASM_X86__I8259_H */
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index be62847..8ec68a5 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -107,6 +107,20 @@ struct IO_APIC_route_entry {
 
 } __attribute__ ((packed));
 
+struct IR_IO_APIC_route_entry {
+	__u64	vector		: 8,
+		zero		: 3,
+		index2		: 1,
+		delivery_status : 1,
+		polarity	: 1,
+		irr		: 1,
+		trigger		: 1,
+		mask		: 1,
+		reserved	: 31,
+		format		: 1,
+		index		: 15;
+} __attribute__ ((packed));
+
 #ifdef CONFIG_X86_IO_APIC
 
 /*
@@ -183,6 +197,12 @@ extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 
+#ifdef CONFIG_X86_64
+extern int save_mask_IO_APIC_setup(void);
+extern void restore_IO_APIC_setup(void);
+extern void reinit_intr_remapped_IO_APIC(int);
+#endif
+
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static const int timer_through_8259 = 0;
diff --git a/include/asm-x86/ipi.h b/include/asm-x86/ipi.h
index c1b2267..30a692c 100644
--- a/include/asm-x86/ipi.h
+++ b/include/asm-x86/ipi.h
@@ -49,6 +49,12 @@ static inline int __prepare_ICR2(unsigned int mask)
 	return SET_APIC_DEST_FIELD(mask);
 }
 
+static inline void __xapic_wait_icr_idle(void)
+{
+	while (native_apic_mem_read(APIC_ICR) & APIC_ICR_BUSY)
+		cpu_relax();
+}
+
 static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
 				       unsigned int dest)
 {
@@ -64,7 +70,7 @@ static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
 	/*
 	 * Wait for idle.
 	 */
-	apic_wait_icr_idle();
+	__xapic_wait_icr_idle();
 
 	/*
 	 * No need to touch the target chip field
@@ -74,7 +80,7 @@ static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write(APIC_ICR, cfg);
+	native_apic_mem_write(APIC_ICR, cfg);
 }
 
 /*
@@ -92,13 +98,13 @@ static inline void __send_IPI_dest_field(unsigned int mask, int vector,
 	if (unlikely(vector == NMI_VECTOR))
 		safe_apic_wait_icr_idle();
 	else
-		apic_wait_icr_idle();
+		__xapic_wait_icr_idle();
 
 	/*
 	 * prepare target chip field
 	 */
 	cfg = __prepare_ICR2(mask);
-	apic_write(APIC_ICR2, cfg);
+	native_apic_mem_write(APIC_ICR2, cfg);
 
 	/*
 	 * program the ICR
@@ -108,7 +114,7 @@ static inline void __send_IPI_dest_field(unsigned int mask, int vector,
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write(APIC_ICR, cfg);
+	native_apic_mem_write(APIC_ICR, cfg);
 }
 
 static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
diff --git a/include/asm-x86/irq_remapping.h b/include/asm-x86/irq_remapping.h
new file mode 100644
index 0000000..78242c6
--- /dev/null
+++ b/include/asm-x86/irq_remapping.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_IRQ_REMAPPING_H
+#define _ASM_IRQ_REMAPPING_H
+
+extern int x2apic;
+
+#define IRTE_DEST(dest) ((x2apic) ? dest : dest << 8)
+
+#endif
diff --git a/include/asm-x86/mach-bigsmp/mach_apicdef.h b/include/asm-x86/mach-bigsmp/mach_apicdef.h
deleted file mode 100644
index 811935d..0000000
--- a/include/asm-x86/mach-bigsmp/mach_apicdef.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef ASM_X86__MACH_BIGSMP__MACH_APICDEF_H
-#define ASM_X86__MACH_BIGSMP__MACH_APICDEF_H
-
-#define		APIC_ID_MASK		(0xFF<<24)
-
-static inline unsigned get_apic_id(unsigned long x) 
-{ 
-	return (((x)>>24)&0xFF);
-} 
-
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
-#endif /* ASM_X86__MACH_BIGSMP__MACH_APICDEF_H */
diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index b615f40..2a330a4 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -30,6 +30,8 @@ static inline cpumask_t target_cpus(void)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
+#define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
+#define send_IPI_self (genapic->send_IPI_self)
 extern void setup_apic_routing(void);
 #else
 #define INT_DELIVERY_MODE dest_LowestPrio
@@ -54,7 +56,7 @@ static inline void init_apic_ldr(void)
 
 static inline int apic_id_registered(void)
 {
-	return physid_isset(GET_APIC_ID(read_apic_id()), phys_cpu_present_map);
+	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
 static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
diff --git a/include/asm-x86/mach-default/mach_apicdef.h b/include/asm-x86/mach-default/mach_apicdef.h
index 936704f..0c2d41c 100644
--- a/include/asm-x86/mach-default/mach_apicdef.h
+++ b/include/asm-x86/mach-default/mach_apicdef.h
@@ -4,9 +4,9 @@
 #include <asm/apic.h>
 
 #ifdef CONFIG_X86_64
-#define	APIC_ID_MASK		(0xFFu<<24)
-#define GET_APIC_ID(x)          (((x)>>24)&0xFFu)
-#define	SET_APIC_ID(x)		(((x)<<24))
+#define	APIC_ID_MASK		(genapic->apic_id_mask)
+#define GET_APIC_ID(x)		(genapic->get_apic_id(x))
+#define	SET_APIC_ID(x)		(genapic->set_apic_id(x))
 #else
 #define		APIC_ID_MASK		(0xF<<24)
 static inline unsigned get_apic_id(unsigned long x) 
diff --git a/include/asm-x86/mach-es7000/mach_apicdef.h b/include/asm-x86/mach-es7000/mach_apicdef.h
deleted file mode 100644
index a07e567..0000000
--- a/include/asm-x86/mach-es7000/mach_apicdef.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef ASM_X86__MACH_ES7000__MACH_APICDEF_H
-#define ASM_X86__MACH_ES7000__MACH_APICDEF_H
-
-#define		APIC_ID_MASK		(0xFF<<24)
-
-static inline unsigned get_apic_id(unsigned long x) 
-{ 
-	return (((x)>>24)&0xFF);
-} 
-
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
-#endif /* ASM_X86__MACH_ES7000__MACH_APICDEF_H */
diff --git a/include/asm-x86/mach-numaq/mach_mpparse.h b/include/asm-x86/mach-numaq/mach_mpparse.h
deleted file mode 100644
index 74ade18..0000000
--- a/include/asm-x86/mach-numaq/mach_mpparse.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef ASM_X86__MACH_NUMAQ__MACH_MPPARSE_H
-#define ASM_X86__MACH_NUMAQ__MACH_MPPARSE_H
-
-extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
-
-#endif /* ASM_X86__MACH_NUMAQ__MACH_MPPARSE_H */
diff --git a/include/asm-x86/mach-summit/mach_apicdef.h b/include/asm-x86/mach-summit/mach_apicdef.h
deleted file mode 100644
index d4bc859..0000000
--- a/include/asm-x86/mach-summit/mach_apicdef.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef ASM_X86__MACH_SUMMIT__MACH_APICDEF_H
-#define ASM_X86__MACH_SUMMIT__MACH_APICDEF_H
-
-#define		APIC_ID_MASK		(0xFF<<24)
-
-static inline unsigned get_apic_id(unsigned long x) 
-{ 
-	return (((x)>>24)&0xFF);
-} 
-
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
-#endif /* ASM_X86__MACH_SUMMIT__MACH_APICDEF_H */
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 118da36..be2241a 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -5,11 +5,12 @@
 
 #include <asm/mpspec_def.h>
 
+extern int apic_version[MAX_APICS];
+
 #ifdef CONFIG_X86_32
 #include <mach_mpspec.h>
 
 extern unsigned int def_to_bigsmp;
-extern int apic_version[MAX_APICS];
 extern u8 apicid_2_node[];
 extern int pic_mode;
 
diff --git a/include/asm-x86/msidef.h b/include/asm-x86/msidef.h
index 3139666..ed91902 100644
--- a/include/asm-x86/msidef.h
+++ b/include/asm-x86/msidef.h
@@ -48,4 +48,8 @@
 #define  MSI_ADDR_DEST_ID(dest)		(((dest) << MSI_ADDR_DEST_ID_SHIFT) & \
 					 MSI_ADDR_DEST_ID_MASK)
 
+#define MSI_ADDR_IR_EXT_INT		(1 << 4)
+#define MSI_ADDR_IR_SHV			(1 << 3)
+#define MSI_ADDR_IR_INDEX1(index)	((index & 0x8000) >> 13)
+#define MSI_ADDR_IR_INDEX2(index)	((index & 0x7fff) << 5)
 #endif /* ASM_X86__MSIDEF_H */
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 3052f05..0bb4330 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -176,6 +176,7 @@
 #define MSR_IA32_TSC			0x00000010
 #define MSR_IA32_PLATFORM_ID		0x00000017
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
+#define MSR_IA32_FEATURE_CONTROL        0x0000003a
 
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
@@ -310,4 +311,19 @@
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
+/* Intel VT MSRs */
+#define MSR_IA32_VMX_BASIC              0x00000480
+#define MSR_IA32_VMX_PINBASED_CTLS      0x00000481
+#define MSR_IA32_VMX_PROCBASED_CTLS     0x00000482
+#define MSR_IA32_VMX_EXIT_CTLS          0x00000483
+#define MSR_IA32_VMX_ENTRY_CTLS         0x00000484
+#define MSR_IA32_VMX_MISC               0x00000485
+#define MSR_IA32_VMX_CR0_FIXED0         0x00000486
+#define MSR_IA32_VMX_CR0_FIXED1         0x00000487
+#define MSR_IA32_VMX_CR4_FIXED0         0x00000488
+#define MSR_IA32_VMX_CR4_FIXED1         0x00000489
+#define MSR_IA32_VMX_VMCS_ENUM          0x0000048a
+#define MSR_IA32_VMX_PROCBASED_CTLS2    0x0000048b
+#define MSR_IA32_VMX_EPT_VPID_CAP       0x0000048c
+
 #endif /* ASM_X86__MSR_INDEX_H */
diff --git a/include/asm-x86/mach-numaq/mach_apic.h b/include/asm-x86/numaq/apic.h
similarity index 96%
rename from include/asm-x86/mach-numaq/mach_apic.h
rename to include/asm-x86/numaq/apic.h
index 7a0d39e..a8344ba 100644
--- a/include/asm-x86/mach-numaq/mach_apic.h
+++ b/include/asm-x86/numaq/apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_NUMAQ__MACH_APIC_H
-#define ASM_X86__MACH_NUMAQ__MACH_APIC_H
+#ifndef __ASM_NUMAQ_APIC_H
+#define __ASM_NUMAQ_APIC_H
 
 #include <asm/io.h>
 #include <linux/mmzone.h>
@@ -135,4 +135,4 @@ static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-#endif /* ASM_X86__MACH_NUMAQ__MACH_APIC_H */
+#endif /* __ASM_NUMAQ_APIC_H */
diff --git a/include/asm-x86/mach-numaq/mach_apicdef.h b/include/asm-x86/numaq/apicdef.h
similarity index 55%
rename from include/asm-x86/mach-numaq/mach_apicdef.h
rename to include/asm-x86/numaq/apicdef.h
index f870ec5..e012a46 100644
--- a/include/asm-x86/mach-numaq/mach_apicdef.h
+++ b/include/asm-x86/numaq/apicdef.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_NUMAQ__MACH_APICDEF_H
-#define ASM_X86__MACH_NUMAQ__MACH_APICDEF_H
+#ifndef __ASM_NUMAQ_APICDEF_H
+#define __ASM_NUMAQ_APICDEF_H
 
 
 #define APIC_ID_MASK (0xF<<24)
@@ -11,4 +11,4 @@ static inline unsigned get_apic_id(unsigned long x)
 
 #define         GET_APIC_ID(x)  get_apic_id(x)
 
-#endif /* ASM_X86__MACH_NUMAQ__MACH_APICDEF_H */
+#endif
diff --git a/include/asm-x86/mach-numaq/mach_ipi.h b/include/asm-x86/numaq/ipi.h
similarity index 77%
rename from include/asm-x86/mach-numaq/mach_ipi.h
rename to include/asm-x86/numaq/ipi.h
index 1e83582..935588d 100644
--- a/include/asm-x86/mach-numaq/mach_ipi.h
+++ b/include/asm-x86/numaq/ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_NUMAQ__MACH_IPI_H
-#define ASM_X86__MACH_NUMAQ__MACH_IPI_H
+#ifndef __ASM_NUMAQ_IPI_H
+#define __ASM_NUMAQ_IPI_H
 
 void send_IPI_mask_sequence(cpumask_t, int vector);
 
@@ -22,4 +22,4 @@ static inline void send_IPI_all(int vector)
 	send_IPI_mask(cpu_online_map, vector);
 }
 
-#endif /* ASM_X86__MACH_NUMAQ__MACH_IPI_H */
+#endif /* __ASM_NUMAQ_IPI_H */
diff --git a/include/asm-x86/numaq/mpparse.h b/include/asm-x86/numaq/mpparse.h
new file mode 100644
index 0000000..252292e
--- /dev/null
+++ b/include/asm-x86/numaq/mpparse.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_NUMAQ_MPPARSE_H
+#define __ASM_NUMAQ_MPPARSE_H
+
+extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
+				char *productid);
+
+#endif /* __ASM_NUMAQ_MPPARSE_H */
diff --git a/include/asm-x86/mach-numaq/mach_wakecpu.h b/include/asm-x86/numaq/wakecpu.h
similarity index 88%
rename from include/asm-x86/mach-numaq/mach_wakecpu.h
rename to include/asm-x86/numaq/wakecpu.h
index 0db8cea..c577bda 100644
--- a/include/asm-x86/mach-numaq/mach_wakecpu.h
+++ b/include/asm-x86/numaq/wakecpu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_NUMAQ__MACH_WAKECPU_H
-#define ASM_X86__MACH_NUMAQ__MACH_WAKECPU_H
+#ifndef __ASM_NUMAQ_WAKECPU_H
+#define __ASM_NUMAQ_WAKECPU_H
 
 /* This file copes with machines that wakeup secondary CPUs by NMIs */
 
@@ -40,4 +40,4 @@ static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
 
 #define inquire_remote_apic(apicid) {}
 
-#endif /* ASM_X86__MACH_NUMAQ__MACH_WAKECPU_H */
+#endif /* __ASM_NUMAQ_WAKECPU_H */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 891971f..d7d358a 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -201,12 +201,6 @@ struct pv_irq_ops {
 
 struct pv_apic_ops {
 #ifdef CONFIG_X86_LOCAL_APIC
-	/*
-	 * Direct APIC operations, principally for VMI.  Ideally
-	 * these shouldn't be in this interface.
-	 */
-	void (*apic_write)(unsigned long reg, u32 v);
-	u32 (*apic_read)(unsigned long reg);
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
 
@@ -910,19 +904,6 @@ static inline void slow_down_io(void)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Basic functions accessing APICs.
- */
-static inline void apic_write(unsigned long reg, u32 v)
-{
-	PVOP_VCALL2(pv_apic_ops.apic_write, reg, v);
-}
-
-static inline u32 apic_read(unsigned long reg)
-{
-	return PVOP_CALL1(unsigned long, pv_apic_ops.apic_read, reg);
-}
-
 static inline void setup_boot_clock(void)
 {
 	PVOP_VCALL0(pv_apic_ops.setup_boot_clock);
diff --git a/include/asm-x86/processor-cyrix.h b/include/asm-x86/processor-cyrix.h
index 97568ad..1198f2a 100644
--- a/include/asm-x86/processor-cyrix.h
+++ b/include/asm-x86/processor-cyrix.h
@@ -28,3 +28,11 @@ static inline void setCx86(u8 reg, u8 data)
 	outb(reg, 0x22);
 	outb(data, 0x23);
 }
+
+#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })
+
+#define setCx86_old(reg, data) do { \
+	outb((reg), 0x22); \
+	outb((data), 0x23); \
+} while (0)
+
diff --git a/include/asm-x86/processor-flags.h b/include/asm-x86/processor-flags.h
index 5dd7977..dc5f071 100644
--- a/include/asm-x86/processor-flags.h
+++ b/include/asm-x86/processor-flags.h
@@ -59,6 +59,7 @@
 #define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
+#define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 
 /*
  * x86-64 Task Priority Register, CR8
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5eaf9bf..c7d3546 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -76,11 +76,11 @@ struct cpuinfo_x86 {
 	int			 x86_tlbsize;
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
+#endif
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */
 	__u32			extended_cpuid_level;
-#endif
 	/* Maximum supported CPUID level, -1=no CPUID: */
 	int			cpuid_level;
 	__u32			x86_capability[NCAPINTS];
@@ -166,11 +166,8 @@ extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
-#if defined(CONFIG_X86_HT) || defined(CONFIG_X86_64)
+extern void detect_extended_topology(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
-#else
-static inline void detect_ht(struct cpuinfo_x86 *c) {}
-#endif
 
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
@@ -327,7 +324,12 @@ struct i387_fxsave_struct {
 	/* 16*16 bytes for each XMM-reg = 256 bytes:			*/
 	u32			xmm_space[64];
 
-	u32			padding[24];
+	u32			padding[12];
+
+	union {
+		u32		padding1[12];
+		u32		sw_reserved[12];
+	};
 
 } __attribute__((aligned(16)));
 
@@ -351,10 +353,23 @@ struct i387_soft_struct {
 	u32			entry_eip;
 };
 
+struct xsave_hdr_struct {
+	u64 xstate_bv;
+	u64 reserved1[2];
+	u64 reserved2[5];
+} __attribute__((packed));
+
+struct xsave_struct {
+	struct i387_fxsave_struct i387;
+	struct xsave_hdr_struct xsave_hdr;
+	/* new processor state extensions will go here */
+} __attribute__ ((packed, aligned (64)));
+
 union thread_xstate {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct		soft;
+	struct xsave_struct		xsave;
 };
 
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 9030cb7..11b6cc1 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -38,6 +38,7 @@ struct x86_quirks {
 	void (*mpc_oem_pci_bus)(struct mpc_config_bus *m);
 	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
                                     unsigned short oemsize);
+	int (*setup_ioapic_ids)(void);
 };
 
 extern struct x86_quirks *x86_quirks;
diff --git a/include/asm-x86/sigcontext.h b/include/asm-x86/sigcontext.h
index 24879c8..ee813f4 100644
--- a/include/asm-x86/sigcontext.h
+++ b/include/asm-x86/sigcontext.h
@@ -4,6 +4,40 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
+#define FP_XSTATE_MAGIC1	0x46505853U
+#define FP_XSTATE_MAGIC2	0x46505845U
+#define FP_XSTATE_MAGIC2_SIZE	sizeof(FP_XSTATE_MAGIC2)
+
+/*
+ * bytes 464..511 in the current 512byte layout of fxsave/fxrstor frame
+ * are reserved for SW usage. On cpu's supporting xsave/xrstor, these bytes
+ * are used to extended the fpstate pointer in the sigcontext, which now
+ * includes the extended state information along with fpstate information.
+ *
+ * Presence of FP_XSTATE_MAGIC1 at the beginning of this SW reserved
+ * area and FP_XSTATE_MAGIC2 at the end of memory layout
+ * (extended_size - FP_XSTATE_MAGIC2_SIZE) indicates the presence of the
+ * extended state information in the memory layout pointed by the fpstate
+ * pointer in sigcontext.
+ */
+struct _fpx_sw_bytes {
+	__u32 magic1;		/* FP_XSTATE_MAGIC1 */
+	__u32 extended_size;	/* total size of the layout referred by
+				 * fpstate pointer in the sigcontext.
+				 */
+	__u64 xstate_bv;
+				/* feature bit mask (including fp/sse/extended
+				 * state) that is present in the memory
+				 * layout.
+				 */
+	__u32 xstate_size;	/* actual xsave state size, based on the
+				 * features saved in the layout.
+				 * 'extended_size' will be greater than
+				 * 'xstate_size'.
+				 */
+	__u32 padding[7];	/*  for future use. */
+};
+
 #ifdef __i386__
 /*
  * As documented in the iBCS2 standard..
@@ -53,7 +87,13 @@ struct _fpstate {
 	unsigned long	reserved;
 	struct _fpxreg	_fxsr_st[8];	/* FXSR FPU reg data is ignored */
 	struct _xmmreg	_xmm[8];
-	unsigned long	padding[56];
+	unsigned long	padding1[44];
+
+	union {
+		unsigned long	padding2[12];
+		struct _fpx_sw_bytes sw_reserved; /* represents the extended
+						   * state info */
+	};
 };
 
 #define X86_FXSR_MAGIC		0x0000
@@ -79,7 +119,15 @@ struct sigcontext {
 	unsigned long flags;
 	unsigned long sp_at_signal;
 	unsigned short ss, __ssh;
-	struct _fpstate __user *fpstate;
+
+	/*
+	 * fpstate is really (struct _fpstate *) or (struct _xstate *)
+	 * depending on the FP_XSTATE_MAGIC1 encoded in the SW reserved
+	 * bytes of (struct _fpstate) and FP_XSTATE_MAGIC2 present at the end
+	 * of extended memory layout. See comments at the defintion of
+	 * (struct _fpx_sw_bytes)
+	 */
+	void __user *fpstate;		/* zero when no FPU/extended context */
 	unsigned long oldmask;
 	unsigned long cr2;
 };
@@ -130,7 +178,12 @@ struct _fpstate {
 	__u32	mxcsr_mask;
 	__u32	st_space[32];	/* 8*16 bytes for each FP-reg */
 	__u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg  */
-	__u32	reserved2[24];
+	__u32	reserved2[12];
+	union {
+		__u32	reserved3[12];
+		struct _fpx_sw_bytes sw_reserved; /* represents the extended
+						   * state information */
+	};
 };
 
 #ifdef __KERNEL__
@@ -161,7 +214,15 @@ struct sigcontext {
 	unsigned long trapno;
 	unsigned long oldmask;
 	unsigned long cr2;
-	struct _fpstate __user *fpstate;	/* zero when no FPU context */
+
+	/*
+	 * fpstate is really (struct _fpstate *) or (struct _xstate *)
+	 * depending on the FP_XSTATE_MAGIC1 encoded in the SW reserved
+	 * bytes of (struct _fpstate) and FP_XSTATE_MAGIC2 present at the end
+	 * of extended memory layout. See comments at the defintion of
+	 * (struct _fpx_sw_bytes)
+	 */
+	void __user *fpstate;		/* zero when no FPU/extended context */
 	unsigned long reserved1[8];
 };
 #else /* __KERNEL__ */
@@ -202,4 +263,22 @@ struct sigcontext {
 
 #endif /* !__i386__ */
 
+struct _xsave_hdr {
+	__u64 xstate_bv;
+	__u64 reserved1[2];
+	__u64 reserved2[5];
+};
+
+/*
+ * Extended state pointed by the fpstate pointer in the sigcontext.
+ * In addition to the fpstate, information encoded in the xstate_hdr
+ * indicates the presence of other extended state information
+ * supported by the processor and OS.
+ */
+struct _xstate {
+	struct _fpstate fpstate;
+	struct _xsave_hdr xstate_hdr;
+	/* new processor state extensions go here */
+};
+
 #endif /* ASM_X86__SIGCONTEXT_H */
diff --git a/include/asm-x86/sigcontext32.h b/include/asm-x86/sigcontext32.h
index 4e2ec73..8c34703 100644
--- a/include/asm-x86/sigcontext32.h
+++ b/include/asm-x86/sigcontext32.h
@@ -40,7 +40,11 @@ struct _fpstate_ia32 {
 	__u32	reserved;
 	struct _fpxreg	_fxsr_st[8];
 	struct _xmmreg	_xmm[8];	/* It's actually 16 */
-	__u32	padding[56];
+	__u32	padding[44];
+	union {
+		__u32 padding2[12];
+		struct _fpx_sw_bytes sw_reserved;
+	};
 };
 
 struct sigcontext_ia32 {
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 04f84f4..29324c1 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -167,30 +167,33 @@ extern int safe_smp_processor_id(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
+#ifndef CONFIG_X86_64
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
-#ifndef CONFIG_X86_64
+#include <mach_apicdef.h>
 static inline unsigned int read_apic_id(void)
 {
-	return *(u32 *)(APIC_BASE + APIC_ID);
+	unsigned int reg;
+
+	reg = *(u32 *)(APIC_BASE + APIC_ID);
+
+	return GET_APIC_ID(reg);
 }
-#else
-extern unsigned int read_apic_id(void);
 #endif
 
 
-# ifdef APIC_DEFINITION
+# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
 extern int hard_smp_processor_id(void);
 # else
-#  include <mach_apicdef.h>
+#include <mach_apicdef.h>
 static inline int hard_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(read_apic_id());
+	return read_apic_id();
 }
 # endif /* APIC_DEFINITION */
 
diff --git a/include/asm-x86/mach-summit/mach_apic.h b/include/asm-x86/summit/apic.h
similarity index 93%
rename from include/asm-x86/mach-summit/mach_apic.h
rename to include/asm-x86/summit/apic.h
index 7a66758..c5b2e4b 100644
--- a/include/asm-x86/mach-summit/mach_apic.h
+++ b/include/asm-x86/summit/apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_SUMMIT__MACH_APIC_H
-#define ASM_X86__MACH_SUMMIT__MACH_APIC_H
+#ifndef __ASM_SUMMIT_APIC_H
+#define __ASM_SUMMIT_APIC_H
 
 #include <asm/smp.h>
 
@@ -21,7 +21,7 @@ static inline cpumask_t target_cpus(void)
 	 * Just start on cpu 0.  IRQ balancing will spread load
 	 */
 	return cpumask_of_cpu(0);
-} 
+}
 #define TARGET_CPUS	(target_cpus())
 
 #define INT_DELIVERY_MODE (dest_LowestPrio)
@@ -30,10 +30,10 @@ static inline cpumask_t target_cpus(void)
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return 0;
-} 
+}
 
 /* we don't use the phys_cpu_present_map to indicate apicid presence */
-static inline unsigned long check_apicid_present(int bit) 
+static inline unsigned long check_apicid_present(int bit)
 {
 	return 1;
 }
@@ -122,7 +122,7 @@ static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_id_map)
 
 static inline physid_mask_t apicid_to_cpu_present(int apicid)
 {
-	return physid_mask_of_physid(apicid);
+	return physid_mask_of_physid(0);
 }
 
 static inline void setup_portio_remap(void)
@@ -143,22 +143,22 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
-	int apicid;	
+	int apicid;
 
 	num_bits_set = cpus_weight(cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return (int) 0xFF;
-	/* 
-	 * The cpus in the mask must all be on the apic cluster.  If are not 
-	 * on the same apicid cluster return default value of TARGET_CPUS. 
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
 	cpu = first_cpu(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
 		if (cpu_isset(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
-			if (apicid_cluster(apicid) != 
+			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
 				printk ("%s: Not a valid mask!\n",__FUNCTION__);
 				return 0xFF;
@@ -182,4 +182,4 @@ static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
 	return hard_smp_processor_id() >> index_msb;
 }
 
-#endif /* ASM_X86__MACH_SUMMIT__MACH_APIC_H */
+#endif /* __ASM_SUMMIT_APIC_H */
diff --git a/include/asm-x86/summit/apicdef.h b/include/asm-x86/summit/apicdef.h
new file mode 100644
index 0000000..f3fbca1
--- /dev/null
+++ b/include/asm-x86/summit/apicdef.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_SUMMIT_APICDEF_H
+#define __ASM_SUMMIT_APICDEF_H
+
+#define		APIC_ID_MASK		(0xFF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	return (x>>24)&0xFF;
+}
+
+#define		GET_APIC_ID(x)	get_apic_id(x)
+
+#endif
diff --git a/include/asm-x86/mach-summit/mach_ipi.h b/include/asm-x86/summit/ipi.h
similarity index 77%
rename from include/asm-x86/mach-summit/mach_ipi.h
rename to include/asm-x86/summit/ipi.h
index a3b31c5..53bd1e7 100644
--- a/include/asm-x86/mach-summit/mach_ipi.h
+++ b/include/asm-x86/summit/ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_SUMMIT__MACH_IPI_H
-#define ASM_X86__MACH_SUMMIT__MACH_IPI_H
+#ifndef __ASM_SUMMIT_IPI_H
+#define __ASM_SUMMIT_IPI_H
 
 void send_IPI_mask_sequence(cpumask_t mask, int vector);
 
@@ -22,4 +22,4 @@ static inline void send_IPI_all(int vector)
 	send_IPI_mask(cpu_online_map, vector);
 }
 
-#endif /* ASM_X86__MACH_SUMMIT__MACH_IPI_H */
+#endif /* __ASM_SUMMIT_IPI_H */
diff --git a/include/asm-x86/mach-summit/irq_vectors_limits.h b/include/asm-x86/summit/irq_vectors_limits.h
similarity index 65%
rename from include/asm-x86/mach-summit/irq_vectors_limits.h
rename to include/asm-x86/summit/irq_vectors_limits.h
index 22f376a..890ce3f 100644
--- a/include/asm-x86/mach-summit/irq_vectors_limits.h
+++ b/include/asm-x86/summit/irq_vectors_limits.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_SUMMIT__IRQ_VECTORS_LIMITS_H
-#define ASM_X86__MACH_SUMMIT__IRQ_VECTORS_LIMITS_H
+#ifndef _ASM_IRQ_VECTORS_LIMITS_H
+#define _ASM_IRQ_VECTORS_LIMITS_H
 
 /*
  * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
@@ -11,4 +11,4 @@
 #define NR_IRQS	224
 #define NR_IRQ_VECTORS	1024
 
-#endif /* ASM_X86__MACH_SUMMIT__IRQ_VECTORS_LIMITS_H */
+#endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-x86/mach-summit/mach_mpparse.h b/include/asm-x86/summit/mpparse.h
similarity index 95%
rename from include/asm-x86/mach-summit/mach_mpparse.h
rename to include/asm-x86/summit/mpparse.h
index 92396f2..013ce6f 100644
--- a/include/asm-x86/mach-summit/mach_mpparse.h
+++ b/include/asm-x86/summit/mpparse.h
@@ -1,7 +1,6 @@
-#ifndef ASM_X86__MACH_SUMMIT__MACH_MPPARSE_H
-#define ASM_X86__MACH_SUMMIT__MACH_MPPARSE_H
+#ifndef __ASM_SUMMIT_MPPARSE_H
+#define __ASM_SUMMIT_MPPARSE_H
 
-#include <mach_apic.h>
 #include <asm/tsc.h>
 
 extern int use_cyclone;
@@ -12,11 +11,11 @@ extern void setup_summit(void);
 #define setup_summit()	{}
 #endif
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem, 
+static inline int mps_oem_check(struct mp_config_table *mpc, char *oem,
 		char *productid)
 {
-	if (!strncmp(oem, "IBM ENSW", 8) && 
-			(!strncmp(productid, "VIGIL SMP", 9) 
+	if (!strncmp(oem, "IBM ENSW", 8) &&
+			(!strncmp(productid, "VIGIL SMP", 9)
 			 || !strncmp(productid, "EXA", 3)
 			 || !strncmp(productid, "RUTHLESS SMP", 12))){
 		mark_tsc_unstable("Summit based system");
@@ -107,4 +106,4 @@ static inline int is_WPEG(struct rio_detail *rio){
 		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
 }
 
-#endif /* ASM_X86__MACH_SUMMIT__MACH_MPPARSE_H */
+#endif /* __ASM_SUMMIT_MPPARSE_H */
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 4db0066..3f4e52b 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -241,6 +241,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
+#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
diff --git a/include/asm-x86/ucontext.h b/include/asm-x86/ucontext.h
index 9948dd3..89eaa54 100644
--- a/include/asm-x86/ucontext.h
+++ b/include/asm-x86/ucontext.h
@@ -1,6 +1,12 @@
 #ifndef ASM_X86__UCONTEXT_H
 #define ASM_X86__UCONTEXT_H
 
+#define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
+				 * information in the memory layout pointed
+				 * by the fpstate pointer in the ucontext's
+				 * sigcontext struct (uc_mcontext).
+				 */
+
 struct ucontext {
 	unsigned long	  uc_flags;
 	struct ucontext  *uc_link;
diff --git a/include/asm-x86/xcr.h b/include/asm-x86/xcr.h
new file mode 100644
index 0000000..f2cba4e
--- /dev/null
+++ b/include/asm-x86/xcr.h
@@ -0,0 +1,49 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright 2008 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * asm-x86/xcr.h
+ *
+ * Definitions for the eXtended Control Register instructions
+ */
+
+#ifndef _ASM_X86_XCR_H
+#define _ASM_X86_XCR_H
+
+#define XCR_XFEATURE_ENABLED_MASK	0x00000000
+
+#ifdef __KERNEL__
+# ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	asm volatile(".byte 0x0f,0x01,0xd0" /* xgetbv */
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax + ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	asm volatile(".byte 0x0f,0x01,0xd1" /* xsetbv */
+		     : : "a" (eax), "d" (edx), "c" (index));
+}
+
+# endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_X86_XCR_H */
diff --git a/include/asm-x86/xsave.h b/include/asm-x86/xsave.h
new file mode 100644
index 0000000..08e9a1a
--- /dev/null
+++ b/include/asm-x86/xsave.h
@@ -0,0 +1,118 @@
+#ifndef __ASM_X86_XSAVE_H
+#define __ASM_X86_XSAVE_H
+
+#include <linux/types.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+
+#define XSTATE_FP	0x1
+#define XSTATE_SSE	0x2
+
+#define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
+
+#define FXSAVE_SIZE	512
+
+/*
+ * These are the features that the OS can handle currently.
+ */
+#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE)
+
+#ifdef CONFIG_X86_64
+#define REX_PREFIX	"0x48, "
+#else
+#define REX_PREFIX
+#endif
+
+extern unsigned int xstate_size;
+extern u64 pcntxt_mask;
+extern struct xsave_struct *init_xstate_buf;
+
+extern void xsave_cntxt_init(void);
+extern void xsave_init(void);
+extern int init_fpu(struct task_struct *child);
+extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
+			    void __user *fpstate,
+			    struct _fpx_sw_bytes *sw);
+
+static inline int xrstor_checking(struct xsave_struct *fx)
+{
+	int err;
+
+	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err)
+		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+static inline int xsave_user(struct xsave_struct __user *buf)
+{
+	int err;
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+			     : "memory");
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
+	/* No need to clear here because the caller clears USED_MATH */
+	return err;
+}
+
+static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
+{
+	int err;
+	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
+			     : "memory");	/* memory required? */
+	return err;
+}
+
+static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		     :   "memory");
+}
+
+static inline void xsave(struct task_struct *tsk)
+{
+	/* This, however, we can work around by forcing the compiler to select
+	   an addressing mode that doesn't require extended registers. */
+	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
+			     : : "D" (&(tsk->thread.xstate->xsave)),
+				 "a" (-1), "d"(-1) : "memory");
+}
+#endif
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 56c73b8..c360c55 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -25,9 +25,99 @@
 #include <linux/types.h>
 #include <linux/msi.h>
 
-#ifdef CONFIG_DMAR
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
 struct intel_iommu;
 
+struct dmar_drhd_unit {
+	struct list_head list;		/* list of drhd units	*/
+	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
+	u64	reg_base_addr;		/* register base address*/
+	struct	pci_dev **devices; 	/* target device array	*/
+	int	devices_cnt;		/* target device count	*/
+	u8	ignored:1; 		/* ignore drhd		*/
+	u8	include_all:1;
+	struct intel_iommu *iommu;
+};
+
+extern struct list_head dmar_drhd_units;
+
+#define for_each_drhd_unit(drhd) \
+	list_for_each_entry(drhd, &dmar_drhd_units, list)
+
+extern int dmar_table_init(void);
+extern int early_dmar_detect(void);
+extern int dmar_dev_scope_init(void);
+
+/* Intel IOMMU detection */
+extern void detect_intel_iommu(void);
+
+
+extern int parse_ioapics_under_ir(void);
+extern int alloc_iommu(struct dmar_drhd_unit *);
+#else
+static inline void detect_intel_iommu(void)
+{
+	return;
+}
+
+static inline int dmar_table_init(void)
+{
+	return -ENODEV;
+}
+#endif /* !CONFIG_DMAR && !CONFIG_INTR_REMAP */
+
+#ifdef CONFIG_INTR_REMAP
+extern int intr_remapping_enabled;
+extern int enable_intr_remapping(int);
+
+struct irte {
+	union {
+		struct {
+			__u64	present 	: 1,
+				fpd		: 1,
+				dst_mode	: 1,
+				redir_hint	: 1,
+				trigger_mode	: 1,
+				dlvry_mode	: 3,
+				avail		: 4,
+				__reserved_1	: 4,
+				vector		: 8,
+				__reserved_2	: 8,
+				dest_id		: 32;
+		};
+		__u64 low;
+	};
+
+	union {
+		struct {
+			__u64	sid		: 16,
+				sq		: 2,
+				svt		: 2,
+				__reserved_3	: 44;
+		};
+		__u64 high;
+	};
+};
+extern int get_irte(int irq, struct irte *entry);
+extern int modify_irte(int irq, struct irte *irte_modified);
+extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
+extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
+   			u16 sub_handle);
+extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
+extern int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index);
+extern int flush_irte(int irq);
+extern int free_irte(int irq);
+
+extern int irq_remapped(int irq);
+extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
+extern struct intel_iommu *map_ioapic_to_ir(int apic);
+#else
+#define irq_remapped(irq)		(0)
+#define enable_intr_remapping(mode)	(-1)
+#define intr_remapping_enabled		(0)
+#endif
+
+#ifdef CONFIG_DMAR
 extern const char *dmar_get_fault_reason(u8 fault_reason);
 
 /* Can't use the common MSI interrupt functions
@@ -40,47 +130,30 @@ extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
-/* Intel IOMMU detection and initialization functions */
-extern void detect_intel_iommu(void);
-extern int intel_iommu_init(void);
-
-extern int dmar_table_init(void);
-extern int early_dmar_detect(void);
-
-extern struct list_head dmar_drhd_units;
+extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
-
-struct dmar_drhd_unit {
-	struct list_head list;		/* list of drhd units	*/
-	u64	reg_base_addr;		/* register base address*/
-	struct	pci_dev **devices; 	/* target device array	*/
-	int	devices_cnt;		/* target device count	*/
-	u8	ignored:1; 		/* ignore drhd		*/
-	u8	include_all:1;
-	struct intel_iommu *iommu;
-};
-
 struct dmar_rmrr_unit {
 	struct list_head list;		/* list of rmrr units	*/
+	struct acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	base_address;		/* reserved base address*/
 	u64	end_address;		/* reserved end address */
 	struct pci_dev **devices;	/* target devices */
 	int	devices_cnt;		/* target device count */
 };
 
-#define for_each_drhd_unit(drhd) \
-	list_for_each_entry(drhd, &dmar_drhd_units, list)
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
+/* Intel DMAR  initialization functions */
+extern int intel_iommu_init(void);
+extern int dmar_disabled;
 #else
-static inline void detect_intel_iommu(void)
-{
-	return;
-}
 static inline int intel_iommu_init(void)
 {
+#ifdef CONFIG_INTR_REMAP
+	return dmar_dev_scope_init();
+#else
 	return -ENODEV;
+#endif
 }
-
 #endif /* !CONFIG_DMAR */
 #endif /* __DMAR_H__ */
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 350033e..ee9bcc6 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -108,6 +108,9 @@ extern struct resource iomem_resource;
 
 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+extern void reserve_region_with_split(struct resource *root,
+			     resource_size_t start, resource_size_t end,
+			     const char *name);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8ccb462..8d9411b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -62,6 +62,7 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
+#define IRQ_MOVE_PCNTXT	0x01000000	/* IRQ migration from process context */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index fac3337..9f2a375 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -23,12 +23,19 @@
 	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.page_aligned")))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 #else
 #define DEFINE_PER_CPU(type, name)					\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
 	DEFINE_PER_CPU(type, name)
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)		      \
+	DEFINE_PER_CPU(type, name)
 #endif
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0314074..60c49e3 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -89,7 +89,14 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 	set_balance_irq_affinity(irq, cpumask);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	set_pending_irq(irq, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&desc->lock, flags);
+		desc->chip->set_affinity(irq, cpumask);
+		spin_unlock_irqrestore(&desc->lock, flags);
+	} else
+		set_pending_irq(irq, cpumask);
 #else
 	desc->affinity = cpumask;
 	desc->chip->set_affinity(irq, cpumask);
diff --git a/kernel/resource.c b/kernel/resource.c
index 03d796c..414d6fc 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -516,6 +516,74 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 	return result;
 }
 
+static void __init __reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	struct resource *parent = root;
+	struct resource *conflict;
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+
+	if (!res)
+		return;
+
+	res->name = name;
+	res->start = start;
+	res->end = end;
+	res->flags = IORESOURCE_BUSY;
+
+	for (;;) {
+		conflict = __request_resource(parent, res);
+		if (!conflict)
+			break;
+		if (conflict != parent) {
+			parent = conflict;
+			if (!(conflict->flags & IORESOURCE_BUSY))
+				continue;
+		}
+
+		/* Uhhuh, that didn't work out.. */
+		kfree(res);
+		res = NULL;
+		break;
+	}
+
+	if (!res) {
+		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
+			 conflict->name, conflict->start, conflict->end,
+			 name, start, end);
+
+		/* failed, split and try again */
+
+		/* conflict coverred whole area */
+		if (conflict->start <= start && conflict->end >= end)
+			return;
+
+		if (conflict->start > start)
+			__reserve_region_with_split(root, start, conflict->start-1, name);
+		if (!(conflict->flags & IORESOURCE_BUSY)) {
+			resource_size_t common_start, common_end;
+
+			common_start = max(conflict->start, start);
+			common_end = min(conflict->end, end);
+			if (common_start < common_end)
+				__reserve_region_with_split(root, common_start, common_end, name);
+		}
+		if (conflict->end < end)
+			__reserve_region_with_split(root, conflict->end+1, end, name);
+	}
+
+}
+
+void reserve_region_with_split(struct resource *root,
+		resource_size_t start, resource_size_t end,
+		const char *name)
+{
+	write_lock(&resource_lock);
+	__reserve_region_with_split(root, start, end, name);
+	write_unlock(&resource_lock);
+}
+
 EXPORT_SYMBOL(adjust_resource);
 
 /**
