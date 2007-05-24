Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbXEXAin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbXEXAin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761099AbXEXAgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40226 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbXEXAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:23 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Yiannis Pericleous <yiannos@fsl.cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 20/21] Unionfs: Removed a trailing whitespace
Date: Wed, 23 May 2007 20:36:10 -0400
Message-Id: <11799669742692-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yiannis Pericleous <yiannos@fsl.cs.sunysb.edu>

Signed-off-by: Yiannis Pericleous <yiannos@fsl.cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index bfd6c24..fe02941 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -699,10 +699,12 @@ out_no_change:
 	i = atomic_inc_return(&UNIONFS_SB(sb)->generation);
 	atomic_set(&UNIONFS_D(sb->s_root)->generation, i);
 	atomic_set(&UNIONFS_I(sb->s_root->d_inode)->generation, i);
-	if (!(*flags & MS_SILENT)) 
-		printk("unionfs: new generation number %d\n", i);
+
 	err = 0;		/* reset to success */
 
+	if (!(*flags & MS_SILENT))
+		printk("unionfs: new generation number %d\n", i);
+
 	/*
 	 * The code above falls through to the next label, and releases the
 	 * refcnts of the older ones (stored in tmp_*): if we fell through
-- 
1.5.2.rc1.165.gaf9b

