Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYKTOxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYKTOxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYKTOoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:44:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbYKTOoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:44:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/45] CacheFiles: Export things for CacheFiles [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:43:53 +0000
Message-ID: <20081120144353.10667.43664.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export a number of functions for CacheFiles's use.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/super.c          |    1 +
 security/security.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/fs/super.c b/fs/super.c
index 400a760..247ab50 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -270,6 +270,7 @@ int fsync_super(struct super_block *sb)
 	__fsync_super(sb);
 	return sync_blockdev(sb->s_bdev);
 }
+EXPORT_SYMBOL_GPL(fsync_super);
 
 /**
  *	generic_shutdown_super	-	common helper for ->kill_sb()
diff --git a/security/security.c b/security/security.c
index 038ef04..2e3449e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -361,6 +361,7 @@ int security_inode_create(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_create(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_create);
 
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry)
@@ -391,6 +392,7 @@ int security_inode_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		return 0;
 	return security_ops->inode_mkdir(dir, dentry, mode);
 }
+EXPORT_SYMBOL_GPL(security_inode_mkdir);
 
 int security_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {

