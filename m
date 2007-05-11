Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXEKTrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXEKTrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933506AbXEKTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:42:53 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45963 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761342AbXEKTmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:42:50 -0400
Message-ID: <4644C734.3000303@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:42:44 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/powerpc/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/powerpc/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/powerpc/boot/treeboot-ebony.c              |    2 +-
 arch/powerpc/kernel/irq.c                       |    8 ++++----
 arch/powerpc/kernel/legacy_serial.c             |    2 +-
 arch/powerpc/kernel/nvram_64.c                  |    2 +-
 arch/powerpc/kernel/of_platform.c               |    8 ++++----
 arch/powerpc/kernel/prom.c                      |    6 +++---
 arch/powerpc/kernel/rtas-proc.c                 |    2 +-
 arch/powerpc/kernel/rtas.c                      |    2 +-
 arch/powerpc/kernel/setup_64.c                  |    8 ++++----
 arch/powerpc/kernel/signal_32.c                 |    2 +-
 arch/powerpc/kernel/signal_64.c                 |    2 +-
 arch/powerpc/kernel/traps.c                     |    4 ++--
 arch/powerpc/kernel/udbg_16550.c                |    2 +-
 arch/powerpc/math-emu/op-common.h               |    2 +-
 arch/powerpc/math-emu/sfp-machine.h             |    4 ++--
 arch/powerpc/mm/hugetlbpage.c                   |    2 +-
 arch/powerpc/mm/numa.c                          |    2 +-
 arch/powerpc/oprofile/op_model_7450.c           |    4 ++--
 arch/powerpc/oprofile/op_model_cell.c           |    8 ++++----
 arch/powerpc/oprofile/op_model_fsl_booke.c      |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_common.c    |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c       |    4 ++--
 arch/powerpc/platforms/52xx/mpc52xx_pm.c        |    2 +-
 arch/powerpc/platforms/cell/spider-pic.c        |   12 ++++++------
 arch/powerpc/platforms/cell/spufs/lscsa_alloc.c |    2 +-
 arch/powerpc/platforms/cell/spufs/spu_restore.c |    2 +-
 arch/powerpc/platforms/cell/spufs/switch.c      |    4 ++--
 arch/powerpc/platforms/celleb/pci.c             |    4 ++--
 arch/powerpc/platforms/celleb/scc_epci.c        |    6 +++---
 arch/powerpc/platforms/celleb/scc_uhc.c         |    2 +-
 arch/powerpc/platforms/powermac/feature.c       |    4 ++--
 arch/powerpc/platforms/powermac/pfunc_base.c    |    2 +-
 arch/powerpc/platforms/powermac/setup.c         |    4 ++--
 arch/powerpc/platforms/ps3/interrupt.c          |    2 +-
 arch/powerpc/platforms/ps3/mm.c                 |    6 +++---
 arch/powerpc/platforms/ps3/os-area.c            |    4 ++--
 arch/powerpc/platforms/ps3/platform.h           |    4 ++--
 arch/powerpc/platforms/pseries/eeh.c            |    4 ++--
 arch/powerpc/platforms/pseries/eeh_driver.c     |    2 +-
 arch/powerpc/sysdev/commproc.c                  |    2 +-
 arch/powerpc/sysdev/dart_iommu.c                |    2 +-
 arch/powerpc/sysdev/mpic.c                      |    2 +-
 42 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/arch/powerpc/boot/treeboot-ebony.c b/arch/powerpc/boot/treeboot-ebony.c
index 8436a9c..1e3d24e 100644
--- a/arch/powerpc/boot/treeboot-ebony.c
+++ b/arch/powerpc/boot/treeboot-ebony.c
@@ -3,7 +3,7 @@
  *
  * Author: David Gibson <david@gibson.dropbear.id.au>
  *
- * Copyright 2007 David Gibson, IBM Corporatio.
+ * Copyright 2007 David Gibson, IBM Corporation.
  *   Based on cuboot-83xx.c, which is:
  * Copyright (c) 2007 Freescale Semiconductor, Inc.
  *
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 9ed4931..861a288 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -15,7 +15,7 @@
  * 2 of the License, or (at your option) any later version.
  *
  * This file contains the code used by various IRQ handling routines:
- * asking for different IRQ's should be done through these routines
+ * asking for different IRQs should be done through these routines
  * instead of just grabbing them. Thus setups with different IRQ numbers
  * shouldn't result in any weird surprises, and installing new handlers
  * should be easier.
@@ -481,7 +481,7 @@ struct irq_host *irq_alloc_host(unsigned int revmap_type,
 
 			/* Legacy flags are left to default at this point,
 			 * one can then use irq_create_mapping() to
-			 * explicitely change them
+			 * explicitly change them
 			 */
 			ops->map(host, i, i);
 		}
@@ -599,7 +599,7 @@ unsigned int irq_create_mapping(struct irq_host *host,
 
 	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", host, hwirq);
 
-	/* Look for default host if nececssary */
+	/* Look for default host if necessary */
 	if (host == NULL)
 		host = irq_default_host;
 	if (host == NULL) {
@@ -771,7 +771,7 @@ unsigned int irq_find_mapping(struct irq_host *host,
 	unsigned int i;
 	unsigned int hint = hwirq % irq_virq_count;
 
-	/* Look for default host if nececssary */
+	/* Look for default host if necessary */
 	if (host == NULL)
 		host = irq_default_host;
 	if (host == NULL)
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index cea8045..8653b33 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -498,7 +498,7 @@ arch_initcall(serial_dev_init);
 
 /*
  * This is called very early, as part of console_init() (typically just after
- * time_init()). This function is respondible for trying to find a good
+ * time_init()). This function is responsible for trying to find a good
  * default console on serial ports. It tries to match the open firmware
  * default output with one of the available serial console drivers, either
  * one of the platform serial ports that have been probed earlier by
diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index f9676f5..dd3de45 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -431,7 +431,7 @@ static int nvram_create_os_partition(void)
  * 4.) Will first try getting a chunk that will satisfy the maximum
  * error log size (NVRAM_MAX_REQ).
  * 5.) If the max chunk cannot be allocated then try finding a chunk
- * that will satisfy the minum needed (NVRAM_MIN_REQ).
+ * that will satisfy the minimum needed (NVRAM_MIN_REQ).
  */
 static int nvram_setup_partition(void)
 {
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 84c34d9..2279a6f 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -259,8 +259,8 @@ EXPORT_SYMBOL(of_platform_device_create);
 
 /**
  * of_platform_bus_create - Create an OF device for a bus node and all its
- * children. Optionally recursively instanciate matching busses.
- * @bus: device node of the bus to instanciate
+ * children. Optionally recursively instantiate matching busses.
+ * @bus: device node of the bus to instantiate
  * @matches: match table, NULL to use the default, OF_NO_DEEP_PROBE to
  * disallow recursive creation of child busses
  */
@@ -296,7 +296,7 @@ static int of_platform_bus_create(struct device_node *bus,
  * @matches: match table, NULL to use the default
  * @parent: parent to hook devices from, NULL for toplevel
  *
- * Note that children of the provided root are not instanciated as devices
+ * Note that children of the provided root are not instantiated as devices
  * unless the specified root itself matches the bus list and is not NULL.
  */
 
@@ -429,7 +429,7 @@ static int __devinit of_pci_phb_probe(struct of_device *dev,
 
 	/* Setup IO space.
 	 * This will not work properly for ISA IOs, something needs to be done
-	 * about it if we ever generalize that way of probing PCI brigdes
+	 * about it if we ever generalize that way of probing PCI bridges
 	 */
 	pci_setup_phb_io_dynamic(phb, 0);
 
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index caef555..def6585 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -95,7 +95,7 @@ static inline char *find_flat_dt_string(u32 offset)
 
 /**
  * This function is used to scan the flattened device-tree, it is
- * used to extract the memory informations at boot before we can
+ * used to extract the memory information at boot before we can
  * unflatten the tree
  */
 int __init of_scan_flat_dt(int (*it)(unsigned long node,
@@ -1000,7 +1000,7 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_rtas, NULL);
 #endif
 
-	/* Retrieve various informations from the /chosen node of the
+	/* Retrieve various information from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
@@ -1032,7 +1032,7 @@ void __init early_init_devtree(void *params)
 
 	DBG("Scanning CPUs ...\n");
 
-	/* Retreive CPU related informations from the flat tree
+	/* Retreive CPU related information from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
 	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
diff --git a/arch/powerpc/kernel/rtas-proc.c b/arch/powerpc/kernel/rtas-proc.c
index 190b7ed..41d0dfe 100644
--- a/arch/powerpc/kernel/rtas-proc.c
+++ b/arch/powerpc/kernel/rtas-proc.c
@@ -717,7 +717,7 @@ static void check_location(struct seq_file *m, const char *c)
 /* 
  * Format: 
  * ${LETTER}${NUMBER}[[-/]${LETTER}${NUMBER} [ ... ] ]
- * the '.' may be an abbrevation
+ * the '.' may be an abbreviation
  */
 static void check_location_string(struct seq_file *m, const char *c)
 {
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 2147807..54b9e2a 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -819,7 +819,7 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 
 /*
  * Call early during boot, before mem init or bootmem, to retrieve the RTAS
- * informations from the device-tree and allocate the RMO buffer for userland
+ * information from the device-tree and allocate the RMO buffer for userland
  * accesses.
  */
 void __init rtas_initialize(void)
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 6018178..fce0e0c 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -271,7 +271,7 @@ void smp_release_cpus(void)
  * Initialize some remaining members of the ppc64_caches and systemcfg
  * structures
  * (at least until we get rid of them completely). This is mostly some
- * cache informations about the CPU that will be used by cache flush
+ * cache information about the CPU that will be used by cache flush
  * routines and/or provided to userland
  */
 static void __init initialize_cache_info(void)
@@ -293,7 +293,7 @@ static void __init initialize_cache_info(void)
 			u32 size, lsize;
 			const char *dc, *ic;
 
-			/* Then read cache informations */
+			/* Then read cache information */
 			if (machine_is(powermac)) {
 				dc = "d-cache-block-size";
 				ic = "i-cache-block-size";
@@ -364,7 +364,7 @@ void __init setup_system(void)
 	unflatten_device_tree();
 
 	/*
-	 * Fill the ppc64_caches & systemcfg structures with informations
+	 * Fill the ppc64_caches & systemcfg structures with information
  	 * retrieved from the device-tree.
 	 */
 	initialize_cache_info();
@@ -489,7 +489,7 @@ static void __init emergency_stack_init(void)
 
 /*
  * Called into from start_kernel, after lock_kernel has been called.
- * Initializes bootmem, which is unsed to manage page allocation until
+ * Initializes bootmem, which is used to manage page allocation until
  * mem_init is called.
  */
 void __init setup_arch(char **cmdline_p)
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index dd1dca5..1f05b2e 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1199,7 +1199,7 @@ no_signal:
 
 #ifdef CONFIG_PPC64
 	/*
-	 * Reenable the DABR before delivering the signal to
+	 * Re-enable the DABR before delivering the signal to
 	 * user space. The DABR will have been cleared if it
 	 * triggered inside the kernel.
 	 */
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 1ce0ae3..9b0c38f 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -530,7 +530,7 @@ int do_signal(sigset_t *oldset, struct pt_regs *regs)
 			syscall_restart(regs, &ka);
 
 		/*
-		 * Reenable the DABR before delivering the signal to
+		 * Re-enable the DABR before delivering the signal to
 		 * user space. The DABR will have been cleared if it
 		 * triggered inside the kernel.
 		 */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index bf6445a..e6e71df 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -794,7 +794,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	 * ESR_DST (!?) or 0.  In the process of chasing this with the
 	 * hardware people - not sure if it can happen on any illegal
 	 * instruction or only on FP instructions, whether there is a
-	 * pattern to occurences etc. -dgibson 31/Mar/2003 */
+	 * pattern to occurrences etc. -dgibson 31/Mar/2003 */
 	switch (do_mathemu(regs)) {
 	case 0:
 		emulate_single_step(regs);
@@ -1048,7 +1048,7 @@ void SPEFloatingPointException(struct pt_regs *regs)
 	spefscr = current->thread.spefscr;
 	fpexc_mode = current->thread.fpexc_mode;
 
-	/* Hardware does not neccessarily set sticky
+	/* Hardware does not necessarily set sticky
 	 * underflow/overflow/invalid flags */
 	if ((spefscr & SPEFSCR_FOVF) && (fpexc_mode & PR_FP_EXC_OVF)) {
 		code = FPE_FLTOVF;
diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
index 7afab5b..d0bbd95 100644
--- a/arch/powerpc/kernel/udbg_16550.c
+++ b/arch/powerpc/kernel/udbg_16550.c
@@ -1,5 +1,5 @@
 /*
- * udbg for for NS16550 compatable serial ports
+ * udbg for for NS16550 compatible serial ports
  *
  * Copyright (C) 2001-2005 PPC 64 Team, IBM Corp
  *
diff --git a/arch/powerpc/math-emu/op-common.h b/arch/powerpc/math-emu/op-common.h
index afb82b6..ac93fec 100644
--- a/arch/powerpc/math-emu/op-common.h
+++ b/arch/powerpc/math-emu/op-common.h
@@ -3,7 +3,7 @@
   _FP_FRAC_DECL_##wc(X)
 
 /*
- * Finish truely unpacking a native fp value by classifying the kind
+ * Finish truly unpacking a native fp value by classifying the kind
  * of fp value and normalizing both the exponent and the fraction.
  */
 
diff --git a/arch/powerpc/math-emu/sfp-machine.h b/arch/powerpc/math-emu/sfp-machine.h
index 4b17d83..fe7bb33 100644
--- a/arch/powerpc/math-emu/sfp-machine.h
+++ b/arch/powerpc/math-emu/sfp-machine.h
@@ -290,8 +290,8 @@ extern int  fp_pack_ds(void *, long, unsigned long, unsigned long, long, long);
 
 /* asm fragments for mul and div */
 
-/* umul_ppmm(high_prod, low_prod, multipler, multiplicand) multiplies two
- * UWtype integers MULTIPLER and MULTIPLICAND, and generates a two UWtype
+/* umul_ppmm(high_prod, low_prod, multiplier, multiplicand) multiplies two
+ * UWtype integers MULTIPLIER and MULTIPLICAND, and generates a two UWtype
  * word product in HIGH_PROD and LOW_PROD.
  */
 #define umul_ppmm(ph, pl, m0, m1)					\
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 92a1b16..98cc17b 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -482,7 +482,7 @@ repeat:
 		hpte_group = ((hash & htab_hash_mask) *
 			      HPTES_PER_GROUP) & ~0x7UL;
 
-		/* clear HPTE slot informations in new PTE */
+		/* clear HPTE slot information in new PTE */
 		new_pte = (new_pte & ~_PAGE_HPTEFLAGS) | _PAGE_HASHPTE;
 
 		/* Add in WIMG bits */
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index de45aa8..26875e0 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -275,7 +275,7 @@ static int __cpuinit cpu_numa_callback(struct notifier_block *nfb,
  * Returns the size the region should have to enforce the memory limit.
  * This will either be the original value of size, a truncated value,
  * or zero. If the returned value of size is 0 the region should be
- * discarded as it lies wholy above the memory limit.
+ * discarded as it lies wholly above the memory limit.
  */
 static unsigned long __init numa_enforce_memory_limit(unsigned long start,
 						      unsigned long size)
diff --git a/arch/powerpc/oprofile/op_model_7450.c b/arch/powerpc/oprofile/op_model_7450.c
index 5d1bbaf..d75063b 100644
--- a/arch/powerpc/oprofile/op_model_7450.c
+++ b/arch/powerpc/oprofile/op_model_7450.c
@@ -93,7 +93,7 @@ static void fsl7450_cpu_setup(struct op_counter_config *ctr)
 
 #define NUM_CTRS 6
 
-/* Configures the global settings for the countes on all CPUs. */
+/* Configures the global settings for the counters on all CPUs. */
 static void fsl7450_reg_setup(struct op_counter_config *ctr,
 			     struct op_system_config *sys,
 			     int num_ctrs)
@@ -191,7 +191,7 @@ static void fsl7450_handle_interrupt(struct pt_regs *regs,
 	}
 
 	/* The freeze bit was set by the interrupt. */
-	/* Clear the freeze bit, and reenable the interrupt.
+	/* Clear the freeze bit, and re-enable the interrupt.
 	 * The counters won't actually start until the rfi clears
 	 * the PMM bit */
 	pmc_start_ctrs();
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index c29293b..d94388c 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -112,7 +112,7 @@ static DEFINE_PER_CPU(unsigned long[NR_PHYS_CTRS], pmc_values);
 
 static struct pmc_cntrl_data pmc_cntrl[NUM_THREADS][NR_PHYS_CTRS];
 
-/* Interpetation of hdw_thread:
+/* Interpretation of hdw_thread:
  * 0 - even virtual cpus 0, 2, 4,...
  * 1 - odd virtual cpus 1, 3, 5, ...
  */
@@ -189,7 +189,7 @@ static void pm_rtas_activate_signals(u32 node, u32 count)
 	/* There is no debug setup required for the cycles event.
 	 * Note that only events in the same group can be used.
 	 * Otherwise, there will be conflicts in correctly routing
-	 * the signals on the debug bus.  It is the responsiblity
+	 * the signals on the debug bus.  It is the responsibility
 	 * of the OProfile user tool to check the events are in
 	 * the same group.
 	 */
@@ -705,7 +705,7 @@ cell_handle_interrupt(struct pt_regs *regs, struct op_counter_config *ctr)
 	 */
 	spin_lock_irqsave(&virt_cntr_lock, flags);
 
-	/* Need to disable and reenable the performance counters
+	/* Need to disable and re-enable the performance counters
 	 * to get the desired behavior from the hardware.  This
 	 * is hardware specific.
 	 */
@@ -733,7 +733,7 @@ cell_handle_interrupt(struct pt_regs *regs, struct op_counter_config *ctr)
 		}
 
 		/* The counters were frozen by the interrupt.
-		 * Reenable the interrupt and restart the counters.
+		 * Re-enable the interrupt and restart the counters.
 		 * If there was a race between the interrupt handler and
 		 * the virtual counter routine.  The virutal counter
 		 * routine may have cleared the interrupts.  Hence must
diff --git a/arch/powerpc/oprofile/op_model_fsl_booke.c b/arch/powerpc/oprofile/op_model_fsl_booke.c
index 2267eb8..d2e1c39 100644
--- a/arch/powerpc/oprofile/op_model_fsl_booke.c
+++ b/arch/powerpc/oprofile/op_model_fsl_booke.c
@@ -351,7 +351,7 @@ static void fsl_booke_handle_interrupt(struct pt_regs *regs,
 	}
 
 	/* The freeze bit was set by the interrupt. */
-	/* Clear the freeze bit, and reenable the interrupt.
+	/* Clear the freeze bit, and re-enable the interrupt.
 	 * The counters won't actually start until the rfi clears
 	 * the PMM bit */
 	pmc_start_ctrs(1);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_common.c b/arch/powerpc/platforms/52xx/mpc52xx_common.c
index 2dd415f..5ba3425 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_common.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_common.c
@@ -106,7 +106,7 @@ mpc52xx_setup_cpu(void)
 	out_be32(&xlb->master_priority, 0x11111111);
 
 	/* Disable XLB pipelining */
-	/* (cfr errate 292. We could do this only just before ATA PIO
+	/* (cfr errata 292. We could do this only just before ATA PIO
 	    transaction and re-enable it afterwards ...) */
 	out_be32(&xlb->config, in_be32(&xlb->config) | MPC52xx_XLB_CFG_PLDIS);
 
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index 34d34a2..a7eebeb 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -101,7 +101,7 @@ struct mpc52xx_pci {
 
 
 /* ======================================================================== */
-/* PCI configuration acess                                                  */
+/* PCI configuration access                                                 */
 /* ======================================================================== */
 
 static int
@@ -311,7 +311,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 
 	tmp = in_be32(&pci_regs->gscr);
 #if 0
-	/* Reset the exteral bus ( internal PCI controller is NOT resetted ) */
+	/* Reset the exteral bus ( internal PCI controller is NOT reset ) */
 	/* Not necessary and can be a bad thing if for example the bootloader
 	   is displaying a splash screen or ... Just left here for
 	   documentation purpose if anyone need it */
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pm.c b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
index fd40044..f3c5d87 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -160,7 +160,7 @@ int mpc52xx_pm_enter(suspend_state_t state)
 	/* restart jiffies */
 	wakeup_decrementer();
 
-	/* reenable interrupts in PIC */
+	/* re-enable interrupts in PIC */
 	out_be32(&intr->main_mask, intr_main_mask);
 
 	return 0;
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 05f4b3d..6365428 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -228,13 +228,13 @@ static void spider_irq_cascade(unsigned int irq, struct irq_desc *desc)
 	desc->chip->eoi(irq);
 }
 
-/* For hooking up the cascace we have a problem. Our device-tree is
+/* For hooking up the cascade we have a problem. Our device-tree is
  * crap and we don't know on which BE iic interrupt we are hooked on at
  * least not the "standard" way. We can reconstitute it based on two
- * informations though: which BE node we are connected to and wether
- * we are connected to IOIF0 or IOIF1. Right now, we really only care
- * about the IBM cell blade and we know that its firmware gives us an
- * interrupt-map property which is pretty strange.
+ * pieces of information though: which BE node we are connected to and 
+ * whether we are connected to IOIF0 or IOIF1. Right now, we really only 
+ * care about the IBM cell blade and we know that its firmware gives us 
+ * an interrupt-map property which is pretty strange.
  */
 static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 {
@@ -283,7 +283,7 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 
 	/* Ok, now let's get cracking. You may ask me why I just didn't match
 	 * the iic host from the iic OF node, but that way I'm still compatible
-	 * with really really old old firmwares for which we don't have a node
+	 * with really really old old firmware for which we don't have a node
 	 */
 	/* Manufacture an IIC interrupt number of class 2 */
 	virq = irq_create_mapping(NULL,
diff --git a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
index f4b3c05..90963c1 100644
--- a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
+++ b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
@@ -88,7 +88,7 @@ int spu_alloc_lscsa(struct spu_state *csa)
 	 */
 	for (i = 0; i < SPU_LSCSA_NUM_BIG_PAGES; i++) {
 		/* XXX This is likely to fail, we should use a special pool
-		 *     similiar to what hugetlbfs does.
+		 *     similar to what hugetlbfs does.
 		 */
 		csa->lscsa_pages[i] = alloc_pages(GFP_KERNEL,
 						  SPU_64K_PAGE_ORDER);
diff --git a/arch/powerpc/platforms/cell/spufs/spu_restore.c b/arch/powerpc/platforms/cell/spufs/spu_restore.c
index 0bf723d..c74a7a0 100644
--- a/arch/powerpc/platforms/cell/spufs/spu_restore.c
+++ b/arch/powerpc/platforms/cell/spufs/spu_restore.c
@@ -284,7 +284,7 @@ static inline void restore_complete(void)
 		exit_instrs[3] = BR_INSTR;
 		break;
 	default:
-		/* SPU_Status[R]=1. No additonal instructions. */
+		/* SPU_Status[R]=1. No additional instructions. */
 		break;
 	}
 	spu_sync();
diff --git a/arch/powerpc/platforms/cell/spufs/switch.c b/arch/powerpc/platforms/cell/spufs/switch.c
index 71a0b41..ce42a35 100644
--- a/arch/powerpc/platforms/cell/spufs/switch.c
+++ b/arch/powerpc/platforms/cell/spufs/switch.c
@@ -8,11 +8,11 @@
  * Host-side part of SPU context switch sequence outlined in
  * Synergistic Processor Element, Book IV.
  *
- * A fully premptive switch of an SPE is very expensive in terms
+ * A fully preemptive switch of an SPE is very expensive in terms
  * of time and system resources.  SPE Book IV indicates that SPE
  * allocation should follow a "serially reusable device" model,
  * in which the SPE is assigned a task until it completes.  When
- * this is not possible, this sequence may be used to premptively
+ * this is not possible, this sequence may be used to preemptively
  * save, and then later (optionally) restore the context of a
  * program executing on an SPE.
  *
diff --git a/arch/powerpc/platforms/celleb/pci.c b/arch/powerpc/platforms/celleb/pci.c
index d1adf34..af6add2 100644
--- a/arch/powerpc/platforms/celleb/pci.c
+++ b/arch/powerpc/platforms/celleb/pci.c
@@ -169,7 +169,7 @@ static int celleb_fake_pci_read_config(struct pci_bus *bus,
 	unsigned int devno = devfn >> 3;
 	unsigned int fn = devfn & 0x7;
 
-	/* allignment check */
+	/* alignment check */
 	BUG_ON(where % size);
 
 	pr_debug("    fake read: bus=0x%x, ", bus->number);
@@ -200,7 +200,7 @@ static int celleb_fake_pci_write_config(struct pci_bus *bus,
 	unsigned int devno = devfn >> 3;
 	unsigned int fn = devfn & 0x7;
 
-	/* allignment check */
+	/* alignment check */
 	BUG_ON(where % size);
 
 	node = (struct device_node *)bus->sysdata;
diff --git a/arch/powerpc/platforms/celleb/scc_epci.c b/arch/powerpc/platforms/celleb/scc_epci.c
index fb23d53..058adb5 100644
--- a/arch/powerpc/platforms/celleb/scc_epci.c
+++ b/arch/powerpc/platforms/celleb/scc_epci.c
@@ -161,7 +161,7 @@ static int celleb_epci_read_config(struct pci_bus *bus,
 	struct device_node *node;
 	struct pci_controller *hose;
 
-	/* allignment check */
+	/* alignment check */
 	BUG_ON(where % size);
 
 	node = (struct device_node *)bus->sysdata;
@@ -224,7 +224,7 @@ static int celleb_epci_write_config(struct pci_bus *bus,
 	struct device_node *node;
 	struct pci_controller *hose;
 
-	/* allignment check */
+	/* alignment check */
 	BUG_ON(where % size);
 
 	node = (struct device_node *)bus->sysdata;
@@ -378,7 +378,7 @@ static int __devinit celleb_epci_init(struct pci_controller *hose)
 	val |= SCC_EPCI_CNTOPT_O2PMB;
 	out_be32(reg, val);
 
-	/* XXX: temporay: set registers for address conversion setup */
+	/* XXX: temporary: set registers for address conversion setup */
 	reg = epci_base + SCC_EPCI_CNF10_REG;
 	out_be32(reg, 0x80000008);
 	reg = epci_base + SCC_EPCI_CNF14_REG;
diff --git a/arch/powerpc/platforms/celleb/scc_uhc.c b/arch/powerpc/platforms/celleb/scc_uhc.c
index a7c548b..b59c38a 100644
--- a/arch/powerpc/platforms/celleb/scc_uhc.c
+++ b/arch/powerpc/platforms/celleb/scc_uhc.c
@@ -36,7 +36,7 @@ static inline int uhc_clkctrl_ready(u32 val)
 }
 
 /*
- * UHC(usb host controler) enable function.
+ * UHC(usb host controller) enable function.
  * affect to both of OHCI and EHCI core module.
  */
 static void enable_scc_uhc(struct pci_dev *dev)
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index f29705f..183c70e 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -460,7 +460,7 @@ static long heathrow_sound_enable(struct device_node *node, long param,
 	unsigned long		flags;
 
 	/* B&W G3 and Yikes don't support that properly (the
-	 * sound appear to never come back after beeing shut down).
+	 * sound appear to never come back after being shut down).
 	 */
 	if (pmac_mb.model_id == PMAC_TYPE_YOSEMITE ||
 	    pmac_mb.model_id == PMAC_TYPE_YIKES)
@@ -2750,7 +2750,7 @@ set_initial_features(void)
 	 * but I'm not too sure it was audited for side-effects on other
 	 * ohare based machines...
 	 * Since I still have difficulties figuring the right way to
-	 * differenciate them all and since that hack was there for a long
+	 * differentiate them all and since that hack was there for a long
 	 * time, I'll keep it around
 	 */
 	if (macio_chips[0].type == macio_ohare) {
diff --git a/arch/powerpc/platforms/powermac/pfunc_base.c b/arch/powerpc/platforms/powermac/pfunc_base.c
index 45d54b9..1857134 100644
--- a/arch/powerpc/platforms/powermac/pfunc_base.c
+++ b/arch/powerpc/platforms/powermac/pfunc_base.c
@@ -280,7 +280,7 @@ static int unin_do_write_reg32(PMF_STD_ARGS, u32 offset, u32 value, u32 mask)
 
 	spin_lock_irqsave(&feature_lock, flags);
 	/* This is fairly bogus in darwin, but it should work for our needs
-	 * implemeted that way:
+	 * implemented that way:
 	 */
 	UN_OUT(offset, (UN_IN(offset) & ~mask) | (value & mask));
 	spin_unlock_irqrestore(&feature_lock, flags);
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index a410bc7..1d9f13f 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -616,7 +616,7 @@ static int __init pmac_probe(void)
 	 * On U3, the DART (iommu) must be allocated now since it
 	 * has an impact on htab_initialize (due to the large page it
 	 * occupies having to be broken up so the DART itself is not
-	 * part of the cacheable linar mapping
+	 * part of the cacheable linear mapping
 	 */
 	alloc_dart_table();
 
@@ -683,7 +683,7 @@ static void pmac_cpu_die(void)
 
 	/*
 	 * during the path that leads here preemption is disabled,
-	 * reenable it now so that when coming up preempt count is
+	 * re-enable it now so that when coming up preempt count is
 	 * zero correctly
 	 */
 	preempt_enable();
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 9da82c2..b4cd3b3 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -315,7 +315,7 @@ int ps3_send_event_locally(unsigned int virq)
  * @virq: The assigned Linux virq.
  *
  * An event irq represents a virtual device interrupt.  The interrupt_id
- * coresponds to the software interrupt number.
+ * corresponds to the software interrupt number.
  */
 
 int ps3_sb_event_receive_port_setup(enum ps3_cpu_binding cpu,
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index f8a3e20..1b97195 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -360,7 +360,7 @@ static void _dma_dump_region(const struct ps3_dma_region *r, const char* func,
  * @bus_addr: Starting ioc bus address of the area to map.
  * @len: Length in bytes of the area to map.
  * @link: A struct list_head used with struct ps3_dma_region.chunk_list, the
- * list of all chuncks owned by the region.
+ * list of all chunks owned by the region.
  *
  * This implementation uses a very simple dma page manager
  * based on the dma_chunk structure.  This scheme assumes
@@ -655,7 +655,7 @@ int dma_unmap_area(struct ps3_dma_region *r, unsigned long bus_addr,
 }
 
 /**
- * dma_region_create_linear - Setup a linear dma maping for a device.
+ * dma_region_create_linear - Setup a linear dma mapping for a device.
  * @r: Pointer to a struct ps3_dma_region.
  *
  * This routine creates an HV dma region for the device and maps all available
@@ -725,7 +725,7 @@ static int dma_region_free_linear(struct ps3_dma_region *r)
  * @bus_addr: A pointer to return the starting ioc bus address of the area to
  * map.
  *
- * This routine just returns the coresponding bus address.  Actual mapping
+ * This routine just returns the corresponding bus address.  Actual mapping
  * occurs in dma_region_create_linear().
  */
 
diff --git a/arch/powerpc/platforms/ps3/os-area.c b/arch/powerpc/platforms/ps3/os-area.c
index 5c3da08..0eb23c1 100644
--- a/arch/powerpc/platforms/ps3/os-area.c
+++ b/arch/powerpc/platforms/ps3/os-area.c
@@ -111,9 +111,9 @@ struct os_area_params {
 /**
  * struct saved_params - Static working copies of data from the 'Other OS' area.
  *
- * For the convinience of the guest, the HV makes a copy of the 'Other OS' area
+ * For the convenience of the guest, the HV makes a copy of the 'Other OS' area
  * in flash to a high address in the boot memory region and then puts that RAM
- * address and the byte count into the repository for retreval by the guest.
+ * address and the byte count into the repository for retrieval by the guest.
  * We copy the data we want into a static variable and allow the memory setup
  * by the HV to be claimed by the lmb manager.
  */
diff --git a/arch/powerpc/platforms/ps3/platform.h b/arch/powerpc/platforms/ps3/platform.h
index ca04f03..7d5fb6f 100644
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -200,8 +200,8 @@ int ps3_repository_read_boot_dat_info(u64 *lpar_addr, unsigned int *size);
 
 /**
  * enum spu_resource_type - Type of spu resource.
- * @spu_resource_type_shared: Logical spu is shared with other partions.
- * @spu_resource_type_exclusive: Logical spu is not shared with other partions.
+ * @spu_resource_type_shared: Logical spu is shared with other partitions.
+ * @spu_resource_type_exclusive: Logical spu is not shared with other partitions.
  *
  * Returned by ps3_repository_read_spu_resource_id().
  */
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 093438b..f63eba5 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -60,7 +60,7 @@
  *  with EEH.
  *
  *  Ideally, a PCI device driver, when suspecting that an isolation
- *  event has occured (e.g. by reading 0xff's), will then ask EEH
+ *  event has occurred (e.g. by reading 0xff's), will then ask EEH
  *  whether this is the case, and then take appropriate steps to
  *  reset the PCI slot, the PCI device, and then resume operations.
  *  However, until that day,  the checking is done here, with the
@@ -816,7 +816,7 @@ void eeh_restore_bars(struct pci_dn *pdn)
  *
  * Save the values of the device bars. Unlike the restore
  * routine, this routine is *not* recursive. This is because
- * PCI devices are added individuallly; but, for the restore,
+ * PCI devices are added individually; but, for the restore,
  * an entire slot is reset at a time.
  */
 static void eeh_save_bars(struct pci_dn *pdn)
diff --git a/arch/powerpc/platforms/pseries/eeh_driver.c b/arch/powerpc/platforms/pseries/eeh_driver.c
index f07d849..048fd14 100644
--- a/arch/powerpc/platforms/pseries/eeh_driver.c
+++ b/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -242,7 +242,7 @@ static void eeh_report_failure(struct pci_dev *dev, void *userdata)
  *            to the isolated slot. A non-null value will
  *            cause all devices under the bus to be removed
  *            and then re-added.
- * @pe_dn: pointer to a "Partionable Endpoint" device node.
+ * @pe_dn: pointer to a "Partitionable Endpoint" device node.
  *            This is the top-level structure on which pci
  *            bus resets can be performed.
  */
diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index 9b4fafd..9fe7678 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -216,7 +216,7 @@ void cpm_reset(void)
 
 	/* Set SDMA Bus Request priority 5.
 	 * On 860T, this also enables FEC priority 6.  I am not sure
-	 * this is what we realy want for some applications, but the
+	 * this is what we really want for some applications, but the
 	 * manual recommends it.
 	 * Bit 25, FAM can also be set to use FEC aggressive mode (860T).
 	 */
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index a1d2042..885feeb 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -159,7 +159,7 @@ static void dart_build(struct iommu_table *tbl, long index,
 
 	dp = ((unsigned int*)tbl->it_base) + index;
 
-	/* On U3, all memory is contigous, so we can move this
+	/* On U3, all memory is contiguous, so we can move this
 	 * out of the loop.
 	 */
 	l = npages;
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 4fd2bec..f4b0a0d 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -2,7 +2,7 @@
  *  arch/powerpc/kernel/mpic.c
  *
  *  Driver for interrupt controllers following the OpenPIC standard, the
- *  common implementation beeing IBM's MPIC. This driver also can deal
+ *  common implementation being IBM's MPIC. This driver also can deal
  *  with various broken implementations of this HW.
  *
  *  Copyright (C) 2004 Benjamin Herrenschmidt, IBM Corp.
-- 
1.5.0.1

-- 
Simon Arlott
