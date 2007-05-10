Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbXEJKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbXEJKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXEJKWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:22:32 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8921 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbXEJKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:22:26 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 9/13] [PATCH] x86-64: enable sg chaining
Date: Thu, 10 May 2007 12:21:51 +0200
Message-Id: <11787925162693-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787925152319-git-send-email-jens.axboe@oracle.com>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
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

