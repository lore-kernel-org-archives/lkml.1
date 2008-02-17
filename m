Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYBQIRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYBQIRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYBQIQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:16:57 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36784 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbYBQIQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:16:56 -0500
Date: Sun, 17 Feb 2008 10:16:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Nick Piggin <npiggin@suse.de>, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [2.6 patch] make fs/buffer.c:cont_expand_zero() static
Message-ID: <20080217081630.GA3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cont_expand_zero() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 15 Jun 2007

--- linux-2.6.22-rc4-mm2/fs/buffer.c.old	2007-06-14 01:51:08.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/buffer.c	2007-06-14 01:51:42.000000000 +0200
@@ -2181,8 +2181,8 @@
 	return err;
 }
 
-int cont_expand_zero(struct file *file, struct address_space *mapping,
-			loff_t pos, loff_t *bytes)
+static int cont_expand_zero(struct file *file, struct address_space *mapping,
+			    loff_t pos, loff_t *bytes)
 {
 	struct inode *inode = mapping->host;
 	unsigned blocksize = 1 << inode->i_blkbits;

