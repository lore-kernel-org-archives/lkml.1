Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYCAQUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYCAQUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYCAQTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:19:38 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38955 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762374AbYCAQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:19:37 -0500
Date: Sat, 1 Mar 2008 18:18:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport blk_{get,put}_queue
Message-ID: <20080301161812.GH25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused exports of blk_{get,put}_queue.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 block/blk-core.c |    2 --
 1 file changed, 2 deletions(-)

ad857eb2fc3211685b20148d452529ad51d9d4be foobar
diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..195f1cf 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -424,7 +424,6 @@ void blk_put_queue(struct request_queue *q)
 {
 	kobject_put(&q->kobj);
 }
-EXPORT_SYMBOL(blk_put_queue);
 
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -592,7 +591,6 @@ int blk_get_queue(struct request_queue *q)
 
 	return 1;
 }
-EXPORT_SYMBOL(blk_get_queue);
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {

