Return-Path: <linux-kernel-owner+w=401wt.eu-S1765509AbXEVIMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765509AbXEVIMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759341AbXEVIGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:39 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:29112 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbXEVIGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:21 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 13/15] x86-64: Calgary - tabify and trim trailing whitespace
Date: Tue, 22 May 2007 04:06:02 -0400
Message-Id: <11798211673121-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211671872-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com> <11798211672822-git-send-email-muli@il.ibm.com> <1179821167443-git-send-email-muli@il.ibm.com> <11798211673144-git-send-email-muli@il.ibm.com> <11798211671872-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

---
 arch/x86_64/kernel/pci-calgary.c |   44 +++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 5ec9be2..0bb0eb0 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -75,9 +75,9 @@ int use_calgary __read_mostly = 0;
 #define PHB_DOSHOLE_OFFSET	0x08E0
 
 /* CalIOC2 specific */
-#define PHB_SAVIOR_L2           0x0DB0
-#define PHB_PAGE_MIG_CTRL       0x0DA8
-#define PHB_PAGE_MIG_DEBUG      0x0DA0
+#define PHB_SAVIOR_L2		0x0DB0
+#define PHB_PAGE_MIG_CTRL	0x0DA8
+#define PHB_PAGE_MIG_DEBUG	0x0DA0
 #define PHB_ROOT_COMPLEX_STATUS 0x0CB0
 
 /* PHB_CONFIG_RW */
@@ -92,11 +92,11 @@ int use_calgary __read_mostly = 0;
 /* CSR (Channel/DMA Status Register) */
 #define CSR_AGENT_MASK		0xffe0ffff
 /* CCR (Calgary Configuration Register) */
-#define CCR_2SEC_TIMEOUT        0x000000000000000EUL
+#define CCR_2SEC_TIMEOUT	0x000000000000000EUL
 /* PMCR/PMDR (Page Migration Control/Debug Registers */
-#define PMR_SOFTSTOP            0x80000000
-#define PMR_SOFTSTOPFAULT       0x40000000
-#define PMR_HARDSTOP            0x20000000
+#define PMR_SOFTSTOP		0x80000000
+#define PMR_SOFTSTOPFAULT	0x40000000
+#define PMR_HARDSTOP		0x20000000
 
 #define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
 #define MAX_NUM_CHASSIS		8 /* max number of chassis */
@@ -230,7 +230,7 @@ static inline int translate_phb(struct p
 }
 
 static void iommu_range_reserve(struct iommu_table *tbl,
-        unsigned long start_addr, unsigned int npages)
+	unsigned long start_addr, unsigned int npages)
 {
 	unsigned long index;
 	unsigned long end;
@@ -420,7 +420,7 @@ static int calgary_nontranslate_map_sg(s
 {
 	int i;
 
- 	for (i = 0; i < nelems; i++ ) {
+	for (i = 0; i < nelems; i++ ) {
 		struct scatterlist *s = &sg[i];
 		BUG_ON(!s->page);
 		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
@@ -840,12 +840,12 @@ static int __init calgary_setup_tar(stru
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
-  	if (is_calgary(dev->device))
-  		tbl->chip_ops = &calgary_chip_ops;
+	if (is_calgary(dev->device))
+		tbl->chip_ops = &calgary_chip_ops;
 	else if (is_calioc2(dev->device))
 		tbl->chip_ops = &calioc2_chip_ops;
-  	else
-  		BUG();
+	else
+		BUG();
 
 	calgary_reserve_regions(dev);
 
@@ -899,7 +899,7 @@ static void calgary_dump_error_regs(stru
 	void __iomem *bbar = tbl->bbar;
 	void __iomem *target;
 	u32 csr, plssr;
-	
+
 	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_CSR_OFFSET);
 	csr = be32_to_cpu(readl(target));
 
@@ -1027,13 +1027,13 @@ static void calioc2_handle_quirks(struct
 	void __iomem *target;
 	u32 val;
 
- 	/*
- 	 * CalIOC2 designers recommend setting bit 8 in 0xnDB0 to 1
- 	 */
- 	target = calgary_reg(bbar, phb_offset(busnum) | PHB_SAVIOR_L2);
- 	val = cpu_to_be32(readl(target));
- 	val |= 0x00800000;
- 	writel(cpu_to_be32(val), target);
+	/*
+	 * CalIOC2 designers recommend setting bit 8 in 0xnDB0 to 1
+	 */
+	target = calgary_reg(bbar, phb_offset(busnum) | PHB_SAVIOR_L2);
+	val = cpu_to_be32(readl(target));
+	val |= 0x00800000;
+	writel(cpu_to_be32(val), target);
 }
 
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
@@ -1560,7 +1560,7 @@ static void __init calgary_fixup_one_tce
 		printk(KERN_DEBUG "Calg: dev %p [%x] tbl %p reserving "
 		       "0x%Lx-0x%Lx [0x%x pages]\n", dev, dev->bus->number,
 		       tbl, r->start, r->end, npages);
-			
+
 		iommu_range_reserve(tbl, r->start, npages);
 	}
 }
-- 
1.4.4

