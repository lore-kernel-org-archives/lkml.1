Return-Path: <linux-kernel-owner+w=401wt.eu-S1764186AbZDHLYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764186AbZDHLYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762725AbZDHLWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36657 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbZDHLWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:38 -0400
X-Sasl-enc: L55fSv1u4qUBT7Gm0soeN/wQlyaPXcPQRRrU/OcaG9MA 1239189756
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 04/56] befs: Remove void casts
Date: Wed,  8 Apr 2009 12:21:36 +0100
Message-Id: <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/befs/linuxvfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 76afd0d..cfd9698 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -277,7 +277,7 @@ static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
         struct befs_inode_info *bi;
-        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
+        bi = kmem_cache_alloc(befs_inode_cachep,
 							GFP_KERNEL);
         if (!bi)
                 return NULL;
-- 
1.5.4.3

