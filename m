Return-Path: <linux-kernel-owner+w=401wt.eu-S1030812AbXCNJWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812AbXCNJWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030814AbXCNJWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:22:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60563 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030796AbXCNJUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:20:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 15/17] kill bogus casts in amd64 uaccess.h
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPee-0003bH-2R@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:20:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-x86_64/uaccess.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86_64/uaccess.h b/include/asm-x86_64/uaccess.h
index 1981f70..9df30b9 100644
--- a/include/asm-x86_64/uaccess.h
+++ b/include/asm-x86_64/uaccess.h
@@ -373,12 +373,12 @@ extern long __copy_user_nocache(void *dst, const void __user *src, unsigned size
 static inline int __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
 	might_sleep();
-	return __copy_user_nocache(dst, (__force void *)src, size, 1);
+	return __copy_user_nocache(dst, src, size, 1);
 }
 
 static inline int __copy_from_user_inatomic_nocache(void *dst, const void __user *src, unsigned size)
 {
-	return __copy_user_nocache(dst, (__force void *)src, size, 0);
+	return __copy_user_nocache(dst, src, size, 0);
 }
 
 #endif /* __X86_64_UACCESS_H */
-- 
1.5.0-rc2.GIT


