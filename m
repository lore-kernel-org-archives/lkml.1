Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZBCXTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZBCXTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZBCXTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:19:35 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:54635 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbZBCXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:19:32 -0500
X-MUA: Evolution 2.24.3 
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQEACtgiElQLLDG/2dsb2JhbACBbs15hBQG
X-IronPort-AV: E=Sophos;i="4.37,374,1231113600"; 
   d="scan'208";a="141965925"
Subject: [PATCH] cramfs: explicitly state type of unsigned int
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 23:18:43 +0000
Message-Id: <1233703123.20790.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was using cramfs as a model for a new filesystem and came across this,
rather confusing issue...

These variables are currently declared with only a type modifier, not a
type.

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---


diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a07338d..d9210bc 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -136,7 +136,7 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
 {
 	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 	struct page *pages[BLKS_PER_BUF];
-	unsigned i, blocknr, buffer;
+	unsigned int i, blocknr, buffer;
 	unsigned long devsize;
 	char *data;

