Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbXKNFBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbXKNFBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbXKNFBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:01:23 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:40310 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXKNFBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:01:22 -0500
Date: Wed, 14 Nov 2007 10:30:54 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk,
       apw@shadowen.org
Subject: [PATCH] 2.6.24-rc2-mm1 - Build Fail - fs/bfs/inode.c
Message-ID: <20071114050054.GB12453@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, with following error

fs/bfs/inode.c: In function ‘bfs_iget’:
fs/bfs/inode.c:37: error: ‘ino’ redeclared as different kind of symbol
fs/bfs/inode.c:35: error: previous definition of ‘ino’ was here
fs/bfs/inode.c:37: error: ‘inode’ undeclared (first use in this function)
fs/bfs/inode.c:37: error: (Each undeclared identifier is reported onlyonce
fs/bfs/inode.c:37: error: for each function it appears in.)
make[2]: *** [fs/bfs/inode.o] Error 1
make[1]: *** [fs/bfs] Error 2
make: *** [fs] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc2/fs/bfs/inode.c	2007-11-14 09:53:41.000000000 +0530
+++ linux-2.6.24-rc2/fs/bfs/~inode.c	2007-11-14 10:21:06.000000000 +0530
@@ -34,7 +34,6 @@ void dump_imap(const char *prefix, struc
 
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
-	unsigned long ino = inode->i_ino;
 	struct bfs_inode *di;
 	struct inode *inode;
 	struct buffer_head *bh;

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
