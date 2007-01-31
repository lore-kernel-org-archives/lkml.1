Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbXAaMlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbXAaMlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbXAaMlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:41:11 -0500
Received: from havoc.gtf.org ([69.61.125.42]:48790 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178AbXAaMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:41:10 -0500
Date: Wed, 31 Jan 2007 07:41:07 -0500
From: Jeff Garzik <jeff@garzik.org>
To: ak@suse.de, Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: define dma noncoherent API functions
Message-ID: <20070131124107.GA4884@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


x86-64 is missing these:

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/include/asm-x86_64/dma-mapping.h b/include/asm-x86_64/dma-mapping.h
index be9ec68..49dbab0 100644
--- a/include/asm-x86_64/dma-mapping.h
+++ b/include/asm-x86_64/dma-mapping.h
@@ -63,6 +63,9 @@ static inline int dma_mapping_error(dma_addr_t dma_addr)
 	return (dma_addr == bad_dma_address);
 }
 
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
