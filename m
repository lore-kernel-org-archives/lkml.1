Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYC2DJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYC2DJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759511AbYC2DIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:08:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49854 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507AbYC2DI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:08:29 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] misc __user misannotations (pointless casts to long)
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRQi-0002fW-JN@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:08:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/lguest/lguest_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 2221485..3b67da9 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -182,7 +182,7 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	}
 
 	/* Populate the easy fields of our "struct lguest" */
-	lg->mem_base = (void __user *)(long)args[0];
+	lg->mem_base = (void __user *)args[0];
 	lg->pfn_limit = args[1];
 
 	/* This is the first cpu */
-- 
1.5.3.GIT


