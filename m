Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYJaDU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYJaDU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYJaDUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:20:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYJaDUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:20:11 -0400
Message-ID: <490A78FE.20201@cn.fujitsu.com>
Date: Fri, 31 Oct 2008 11:18:22 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] Correct wrong function name of d_put in kernel document and
 source comment
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no function named d_put(), it should be dput().

Impact: fix document and comment, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fuijtsu.com>
---
 Documentation/filesystems/vfs.txt |    2 +-
 fs/dcache.c                       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index c4d348d..e663178 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -960,7 +960,7 @@ manipulate dentries:
   d_lookup: look up a dentry given its parent and path name component
 	It looks up the child of that given name from the dcache
 	hash table. If it is found, the reference count is incremented
-	and the dentry is returned. The caller must use d_put()
+	and the dentry is returned. The caller must use dput()
 	to free the dentry when it finishes using it.
 
 For further information on dentry locking, please refer to the document
diff --git a/fs/dcache.c b/fs/dcache.c
index a1d86c7..db2bc6a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1336,7 +1336,7 @@ err_out:
  *
  * Searches the children of the parent dentry for the name in question. If
  * the dentry is found its reference count is incremented and the dentry
- * is returned. The caller must use d_put to free the entry when it has
+ * is returned. The caller must use dput to free the entry when it has
  * finished using it. %NULL is returned on failure.
  *
  * __d_lookup is dcache_lock free. The hash list is protected using RCU.
-- 
1.5.5.3

