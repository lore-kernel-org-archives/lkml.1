Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXE1IhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXE1IhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759184AbXE1Igd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4651 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbXE1Igb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:31 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069461:sNHT20984971"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Aubrey Li <aubrey.li@analog.com>, Bryan Wu <bryan.wu@analog.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 02/20] Blackfin arch: DMA code minor naming convention fix
Date: Mon, 28 May 2007 16:37:37 +0800
Message-Id: <11803414761748-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aubrey Li <aubrey.li@analog.com>

Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 0ccb0dc..069a896 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -595,7 +595,7 @@ unsigned short get_dma_curr_ycount(unsigned int channel)
 }
 EXPORT_SYMBOL(get_dma_curr_ycount);
 
-void *_dma_memcpy(void *dest, const void *src, size_t size)
+static void *__dma_memcpy(void *dest, const void *src, size_t size)
 {
 	int direction;	/* 1 - address decrease, 0 - address increase */
 	int flag_align;	/* 1 - address aligned,  0 - address unaligned */
@@ -744,8 +744,8 @@ void *dma_memcpy(void *dest, const void *src, size_t size)
 	bulk = (size >> 16) << 16;
 	rest = size - bulk;
 	if (bulk)
-		_dma_memcpy(dest, src, bulk);
-	addr = _dma_memcpy(dest+bulk, src+bulk, rest);
+		__dma_memcpy(dest, src, bulk);
+	addr = __dma_memcpy(dest+bulk, src+bulk, rest);
 	return addr;
 }
 
-- 
1.5.2
