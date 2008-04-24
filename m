Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYDXXPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYDXXPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYDXXHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:07:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYDXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:07:06 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/24] ia64: types: use <asm-generic/int-*.h> for the ia64 architecture
Date: Thu, 24 Apr 2008 16:05:25 -0700
Message-Id: <1209078352-7593-19-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-18-git-send-email-hpa@zytor.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies <asm-ia64/types.h> to use the <asm-generic/int-*.h>
generic include files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-ia64/types.h |   31 ++-----------------------------
 1 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/include/asm-ia64/types.h b/include/asm-ia64/types.h
index 902850d..e36b371 100644
--- a/include/asm-ia64/types.h
+++ b/include/asm-ia64/types.h
@@ -13,6 +13,8 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
+#include <asm-generic/int-l64.h>
+
 #ifdef __ASSEMBLY__
 # define __IA64_UL(x)		(x)
 # define __IA64_UL_CONST(x)	x
@@ -28,39 +30,10 @@
 typedef unsigned int umode_t;
 
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
-typedef __signed__ long __s64;
-typedef unsigned long __u64;
-
-/*
  * These aren't exported outside the kernel to avoid name space clashes
  */
 # ifdef __KERNEL__
 
-typedef __s8 s8;
-typedef __u8 u8;
-
-typedef __s16 s16;
-typedef __u16 u16;
-
-typedef __s32 s32;
-typedef __u32 u32;
-
-typedef __s64 s64;
-typedef __u64 u64;
-
 #define BITS_PER_LONG 64
 
 /* DMA addresses are 64-bits wide, in general.  */
-- 
1.5.4.1

