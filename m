Return-Path: <linux-kernel-owner+w=401wt.eu-S935011AbZDAXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935011AbZDAXSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934093AbZDAXFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:05:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934102AbZDAXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:05:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/43] CacheFiles: Export things for CacheFiles [ver #46]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 02 Apr 2009 00:05:25 +0100
Message-ID: <20090401230525.28177.27454.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export a number of functions for CacheFiles's use.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/super.c          |    1 +
 security/security.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/fs/super.c b/fs/super.c
index 2ba4815..77cb4ec 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -287,6 +287,7 @@ int fsync_super(struct super_block *sb)
 	__fsync_super(sb);
 	return sync_blockdev(sb->s_bdev);
 }
+EXPORT_SYMBOL_GPL(fsync_super);
 
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
diff --git a/security/security.c b/security/security.c
index 206e538..5284255 100644
--- a/security/security.c
+++ b/security/security.c
@@ -445,6 +445,7 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_create(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_create);
 
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry)
@@ -475,6 +476,7 @@ int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_mkdir(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {

