Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYC3Wko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYC3Wko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYC3WkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:40:14 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53000 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbYC3WkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:40:13 -0400
Date: Mon, 31 Mar 2008 01:40:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Igor Mammedov <niallain@gmail.com>, Steve French <sfrench@us.ibm.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cifs_dfs_automount_list static
Message-ID: <20080330224001.GB28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global cifs_dfs_automount_list static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/cifs/cifs_dfs_ref.c |    2 +-
 fs/cifs/cifsfs.h       |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

7bd42d48fcdcda24f48c025ca4bfd31b2bf77d46 diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index a1a95b0..33719df 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -23,7 +23,7 @@
 #include "dns_resolve.h"
 #include "cifs_debug.h"
 
-LIST_HEAD(cifs_dfs_automount_list);
+static LIST_HEAD(cifs_dfs_automount_list);
 
 /*
  * DFS functions
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 6897830..dbaefc3 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -62,7 +62,6 @@ extern int cifs_setattr(struct dentry *, struct iattr *);
 
 extern const struct inode_operations cifs_file_inode_ops;
 extern const struct inode_operations cifs_symlink_inode_ops;
-extern struct list_head cifs_dfs_automount_list;
 extern struct inode_operations cifs_dfs_referral_inode_operations;
 
 

