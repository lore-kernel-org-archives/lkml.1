Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbYBMV3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbYBMV3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYBMV3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:29:33 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55629 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYBMV3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:29:32 -0500
Date: Wed, 13 Feb 2008 23:29:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make blk-core.c:request_cachep static again
Message-ID: <20080213212914.GB3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_cachep needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
11b0ecec3d7a5208d95dd95392815a4785d70844 
diff --git a/block/blk-core.c b/block/blk-core.c
index 8ff9944..36588ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -37,7 +37,7 @@ static int __make_request(struct request_queue *q, struct bio *bio);
 /*
  * For the allocated request tables
  */
-struct kmem_cache *request_cachep;
+static struct kmem_cache *request_cachep;
 
 /*
  * For queue allocation

