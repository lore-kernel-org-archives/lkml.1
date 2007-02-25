Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbXBYUw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbXBYUw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXBYUw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:52:57 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51463 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXBYUw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:52:56 -0500
Date: Sun, 25 Feb 2007 21:53:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: fix section mismatch warnings
Message-ID: <20070225205302.GA5851@uranus.ravnborg.org>
References: <20070222.005728.126762028.anemo@mba.ocn.ne.jp> <20070225.035315.25909736.anemo@mba.ocn.ne.jp> <20070224232527.GA10768@uranus.ravnborg.org> <20070226.004838.126574842.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226.004838.126574842.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following section mismatch warnings on x86_64:
(build using defconfig)

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset 0x65eb) and 'IRQ0x20_interrupt'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'finish_e820_parsing' (at offset 0x7dc2) and 'early_panic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:e820_print_map from .text between 'finish_e820_parsing' (at offset 0x7de1) and 'early_panic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'acpi_unmap_lsapic' (at offset 0xc88f) and 'acpi_register_ioapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:disabled_cpus from .text between 'MP_processor_info' (at offset 0x11f35) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'MP_processor_info' (at offset 0x11f6e) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'MP_processor_info' (at offset 0x11f93) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fix_aperture from .text between 'gart_parse_options' (at offset 0x15517) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fix_aperture from .text between 'gart_parse_options' (at offset 0x1552c) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x1553d) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15552) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15561) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15577) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fallback_aper_force from .text between 'gart_parse_options' (at offset 0x1558a) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fallback_aper_order from .text between 'gart_parse_options' (at offset 0x155bf) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:timer_over_8254 from .text between 'ati_bugs' (at offset 0x16344) and 'via_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:timer_over_8254 from .text between 'ati_bugs' (at offset 0x16356) and 'via_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'via_bugs' (at offset 0x16380) and 'nvidia_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_disabled from .text between 'via_bugs' (at offset 0x16397) and 'nvidia_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:acpi_use_timer_override from .text between 'nvidia_bugs' (at offset 0x163a7) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:nvidia_hpet_check from .text between 'nvidia_bugs' (at offset 0x163b1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'nvidia_bugs' (at offset 0x163be) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'nvidia_bugs' (at offset 0x163d1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:acpi_skip_timer_override from .text between 'nvidia_bugs' (at offset 0x163e1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:quirk_intel_irqbalance from .text between 'intel_bugs' (at offset 0x1633c) and 'ati_bugs'

But adds:
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:get_mtrr_state from .text between 'mtrr_bp_init' (at offset 0xb887) and 'ipi_handler'

The warnings does not show up during a normal build due to kbuild
failing to check for section mismatch in vmlinux.
To see these warnings run:
scripts/mod/modpost arch/x86_64/kernel/built-in.o

kbuild will be fixed but the 'noise-level' had to be decresed first.
There remains a few section mismatch warnigns for x86_64 for areas where I did
not feel confident.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

I only recently got my new dev machine running and has not yet
installed cross-compile tools etc. so I do not know the status
of other architectures.

Fro the mtrr changes I felt less confident then the rest and did not fix up the
introduced warning for the same reason. Let me know if you have any hints.

Any easy way to get cross-compile tools on ubuntu other than using Dan Kegel's
toolset or Linux Foundation precompield versions?

	Sam

diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 0acfb6a..8972cad 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_driver = {
  * initialized (i.e. before smp_init()).
  * 
  */
-void __init mtrr_bp_init(void)
+void __cpuinit mtrr_bp_init(void)
 {
 	init_ifs();
 
diff --git a/arch/x86_64/kernel/e820.c b/arch/x86_64/kernel/e820.c
index 4651fd2..a490fab 100644
--- a/arch/x86_64/kernel/e820.c
+++ b/arch/x86_64/kernel/e820.c
@@ -662,7 +662,7 @@ static int __init parse_memmap_opt(char *p)
 }
 early_param("memmap", parse_memmap_opt);
 
-void finish_e820_parsing(void)
+void __init finish_e820_parsing(void)
 {
 	if (userdef) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
diff --git a/arch/x86_64/kernel/early-quirks.c b/arch/x86_64/kernel/early-quirks.c
index 8047ea8..51c281c 100644
--- a/arch/x86_64/kernel/early-quirks.c
+++ b/arch/x86_64/kernel/early-quirks.c
@@ -16,7 +16,7 @@
 #include <asm/proto.h>
 #include <asm/dma.h>
 
-static void via_bugs(void)
+static void __init via_bugs(void)
 {
 #ifdef CONFIG_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
@@ -39,7 +39,7 @@ static int __init nvidia_hpet_check(struct acpi_table_header *header)
 }
 #endif
 
-static void nvidia_bugs(void)
+static void __init nvidia_bugs(void)
 {
 #ifdef CONFIG_ACPI
 	/*
@@ -69,7 +69,7 @@ static void nvidia_bugs(void)
 
 }
 
-static void ati_bugs(void)
+static void __init ati_bugs(void)
 {
 	if (timer_over_8254 == 1) {
 		timer_over_8254 = 0;
@@ -78,7 +78,7 @@ static void ati_bugs(void)
 	}
 }
 
-static void intel_bugs(void)
+static void __init intel_bugs(void)
 {
 	u16 device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
 
@@ -95,7 +95,7 @@ struct chipset {
 	void (*f)(void);
 };
 
-static struct chipset early_qrk[] = {
+static struct __initdata chipset early_qrk[] = {
 	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
 	{ PCI_VENDOR_ID_VIA, via_bugs },
 	{ PCI_VENDOR_ID_ATI, ati_bugs },
diff --git a/arch/x86_64/kernel/mpparse.c b/arch/x86_64/kernel/mpparse.c
index 50dd8be..455aa0b 100644
--- a/arch/x86_64/kernel/mpparse.c
+++ b/arch/x86_64/kernel/mpparse.c
@@ -60,9 +60,9 @@ unsigned long mp_lapic_addr = 0;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_id = -1U;
 /* Internal processor count */
-unsigned int num_processors __initdata = 0;
+unsigned int num_processors __cpuinitdata = 0;
 
-unsigned disabled_cpus __initdata;
+unsigned disabled_cpus __cpuinitdata;
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 030eb37..2bac8c6 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -675,7 +675,7 @@ void __init gart_iommu_init(void)
 	dma_ops = &gart_dma_ops;
 } 
 
-void gart_parse_options(char *p)
+void __init gart_parse_options(char *p)
 {
 	int arg;
 
diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
index f54f3ab..b6e65a6 100644
--- a/include/asm-x86_64/proto.h
+++ b/include/asm-x86_64/proto.h
@@ -99,7 +99,7 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef CONFIG_IOMMU
 extern void gart_iommu_init(void);
-extern void gart_parse_options(char *);
+extern void __init gart_parse_options(char *);
 extern void iommu_hole_init(void);
 extern int fallback_aper_order;
 extern int fallback_aper_force;
diff --git a/include/asm-x86_64/smp.h b/include/asm-x86_64/smp.h
index e17b9ec..de592a4 100644
--- a/include/asm-x86_64/smp.h
+++ b/include/asm-x86_64/smp.h
@@ -7,6 +7,7 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/bitops.h>
+#include <linux/init.h>
 extern int disable_apic;
 
 #include <asm/fixmap.h>
@@ -68,7 +69,7 @@ extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
 extern unsigned num_processors;
-extern unsigned disabled_cpus;
+extern unsigned __cpuinitdata disabled_cpus;
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
 
