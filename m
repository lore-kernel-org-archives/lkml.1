Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYLHL63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYLHL63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbYLHLy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:54:29 -0500
Received: from smtp.nokia.com ([192.100.122.233]:32522 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053AbYLHLy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:54:28 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 1/1] fs: fix warning message with inserting a single space
Date: Mon,  8 Dec 2008 13:54:12 +0200
Message-Id: <1228737252-31948-1-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.6.0.4.836.gd5cb
X-OriginalArrivalTime: 08 Dec 2008 11:54:14.0261 (UTC) FILETIME=[B0DE8A50:01C9592B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 fs/libfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 1add676..8e6fa43 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -453,7 +453,7 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 
 		/* warn if it tries to conflict with the root inode */
 		if (unlikely(i == 1))
-			printk(KERN_WARNING "%s: %s passed in a files array"
+			printk(KERN_WARNING "%s: %s passed in a files array "
 				"with an index of 1!\n", __func__,
 				s->s_type->name);
 
-- 
1.6.0.4.836.gd5cb

