Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbXIJKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbXIJKBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXIJKBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:01:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41812 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXIJKBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:01:11 -0400
Date: Mon, 10 Sep 2007 19:02:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: hch@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [14/35] changes in
 freevxfs
Message-Id: <20070910190249.c5da3b58.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in freevxfs.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/freevxfs/vxfs_immed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/freevxfs/vxfs_immed.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/freevxfs/vxfs_immed.c
+++ test-2.6.23-rc4-mm1/fs/freevxfs/vxfs_immed.c
@@ -98,7 +98,7 @@ vxfs_immed_follow_link(struct dentry *dp
 static int
 vxfs_immed_readpage(struct file *fp, struct page *pp)
 {
-	struct vxfs_inode_info	*vip = VXFS_INO(pp->mapping->host);
+	struct vxfs_inode_info	*vip = VXFS_INO(page_inode(pp));
 	u_int64_t	offset = (u_int64_t)pp->index << PAGE_CACHE_SHIFT;
 	caddr_t		kaddr;
 

