Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYC2DId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYC2DId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759367AbYC2DIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:08:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49764 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358AbYC2DH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:07:59 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] futex_compat __user annotation
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRQE-0002bB-IL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:07:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/futex_compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index ff90f04..04ac3a9 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -30,7 +30,7 @@ fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
 	return 0;
 }
 
-static void __user *futex_uaddr(struct robust_list *entry,
+static void __user *futex_uaddr(struct robust_list __user *entry,
 				compat_long_t futex_offset)
 {
 	compat_uptr_t base = ptr_to_compat(entry);
-- 
1.5.3.GIT


