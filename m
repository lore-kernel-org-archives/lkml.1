Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXLJC67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXLJC67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXLJCq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:46:27 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49954 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbXLJCqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:46:24 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Mike Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH 40/42] eCryptfs: use simplified fs_stack API for dentry operations
Date: Sun,  9 Dec 2007 21:42:13 -0500
Message-Id: <11972545621722-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Mike Halcrow <mhalcrow@us.ibm.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/ecryptfs/dentry.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index cb20b96..a8c1686 100644
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -62,7 +62,7 @@ static int ecryptfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
 
-		fsstack_copy_attr_all(dentry->d_inode, lower_inode, NULL);
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode);
 	}
 out:
 	return rc;
-- 
1.5.2.2

