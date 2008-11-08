Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKHItc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKHItc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYKHItW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:49:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:55149 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYKHItV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ElfZljc7zZ/ZZifpF4HO5ZwWCBkuKpsSEakFuYc7U0YL/6taNnTUi1oaAhQ3+Xgj3K
         71kcJj415b2kBl1Vj86nK5FPYchShFQERJyk1e9LqCcxBnLF/VgMcHImTFKZnflM79ei
         FljBeRJBfP0K/L47wRZpa8Fwn6zfTc29Bmf+Q=
Date: Sat, 8 Nov 2008 16:48:33 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] /fs/ecryptfs/inode.c: cleanup kerneldoc
Message-ID: <20081108164833.71ab8742@ubuntu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arguments lower_dentry and ecryptfs_dentry in ecryptfs_create_underlying_file()
have been merged into dentry, now fix it.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 89209f0..b17146f 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -52,8 +52,7 @@ static void unlock_dir(struct dentry *dir)
 /**
  * ecryptfs_create_underlying_file
  * @lower_dir_inode: inode of the parent in the lower fs of the new file
- * @lower_dentry: New file's dentry in the lower fs
- * @ecryptfs_dentry: New file's dentry in ecryptfs
+ * @dentry: New file's dentry
  * @mode: The mode of the new file
  * @nd: nameidata of ecryptfs' parent's dentry & vfsmount
  *
