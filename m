Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbXJXMHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbXJXMHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbXJXMH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:07:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37297 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757001AbXJXMHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:07:25 -0400
Date: Wed, 24 Oct 2007 14:07:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>, chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] xtensa: fix sg fallout
Message-ID: <20071024120755.GC30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d1794cb192dcd1212c9bc2f3f78f5ca4860bf6ce 
diff --git a/include/asm-xtensa/dma-mapping.h b/include/asm-xtensa/dma-mapping.h
index 8bd9d2c..791e1c9 100644
--- a/include/asm-xtensa/dma-mapping.h
+++ b/include/asm-xtensa/dma-mapping.h
@@ -11,7 +11,7 @@
 #ifndef _XTENSA_DMA_MAPPING_H
 #define _XTENSA_DMA_MAPPING_H
 
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/cache.h>
 #include <asm/io.h>
 #include <linux/mm.h>

