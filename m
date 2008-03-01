Return-Path: <linux-kernel-owner+w=401wt.eu-S1762509AbYCAQU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762509AbYCAQU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbYCAQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:19:43 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55590 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157AbYCAQTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:19:42 -0500
Date: Sat, 1 Mar 2008 18:18:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport blk_rq_map_user_iov
Message-ID: <20080301161816.GI25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused export of blk_rq_map_user_iov.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
76229376e92479701b97d25bd3513d8c35f7646e foobar
diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..35ec03d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -215,7 +215,6 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
-EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
  * blk_rq_unmap_user - unmap a request with user data

