Return-Path: <linux-kernel-owner+w=401wt.eu-S1764581AbZDHL07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764581AbZDHL07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762890AbZDHLWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39800 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762574AbZDHLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:47 -0400
X-Sasl-enc: eZbUMQw9v6HX4ZiwhWHD47IrRjH+JVoLuKBvB7OrFdIE 1239189765
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 11/56] freevxfs: Remove void casts
Date: Wed,  8 Apr 2009 12:21:43 +0100
Message-Id: <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/freevxfs/vxfs_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 03a6ea5..9811217 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -138,7 +138,7 @@ __vxfs_iget(ino_t ino, struct inode *ilistp)
 	if (!IS_ERR(pp)) {
 		struct vxfs_inode_info	*vip;
 		struct vxfs_dinode	*dip;
-		caddr_t			kaddr = (char *)page_address(pp);
+		caddr_t			kaddr = page_address(pp);
 
 		if (!(vip = kmem_cache_alloc(vxfs_inode_cachep, GFP_KERNEL)))
 			goto fail;
-- 
1.5.4.3

