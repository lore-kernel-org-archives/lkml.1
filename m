Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbXKTCIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbXKTCIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbXKTBx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:53:58 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2204 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759515AbXKTBxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:52 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 49/59] fs/ufs: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:36 -0800
Message-Id: <1195523627-15389-7-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-6-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
 <1195523627-15389-3-git-send-email-joe@perches.com>
 <1195523627-15389-4-git-send-email-joe@perches.com>
 <1195523627-15389-5-git-send-email-joe@perches.com>
 <1195523627-15389-6-git-send-email-joe@perches.com>
Message-Id: <ffd427b1785990d5c177b795ce4f9a9fc4d614ec.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ufs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 30f8c2b..d19dfe8 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -180,7 +180,7 @@ bad_entry:
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
 	ufs_error (sb, "ext2_check_page",
-		   "entry in directory #%lu spans the page boundary"
+		   "entry in directory #%lu spans the page boundary "
 		   "offset=%lu",
 		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
 fail:
-- 
1.5.3.5.652.gf192c

