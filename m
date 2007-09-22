Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXIVCaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXIVCaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 22:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXIVCaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 22:30:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:59453 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbXIVCaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 22:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=tmNlDxshOiZVspjGUKtCxbZfeO5ZlSjuU4SzAZmM9SomHIPK1Hsik7XIC05nIGTrruSOrbuH1wn1JlgH5c/wk3GZSjXfAERcCoRF7qOQ4VhArqQpAhuLjFGGFvoBU7ngMk3wv9Bx1BDssjH9ZIQT6hIDGxQoQXxNl02gs7MMiVs=
Date: Sat, 22 Sep 2007 10:26:00 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, Andrew Morton <akpm@osdl.org>
Subject: [-rc7 Patch] fs/isofs/namei.c: mark variables as uninitialized_var
Message-ID: <20070922022600.GB2480@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix may-be-used-uninitialized warnings.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 fs/isofs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc7/fs/isofs/namei.c
===================================================================
--- linux-2.6.23-rc7.orig/fs/isofs/namei.c
+++ linux-2.6.23-rc7/fs/isofs/namei.c
@@ -158,7 +158,7 @@ isofs_find_entry(struct inode *dir, stru
 struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	int found;
-	unsigned long block, offset;
+	unsigned long uninitialized_var(block), uninitialized_var(offset);
 	struct inode *inode;
 	struct page *page;
 
