Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXISV0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXISV0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXISVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52802 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbXISVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:00 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/6] Unionfs: add missing newlines to printks
Date: Wed, 19 Sep 2007 17:24:37 -0400
Message-Id: <11902370823359-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
References: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index f32922e..91f9780 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -438,13 +438,13 @@ static void unionfs_d_release(struct dentry *dentry)
 	unionfs_check_dentry(dentry);
 	/* this could be a negative dentry, so check first */
 	if (!UNIONFS_D(dentry)) {
-		printk(KERN_DEBUG "unionfs: dentry without private data: %.*s",
+		printk(KERN_DEBUG "unionfs: dentry without private data: %.*s\n",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out;
 	} else if (dbstart(dentry) < 0) {
 		/* this is due to a failed lookup */
 		printk(KERN_DEBUG "unionfs: dentry without lower "
-		       "dentries: %.*s",
+		       "dentries: %.*s\n",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out_free;
 	}
-- 
1.5.2.2

