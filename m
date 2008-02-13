Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbYBMVem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbYBMVem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763410AbYBMVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:12 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50773 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763152AbYBMVaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:07 -0500
Date: Wed, 13 Feb 2008 23:29:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make blk_settings_init() static
Message-ID: <20080213212951.GN3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_settings_init() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2d96ca5afae850c7cb192e340b2d76fb687e9861 diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8d0c57..13536a3 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -386,7 +386,7 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
-int __init blk_settings_init(void)
+static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
 	blk_max_pfn = max_pfn - 1;
