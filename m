Return-Path: <linux-kernel-owner+w=401wt.eu-S1764616AbYCWIfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764616AbYCWIfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbYCWIKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:14 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2297 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759727AbYCWIKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:08 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 122/148] include/asm-x86/swiotlb.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:37 -0700
Message-Id: <1206259443-13210-123-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/swiotlb.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index f9c5895..f5d9e74 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -8,15 +8,15 @@
 extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
 				     size_t size, int dir);
 extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-                       dma_addr_t *dma_handle, gfp_t flags);
+				    dma_addr_t *dma_handle, gfp_t flags);
 extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				  size_t size, int dir);
+				 size_t size, int dir);
 extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					 dma_addr_t dev_addr,
-					 size_t size, int dir);
+					dma_addr_t dev_addr,
+					size_t size, int dir);
 extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					    dma_addr_t dev_addr,
-					    size_t size, int dir);
+					   dma_addr_t dev_addr,
+					   size_t size, int dir);
 extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
 					      dma_addr_t dev_addr,
 					      unsigned long offset,
@@ -26,18 +26,18 @@ extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
 						 unsigned long offset,
 						 size_t size, int dir);
 extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				     struct scatterlist *sg, int nelems,
-				     int dir);
+				    struct scatterlist *sg, int nelems,
+				    int dir);
 extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-					struct scatterlist *sg, int nelems,
-					int dir);
+				       struct scatterlist *sg, int nelems,
+				       int dir);
 extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-		      int nents, int direction);
+			  int nents, int direction);
 extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			 int nents, int direction);
+			     int nents, int direction);
 extern int swiotlb_dma_mapping_error(dma_addr_t dma_addr);
-extern void swiotlb_free_coherent (struct device *hwdev, size_t size,
-				   void *vaddr, dma_addr_t dma_handle);
+extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
+				  void *vaddr, dma_addr_t dma_handle);
 extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
 extern void swiotlb_init(void);
 
-- 
1.5.4.rc2

