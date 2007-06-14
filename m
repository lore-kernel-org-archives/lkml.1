Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbXFNWRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbXFNWRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbXFNWPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:15:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35386 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757710AbXFNWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:15:35 -0400
Date: Fri, 15 Jun 2007 00:15:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make fs/buffer.c:cont_expand_zero() static
Message-ID: <20070614221545.GX3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cont_expand_zero() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
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

