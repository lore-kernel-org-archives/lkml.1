Return-Path: <linux-kernel-owner+w=401wt.eu-S966188AbXEKToh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966188AbXEKToh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763241AbXEKTlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:41:46 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45939 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763162AbXEKTln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:41:43 -0400
Message-ID: <4644C6F3.1050808@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:41:39 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/i386/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/i386/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/i386/boot/compressed/misc.c               |    4 ++--
 arch/i386/kernel/acpi/boot.c                   |    8 ++++----
 arch/i386/kernel/apic.c                        |    4 ++--
 arch/i386/kernel/apm.c                         |    2 +-
 arch/i386/kernel/cpu/amd.c                     |    2 +-
 arch/i386/kernel/cpu/centaur.c                 |    4 ++--
 arch/i386/kernel/cpu/common.c                  |    2 +-
 arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c |    2 +-
 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c      |    8 ++++----
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c     |    2 +-
 arch/i386/kernel/cpu/cpufreq/powernow-k8.h     |    4 ++--
 arch/i386/kernel/cpu/cyrix.c                   |    2 +-
 arch/i386/kernel/cpu/mtrr/cyrix.c              |    4 ++--
 arch/i386/kernel/cpu/mtrr/generic.c            |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c               |    2 +-
 arch/i386/kernel/e820.c                        |    2 +-
 arch/i386/kernel/hpet.c                        |    2 +-
 arch/i386/kernel/i8253.c                       |    2 +-
 arch/i386/kernel/io_apic.c                     |    4 ++--
 arch/i386/kernel/mpparse.c                     |    2 +-
 arch/i386/kernel/ptrace.c                      |    2 +-
 arch/i386/kernel/setup.c                       |    2 +-
 arch/i386/kernel/signal.c                      |    2 +-
 arch/i386/kernel/smp.c                         |    4 ++--
 arch/i386/kernel/smpboot.c                     |    2 +-
 arch/i386/kernel/summit.c                      |    2 +-
 arch/i386/kernel/tsc.c                         |    2 +-
 arch/i386/mach-default/setup.c                 |    2 +-
 arch/i386/mach-generic/default.c               |    2 +-
 arch/i386/mach-generic/probe.c                 |    2 +-
 arch/i386/mach-voyager/voyager_smp.c           |   12 ++++++------
 arch/i386/mach-voyager/voyager_thread.c        |    2 +-
 arch/i386/mm/boot_ioremap.c                    |    2 +-
 arch/i386/mm/discontig.c                       |    2 +-
 arch/i386/mm/fault.c                           |    4 ++--
 arch/i386/oprofile/op_x86_model.h              |    2 +-
 arch/i386/pci/irq.c                            |    4 ++--
 37 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/arch/i386/boot/compressed/misc.c b/arch/i386/boot/compressed/misc.c
index b28505c..1dc1e19 100644
--- a/arch/i386/boot/compressed/misc.c
+++ b/arch/i386/boot/compressed/misc.c
@@ -25,7 +25,7 @@
 
 /*
  * Getting to provable safe in place decompression is hard.
- * Worst case behaviours need to be analized.
+ * Worst case behaviours need to be analyzed.
  * Background information:
  *
  * The file layout is:
@@ -94,7 +94,7 @@
  * Adding 32768 instead of 32767 just makes for round numbers.
  * Adding the decompressor_size is necessary as it musht live after all
  * of the data as well.  Last I measured the decompressor is about 14K.
- * 10K of actuall data and 4K of bss.
+ * 10K of actual data and 4K of bss.
  *
  */
 
diff --git a/arch/i386/kernel/acpi/boot.c b/arch/i386/kernel/acpi/boot.c
index 280898b..fc2fc6f 100644
--- a/arch/i386/kernel/acpi/boot.c
+++ b/arch/i386/kernel/acpi/boot.c
@@ -99,7 +99,7 @@ static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
 /*
  * The default interrupt routing model is PIC (8259).  This gets
- * overriden if IOAPICs are enumerated (below).
+ * overridden if IOAPICs are enumerated (below).
  */
 enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
 
@@ -414,8 +414,8 @@ acpi_parse_nmi_src(struct acpi_subtable_header * header, const unsigned long end
  *
  * Port 0x4d0-4d1 are ECLR1 and ECLR2, the Edge/Level Control Registers
  * for the 8259 PIC.  bit[n] = 1 means irq[n] is Level, otherwise Edge.
- * ECLR1 is IRQ's 0-7 (IRQ 0, 1, 2 must be 0)
- * ECLR2 is IRQ's 8-15 (IRQ 8, 13 must be 0)
+ * ECLR1 is IRQs 0-7 (IRQ 0, 1, 2 must be 0)
+ * ECLR2 is IRQs 8-15 (IRQ 8, 13 must be 0)
  */
 
 void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
@@ -427,7 +427,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 	old = inb(0x4d0) | (inb(0x4d1) << 8);
 
 	/*
-	 * If we use ACPI to set PCI irq's, then we should clear ELCR
+	 * If we use ACPI to set PCI IRQs, then we should clear ELCR
 	 * since we will set it correctly as we enable the PCI irq
 	 * routing.
 	 */
diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 67824f3..d2896ca 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -943,7 +943,7 @@ void __devinit setup_local_APIC(void)
 	 * Set up LVT0, LVT1:
 	 *
 	 * set up through-local-APIC on the BP's LINT0. This is not
-	 * strictly necessery in pure symmetric-IO mode, but sometimes
+	 * strictly necessary in pure symmetric-IO mode, but sometimes
 	 * we delegate interrupts to the 8259A.
 	 */
 	/*
@@ -994,7 +994,7 @@ void __devinit setup_local_APIC(void)
 	} else {
 		if (esr_disable)
 			/*
-			 * Something untraceble is creating bad interrupts on
+			 * Something untraceable is creating bad interrupts on
 			 * secondary quads ... for the moment, just leave the
 			 * ESR disabled - we can't do anything useful with the
 			 * errors anyway - mbligh
diff --git a/arch/i386/kernel/apm.c b/arch/i386/kernel/apm.c
index 4112afe..6ab37d9 100644
--- a/arch/i386/kernel/apm.c
+++ b/arch/i386/kernel/apm.c
@@ -57,7 +57,7 @@
  *         screen-blanking and gpm (Stephen Rothwell); Linux 1.99.4
  *    1.2a:Simple change to stop mysterious bug reports with SMP also added
  *	   levels to the printk calls. APM is not defined for SMP machines.
- *         The new replacment for it is, but Linux doesn't yet support this.
+ *         The new replacement for it is, but Linux doesn't yet support this.
  *         Alan Cox Linux 2.1.55
  *    1.3: Set up a valid data descriptor 0x40 for buggy BIOS's
  *    1.4: Upgraded to support APM 1.2. Integrated ThinkPad suspend patch by
diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 4fec702..cb7f40c 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -255,7 +255,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_HT
 	/*
 	 * On a AMD multi core setup the lower bits of the APIC id
-	 * distingush the cores.
+	 * distinguish the cores.
 	 */
 	if (c->x86_max_cores > 1) {
 		int cpu = smp_processor_id();
diff --git a/arch/i386/kernel/cpu/centaur.c b/arch/i386/kernel/cpu/centaur.c
index 473eac8..9681fa1 100644
--- a/arch/i386/kernel/cpu/centaur.c
+++ b/arch/i386/kernel/cpu/centaur.c
@@ -53,7 +53,7 @@ static u32 __cpuinit ramtop(void)		/* 16388 */
 			continue;
 		/*
 		 *	Don't MCR over reserved space. Ignore the ISA hole
-		 *	we frob around that catastrophy already
+		 *	we frob around that catastrophe already
 		 */
 		 			
 		if (e820.map[i].type == E820_RESERVED)
@@ -287,7 +287,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		c->x86_capability[5] = cpuid_edx(0xC0000001);
 	}
 
-	/* Cyrix III family needs CX8 & PGE explicity enabled. */
+	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
 	if (c->x86_model >=6 && c->x86_model <= 9) {
 		rdmsr (MSR_VIA_FCR, lo, hi);
 		lo |= (1<<1 | 1<<7);
diff --git a/arch/i386/kernel/cpu/common.c b/arch/i386/kernel/cpu/common.c
index 794d593..a501fca 100644
--- a/arch/i386/kernel/cpu/common.c
+++ b/arch/i386/kernel/cpu/common.c
@@ -207,7 +207,7 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
 
 static int __init x86_fxsr_setup(char * s)
 {
-	/* Tell all the other CPU's to not use it... */
+	/* Tell all the other CPUs to not use it... */
 	disable_x86_fxsr = 1;
 
 	/*
diff --git a/arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c
index 0d49d73..6f1f3e2 100644
--- a/arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -260,7 +260,7 @@ static int nforce2_target(struct cpufreq_policy *policy,
 
 	freqs.old = nforce2_get(policy->cpu);
 	freqs.new = target_fsb * fid * 100;
-	freqs.cpu = 0;		/* Only one CPU on nForce2 plattforms */
+	freqs.cpu = 0;		/* Only one CPU on nForce2 platforms */
 
 	if (freqs.old == freqs.new)
 		return 0;
diff --git a/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c b/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
index 6667e9c..617a3a4 100644
--- a/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
+++ b/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
@@ -12,12 +12,12 @@
  *      of any nature resulting due to the use of this software. This
  *      software is provided AS-IS with no warranties.
  *
- * Theoritical note:
+ * Theoretical note:
  *
  *	(see Geode(tm) CS5530 manual (rev.4.1) page.56)
  *
  *	CPU frequency control on NatSemi Geode GX1/GXLV processor and CS55x0
- *	are based on Suspend Moduration.
+ *	are based on Suspend Modulation.
  *
  *	Suspend Modulation works by asserting and de-asserting the SUSP# pin
  *	to CPU(GX1/GXLV) for configurable durations. When asserting SUSP#
@@ -101,11 +101,11 @@
 
 /* SUSCFG bits */
 #define SUSMOD		(1<<0)	/* enable/disable suspend modulation */
-/* the belows support only with cs5530 (after rev.1.2)/cs5530A */
+/* the below is supported only with cs5530 (after rev.1.2)/cs5530A */
 #define SMISPDUP	(1<<1)	/* select how SMI re-enable suspend modulation: */
 				/* IRQTC timer or read SMI speedup disable reg.(F1BAR[08-09h]) */
 #define SUSCFG		(1<<2)	/* enable powering down a GXLV processor. "Special 3Volt Suspend" mode */
-/* the belows support only with cs5530A */
+/* the below is supported only with cs5530A */
 #define PWRSVE_ISA	(1<<3)	/* stop ISA clock  */
 #define PWRSVE		(1<<4)	/* active idle */
 
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
index 7cf3d20..8e2deea 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -165,7 +165,7 @@ static void count_off_irt(struct powernow_k8_data *data)
 	return;
 }
 
-/* the voltage stabalization time */
+/* the voltage stabilization time */
 static void count_off_vst(struct powernow_k8_data *data)
 {
 	udelay(data->vstable * VST_UNITS_20US);
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
index 95be501..72fbdc4 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
@@ -148,10 +148,10 @@ struct powernow_k8_data {
 #define PLL_LOCK_CONVERSION (1000/5) /* ms to ns, then divide by clock period */
 
 #define MAXIMUM_VID_STEPS 1  /* Current cpus only allow a single step of 25mV */
-#define VST_UNITS_20US 20   /* Voltage Stabalization Time is in units of 20us */
+#define VST_UNITS_20US 20   /* Voltage Stabilization Time is in units of 20us */
 
 /*
- * Most values of interest are enocoded in a single field of the _PSS
+ * Most values of interest are encoded in a single field of the _PSS
  * entries: the "control" value.
  */
 
diff --git a/arch/i386/kernel/cpu/cyrix.c b/arch/i386/kernel/cpu/cyrix.c
index 0b8411a..f1a52aa 100644
--- a/arch/i386/kernel/cpu/cyrix.c
+++ b/arch/i386/kernel/cpu/cyrix.c
@@ -255,7 +255,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		u32 vendor, device;
 		/* It isn't really a PCI quirk directly, but the cure is the
 		   same. The MediaGX has deep magic SMM stuff that handles the
-		   SB emulation. It thows away the fifo on disable_dma() which
+		   SB emulation. It throws away the fifo on disable_dma() which
 		   is wrong and ruins the audio. 
 
 		   Bug2: VSA1 has a wrap bug so that using maximum sized DMA 
diff --git a/arch/i386/kernel/cpu/mtrr/cyrix.c b/arch/i386/kernel/cpu/mtrr/cyrix.c
index 0737a59..d01f2cf 100644
--- a/arch/i386/kernel/cpu/mtrr/cyrix.c
+++ b/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -146,10 +146,10 @@ static void prepare_set(void)
 	write_cr0(cr0);
 	wbinvd();
 
-	/* Cyrix ARRs - everything else were excluded at the top */
+	/* Cyrix ARRs - everything else was excluded at the top */
 	ccr3 = getCx86(CX86_CCR3);
 
-	/* Cyrix ARRs - everything else were excluded at the top */
+	/* Cyrix ARRs - everything else was excluded at the top */
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);
 
 }
diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/i386/kernel/cpu/mtrr/generic.c
index 5367e32..2d27b55 100644
--- a/arch/i386/kernel/cpu/mtrr/generic.c
+++ b/arch/i386/kernel/cpu/mtrr/generic.c
@@ -181,7 +181,7 @@ static inline void k8_enable_fixed_iorrs(void)
 
 /**
  * Checks and updates an fixed-range MTRR if it differs from the value it
- * should have. If K8 extenstions are wanted, update the K8 SYSCFG MSR also.
+ * should have. If K8 extentions are wanted, update the K8 SYSCFG MSR also.
  * see AMD publication no. 24593, chapter 7.8.1, page 233 for more information
  * \param msr MSR address of the MTTR which should be checked and updated
  * \param changed pointer which indicates whether the MTRR needed to be changed
diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 02a2f39..f4f886b 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -747,7 +747,7 @@ static int __init mtrr_init_finialize(void)
 	if (use_intel())
 		mtrr_state_warn();
 	else {
-		/* The CPUs haven't MTRR and seemes not support SMP. They have
+		/* The CPUs haven't MTRR and seem to not support SMP. They have
 		 * specific drivers, we use a tricky method to support
 		 * suspend/resume for them.
 		 * TBD: is there any system with such CPU which supports
diff --git a/arch/i386/kernel/e820.c b/arch/i386/kernel/e820.c
index 9645bb5..464bc5c 100644
--- a/arch/i386/kernel/e820.c
+++ b/arch/i386/kernel/e820.c
@@ -673,7 +673,7 @@ void __init e820_register_memory(void)
 	int i;
 
 	/*
-	 * Search for the bigest gap in the low 32 bits of the e820
+	 * Search for the biggest gap in the low 32 bits of the e820
 	 * memory space.
 	 */
 	last = 0x100000000ull;
diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index 17d7345..91712f5 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -277,7 +277,7 @@ int __init hpet_enable(void)
 	 *
 	 * hpet period is in femto seconds per cycle
 	 * so we need to convert this to ns/cyc units
-	 * aproximated by mult/2^shift
+	 * approximated by mult/2^shift
 	 *
 	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
 	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
diff --git a/arch/i386/kernel/i8253.c b/arch/i386/kernel/i8253.c
index f8a3c40..9f3cba9 100644
--- a/arch/i386/kernel/i8253.c
+++ b/arch/i386/kernel/i8253.c
@@ -87,7 +87,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
  * On UP the PIT can serve all of the possible timer functions. On SMP systems
  * it can be solely used for the global tick.
  *
- * The profiling and update capabilites are switched off once the local apic is
+ * The profiling and update capabilities are switched off once the local apic is
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 7f8b7af..5c72bca 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -600,7 +600,7 @@ tryanotherirq:
 
 	imbalance = move_this_load;
 	
-	/* For physical_balance case, we accumlated both load
+	/* For physical_balance case, we accumulated both load
 	 * values in the one of the siblings cpu_irq[],
 	 * to use the same code for physical and logical processors
 	 * as much as possible. 
@@ -2491,7 +2491,7 @@ void destroy_irq(unsigned int irq)
 }
 
 /*
- * MSI mesage composition
+ * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
diff --git a/arch/i386/kernel/mpparse.c b/arch/i386/kernel/mpparse.c
index 13abb4e..7a05a7f 100644
--- a/arch/i386/kernel/mpparse.c
+++ b/arch/i386/kernel/mpparse.c
@@ -1001,7 +1001,7 @@ void __init mp_config_acpi_legacy_irqs (void)
 
 	/* 
 	 * Use the default configuration for the IRQs 0-15.  Unless
-	 * overriden by (MADT) interrupt source override entries.
+	 * overridden by (MADT) interrupt source override entries.
 	 */
 	for (i = 0; i < 16; i++) {
 		int idx;
diff --git a/arch/i386/kernel/ptrace.c b/arch/i386/kernel/ptrace.c
index 0c0ceec..4f0550f 100644
--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -642,7 +642,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
 	/* User-mode eip? */
 	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->eip : NULL;
 
-	/* Send us the fakey SIGTRAP */
+	/* Send us the fake SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 698c24f..1b5f3eb 100644
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -592,7 +592,7 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * NOTE: before this point _nobody_ is allowed to allocate
 	 * any memory using the bootmem allocator.  Although the
-	 * alloctor is now initialised only the first 8Mb of the kernel
+	 * allocator is now initialised only the first 8Mb of the kernel
 	 * virtual address space has been mapped.  All allocations before
 	 * paging_init() has completed must use the alloc_bootmem_low_pages()
 	 * variant (which allocates DMA'able memory) and care must be taken
diff --git a/arch/i386/kernel/signal.c b/arch/i386/kernel/signal.c
index d574e38..f6d4763 100644
--- a/arch/i386/kernel/signal.c
+++ b/arch/i386/kernel/signal.c
@@ -591,7 +591,7 @@ static void fastcall do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Reenable any watchpoints before delivering the
+		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
 		 * inside the kernel.
diff --git a/arch/i386/kernel/smp.c b/arch/i386/kernel/smp.c
index 93f202a..34db9f1 100644
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -68,7 +68,7 @@
  *
  *		B stepping CPUs may hang. There are hardware work arounds
  *	for this. We warn about it in case your board doesn't have the work
- *	arounds. Basically thats so I can tell anyone with a B stepping
+ *	arounds. Basically that's so I can tell anyone with a B stepping
  *	CPU and SMP problems "tough".
  *
  *	Specific items [From Pentium Processor Specification Update]
@@ -272,7 +272,7 @@ static inline void leave_mm (unsigned long cpu)
  * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
  * 	Stop ipi delivery for the old mm. This is not synchronized with
  * 	the other cpus, but smp_invalidate_interrupt ignore flush ipis
- * 	for the wrong mm, and in the worst case we perform a superflous
+ * 	for the wrong mm, and in the worst case we perform a superfluous
  * 	tlb flush.
  * 1a2) set cpu_tlbstate to TLBSTATE_OK
  * 	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
diff --git a/arch/i386/kernel/smpboot.c b/arch/i386/kernel/smpboot.c
index b92cc4e..4d2707c 100644
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -416,7 +416,7 @@ static void __cpuinit start_secondary(void *unused)
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
-	 * IPI receipients, and the time when the determination is made
+	 * IPI recipients, and the time when the determination is made
 	 * for which cpus receive the IPI. Holding this
 	 * lock helps us to not include this cpu in a currently in progress
 	 * smp_call_function().
diff --git a/arch/i386/kernel/summit.c b/arch/i386/kernel/summit.c
index d0e01a3..9244a4b 100644
--- a/arch/i386/kernel/summit.c
+++ b/arch/i386/kernel/summit.c
@@ -64,7 +64,7 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 
 	switch (rio_devs[wpeg_num]->type){
 	case CompatWPEG:
-		/* The Compatability Winnipeg controls the 2 legacy buses,
+		/* The Compatibility Winnipeg controls the 2 legacy buses,
 		 * the 66MHz PCI bus [2 slots] and the 2 "extra" buses in case
 		 * a PCI-PCI bridge card is used in either slot: total 5 buses.
 		 */
diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index f64b81f..b4ab389 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -62,7 +62,7 @@ static inline int check_tsc_unstable(void)
 	return tsc_unstable;
 }
 
-/* Accellerators for sched_clock()
+/* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
  *		ns = cycles / (freq / ns_per_sec)
diff --git a/arch/i386/mach-default/setup.c b/arch/i386/mach-default/setup.c
index 7f635c7..4463f1e 100644
--- a/arch/i386/mach-default/setup.c
+++ b/arch/i386/mach-default/setup.c
@@ -104,7 +104,7 @@ void __init time_init_hook(void)
  * mca_nmi_hook - hook into MCA specific NMI chain
  *
  * Description:
- *	The MCA (Microchannel Arcitecture) has an NMI chain for NMI sources
+ *	The MCA (Microchannel Architecture) has an NMI chain for NMI sources
  *	along the MCA bus.  Use this to hook into that chain if you will need
  *	it.
  **/
diff --git a/arch/i386/mach-generic/default.c b/arch/i386/mach-generic/default.c
index 8685208..1af0cc7 100644
--- a/arch/i386/mach-generic/default.c
+++ b/arch/i386/mach-generic/default.c
@@ -1,5 +1,5 @@
 /* 
- * Default generic APIC driver. This handles upto 8 CPUs.
+ * Default generic APIC driver. This handles up to 8 CPUs.
  */
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
diff --git a/arch/i386/mach-generic/probe.c b/arch/i386/mach-generic/probe.c
index 74f3da6..026a621 100644
--- a/arch/i386/mach-generic/probe.c
+++ b/arch/i386/mach-generic/probe.c
@@ -56,7 +56,7 @@ void __init generic_bigsmp_probe(void)
 	/*
 	 * This routine is used to switch to bigsmp mode when
 	 * - There is no apic= option specified by the user
-	 * - generic_apic_probe() has choosen apic_default as the sub_arch
+	 * - generic_apic_probe() has chosen apic_default as the sub_arch
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
diff --git a/arch/i386/mach-voyager/voyager_smp.c b/arch/i386/mach-voyager/voyager_smp.c
index 50d9c52..88e2d51 100644
--- a/arch/i386/mach-voyager/voyager_smp.c
+++ b/arch/i386/mach-voyager/voyager_smp.c
@@ -390,7 +390,7 @@ find_smp_config(void)
 
 	/* The boot CPU must be extended */
 	voyager_extended_vic_processors = 1<<boot_cpu_id;
-	/* initially, all of the first 8 cpu's can boot */
+	/* initially, all of the first 8 CPUs can boot */
 	voyager_allowed_boot_processors = 0xff;
 	/* set up everything for just this CPU, we can alter
 	 * this as we start the other CPUs later */
@@ -1009,7 +1009,7 @@ static struct call_data_struct * call_data;
 
 /* execute a thread on a new CPU.  The function to be called must be
  * previously set up.  This is used to schedule a function for
- * execution on all CPU's - set up the function then broadcast a
+ * execution on all CPUs - set up the function then broadcast a
  * function_interrupt CPI to come here on each CPU */
 static void
 smp_call_function_interrupt(void)
@@ -1132,7 +1132,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * CPI here.  We don't use this actually for counting so losing
  * ticks doesn't matter 
  *
- * FIXME: For those CPU's which actually have a local APIC, we could
+ * FIXME: For those CPUs which actually have a local APIC, we could
  * try to use it to trigger this interrupt instead of having to
  * broadcast the timer tick.  Unfortunately, all my pentium DYADs have
  * no local APIC, so I can't do this
@@ -1324,7 +1324,7 @@ smp_local_timer_interrupt(void)
 
 	/*
 	 * We take the 'long' return path, and there every subsystem
-	 * grabs the apropriate locks (kernel lock/ irq lock).
+	 * grabs the appropriate locks (kernel lock/ irq lock).
 	 *
 	 * we might want to decouple profiling from the 'long path',
 	 * and do the profiling totally in assembly.
@@ -1796,7 +1796,7 @@ set_vic_irq_affinity(unsigned int irq, cpumask_t mask)
 	real_mask = cpus_addr(mask)[0] & voyager_extended_vic_processors;
 	
 	if(cpus_addr(mask)[0] == 0)
-		/* can't have no cpu's to accept the interrupt -- extremely
+		/* can't have no CPUs to accept the interrupt -- extremely
 		 * bad things will happen */
 		return;
 
@@ -1828,7 +1828,7 @@ set_vic_irq_affinity(unsigned int irq, cpumask_t mask)
 	}
 	/* this is magic, we now have the correct affinity maps, so
 	 * enable the interrupt.  This will send an enable CPI to
-	 * those cpu's who need to enable it in their local masks,
+	 * those CPUs who need to enable it in their local masks,
 	 * causing them to correct for the new affinity . If the
 	 * interrupt is currently globally disabled, it will simply be
 	 * disabled again as it comes in (voyager lazy disable).  If
diff --git a/arch/i386/mach-voyager/voyager_thread.c b/arch/i386/mach-voyager/voyager_thread.c
index b4b24e0..95a5868 100644
--- a/arch/i386/mach-voyager/voyager_thread.c
+++ b/arch/i386/mach-voyager/voyager_thread.c
@@ -64,7 +64,7 @@ check_from_kernel(void)
 {
 	if(voyager_status.switch_off) {
 		
-		/* FIXME: This should be configureable via proc */
+		/* FIXME: This should be configurable via proc */
 		execute("umask 600; echo 0 > /etc/initrunlvl; kill -HUP 1");
 	} else if(voyager_status.power_fail) {
 		VDEBUG(("Voyager daemon detected AC power failure\n"));
diff --git a/arch/i386/mm/boot_ioremap.c b/arch/i386/mm/boot_ioremap.c
index 4de95a1..f14da2a 100644
--- a/arch/i386/mm/boot_ioremap.c
+++ b/arch/i386/mm/boot_ioremap.c
@@ -10,7 +10,7 @@
 
 /*
  * We need to use the 2-level pagetable functions, but CONFIG_X86_PAE
- * keeps that from happenning.  If anyone has a better way, I'm listening.
+ * keeps that from happening.  If anyone has a better way, I'm listening.
  *
  * boot_pte_t is defined only if this all works correctly
  */
diff --git a/arch/i386/mm/discontig.c b/arch/i386/mm/discontig.c
index aa58720..43d5032 100644
--- a/arch/i386/mm/discontig.c
+++ b/arch/i386/mm/discontig.c
@@ -278,7 +278,7 @@ unsigned long __init setup_memory(void)
 	 * When mapping a NUMA machine we allocate the node_mem_map arrays
 	 * from node local memory.  They are then mapped directly into KVA
 	 * between zone normal and vmalloc space.  Calculate the size of
-	 * this space and use it to adjust the boundry between ZONE_NORMAL
+	 * this space and use it to adjust the boundary between ZONE_NORMAL
 	 * and ZONE_HIGHMEM.
 	 */
 	find_max_pfn();
diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index 29d7d61..45683e7 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -355,7 +355,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
-	 * kernel and should generate an OOPS.  Unfortunatly, in the case of an
+	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
 	 * erroneous fault occurring in a code path which already holds mmap_sem
 	 * we will deadlock attempting to validate the fault against the
 	 * address space.  Luckily the kernel only validly references user
@@ -363,7 +363,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	 * exceptions table.
 	 *
 	 * As the vast majority of faults will be valid we will only perform
-	 * the source reference check when there is a possibilty of a deadlock.
+	 * the source reference check when there is a possibility of a deadlock.
 	 * Attempt to lock the address space, if we cannot we then validate the
 	 * source.  If this is invalid we can skip the address space check,
 	 * thus avoiding the deadlock.
diff --git a/arch/i386/oprofile/op_x86_model.h b/arch/i386/oprofile/op_x86_model.h
index abb1aa9..45b605f 100644
--- a/arch/i386/oprofile/op_x86_model.h
+++ b/arch/i386/oprofile/op_x86_model.h
@@ -29,7 +29,7 @@ struct op_msrs {
 struct pt_regs;
 
 /* The model vtable abstracts the differences between
- * various x86 CPU model's perfctr support.
+ * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
 	unsigned int const num_counters;
diff --git a/arch/i386/pci/irq.c b/arch/i386/pci/irq.c
index f2cb942..92cd18e 100644
--- a/arch/i386/pci/irq.c
+++ b/arch/i386/pci/irq.c
@@ -168,7 +168,7 @@ void eisa_set_level_irq(unsigned int irq)
 }
 
 /*
- * Common IRQ routing practice: nybbles in config space,
+ * Common IRQ routing practice: nibbles in config space,
  * offset by some magic constant.
  */
 static unsigned int read_config_nybble(struct pci_dev *router, unsigned offset, unsigned nr)
@@ -563,7 +563,7 @@ static __init int via_router_probe(struct irq_router *r,
 	/* FIXME: We should move some of the quirk fixup stuff here */
 
 	/*
-	 * work arounds for some buggy BIOSes
+	 * workarounds for some buggy BIOSes
 	 */
 	if (device == PCI_DEVICE_ID_VIA_82C586_0) {
 		switch(router->device) {
-- 
1.5.0.1

-- 
Simon Arlott
