Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbXJVBFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbXJVBFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 21:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXJVBFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 21:05:12 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41662 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXJVBFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 21:05:11 -0400
Message-ID: <471BF741.2020501@tiscali.nl>
Date: Mon, 22 Oct 2007 03:05:05 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] return hidden bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    return hidden bug
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e1c4707..6a69425 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -365,8 +365,8 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
 		printk(KERN_ERR "Bogus pci_unmap_single: dma_addr %lx "
 		       " base %lx size %x\n", dma_addr, arena->dma_base,
 		       arena->size);
-		return;
 		BUG();
+		return;
 	}
 
 	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
