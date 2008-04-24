Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYDXXMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYDXXMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYDXXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:07:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbYDXXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:06:45 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "William L. Irwin" <wli@holomorphy.com>
Subject: [PATCH 18/24] sparc: types: use <asm-generic/int-*.h> for the sparc architecture
Date: Thu, 24 Apr 2008 16:05:42 -0700
Message-Id: <1209078352-7593-36-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-35-git-send-email-hpa@zytor.com>
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
 <1209078352-7593-21-git-send-email-hpa@zytor.com>
 <1209078352-7593-22-git-send-email-hpa@zytor.com>
 <1209078352-7593-23-git-send-email-hpa@zytor.com>
 <1209078352-7593-24-git-send-email-hpa@zytor.com>
 <1209078352-7593-25-git-send-email-hpa@zytor.com>
 <1209078352-7593-26-git-send-email-hpa@zytor.com>
 <1209078352-7593-27-git-send-email-hpa@zytor.com>
 <1209078352-7593-28-git-send-email-hpa@zytor.com>
 <1209078352-7593-29-git-send-email-hpa@zytor.com>
 <1209078352-7593-30-git-send-email-hpa@zytor.com>
 <1209078352-7593-31-git-send-email-hpa@zytor.com>
 <1209078352-7593-32-git-send-email-hpa@zytor.com>
 <1209078352-7593-33-git-send-email-hpa@zytor.com>
 <1209078352-7593-34-git-send-email-hpa@zytor.com>
 <1209078352-7593-35-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This modifies <asm-sparc/types.h> to use the <asm-generic/int-*.h>
generic include files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: William L. Irwin <wli@holomorphy.com>
---
 include/asm-sparc/types.h |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/include/asm-sparc/types.h b/include/asm-sparc/types.h
index 42fc6ed..1b08ef8 100644
--- a/include/asm-sparc/types.h
+++ b/include/asm-sparc/types.h
@@ -3,34 +3,18 @@
 #define _SPARC_TYPES_H
 
 /*
- * _xx is ok: it doesn't pollute the POSIX namespace. Use these in the
- * header files exported to user space.
- */
-
-/*
  * This file is never included by application software unless
  * explicitly requested (e.g., via linux/types.h) in which case the
  * application is Linux specific so (user-) name space pollution is
  * not a major issue.  However, for interoperability, libraries still
  * need to be careful to avoid a name clashes.
  */
+#include <asm-generic/int-ll64.h>
 
 #ifndef __ASSEMBLY__
 
 typedef unsigned short umode_t;
 
-typedef __signed__ char __s8;
-typedef unsigned char __u8;
-
-typedef __signed__ short __s16;
-typedef unsigned short __u16;
-
-typedef __signed__ int __s32;
-typedef unsigned int __u32;
-
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
-
 #endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
@@ -39,18 +23,6 @@ typedef unsigned long long __u64;
 
 #ifndef __ASSEMBLY__
 
-typedef __signed__ char s8;
-typedef unsigned char u8;
-
-typedef __signed__ short s16;
-typedef unsigned short u16;
-
-typedef __signed__ int s32;
-typedef unsigned int u32;
-
-typedef __signed__ long long s64;
-typedef unsigned long long u64;
-
 typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
-- 
1.5.4.1

