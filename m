Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXJVSOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXJVSOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXJVSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22193 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXJVSMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:25 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 07/10] [SG] Update swiotlb to use sg helpers
Date: Mon, 22 Oct 2007 20:11:01 +0200
Message-Id: <1193076664-13652-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 752fd95..1a8050a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -35,7 +35,7 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
+#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 #define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
 
 /*
-- 
1.5.3.GIT

