Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0BFRrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:47:43 -0500
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:53193 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932943Ab0BFRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:33 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 13/16] powerpc: remove trailing space in messages
Date: Sat,  6 Feb 2010 18:47:20 +0100
Message-Id: <1265478443-31072-13-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:27.0182 (UTC) FILETIME=[726566E0:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---

Please review the following with extra attention:
- arch/powerpc/kernel/lparcfg.c: last blob
- arch/powerpc/platforms/85xx/stx_gp3.c
- arch/powerpc/platforms/iseries/proc.c

For now I have skipped trailing spaces in printf and LOG_BLOB
statements in:
- arch/powerpc/boot/addRamDisk.c
- arch/powerpc/boot/ps3.c
- arch/powerpc/platforms/powermac/pfunc_core.c
- arch/powerpc/xmon/xmon.c
---
 arch/powerpc/kernel/lparcfg.c                |   10 +++++-----
 arch/powerpc/kernel/pci_of_scan.c            |    2 +-
 arch/powerpc/platforms/85xx/stx_gp3.c        |    2 +-
 arch/powerpc/platforms/iseries/proc.c        |    2 +-
 arch/powerpc/platforms/iseries/setup.c       |    2 +-
 arch/powerpc/platforms/powermac/bootx_init.c |    4 ++--
 arch/powerpc/platforms/pseries/eeh_driver.c  |    6 +++---
 arch/powerpc/platforms/pseries/pci_dlpar.c   |    2 +-
 arch/powerpc/platforms/pseries/phyp_dump.c   |    6 +++---
 arch/powerpc/platforms/pseries/xics.c        |    2 +-
 arch/powerpc/sysdev/mpic.c                   |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c           |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c           |    8 ++++----
 drivers/macintosh/therm_adt746x.c            |    2 +-
 drivers/ps3/ps3av.c                          |    2 +-
 15 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 79a00bb..d09d1c6 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -359,7 +359,7 @@ static void parse_system_parameter_string(struct seq_file *m)
 
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
 	if (!local_buffer) {
-		printk(KERN_ERR "%s %s kmalloc failure at line %d \n",
+		printk(KERN_ERR "%s %s kmalloc failure at line %d\n",
 		       __FILE__, __func__, __LINE__);
 		return;
 	}
@@ -383,13 +383,13 @@ static void parse_system_parameter_string(struct seq_file *m)
 		int idx, w_idx;
 		char *workbuffer = kzalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
 		if (!workbuffer) {
-			printk(KERN_ERR "%s %s kmalloc failure at line %d \n",
+			printk(KERN_ERR "%s %s kmalloc failure at line %d\n",
 			       __FILE__, __func__, __LINE__);
 			kfree(local_buffer);
 			return;
 		}
 #ifdef LPARCFG_DEBUG
-		printk(KERN_INFO "success calling get-system-parameter \n");
+		printk(KERN_INFO "success calling get-system-parameter\n");
 #endif
 		splpar_strlen = local_buffer[0] * 256 + local_buffer[1];
 		local_buffer += 2;	/* step over strlen value */
@@ -440,7 +440,7 @@ static int lparcfg_count_active_processors(void)
 
 	while ((cpus_dn = of_find_node_by_type(cpus_dn, "cpu"))) {
 #ifdef LPARCFG_DEBUG
-		printk(KERN_ERR "cpus_dn %p \n", cpus_dn);
+		printk(KERN_ERR "cpus_dn %p\n", cpus_dn);
 #endif
 		count++;
 	}
@@ -725,7 +725,7 @@ static int lparcfg_data(struct seq_file *m, void *v)
 	const unsigned int *lp_index_ptr;
 	unsigned int lp_index = 0;
 
-	seq_printf(m, "%s %s \n", MODULE_NAME, MODULE_VERS);
+	seq_printf(m, "%s %s\n", MODULE_NAME, MODULE_VERS);
 
 	rootdn = of_find_node_by_path("/");
 	if (rootdn) {
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 4aa1740..cd11d5c 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -304,7 +304,7 @@ static void __devinit __of_scan_bus(struct device_node *node,
 	int reglen, devfn;
 	struct pci_dev *dev;
 
-	pr_debug("of_scan_bus(%s) bus no %d... \n",
+	pr_debug("of_scan_bus(%s) bus no %d...\n",
 		 node->full_name, bus->number);
 
 	/* Scan direct children */
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index f559918..bc33d18 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -134,7 +134,7 @@ static void stx_gp3_show_cpuinfo(struct seq_file *m)
 	pvid = mfspr(SPRN_PVR);
 	svid = mfspr(SPRN_SVR);
 
-	seq_printf(m, "Vendor\t\t: RPC Electronics STx \n");
+	seq_printf(m, "Vendor\t\t: RPC Electronics STx\n");
 	seq_printf(m, "PVR\t\t: 0x%x\n", pvid);
 	seq_printf(m, "SVR\t\t: 0x%x\n", svid);
 
diff --git a/arch/powerpc/platforms/iseries/proc.c b/arch/powerpc/platforms/iseries/proc.c
index 91f4c6c..0676368 100644
--- a/arch/powerpc/platforms/iseries/proc.c
+++ b/arch/powerpc/platforms/iseries/proc.c
@@ -85,7 +85,7 @@ static int proc_titantod_show(struct seq_file *m, void *v)
 
 		seq_printf(m, "  titan elapsed = %lu uSec\n", titan_usec);
 		seq_printf(m, "  tb elapsed    = %lu ticks\n", tb_ticks);
-		seq_printf(m, "  titan jiffies = %lu.%04lu \n", titan_jiffies,
+		seq_printf(m, "  titan jiffies = %lu.%04lu\n", titan_jiffies,
 			   titan_jiff_rem_usec);
 		seq_printf(m, "  tb jiffies    = %lu.%04lu\n", tb_jiffies,
 			   tb_jiff_rem_usec);
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index a6cd339..b086341 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -256,7 +256,7 @@ static unsigned long iSeries_process_mainstore_vpd(struct MemoryBlock *mb_array,
 		mem_blocks = iSeries_process_Condor_mainstore_vpd(mb_array,
 				max_entries);
 
-	printk("Mainstore_VPD: numMemoryBlocks = %ld \n", mem_blocks);
+	printk("Mainstore_VPD: numMemoryBlocks = %ld\n", mem_blocks);
 	for (i = 0; i < mem_blocks; ++i) {
 		printk("Mainstore_VPD: block %3ld logical chunks %016lx - %016lx\n"
 		       "                             abs chunks %016lx - %016lx\n",
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index 9dd789a..84d7fd9 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -539,7 +539,7 @@ void __init bootx_init(unsigned long r3, unsigned long r4)
 		if (model
 		    && (strcmp(model, "iMac,1") == 0
 			|| strcmp(model, "PowerMac1,1") == 0)) {
-			bootx_printf("iMac,1 detected, shutting down USB \n");
+			bootx_printf("iMac,1 detected, shutting down USB\n");
 			out_le32((unsigned __iomem *)0x80880008, 1);	/* XXX */
 		}
 	}
@@ -554,7 +554,7 @@ void __init bootx_init(unsigned long r3, unsigned long r4)
 	} else
 		space = bi->totalParamsSize;
 
-	bootx_printf("Total space used by parameters & ramdisk: 0x%x \n", space);
+	bootx_printf("Total space used by parameters & ramdisk: 0x%x\n", space);
 
 	/* New BootX will have flushed all TLBs and enters kernel with
 	 * MMU switched OFF, so this should not be useful anymore.
diff --git a/arch/powerpc/platforms/pseries/eeh_driver.c b/arch/powerpc/platforms/pseries/eeh_driver.c
index ef8e454..0c252c3 100644
--- a/arch/powerpc/platforms/pseries/eeh_driver.c
+++ b/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -478,9 +478,9 @@ excess_failures:
 	 * due to actual, failed cards.
 	 */
 	printk(KERN_ERR
-	   "EEH: PCI device at location=%s driver=%s pci addr=%s \n"
+	   "EEH: PCI device at location=%s driver=%s pci addr=%s\n"
 		"has failed %d times in the last hour "
-		"and has been permanently disabled. \n"
+		"and has been permanently disabled.\n"
 		"Please try reseating this device or replacing it.\n",
 		location, drv_str, pci_str, frozen_pdn->eeh_freeze_count);
 	goto perm_error;
@@ -488,7 +488,7 @@ excess_failures:
 hard_fail:
 	printk(KERN_ERR
 	   "EEH: Unable to recover from failure of PCI device "
-	   "at location=%s driver=%s pci addr=%s \n"
+	   "at location=%s driver=%s pci addr=%s\n"
 	   "Please try reseating this device or replacing it.\n",
 		location, drv_str, pci_str);
 
diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index b6fa3e4..4b7a062 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -165,7 +165,7 @@ int remove_phb_dynamic(struct pci_controller *phb)
 	struct resource *res;
 	int rc, i;
 
-	pr_debug("PCI: Removing PHB %04x:%02x... \n",
+	pr_debug("PCI: Removing PHB %04x:%02x...\n",
 		 pci_domain_nr(b), b->number);
 
 	/* We cannot to remove a root bus that has children */
diff --git a/arch/powerpc/platforms/pseries/phyp_dump.c b/arch/powerpc/platforms/pseries/phyp_dump.c
index 15eb610..225a50a 100644
--- a/arch/powerpc/platforms/pseries/phyp_dump.c
+++ b/arch/powerpc/platforms/pseries/phyp_dump.c
@@ -150,7 +150,7 @@ static void print_dump_header(const struct phyp_dump_header *ph)
 	printk(KERN_INFO "Max auto time= %d\n", ph->maxtime_to_auto);
 
 	/*set cpu state and hpte states as well scratch pad area */
-	printk(KERN_INFO " CPU AREA \n");
+	printk(KERN_INFO " CPU AREA\n");
 	printk(KERN_INFO "cpu dump_flags =%d\n", ph->cpu_data.dump_flags);
 	printk(KERN_INFO "cpu source_type =%d\n", ph->cpu_data.source_type);
 	printk(KERN_INFO "cpu error_flags =%d\n", ph->cpu_data.error_flags);
@@ -161,7 +161,7 @@ static void print_dump_header(const struct phyp_dump_header *ph)
 	printk(KERN_INFO "cpu length_copied =%llx\n",
 		ph->cpu_data.length_copied);
 
-	printk(KERN_INFO " HPTE AREA \n");
+	printk(KERN_INFO " HPTE AREA\n");
 	printk(KERN_INFO "HPTE dump_flags =%d\n", ph->hpte_data.dump_flags);
 	printk(KERN_INFO "HPTE source_type =%d\n", ph->hpte_data.source_type);
 	printk(KERN_INFO "HPTE error_flags =%d\n", ph->hpte_data.error_flags);
@@ -172,7 +172,7 @@ static void print_dump_header(const struct phyp_dump_header *ph)
 	printk(KERN_INFO "HPTE length_copied =%llx\n",
 		ph->hpte_data.length_copied);
 
-	printk(KERN_INFO " SRSD AREA \n");
+	printk(KERN_INFO " SRSD AREA\n");
 	printk(KERN_INFO "SRSD dump_flags =%d\n", ph->kernel_data.dump_flags);
 	printk(KERN_INFO "SRSD source_type =%d\n", ph->kernel_data.source_type);
 	printk(KERN_INFO "SRSD error_flags =%d\n", ph->kernel_data.error_flags);
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 1ee66db..e9a52ec 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -127,7 +127,7 @@ static inline unsigned int lpar_xirr_info_get(void)
 
 	lpar_rc = plpar_xirr(&return_value);
 	if (lpar_rc != H_SUCCESS)
-		panic(" bad return code xirr - rc = %lx \n", lpar_rc);
+		panic(" bad return code xirr - rc = %lx\n", lpar_rc);
 	return (unsigned int)return_value;
 }
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 470dc6c..314f0fa 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1575,7 +1575,7 @@ void mpic_request_ipis(void)
 	int i;
 	BUG_ON(mpic == NULL);
 
-	printk(KERN_INFO "mpic: requesting IPIs ... \n");
+	printk(KERN_INFO "mpic: requesting IPIs...\n");
 
 	for (i = 0; i < 4; i++) {
 		unsigned int vipi = irq_create_mapping(mpic->irqhost,
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index 2acc928..5f0b036 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -256,7 +256,7 @@ static int qe_ic_host_map(struct irq_host *h, unsigned int virq,
 	struct irq_chip *chip;
 
 	if (qe_ic_info[hw].mask == 0) {
-		printk(KERN_ERR "Can't map reserved IRQ \n");
+		printk(KERN_ERR "Can't map reserved IRQ\n");
 		return -EINVAL;
 	}
 	/* Default chip */
diff --git a/arch/powerpc/sysdev/qe_lib/qe_io.c b/arch/powerpc/sysdev/qe_lib/qe_io.c
index 7c87460..77e4934 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_io.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_io.c
@@ -157,13 +157,13 @@ int par_io_of_config(struct device_node *np)
 	const unsigned int *pio_map;
 
 	if (par_io == NULL) {
-		printk(KERN_ERR "par_io not initialized \n");
+		printk(KERN_ERR "par_io not initialized\n");
 		return -1;
 	}
 
 	ph = of_get_property(np, "pio-handle", NULL);
 	if (ph == NULL) {
-		printk(KERN_ERR "pio-handle not available \n");
+		printk(KERN_ERR "pio-handle not available\n");
 		return -1;
 	}
 
@@ -171,12 +171,12 @@ int par_io_of_config(struct device_node *np)
 
 	pio_map = of_get_property(pio, "pio-map", &pio_map_len);
 	if (pio_map == NULL) {
-		printk(KERN_ERR "pio-map is not set! \n");
+		printk(KERN_ERR "pio-map is not set!\n");
 		return -1;
 	}
 	pio_map_len /= sizeof(unsigned int);
 	if ((pio_map_len % 6) != 0) {
-		printk(KERN_ERR "pio-map format wrong! \n");
+		printk(KERN_ERR "pio-map format wrong!\n");
 		return -1;
 	}
 
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index 5ff47ba..0da62d5 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -312,7 +312,7 @@ static void update_fans_speed (struct thermostat *th)
 
 			if (verbose)
 				printk(KERN_DEBUG "adt746x: Setting fans speed to %d "
-						 "(limit exceeded by %d on %s) \n",
+						 "(limit exceeded by %d on %s)\n",
 						new_speed, var,
 						sensor_location[fan_number+1]);
 			write_both_fan_speed(th, new_speed);
diff --git a/drivers/ps3/ps3av.c b/drivers/ps3/ps3av.c
index e82d8c9..95a689b 100644
--- a/drivers/ps3/ps3av.c
+++ b/drivers/ps3/ps3av.c
@@ -532,7 +532,7 @@ static void ps3av_set_videomode_packet(u32 id)
 	res = ps3av_cmd_avb_param(&avb_param, len);
 	if (res == PS3AV_STATUS_NO_SYNC_HEAD)
 		printk(KERN_WARNING
-		       "%s: Command failed. Please try your request again. \n",
+		       "%s: Command failed. Please try your request again.\n",
 		       __func__);
 	else if (res)
 		dev_dbg(&ps3av->dev->core, "ps3av_cmd_avb_param failed\n");
-- 
1.6.6.1

