Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbYCAQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbYCAQT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYCAQTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:19:20 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38946 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbYCAQTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:19:20 -0500
Date: Sat, 1 Mar 2008 18:17:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] block/blk-tag.c should #include "blk.h"
Message-ID: <20080301161754.GE25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global functions (in this case for __blk_queue_free_tags()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0edfc0436c5d278bb3272aa6ce3044052b137f99 foobar
diff --git a/block/blk-tag.c b/block/blk-tag.c
index a8c37d4..4780a46 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -6,6 +6,8 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 
+#include "blk.h"
+
 /**
  * blk_queue_find_tag - find a request by its tag and queue
  * @q:	 The request queue for the device

