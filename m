Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYBQDCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYBQDCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbYBQC6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:37 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36369 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYBQC6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:32 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 05/17] Unionfs: initialize path_save variable
Date: Sat, 16 Feb 2008 21:57:14 -0500
Message-Id: <12032170493255-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not strictly necessary, but it helps quiet a gcc-4.2 warning (a good
optimizer may optimize this initialization away).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 0b92da2..8d939dc 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -246,7 +246,7 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 				     struct dentry *dentry,
 				     struct nameidata *nd)
 {
-	struct path path_save;
+	struct path path_save = {NULL, NULL};
 	struct dentry *ret;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
-- 
1.5.2.2

