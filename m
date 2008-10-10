Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYJJR5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYJJR5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbYJJR4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:56:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759763AbYJJR4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:56:44 -0400
Date: Fri, 10 Oct 2008 19:56:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull, take 2] x86 updates for v2.6.28, phase #4, x2apic,
	unify-cpu-detect
Message-ID: <20081010175613.GA20112@elte.hu>
References: <20081010000408.GA5970@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010000408.GA5970@elte.hu>
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

> Linus,
> 
> Please pull the latest x86-v28-for-linus-phase4 git tree from:
> 
> x86/x2apic and x86/unify-cpu-detect topics.

Linus, please find a new pull request below - relative to 
x86-v28-for-linus-phase3-B.

I'm double-checking all the new integrations by merging them ontop of 
the old ones, and it's also being rolling tested.

	Ingo

----------------->
Linus,

Please pull the latest x86-v28-for-linus-phase4-B git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase4-B


out-of-topic modifications in x86-v28-for-linus-phase4-B:
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
include/linux/dmar.h               # 75c46fa: x64, x2apic/intr-remap: MSI and M
                                   # 89027d3: x64, x2apic/intr-remap: IO-APIC s
                                   # b6fcb33: x64, x2apic/intr-remap: routines 
                                   # 2ae2101: x64, x2apic/intr-remap: Interrupt
                                   # ad3ad3f: x64, x2apic/intr-remap: parse ioa
                                   # 1886e8a: x64, x2apic/intr-remap: code re-s
include/linux/irq.h                # 72b1e22: x64, x2apic/intr-remap: generic i
kernel/irq/manage.c                # 72b1e22: x64, x2apic/intr-remap: generic i

 Thanks,

	Ingo

------------------>
Andreas Herrmann (2):
      x86: pda_init(): fix memory leak when using CPU hotplug
      x86: cpu_init(): fix memory leak when using CPU hotplug

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

Hiroshi Shimamoto (2):
      x86_32: use apic_ops at print_local_APIC()
      x86_64: uml: fix rename header guard

Huang Weiyi (1):
      arch/x86/kernel/genx2apic_uv_x.c: Removed duplicated include

Ingo Molnar (2):
      x86, xen: fix apic_ops build on UP
      x86, lguest: fix apic_ops build on UP

Maciej W. Rozycki (1):
      x86: PIC, L-APIC and I/O APIC debug information

Suresh Siddha (35):
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

Yinghai Lu (15):
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


 Documentation/kernel-parameters.txt                |    6 +
 arch/um/sys-x86_64/syscall_table.c                 |    4 +-
 arch/x86/Kconfig                                   |    8 +
 arch/x86/{mach-es7000 => es7000}/Makefile          |    0
 arch/x86/{mach-es7000 => es7000}/es7000.h          |   18 +-
 arch/x86/{mach-es7000 => es7000}/es7000plat.c      |    2 +-
 arch/x86/kernel/Makefile                           |    2 +
 arch/x86/kernel/acpi/boot.c                        |    8 +-
 arch/x86/kernel/apic_32.c                          |  437 ++++++++------
 arch/x86/kernel/apic_64.c                          |  626 +++++++++++++++++---
 arch/x86/kernel/cpu/common_64.c                    |    2 +
 arch/x86/kernel/cpu/feature_names.c                |    2 +-
 arch/x86/kernel/genapic_64.c                       |   88 +--
 arch/x86/kernel/genapic_flat_64.c                  |   62 ++-
 arch/x86/kernel/genx2apic_cluster.c                |  164 +++++
 arch/x86/kernel/genx2apic_phys.c                   |  159 +++++
 arch/x86/kernel/genx2apic_uv_x.c                   |   70 ++-
 arch/x86/kernel/i8259.c                            |   24 +
 arch/x86/kernel/io_apic_32.c                       |   47 +-
 arch/x86/kernel/io_apic_64.c                       |  639 ++++++++++++++++++--
 arch/x86/kernel/irqinit_32.c                       |   49 ++
 arch/x86/kernel/mpparse.c                          |    2 +
 arch/x86/kernel/numaq_32.c                         |    7 +
 arch/x86/kernel/paravirt.c                         |    2 -
 arch/x86/kernel/setup.c                            |    2 +
 arch/x86/kernel/smpboot.c                          |   38 +-
 arch/x86/kernel/summit_32.c                        |    2 +-
 arch/x86/kernel/vmi_32.c                           |    4 +-
 arch/x86/lguest/boot.c                             |   38 +-
 arch/x86/mach-default/setup.c                      |   15 -
 arch/x86/mach-generic/Makefile                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                     |    9 +-
 arch/x86/mach-generic/es7000.c                     |   13 +-
 arch/x86/mach-generic/numaq.c                      |   12 +-
 arch/x86/mach-generic/summit.c                     |   11 +-
 arch/x86/pci/acpi.c                                |    5 -
 arch/x86/xen/enlighten.c                           |   45 ++-
 drivers/pci/Makefile                               |    2 +
 drivers/pci/dma_remapping.h                        |  157 +++++
 drivers/pci/dmar.c                                 |  397 ++++++++++++-
 drivers/pci/intel-iommu.c                          |  185 +-----
 drivers/pci/intel-iommu.h                          |  233 +++----
 drivers/pci/intr_remapping.c                       |  471 ++++++++++++++
 drivers/pci/intr_remapping.h                       |    8 +
 include/asm-x86/apic.h                             |   65 ++-
 include/asm-x86/apicdef.h                          |    3 +
 include/asm-x86/arch_hooks.h                       |    2 -
 .../{mach-bigsmp/mach_apic.h => bigsmp/apic.h}     |   10 +-
 include/asm-x86/bigsmp/apicdef.h                   |   13 +
 .../{mach-bigsmp/mach_ipi.h => bigsmp/ipi.h}       |    6 +-
 include/asm-x86/cpufeature.h                       |    2 +
 include/asm-x86/dma-mapping.h                      |    1 +
 .../{mach-es7000/mach_apic.h => es7000/apic.h}     |   32 +-
 include/asm-x86/es7000/apicdef.h                   |   13 +
 .../{mach-es7000/mach_ipi.h => es7000/ipi.h}       |    6 +-
 .../mach_mpparse.h => es7000/mpparse.h}            |    6 +-
 .../mach_wakecpu.h => es7000/wakecpu.h}            |    8 +-
 include/asm-x86/genapic_64.h                       |    8 +
 include/asm-x86/hw_irq.h                           |    3 +-
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
 .../{mach-numaq/mach_apic.h => numaq/apic.h}       |    6 +-
 .../{mach-numaq/mach_apicdef.h => numaq/apicdef.h} |    6 +-
 .../asm-x86/{mach-numaq/mach_ipi.h => numaq/ipi.h} |    6 +-
 include/asm-x86/numaq/mpparse.h                    |    7 +
 .../{mach-numaq/mach_wakecpu.h => numaq/wakecpu.h} |    6 +-
 include/asm-x86/paravirt.h                         |   19 -
 include/asm-x86/setup.h                            |    1 +
 include/asm-x86/smp.h                              |   17 +-
 .../{mach-summit/mach_apic.h => summit/apic.h}     |   24 +-
 include/asm-x86/summit/apicdef.h                   |   13 +
 .../{mach-summit/mach_ipi.h => summit/ipi.h}       |    6 +-
 .../{mach-summit => summit}/irq_vectors_limits.h   |    6 +-
 .../mach_mpparse.h => summit/mpparse.h}            |   13 +-
 include/linux/dmar.h                               |  127 +++-
 include/linux/irq.h                                |    1 +
 kernel/irq/manage.c                                |    9 +-
 87 files changed, 3636 insertions(+), 996 deletions(-)
 rename arch/x86/{mach-es7000 => es7000}/Makefile (100%)
 rename arch/x86/{mach-es7000 => es7000}/es7000.h (89%)
 rename arch/x86/{mach-es7000 => es7000}/es7000plat.c (99%)
 create mode 100644 arch/x86/kernel/genx2apic_cluster.c
 create mode 100644 arch/x86/kernel/genx2apic_phys.c
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
diff --git a/arch/x86/mach-es7000/Makefile b/arch/x86/es7000/Makefile
similarity index 100%
rename from arch/x86/mach-es7000/Makefile
rename to arch/x86/es7000/Makefile
diff --git a/arch/x86/mach-es7000/es7000.h b/arch/x86/es7000/es7000.h
similarity index 89%
rename from arch/x86/mach-es7000/es7000.h
rename to arch/x86/es7000/es7000.h
index c8d5aa1..4e62f6f 100644
--- a/arch/x86/mach-es7000/es7000.h
+++ b/arch/x86/es7000/es7000.h
@@ -1,7 +1,7 @@
 /*
  * Written by: Garry Forsgren, Unisys Corporation
  *             Natalie Protasevich, Unisys Corporation
- * This file contains the code to configure and interface 
+ * This file contains the code to configure and interface
  * with Unisys ES7000 series hardware system manager.
  *
  * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
@@ -18,7 +18,7 @@
  * with this program; if not, write the Free Software Foundation, Inc., 59
  * Temple Place - Suite 330, Boston MA 02111-1307, USA.
  *
- * Contact information: Unisys Corporation, Township Line & Union Meeting 
+ * Contact information: Unisys Corporation, Township Line & Union Meeting
  * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
  *
  * http://www.unisys.com
@@ -41,7 +41,7 @@
 #define	MIP_VALID		0x0100000000000000ULL
 #define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
 
-#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)   
+#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)
 
 struct mip_reg_info {
 	unsigned long long mip_info;
@@ -51,11 +51,11 @@ struct mip_reg_info {
 };
 
 struct part_info {
-	unsigned char type;   
+	unsigned char type;
 	unsigned char length;
 	unsigned char part_id;
 	unsigned char apic_mode;
-	unsigned long snum;    
+	unsigned long snum;
 	char ptype[16];
 	char sname[64];
 	char pname[64];
@@ -68,11 +68,11 @@ struct psai {
 };
 
 struct es7000_mem_info {
-	unsigned char type;   
+	unsigned char type;
 	unsigned char length;
 	unsigned char resv[6];
-	unsigned long long  start; 
-	unsigned long long  size; 
+	unsigned long long  start;
+	unsigned long long  size;
 };
 
 struct es7000_oem_table {
@@ -106,7 +106,7 @@ struct mip_reg {
 };
 
 #define	MIP_SW_APIC		0x1020b
-#define	MIP_FUNC(VALUE) 	(VALUE & 0xff)
+#define	MIP_FUNC(VALUE)		(VALUE & 0xff)
 
 extern int parse_unisys_oem (char *oemptr);
 extern void setup_unisys(void);
diff --git a/arch/x86/mach-es7000/es7000plat.c b/arch/x86/es7000/es7000plat.c
similarity index 99%
rename from arch/x86/mach-es7000/es7000plat.c
rename to arch/x86/es7000/es7000plat.c
index 50189af..7789fde 100644
--- a/arch/x86/mach-es7000/es7000plat.c
+++ b/arch/x86/es7000/es7000plat.c
@@ -72,7 +72,7 @@ es7000_rename_gsi(int ioapic, int gsi)
 			base += nr_ioapic_registers[i];
 	}
 
-	if (!ioapic && (gsi < 16)) 
+	if (!ioapic && (gsi < 16))
 		gsi += base;
 	return gsi;
 }
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3db651f..a07ec14 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,6 +104,8 @@ obj-$(CONFIG_OLPC)		+= olpc.o
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
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 305b465..43f1aa5 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -687,6 +687,8 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	check_efer();
+	if (cpu != 0 && x2apic)
+		enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
diff --git a/arch/x86/kernel/cpu/feature_names.c b/arch/x86/kernel/cpu/feature_names.c
index c901779..b96b695 100644
--- a/arch/x86/kernel/cpu/feature_names.c
+++ b/arch/x86/kernel/cpu/feature_names.c
@@ -46,7 +46,7 @@ const char * const x86_cap_flags[NCAPINTS*32] = {
 	/* Intel-defined (#2) */
 	"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 	"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-	NULL, NULL, "dca", "sse4_1", "sse4_2", NULL, NULL, "popcnt",
+	NULL, NULL, "dca", "sse4_1", "sse4_2", "x2apic", NULL, "popcnt",
 	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 	/* VIA/Cyrix/Centaur-defined */
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
index 0000000..fed9f68
--- /dev/null
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -0,0 +1,164 @@
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
+static unsigned int x2apic_read_id(void)
+{
+	return apic_read(APIC_ID);
+}
+
+static unsigned int phys_pkg_id(int index_msb)
+{
+	return x2apic_read_id() >> index_msb;
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
index 0000000..958d537
--- /dev/null
+++ b/arch/x86/kernel/genx2apic_phys.c
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
+static unsigned int x2apic_read_id(void)
+{
+	return apic_read(APIC_ID);
+}
+
+static unsigned int phys_pkg_id(int index_msb)
+{
+	return x2apic_read_id() >> index_msb;
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
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
index 0dbd780..4706de7 100644
--- a/arch/x86/mach-generic/Makefile
+++ b/arch/x86/mach-generic/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT)	+= summit.o
 obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
 obj-$(CONFIG_X86_ES7000)	+= es7000.o
-obj-$(CONFIG_X86_ES7000)	+= ../../x86/mach-es7000/
+obj-$(CONFIG_X86_ES7000)	+= ../../x86/es7000/
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
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 250fa0c..065c6a8 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -93,6 +93,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
 #define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
@@ -192,6 +193,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 219c33d..0fff2e0 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -306,3 +306,4 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 }
 
 #endif
+#endif /* ASM_X86__DMA_MAPPING_H */
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
