Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbXIJJtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbXIJJtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXIJJtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:49:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57230 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbXIJJtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:49:42 -0400
Date: Mon, 10 Sep 2007 18:51:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: jaharkes@cs.cmu.edu, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [7/35] changes in CODA
Message-Id: <20070910185139.504bc99d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change page->mapping handling in CODA

Singed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/coda/symlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/coda/symlink.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/coda/symlink.c
+++ test-2.6.23-rc4-mm1/fs/coda/symlink.c
@@ -23,7 +23,7 @@
 
 static int coda_symlink_filler(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	int error;
 	struct coda_inode_info *cii;
 	unsigned int len = PAGE_SIZE;

