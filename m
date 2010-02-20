Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0BTIM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:12:28 -0500
Received: from sh.osrg.net ([192.16.179.4]:38793 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0BTIM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:12:26 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: dhowells@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 1/2] frv: add a pointer to Documentation/DMA-API.txt
Date: Sat, 20 Feb 2010 17:09:24 +0900
Message-Id: <1266653365-448-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 20 Feb 2010 17:11:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/frv/include/asm/dma-mapping.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
index 20cca40..6af5d83 100644
--- a/arch/frv/include/asm/dma-mapping.h
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -7,6 +7,11 @@
 #include <asm/scatterlist.h>
 #include <asm/io.h>
 
+/*
+ * See Documentation/DMA-API.txt for the description of how the
+ * following DMA API should work.
+ */
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-- 
1.6.5

