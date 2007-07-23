Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXGWID1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXGWID1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763026AbXGWIB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:01:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41702 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758435AbXGWIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:01:55 -0400
Date: Mon, 23 Jul 2007 10:01:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ocfs2_insert_extent(): remove dead code
Message-ID: <20070723080121.GC26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some now dead code.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/ocfs2/alloc.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.22-rc6-mm1/fs/ocfs2/alloc.c.old	2007-07-23 01:29:25.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/ocfs2/alloc.c	2007-07-23 01:29:52.000000000 +0200
@@ -3500,7 +3500,6 @@ int ocfs2_insert_extent(struct ocfs2_sup
 {
 	int status;
 	struct buffer_head *last_eb_bh = NULL;
-	struct buffer_head *bh = NULL;
 	struct ocfs2_insert_type insert = {0, };
 	struct ocfs2_extent_rec rec;
 
@@ -3552,9 +3551,6 @@ int ocfs2_insert_extent(struct ocfs2_sup
 		ocfs2_extent_map_insert_rec(inode, &rec);
 
 bail:
-	if (bh)
-		brelse(bh);
-
 	if (last_eb_bh)
 		brelse(last_eb_bh);
 

