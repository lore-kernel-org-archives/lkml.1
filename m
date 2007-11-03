Return-Path: <linux-kernel-owner+w=401wt.eu-S1762907AbXKCBZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762907AbXKCBZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbXKCBXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35212 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbXKCBXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:17 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 8/8] Unionfs/VFS: no need to export 2 symbols in security/security.c
Date: Fri,  2 Nov 2007 21:22:49 -0400
Message-Id: <11940529733128-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
References: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 security/security.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/security/security.c b/security/security.c
index 95a6733..0e1f1f1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -409,7 +409,6 @@ int security_inode_permission(struct inode *inode, int mask, struct nameidata *n
 		return 0;
 	return security_ops->inode_permission(inode, mask, nd);
 }
-EXPORT_SYMBOL(security_inode_permission);
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -519,7 +518,6 @@ int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return security_ops->file_ioctl(file, cmd, arg);
 }
-EXPORT_SYMBOL(security_file_ioctl);
 
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-- 
1.5.2.2

