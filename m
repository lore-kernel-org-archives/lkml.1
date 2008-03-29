Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbYC2DL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbYC2DL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYC2DJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:09:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50044 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbYC2DJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:29 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] compat_sys_wait4() prototype misannotation
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRRg-0002pE-KL@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:09:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/compat.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index a671dbf..8fa7857 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -192,8 +192,8 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		struct compat_timeval __user *tvp);
 
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
-				 compat_uint_t *stat_addr, int options,
-				 struct compat_rusage *ru);
+				 compat_uint_t __user *stat_addr, int options,
+				 struct compat_rusage __user *ru);
 
 #define BITS_PER_COMPAT_LONG    (8*sizeof(compat_long_t))
 
-- 
1.5.3.GIT


