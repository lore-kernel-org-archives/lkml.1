Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788Ab0BZAn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:43:56 -0500
Received: from sh.osrg.net ([192.16.179.4]:49847 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934756Ab0BZAnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:43:55 -0500
Date: Fri, 26 Feb 2010 09:43:51 +0900
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100226093941C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Feb 2010 09:43:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc's scatterlist structure is identical to the generic one.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sparc/include/asm/scatterlist.h |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/include/asm/scatterlist.h b/arch/sparc/include/asm/scatterlist.h
index e580f55..d112025 100644
--- a/arch/sparc/include/asm/scatterlist.h
+++ b/arch/sparc/include/asm/scatterlist.h
@@ -1,27 +1,8 @@
 #ifndef _SPARC_SCATTERLIST_H
 #define _SPARC_SCATTERLIST_H
 
-#include <asm/page.h>
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;
-
-	unsigned int	length;
-
-	dma_addr_t	dma_address;
-	__u32		dma_length;
-};
-
-#define sg_dma_address(sg)	((sg)->dma_address)
 #define sg_dma_len(sg)     	((sg)->dma_length)
 
-#define ISA_DMA_THRESHOLD	(~0UL)
-
-#define ARCH_HAS_SG_CHAIN
+#include <asm-generic/scatterlist.h>
 
 #endif /* !(_SPARC_SCATTERLIST_H) */
-- 
1.6.5

