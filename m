Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbYDXXHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbYDXXHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYDXXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:06:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYDXXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:06:22 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 08/24] h8300: types: use <asm-generic/int-*.h> for the h8300 architecture
Date: Thu, 24 Apr 2008 16:05:23 -0700
Message-Id: <1209078352-7593-17-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-16-git-send-email-hpa@zytor.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies <asm-h8300/types.h> to use the <asm-generic/int-*.h>
generic include files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-h8300/types.h |   33 ++-------------------------------
 1 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/include/asm-h8300/types.h b/include/asm-h8300/types.h
index 56566e2..1287519 100644
--- a/include/asm-h8300/types.h
+++ b/include/asm-h8300/types.h
@@ -1,6 +1,8 @@
 #ifndef _H8300_TYPES_H
 #define _H8300_TYPES_H
 
+#include <asm-generic/int-ll64.h>
+
 #if !defined(__ASSEMBLY__)
 
 /*
@@ -14,41 +16,10 @@
 typedef unsigned short umode_t;
 
 /*
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
-
-/*
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
 
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
 #define BITS_PER_LONG 32
 
 /* Dma addresses are 32-bits wide.  */
-- 
1.5.4.1

