Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbYEFU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbYEFU6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbYEFU56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:57:58 -0400
Received: from mx28.mail.ru ([194.67.23.67]:9530 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233AbYEFU54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:57:56 -0400
Date: Tue, 6 May 2008 23:32:59 +0400
From: Evgeniy Dushistov <dushistov@mail.ru>
To: akpm@linux-foundation.org
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ufs: remove unneeded ufs_put_inode prototype
Message-ID: <20080506193258.GA17215@rain>
Mail-Followup-To: akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>

diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index 244a1aa..11c0351 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -107,7 +107,6 @@ extern struct inode * ufs_new_inode (struct inode *, int);
 
 /* inode.c */
 extern struct inode *ufs_iget(struct super_block *, unsigned long);
-extern void ufs_put_inode (struct inode *);
 extern int ufs_write_inode (struct inode *, int);
 extern int ufs_sync_inode (struct inode *);
 extern void ufs_delete_inode (struct inode *);

-- 
/Evgeniy

