Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXIJKS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXIJKS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXIJKSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:18:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43423 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbXIJKST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:18:19 -0400
Date: Mon, 10 Sep 2007 19:20:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [25/35] changes in
 NCPFS
Message-Id: <20070910192012.a0aeed81.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in NCPFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/ncpfs/symlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/ncpfs/symlink.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/ncpfs/symlink.c
+++ test-2.6.23-rc4-mm1/fs/ncpfs/symlink.c
@@ -42,7 +42,7 @@
 
 static int ncp_symlink_readpage(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	int error, length, len;
 	char *link, *rawlink;
 	char *buf = kmap(page);

