Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZGMG3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZGMG3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZGMG3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:29:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:60441 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZGMG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 2/8] IA64: remove NULL flush_write_buffers
Date: Mon, 13 Jul 2009 15:25:54 +0900
Message-Id: <1247466360-13330-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_write_buffers() in dma-mapping-common.h was removed so we can
remove NULL flush_write_buffers() in IA64.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/dma-mapping.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 5a61b5c..fe9c822 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -44,7 +44,6 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 #define get_dma_ops(dev) platform_dma_get_ops(dev)
-#define flush_write_buffers()
 
 #include <asm-generic/dma-mapping-common.h>
 
-- 
1.6.0.6

