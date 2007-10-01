Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXJAFwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXJAFwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXJAFvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:24 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40707 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbXJAFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:19 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/19] Unionfs: minor comment cleanups
Date: Mon,  1 Oct 2007 01:50:40 -0400
Message-Id: <11912178583740-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |    2 +-
 fs/unionfs/mmap.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 94e4c8e..53668d6 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -206,7 +206,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		}
 
 		if (wh_lower_dentry->d_inode) {
-			/* We found a whiteout so lets give up. */
+			/* We found a whiteout so let's give up. */
 			if (S_ISREG(wh_lower_dentry->d_inode->i_mode)) {
 				set_dbend(dentry, bindex);
 				set_dbopaque(dentry, bindex);
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index bcd4267..cf9545e 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -293,7 +293,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	lower_file->f_pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + from;
 
 	/*
-	 * SP: I use vfs_write instead of copying page data and the
+	 * We use vfs_write instead of copying page data and the
 	 * prepare_write/commit_write combo because file system's like
 	 * GFS/OCFS2 don't like things touching those directly,
 	 * calling the underlying write op, while a little bit slower, will
-- 
1.5.2.2

