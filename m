Return-Path: <linux-kernel-owner+w=401wt.eu-S1030762AbXCNJRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030762AbXCNJRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030755AbXCNJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:16:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60771 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030771AbXCNJQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:16:46 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 11/13] sparc: have dma-mapping.h include generic/dma-mapping-broken in non-PCI case
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1HRPbA-0003Fz-P0@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:16:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-sparc/dma-mapping.h |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/include/asm-sparc/dma-mapping.h b/include/asm-sparc/dma-mapping.h
index 6db83dc..f3a641e 100644
--- a/include/asm-sparc/dma-mapping.h
+++ b/include/asm-sparc/dma-mapping.h
@@ -5,20 +5,7 @@
 #ifdef CONFIG_PCI
 #include <asm-generic/dma-mapping.h>
 #else
-
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t flag)
-{
-	BUG();
-	return NULL;
-}
-
-static inline void dma_free_coherent(struct device *dev, size_t size,
-		       void *vaddr, dma_addr_t dma_handle)
-{
-	BUG();
-}
-
+#include <asm-generic/dma-mapping-broken.h>
 #endif /* PCI */
 
 #endif /* _ASM_SPARC_DMA_MAPPING_H */
-- 
1.5.0-rc2.GIT


