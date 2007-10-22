Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXJVEAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXJVEAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXJVD77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:59:59 -0400
Received: from xenotime.net ([66.160.160.81]:58837 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751532AbXJVD76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:59:58 -0400
Date: Sun, 21 Oct 2007 20:59:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] auditsc: fix kernel-doc param warnings
Message-Id: <20071021205953.aaa9b195.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc for auditsc parameter changes.

Warning(linux-2.6.23-git17//kernel/auditsc.c:1623): No description found for parameter 'dentry'
Warning(linux-2.6.23-git17//kernel/auditsc.c:1666): No description found for parameter 'dentry'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-git17.orig/kernel/auditsc.c
+++ linux-2.6.23-git17/kernel/auditsc.c
@@ -1615,7 +1615,7 @@ static void audit_copy_inode(struct audi
 /**
  * audit_inode - store the inode and device from a lookup
  * @name: name being audited
- * @inode: inode being audited
+ * @dentry: dentry being audited
  *
  * Called from fs/namei.c:path_lookup().
  */
@@ -1650,7 +1650,7 @@ void __audit_inode(const char *name, con
 /**
  * audit_inode_child - collect inode info for created/removed objects
  * @dname: inode's dentry name
- * @inode: inode being audited
+ * @dentry: dentry being audited
  * @parent: inode of dentry parent
  *
  * For syscalls that create or remove filesystem objects, audit_inode
---
~Randy
