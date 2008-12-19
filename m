Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYLSAUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYLSAUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYLSAU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:20:29 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:24364 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYLSAU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:20:28 -0500
Date: Thu, 18 Dec 2008 16:14:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Chinner <david@fromorbit.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for December 18 (patch: kernel-doc notation)
Message-Id: <20081218161437.fe2d2675.randy.dunlap@oracle.com>
In-Reply-To: <20081218230637.c879a046.sfr@canb.auug.org.au>
References: <20081218230637.c879a046.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.494AE770.0158:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/inode.c and mm/filemap.c need kernel-doc fixes.

What tree were these merged into for linux-next?
How do I get these doc fixes merged?  (2 patches below)

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix fs/inode.c kernel-doc function parameters:

Warning(linux-next-20081218//fs/inode.c:120): No description found for parameter 'sb'
Warning(linux-next-20081218//fs/inode.c:120): No description found for parameter 'inode'
Warning(linux-next-20081218//fs/inode.c:588): No description found for parameter 'sb'
Warning(linux-next-20081218//fs/inode.c:588): No description found for parameter 'inode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Dave Chinner <david@fromorbit.com>
---
 fs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20081218.orig/fs/inode.c
+++ linux-next-20081218/fs/inode.c
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

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mm/filemap.c functions' kernel-doc:

Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:575): No description found for parameter 'page'
Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:575): No description found for parameter 'waiter'
Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:2348): No description found for parameter 'mapping'
Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:2348): No description found for parameter 'index'
Warning(/local/linsrc/linux-next-20081218//mm/filemap.c:2348): No description found for parameter 'source'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Dave Chinner <david@fromorbit.com>
---
 mm/filemap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- linux-next-20081218.orig/mm/filemap.c
+++ linux-next-20081218/mm/filemap.c
@@ -566,8 +566,8 @@ EXPORT_SYMBOL(wait_on_page_bit);
 
 /**
  * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
- * @page - Page defining the wait queue of interest
- * @waiter - Waiter to add to the queue
+ * @page: Page defining the wait queue of interest
+ * @waiter: Waiter to add to the queue
  *
  * Add an arbitrary @waiter to the wait queue for the nominated @page.
  */
@@ -2328,11 +2328,10 @@ generic_file_buffered_write(struct kiocb
 EXPORT_SYMBOL(generic_file_buffered_write);
 
 /**
- * generic_file_buffered_write_one_page - Write a single page of data to an
- *	inode
- * @mapping - The address space of the target inode
- * @index - The target page in the target inode to fill
- * @source - The data to write into the target page
+ * generic_file_buffered_write_one_page - Write a single page of data to an inode
+ * @mapping: The address space of the target inode
+ * @index: The target page in the target inode to fill
+ * @source: The data to write into the target page
  *
  * Write the data from the source page to the page in the nominated address
  * space at the @index specified.  Note that the file will not be extended if
