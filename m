Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbYDXXJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbYDXXJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYDXXGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:06:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYDXXG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:06:28 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/24] m32r: types: use <asm-generic/int-*.h> for the m32r architecture
Date: Thu, 24 Apr 2008 16:05:27 -0700
Message-Id: <1209078352-7593-21-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-20-git-send-email-hpa@zytor.com>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
 <1209078352-7593-2-git-send-email-hpa@zytor.com>
 <1209078352-7593-3-git-send-email-hpa@zytor.com>
 <1209078352-7593-4-git-send-email-hpa@zytor.com>
 <1209078352-7593-5-git-send-email-hpa@zytor.com>
 <1209078352-7593-6-git-send-email-hpa@zytor.com>
 <1209078352-7593-7-git-send-email-hpa@zytor.com>
 <1209078352-7593-8-git-send-email-hpa@zytor.com>
 <1209078352-7593-9-git-send-email-hpa@zytor.com>
 <1209078352-7593-10-git-send-email-hpa@zytor.com>
 <1209078352-7593-11-git-send-email-hpa@zytor.com>
 <1209078352-7593-12-git-send-email-hpa@zytor.com>
 <1209078352-7593-13-git-send-email-hpa@zytor.com>
 <1209078352-7593-14-git-send-email-hpa@zytor.com>
 <1209078352-7593-15-git-send-email-hpa@zytor.com>
 <1209078352-7593-16-git-send-email-hpa@zytor.com>
 <1209078352-7593-17-git-send-email-hpa@zytor.com>
 <1209078352-7593-18-git-send-email-hpa@zytor.com>
 <1209078352-7593-19-git-send-email-hpa@zytor.com>
 <1209078352-7593-20-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies <asm-m32r/types.h> to use the <asm-generic/int-*.h>
generic include files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-m32r/types.h |   32 ++------------------------------
 1 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/include/asm-m32r/types.h b/include/asm-m32r/types.h
index b64c166..bc9f7ff 100644
--- a/include/asm-m32r/types.h
+++ b/include/asm-m32r/types.h
@@ -1,28 +1,12 @@
 #ifndef _ASM_M32R_TYPES_H
 #define _ASM_M32R_TYPES_H
 
+#include <asm-generic/int-ll64.h>
+
 #ifndef __ASSEMBLY__
 
 typedef unsigned short umode_t;
 
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
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
-#endif
 #endif /* __ASSEMBLY__ */
 
 /*
@@ -34,18 +18,6 @@ __extension__ typedef unsigned long long __u64;
 
 #ifndef __ASSEMBLY__
 
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long long s64;
-typedef unsigned long long u64;
-
 /* DMA addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
-- 
1.5.4.1

