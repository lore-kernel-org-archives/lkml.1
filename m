Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXJNSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXJNSeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXJNSeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:34:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbXJNSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:34:11 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] mm/migrate.c __user annotation
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8Hy-00040O-5S@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:34:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e2fdbce..07f22d4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -972,7 +972,7 @@ asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
 	 * array. Return various errors if the user did something wrong.
 	 */
 	for (i = 0; i < nr_pages; i++) {
-		const void *p;
+		const void __user *p;
 
 		err = -EFAULT;
 		if (get_user(p, pages + i))
-- 
1.5.3.GIT


