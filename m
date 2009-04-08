Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbZDHLah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbZDHLah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763331AbZDHLXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:23:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42272 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761255AbZDHLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:44 -0400
X-Sasl-enc: y18PMoj67/H969oN8CzotURqNESA+TS95+9Q3lf+QUCM 1239189762
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 09/56] efs: Remove void casts
Date: Wed,  8 Apr 2009 12:21:41 +0100
Message-Id: <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/efs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index f049428..6869342 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -59,7 +59,7 @@ static struct kmem_cache * efs_inode_cachep;
 static struct inode *efs_alloc_inode(struct super_block *sb)
 {
 	struct efs_inode_info *ei;
-	ei = (struct efs_inode_info *)kmem_cache_alloc(efs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(efs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
-- 
1.5.4.3

