Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbYLaRuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbYLaRuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYLaRuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:50:06 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:51092 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbYLaRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:50:05 -0500
Date: Wed, 31 Dec 2008 09:49:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] fs/inode: fix kernel-doc notation
Message-Id: <20081231094904.2337e571.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.495BB092.0250:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation:

Warning(linux-2.6.28-git3//fs/inode.c:120): No description found for parameter 'sb'
Warning(linux-2.6.28-git3//fs/inode.c:120): No description found for parameter 'inode'
Warning(linux-2.6.28-git3//fs/inode.c:588): No description found for parameter 'sb'
Warning(linux-2.6.28-git3//fs/inode.c:588): No description found for parameter 'inode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.28-git3.orig/fs/inode.c
+++ linux-2.6.28-git3/fs/inode.c
@@ -110,8 +110,8 @@ static void wake_up_inode(struct inode *
 
 /**
  * inode_init_always - perform inode structure intialisation
- * @sb		- superblock inode belongs to.
- * @inode	- inode to initialise
+ * @sb: superblock inode belongs to
+ * @inode: inode to initialise
  *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
@@ -574,8 +574,8 @@ __inode_add_to_lists(struct super_block 
 
 /**
  * inode_add_to_lists - add a new inode to relevant lists
- * @sb		- superblock inode belongs to.
- * @inode	- inode to mark in use
+ * @sb: superblock inode belongs to
+ * @inode: inode to mark in use
  *
  * When an inode is allocated it needs to be accounted for, added to the in use
  * list, the owning superblock and the inode hash. This needs to be done under
