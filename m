Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYJJAEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYJJAEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYJJAE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:04:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYJJAE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:04:27 -0400
Date: Fri, 10 Oct 2008 02:04:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #4, x2apic,
	unify-cpu-detect
Message-ID: <20081010000408.GA5970@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Please pull the latest x86-v28-for-linus-phase4 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase4

x86/x2apic and x86/unify-cpu-detect topics.

out-of-topic modifications in x86-v28-for-linus-phase4:
-------------------------------------------------------
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

Special mention for the kernel/resource.c change.

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
 arch/x86/kernel/cpu/amd.c                          |  548 ++++++++----
 arch/x86/kernel/cpu/amd_64.c                       |  224 -----
 arch/x86/kernel/cpu/centaur.c                      |    4 +-
 arch/x86/kernel/cpu/centaur_64.c                   |    6 +-
 arch/x86/kernel/cpu/cmpxchg.c                      |   72 ++
 arch/x86/kernel/cpu/common.c                       |  971 ++++++++++++++------
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
 144 files changed, 6627 insertions(+), 3286 deletions(-)
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

