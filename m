Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbYBMVeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbYBMVeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763344AbYBMVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:09 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47469 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbYBMVaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:05 -0500
Date: Wed, 13 Feb 2008 23:29:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make blk_ioc_init() static
Message-ID: <20080213212949.GM3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_ioc_init() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6df9a0aeeeac4ae589ee18ffbdf4897ab36d7233 diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 80245dc..4ae0929 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -176,7 +176,7 @@ void copy_io_context(struct io_context **pdst, struct io_context **psrc)
 }
 EXPORT_SYMBOL(copy_io_context);
 
-int __init blk_ioc_init(void)
+static int __init blk_ioc_init(void)
 {
 	iocontext_cachep = kmem_cache_create("blkdev_ioc",
 			sizeof(struct io_context), 0, SLAB_PANIC, NULL);
