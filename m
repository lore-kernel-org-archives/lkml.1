Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYKPFuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYKPFuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYKPFuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:50:06 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:34283 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbYKPFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=NYlSc6fKYF1LfYirAGcbUiOgqyUP5r9x8YrD/XkRwJtRzG3fTk6DRPLU7kz5DPv541
         STTKaEMBHwWKWx8UNzdJP/QxZ5zV817xqg1yQG6cScqKQy71+dECS2uPRf2AnmBSjWwP
         CH07cseTU2p42aY1atU4fR3mnEdbp2jPd7H04=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: Mingming Cao <cmm@us.ibm.com>
Cc: qhfeng.kernel@gmail.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] EXT2: cleanup comment of ext2_splice_branch 
Date: Sun, 16 Nov 2008 13:49:51 +0800
User-Agent: sniper-patch-carrier/1.02
Message-ID: <491fb489.04506e0a.0b9a.ffff85fb@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No argument named @chain in ext2_splice_branch,
remove it.

The comments of ext{3|4}_splice_branch and some other 
functions in */inode.c shoud be updated too, but I 
am not sure how to change them precisely.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7658b33..da31ee9 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -497,8 +497,6 @@ static int ext2_alloc_branch(struct inode *inode,
  * ext2_splice_branch - splice the allocated branch onto inode.
  * @inode: owner
  * @block: (logical) number of block we are adding
- * @chain: chain of indirect blocks (with a missing link - see
- *	ext2_alloc_branch)
  * @where: location of missing link
  * @num:   number of indirect blocks we are adding
  * @blks:  number of direct blocks we are adding

