Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbXLJCxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbXLJCxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbXLJCoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:44:06 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49826 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbXLJCnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:37 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Mike Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH 42/42] eCryptfs: use simplified fs_stack API for main operations
Date: Sun,  9 Dec 2007 21:42:15 -0500
Message-Id: <1197254564600-git-send-email-ezk@cs.sunysb.edu>
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
 fs/ecryptfs/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index b83a512..cebe7dc 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -208,7 +208,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
-- 
1.5.2.2

