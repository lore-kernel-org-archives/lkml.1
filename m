Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbXIJKI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbXIJKI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXIJKIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:08:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34396 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbXIJKIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:08:49 -0400
Date: Mon, 10 Sep 2007 19:09:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [18/35] changes in
 HFSPLUS
Message-Id: <20070910190947.64391cfe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in HFSPLUS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/hfsplus/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/hfsplus/inode.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/hfsplus/inode.c
+++ test-2.6.23-rc4-mm1/fs/hfsplus/inode.c
@@ -44,7 +44,7 @@ static sector_t hfsplus_bmap(struct addr
 
 static int hfsplus_releasepage(struct page *page, gfp_t mask)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	struct super_block *sb = inode->i_sb;
 	struct hfs_btree *tree;
 	struct hfs_bnode *node;

