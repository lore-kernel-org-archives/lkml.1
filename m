Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXGOUCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXGOUCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXGOUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbXGOUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:32 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] frv: missing __clear_user()
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Message-Id: <E1IAAGd-00055H-VR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-frv/uaccess.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-frv/uaccess.h b/include/asm-frv/uaccess.h
index 3d90e10..53650c9 100644
--- a/include/asm-frv/uaccess.h
+++ b/include/asm-frv/uaccess.h
@@ -277,6 +277,8 @@ extern long __memcpy_user(void *dst, const void *src, unsigned long count);
 
 #endif
 
+#define __clear_user clear_user
+
 static inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-- 
1.5.3.GIT


