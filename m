Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYAZJIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYAZJIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYAZJII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:08:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48843 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbYAZJID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:08:03 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove __STRICT_ANSI__ from linux/types.h
Date: Sat, 26 Jan 2008 04:08:01 -0500
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801260408.01631.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the asm-*/types.h headers have been updated to no longer check
__STRICT_ANSI__ for the 64bit types, so this brings linux/types.h in line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/types.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index f4f8d19..60be1ea 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -53,7 +53,7 @@ typedef __kernel_uid_t		uid_t;
 typedef __kernel_gid_t		gid_t;
 #endif /* __KERNEL__ */
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+#if defined(__GNUC__)
 typedef __kernel_loff_t		loff_t;
 #endif
 
@@ -119,7 +119,7 @@ typedef		__u8		uint8_t;
 typedef		__u16		uint16_t;
 typedef		__u32		uint32_t;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+#if defined(__GNUC__)
 typedef		__u64		uint64_t;
 typedef		__u64		u_int64_t;
 typedef		__s64		int64_t;
@@ -181,7 +181,7 @@ typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
 typedef __u32 __bitwise __le32;
 typedef __u32 __bitwise __be32;
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+#if defined(__GNUC__)
 typedef __u64 __bitwise __le64;
 typedef __u64 __bitwise __be64;
 #endif
-- 
1.5.3.8

