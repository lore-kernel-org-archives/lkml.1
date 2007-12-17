Return-Path: <linux-kernel-owner+w=401wt.eu-S936114AbXLQTx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936114AbXLQTx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933842AbXLQTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:40:54 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3176 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670AbXLQTkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:40:52 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [PATCH] drivers/pci/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:11 -0800
Message-Id: <1197920439-5455-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918892.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pci/hotplug/shpchp_hpc.c |    2 +-
 drivers/pci/intel-iommu.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index 5183a45..e8aa138 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -597,7 +597,7 @@ static void hpc_release_ctlr(struct controller *ctrl)
 	cleanup_slots(ctrl);
 
 	/*
-	 * Mask SERR and System Interrut generation
+	 * Mask SERR and System Interrupt generation
 	 */
 	serr_int = shpc_readl(ctrl, SERR_INTR_ENABLE);
 	serr_int |= (GLOBAL_INTR_MASK  | GLOBAL_SERR_MASK |
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index e079a52..4e01df9 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1781,7 +1781,7 @@ __intel_alloc_iova(struct device *dev, struct dmar_domain *domain,
 		/*
 		 * First try to allocate an io virtual address in
 		 * DMA_32BIT_MASK and if that fails then try allocating
-		 * from higer range
+		 * from higher range
 		 */
 		iova = iommu_alloc_iova(domain, size, DMA_32BIT_MASK);
 		if (!iova)
-- 
1.5.3.7.949.g2221a6

