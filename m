Return-Path: <linux-kernel-owner+w=401wt.eu-S1030807AbXCNJVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030807AbXCNJVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXCNJVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:21:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60568 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740AbXCNJUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:20:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 17/17] m68k dma-mapping: gfp_t annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPey-0003d4-2p@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:20:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-m68k/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-m68k/dma-mapping.h b/include/asm-m68k/dma-mapping.h
index 00259ed..a26cdeb 100644
--- a/include/asm-m68k/dma-mapping.h
+++ b/include/asm-m68k/dma-mapping.h
@@ -32,7 +32,7 @@ extern void dma_free_coherent(struct device *, size_t,
 			      void *, dma_addr_t);
 
 static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
-					  dma_addr_t *handle, int flag)
+					  dma_addr_t *handle, gfp_t flag)
 {
 	return dma_alloc_coherent(dev, size, handle, flag);
 }
-- 
1.5.0-rc2.GIT

