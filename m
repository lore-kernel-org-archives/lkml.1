Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbYBVUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbYBVUCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765958AbYBVT7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:59:20 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34196 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765916AbYBVT7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:59:17 -0500
Date: Fri, 22 Feb 2008 21:58:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ian Campbell <ijc@hellion.org.uk>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, chrisw@sous-sol.org
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make xen-blkfront.c:blkif_getgeo() static
Message-ID: <20080222195829.GH1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global blkif_getgeo() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6f34bfdbb8c24e06d982ccaccd24c25dba5b1956 diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9c6f3f9..ae7ee16 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -136,7 +136,7 @@ static void blkif_restart_queue_callback(void *arg)
 	schedule_work(&info->work);
 }
 
-int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
+static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
 {
 	/* We don't have real geometry info, but let's at least return
 	   values consistent with the size of the device */

