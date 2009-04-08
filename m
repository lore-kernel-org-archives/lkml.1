Return-Path: <linux-kernel-owner+w=401wt.eu-S1764500AbZDHL1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764500AbZDHL1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762844AbZDHLWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35037 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762743AbZDHLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:47 -0400
X-Sasl-enc: 412qZeLrjWYtDQL+NhwwgakvEXuFc9LpM71GXDH9+vSl 1239189766
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 12/56] hpfs: Remove void casts
Date: Wed,  8 Apr 2009 12:21:44 +0100
Message-Id: <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
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
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/hpfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index fecf402..ab539dc 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -164,7 +164,7 @@ static struct kmem_cache * hpfs_inode_cachep;
 static struct inode *hpfs_alloc_inode(struct super_block *sb)
 {
 	struct hpfs_inode_info *ei;
-	ei = (struct hpfs_inode_info *)kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
+	ei = kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
-- 
1.5.4.3

