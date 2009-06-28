Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZF1Q3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZF1Q3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZF1Q1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1077 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbZF1Q1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>, oprofile-list@lists.sf.net,
       cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 05/62] arch/powerpc: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:10 -0700
Message-Id: <a55afa18f8b7ba8343072a14d36a2e340e61e816.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/mm/tlb_hash64.c                 |    2 +-
 arch/powerpc/oprofile/cell/vma_map.c         |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c |    2 +-
 arch/powerpc/platforms/powermac/pic.c        |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c      |    1 -
 arch/powerpc/sysdev/fsl_rio.c                |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c             |    4 ++--
 7 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
index 1be1b5e..937eb90 100644
--- a/arch/powerpc/mm/tlb_hash64.c
+++ b/arch/powerpc/mm/tlb_hash64.c
@@ -72,7 +72,7 @@ void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 	 */
 	if (huge) {
 #ifdef CONFIG_HUGETLB_PAGE
-		psize = get_slice_psize(mm, addr);;
+		psize = get_slice_psize(mm, addr);
 #else
 		BUG();
 		psize = pte_pagesize_index(mm, addr, pte); /* shutup gcc */
diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
index 258fa44..c591339 100644
--- a/arch/powerpc/oprofile/cell/vma_map.c
+++ b/arch/powerpc/oprofile/cell/vma_map.c
@@ -185,7 +185,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 			goto fail;
 
 		if (shdr_str.sh_type != SHT_STRTAB)
-			goto fail;;
+			goto fail;
 
 		for (j = 0; j < shdr.sh_size / sizeof (sym); j++) {
 			if (copy_from_user(&sym, spu_elf_start +
diff --git a/arch/powerpc/platforms/powermac/cpufreq_64.c b/arch/powerpc/platforms/powermac/cpufreq_64.c
index 22ecfbe..708c751 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_64.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_64.c
@@ -251,7 +251,7 @@ static void g5_pfunc_switch_volt(int speed_mode)
 static struct pmf_function *pfunc_cpu_setfreq_high;
 static struct pmf_function *pfunc_cpu_setfreq_low;
 static struct pmf_function *pfunc_cpu_getfreq;
-static struct pmf_function *pfunc_slewing_done;;
+static struct pmf_function *pfunc_slewing_done;
 
 static int g5_pfunc_switch_freq(int speed_mode)
 {
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index dce7363..d212006 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -609,7 +609,7 @@ static int pmacpic_find_viaint(void)
 	np = of_find_node_by_name(NULL, "via-pmu");
 	if (np == NULL)
 		goto not_found;
-	viaint = irq_of_parse_and_map(np, 0);;
+	viaint = irq_of_parse_and_map(np, 0);
 
 not_found:
 #endif /* CONFIG_ADB_PMU */
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 9fead0f..3f763c5 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -284,7 +284,6 @@ static int ps3_sb_free_mmio_region(struct ps3_mmio_region *r)
 	int result;
 
 	dump_mmio_region(r);
-;
 	result = lv1_unmap_device_mmio_region(r->dev->bus_id, r->dev->dev_id,
 		r->lpar_addr);
 
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 39db9d1..cbb3bed 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -965,7 +965,7 @@ static inline void fsl_rio_info(struct device *dev, u32 ccsr)
 			break;
 		default:
 			str = "Unknown";
-			break;;
+			break;
 		}
 		dev_info(dev, "Hardware port width: %s\n", str);
 
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index daefc93..6ff9d71 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -1531,7 +1531,7 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 		 */
 
 		/* Calculate window size */
-		sa = (0xffffffffffffffffull << ilog2(ep_size));;
+		sa = (0xffffffffffffffffull << ilog2(ep_size));
 
 		/* Setup BAR0 */
 		out_le32(mbase + PECFG_BAR0HMPA, RES_TO_U32_HIGH(sa));
@@ -1550,7 +1550,7 @@ static void __init ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
 		out_le32(mbase + PCI_BASE_ADDRESS_1, RES_TO_U32_HIGH(ep_addr));
 	} else {
 		/* Calculate window size */
-		sa = (0xffffffffffffffffull << ilog2(size));;
+		sa = (0xffffffffffffffffull << ilog2(size));
 		if (res->flags & IORESOURCE_PREFETCH)
 			sa |= 0x8;
 
-- 
1.6.3.1.10.g659a0.dirty

