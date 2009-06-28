Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZF1QcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZF1QcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZF1Q1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:31 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1100 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbZF1Q12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:28 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 16/62] drivers/dma: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:21 -0700
Message-Id: <f12568a4f9989612ec391db9aba3e6080a2e380f.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/dmatest.c |    2 +-
 drivers/dma/mv_xor.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index fb7da51..cec1ec0 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -114,7 +114,7 @@ static void dmatest_init_srcs(u8 **bufs, unsigned int start, unsigned int len)
 			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
 		for ( ; i < start + len; i++)
 			buf[i] = PATTERN_SRC | PATTERN_COPY
-				| (~i & PATTERN_COUNT_MASK);;
+				| (~i & PATTERN_COUNT_MASK);
 		for ( ; i < test_buf_size; i++)
 			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
 		buf++;
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index ddab94f..3f23eab 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1176,7 +1176,7 @@ static int __devinit mv_xor_probe(struct platform_device *pdev)
 	if (dma_has_cap(DMA_MEMSET, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_memset = mv_xor_prep_dma_memset;
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
-		dma_dev->max_xor = 8;                  ;
+		dma_dev->max_xor = 8;
 		dma_dev->device_prep_dma_xor = mv_xor_prep_dma_xor;
 	}
 
-- 
1.6.3.1.10.g659a0.dirty

