Return-Path: <linux-kernel-owner+w=401wt.eu-S1030749AbXCNJQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030749AbXCNJQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030748AbXCNJQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:16:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60730 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749AbXCNJQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:16:15 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 8/13] m32r dma-mapping.h should simply include generic/dma-mapping-broken.h
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPag-0003Av-Nt@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:16:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... instead of trying to duplicate its bits

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-m32r/dma-mapping.h |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/include/asm-m32r/dma-mapping.h b/include/asm-m32r/dma-mapping.h
index a7fa030..f9b58eb 100644
--- a/include/asm-m32r/dma-mapping.h
+++ b/include/asm-m32r/dma-mapping.h
@@ -1,23 +1,6 @@
 #ifndef _ASM_M32R_DMA_MAPPING_H
 #define _ASM_M32R_DMA_MAPPING_H
 
-/*
- * NOTE: Do not include <asm-generic/dma-mapping.h>
- * Because it requires PCI stuffs, but current M32R don't provide these.
- */
-
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flag)
-{
-	return (void *)NULL;
-}
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-		    dma_addr_t dma_handle)
-{
-	return;
-}
+#include <asm-generic/dma-mapping-broken.h>
 
 #endif /* _ASM_M32R_DMA_MAPPING_H */
-- 
1.5.0-rc2.GIT


