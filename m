Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXBLHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXBLHmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbXBLHmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:42:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:38431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXBLHi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:26 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [36/39] x86_64: define dma noncoherent API functions
Message-Id: <20070212073824.AF6B813DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeff Garzik <jeff@garzik.org>

x86-64 is missing these:

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/dma-mapping.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/asm-x86_64/dma-mapping.h
===================================================================
--- linux.orig/include/asm-x86_64/dma-mapping.h
+++ linux/include/asm-x86_64/dma-mapping.h
@@ -66,6 +66,9 @@ static inline int dma_mapping_error(dma_
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
