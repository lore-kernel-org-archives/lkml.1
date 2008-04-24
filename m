Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYDXXSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYDXXSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbYDXXH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:07:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYDXXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:06:44 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/24] alpha: types: use <asm-generic/int-*.h> for the alpha architecture
Date: Thu, 24 Apr 2008 16:05:11 -0700
Message-Id: <1209078352-7593-5-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-4-git-send-email-hpa@zytor.com>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
 <1209078352-7593-2-git-send-email-hpa@zytor.com>
 <1209078352-7593-3-git-send-email-hpa@zytor.com>
 <1209078352-7593-4-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies <asm-alpha/types.h> to use the <asm-generic/int-*.h>
generic include files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-alpha/types.h |   36 +-----------------------------------
 1 files changed, 1 insertions(+), 35 deletions(-)

diff --git a/include/asm-alpha/types.h b/include/asm-alpha/types.h
index f571613..a9e34ca 100644
--- a/include/asm-alpha/types.h
+++ b/include/asm-alpha/types.h
@@ -8,28 +8,12 @@
  * not a major issue.  However, for interoperability, libraries still
  * need to be careful to avoid a name clashes.
  */
+#include <asm-generic/int-l64.h>
 
 #ifndef __ASSEMBLY__
 
 typedef unsigned int umode_t;
 
-/*
- * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
- * header files exported to user space
- */
-
-typedef __signed__ char __s8;
-typedef unsigned char __u8;
-
-typedef __signed__ short __s16;
-typedef unsigned short __u16;
-
-typedef __signed__ int __s32;
-typedef unsigned int __u32;
-
-typedef __signed__ long __s64;
-typedef unsigned long __u64;
-
 #endif /* __ASSEMBLY__ */
 
 /*
@@ -39,23 +23,5 @@ typedef unsigned long __u64;
 
 #define BITS_PER_LONG 64
 
-#ifndef __ASSEMBLY__
-
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long s64;
-typedef unsigned long u64;
-
-typedef u64 dma_addr_t;
-typedef u64 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_TYPES_H */
-- 
1.5.4.1

