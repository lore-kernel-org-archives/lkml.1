Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0BTIM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:12:27 -0500
Received: from sh.osrg.net ([192.16.179.4]:38792 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0BTIMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:12:25 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: dhowells@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 2/2] mn10300: add a pointer to Documentation/DMA-API.txt
Date: Sat, 20 Feb 2010 17:09:25 +0900
Message-Id: <1266653365-448-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1266653365-448-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1266653365-448-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 20 Feb 2010 17:11:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/mn10300/include/asm/dma-mapping.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/include/asm/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
index 517d3b6..db71441 100644
--- a/arch/mn10300/include/asm/dma-mapping.h
+++ b/arch/mn10300/include/asm/dma-mapping.h
@@ -17,6 +17,11 @@
 #include <asm/cache.h>
 #include <asm/io.h>
 
+/*
+ * See Documentation/DMA-API.txt for the description of how the
+ * following DMA API should work.
+*/
+
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, int flag);
 
-- 
1.6.5

