Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbYCWIiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbYCWIiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759809AbYCWIK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:26 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2303 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759778AbYCWIKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:23 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 026/148] include/asm-x86/dma-mapping_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:01 -0700
Message-Id: <1206259443-13210-27-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/dma-mapping_32.h |  130 ++++++++++++++++++-------------------
 1 files changed, 63 insertions(+), 67 deletions(-)

diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 55f01bd..4f6c2a4 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -12,14 +12,14 @@
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
+			 dma_addr_t *dma_handle, gfp_t flag);
 
 void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
+		       void *vaddr, dma_addr_t dma_handle);
 
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
+static inline dma_addr_t dma_map_single(struct device *dev, void *ptr,
+					size_t size,
+					enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	WARN_ON(size == 0);
@@ -27,16 +27,15 @@ dma_map_single(struct device *dev, void *ptr, size_t size,
 	return virt_to_phys(ptr);
 }
 
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
+static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				    size_t size,
+				    enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction)
+static inline int dma_map_sg(struct device *dev, struct scatterlist *sglist,
+			     int nents, enum dma_data_direction direction)
 {
 	struct scatterlist *sg;
 	int i;
@@ -54,88 +53,89 @@ dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	return nents;
 }
 
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-	     size_t size, enum dma_data_direction direction)
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 	return page_to_phys(page) + offset;
 }
 
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
+static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+				  size_t size,
+				  enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 }
 
 
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
+static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+				int nhwentries,
+				enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
+static inline void dma_sync_single_for_cpu(struct device *dev,
+					   dma_addr_t dma_handle, size_t size,
+					   enum dma_data_direction direction)
 {
 }
 
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
+static inline void dma_sync_single_for_device(struct device *dev,
+					      dma_addr_t dma_handle,
+					      size_t size,
+					      enum dma_data_direction direction)
 {
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
+static inline void dma_sync_single_range_for_cpu(struct device *dev,
+						 dma_addr_t dma_handle,
+						 unsigned long offset,
+						 size_t size,
+						 enum dma_data_direction direction)
 {
 }
 
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
+static inline void dma_sync_single_range_for_device(struct device *dev,
+						    dma_addr_t dma_handle,
+						    unsigned long offset,
+						    size_t size,
+						    enum dma_data_direction direction)
 {
 	flush_write_buffers();
 }
 
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+				       struct scatterlist *sg, int nelems,
+				       enum dma_data_direction direction)
 {
 }
 
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
+static inline void dma_sync_sg_for_device(struct device *dev,
+					  struct scatterlist *sg, int nelems,
+					  enum dma_data_direction direction)
 {
 	flush_write_buffers();
 }
 
-static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(dma_addr_t dma_addr)
 {
 	return 0;
 }
 
 extern int forbid_dac;
 
-static inline int
-dma_supported(struct device *dev, u64 mask)
+static inline int dma_supported(struct device *dev, u64 mask)
 {
-        /*
-         * we fall back to GFP_DMA when the mask isn't all 1s,
-         * so we can't guarantee allocations that must be
-         * within a tighter range than GFP_DMA..
-         */
-        if(mask < 0x00ffffff)
-                return 0;
+	/*
+	 * we fall back to GFP_DMA when the mask isn't all 1s,
+	 * so we can't guarantee allocations that must be
+	 * within a tighter range than GFP_DMA..
+	 */
+	if (mask < 0x00ffffff)
+		return 0;
 
 	/* Work around chipset bugs */
 	if (forbid_dac > 0 && mask > 0xffffffffULL)
@@ -144,10 +144,9 @@ dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
+static inline int dma_set_mask(struct device *dev, u64 mask)
 {
-	if(!dev->dma_mask || !dma_supported(dev, mask))
+	if (!dev->dma_mask || !dma_supported(dev, mask))
 		return -EIO;
 
 	*dev->dma_mask = mask;
@@ -155,8 +154,7 @@ dma_set_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
-static inline int
-dma_get_cache_alignment(void)
+static inline int dma_get_cache_alignment(void)
 {
 	/* no easy way to get cache size on all x86, so return the
 	 * maximum possible, to be safe */
@@ -165,23 +163,21 @@ dma_get_cache_alignment(void)
 
 #define dma_is_consistent(d, h)	(1)
 
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction direction)
+static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+				  enum dma_data_direction direction)
 {
 	flush_write_buffers();
 }
 
 #define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
+extern int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+				       dma_addr_t device_addr, size_t size,
+				       int flags);
 
-extern void
-dma_release_declared_memory(struct device *dev);
+extern void dma_release_declared_memory(struct device *dev);
 
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
+extern void *dma_mark_declared_memory_occupied(struct device *dev,
+					       dma_addr_t device_addr,
+					       size_t size);
 
 #endif
-- 
1.5.4.rc2

