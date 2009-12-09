Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZLILri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZLILri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZLILrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:47:36 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43812 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZLILrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:47:35 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NOMMU: ramfs: drop unused local var
Date: Wed,  9 Dec 2009 06:47:40 -0500
Message-Id: <1260359260-14990-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fs/ramfs/file-nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 32fae40..2efc571 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -60,7 +60,7 @@ const struct inode_operations ramfs_file_inode_operations = {
  */
 int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
-	unsigned long npages, xpages, loop, limit;
+	unsigned long npages, xpages, loop;
 	struct page *pages;
 	unsigned order;
 	void *data;
-- 
1.6.5.5

