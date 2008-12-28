Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYL1GGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYL1GGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 01:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL1GFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 01:05:35 -0500
Received: from sh.osrg.net ([192.16.179.4]:53870 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYL1GFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 01:05:34 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/3] swiotlb: remove unnecessary declaration
Date: Sun, 28 Dec 2008 15:02:06 +0900
Message-Id: <1230444127-587-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1230444127-587-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1230444127-587-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1230444127-587-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1a9d194..db94378 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/swiotlb.h>
 #include <linux/string.h>
 #include <linux/swiotlb.h>
 #include <linux/pfn.h>
@@ -779,8 +778,6 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 				  SYNC_FOR_DEVICE);
 }
 
-void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
-			    struct dma_attrs *);
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_single
-- 
1.5.5.GIT

