Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbYG3CqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbYG3CqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYG3Co0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:26 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46259 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYG3CoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:20 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 19/19] Unionfs: use new kmem_cache_create constructor prototype
Date: Tue, 29 Jul 2008 22:43:49 -0400
Message-Id: <12173858463277-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 1f4b3f4..e774ef3 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -900,7 +900,7 @@ static void unionfs_destroy_inode(struct inode *inode)
 }
 
 /* unionfs inode cache constructor */
-static void init_once(struct kmem_cache *cachep, void *obj)
+static void init_once(void *obj)
 {
 	struct unionfs_inode_info *i = obj;
 
-- 
1.5.2.2

