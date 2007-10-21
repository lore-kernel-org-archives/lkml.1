Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXJUXw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXJUXw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXJUXvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49206 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbXJUXvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:49 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 6/9] Unionfs: convert a printk to pr_debug in release
Date: Sun, 21 Oct 2007 19:51:19 -0400
Message-Id: <1193010685761-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly an informational message, not an error.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 6bab9d6..a3d7b6e 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -455,9 +455,9 @@ static void unionfs_d_release(struct dentry *dentry)
 		goto out;
 	} else if (dbstart(dentry) < 0) {
 		/* this is due to a failed lookup */
-		printk(KERN_ERR "unionfs: dentry without lower "
-		       "dentries: %.*s\n",
-		       dentry->d_name.len, dentry->d_name.name);
+		pr_debug("unionfs: dentry without lower "
+			 "dentries: %.*s\n",
+			 dentry->d_name.len, dentry->d_name.name);
 		goto out_free;
 	}
 
-- 
1.5.2.2

