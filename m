Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab0BDR1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:27:40 -0500
Received: from kroah.org ([198.145.64.141]:34897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342Ab0BDRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:20 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:21 2010
Message-Id: <20100204171520.953500027@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [58/74] random: Remove unused inode variable
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit cd1510cb5f892907fe1a662f90b41fb3a42954e0 upstream.

The previous changeset left behind an unused inode variable.
This patch removes it.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1101,7 +1101,6 @@ static ssize_t random_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)
 {
 	size_t ret;
-	struct inode *inode = file->f_path.dentry->d_inode;
 
 	ret = write_pool(&blocking_pool, buffer, count);
 	if (ret)


