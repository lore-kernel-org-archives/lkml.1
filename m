Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbXEJLmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbXEJLmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760531AbXEJLlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:14 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4889 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbXEJLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 9/12] x86-64: enable sg chaining
Date: Thu, 10 May 2007 13:40:34 +0200
Message-Id: <11787972371310-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787972373654-git-send-email-jens.axboe@oracle.com>
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-x86_64/dma-mapping.h |    3 +--
 include/asm-x86_64/scatterlist.h |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86_64/dma-mapping.h b/include/asm-x86_64/dma-mapping.h
index 6897e2a..ecd0f61 100644
--- a/include/asm-x86_64/dma-mapping.h
+++ b/include/asm-x86_64/dma-mapping.h
@@ -6,8 +6,7 @@
  * documentation.
  */
 
-
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 
diff --git a/include/asm-x86_64/scatterlist.h b/include/asm-x86_64/scatterlist.h
index eaf7ada..ef3986b 100644
--- a/include/asm-x86_64/scatterlist.h
+++ b/include/asm-x86_64/scatterlist.h
@@ -11,6 +11,8 @@ struct scatterlist {
     unsigned int        dma_length;
 };
 
+#define ARCH_HAS_SG_CHAIN
+
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
 /* These macros should be used after a pci_map_sg call has been done
-- 
1.5.2.rc1

