Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbXJXQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbXJXQsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759586AbXJXQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32775 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759566AbXJXQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:14 -0400
Date: Wed, 24 Oct 2007 18:26:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: bryan.wu@analog.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] blackfin: "extern inline" -> "static inline"
Message-ID: <20071024162643.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-blackfin/string.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

f2a6901348a61a13fc19a01f5584406190302919 
diff --git a/include/asm-blackfin/string.h b/include/asm-blackfin/string.h
index e8ada91..e4703a7 100644
--- a/include/asm-blackfin/string.h
+++ b/include/asm-blackfin/string.h
@@ -4,7 +4,7 @@
 #ifdef __KERNEL__		/* only set these up for kernel code */
 
 #define __HAVE_ARCH_STRCPY
-extern inline char *strcpy(char *dest, const char *src)
+static inline char *strcpy(char *dest, const char *src)
 {
 	char *xdest = dest;
 	char temp = 0;
@@ -23,7 +23,7 @@ extern inline char *strcpy(char *dest, const char *src)
 }
 
 #define __HAVE_ARCH_STRNCPY
-extern inline char *strncpy(char *dest, const char *src, size_t n)
+static inline char *strncpy(char *dest, const char *src, size_t n)
 {
 	char *xdest = dest;
 	char temp = 0;
@@ -59,7 +59,7 @@ extern inline char *strncpy(char *dest, const char *src, size_t n)
 }
 
 #define __HAVE_ARCH_STRCMP
-extern inline int strcmp(const char *cs, const char *ct)
+static inline int strcmp(const char *cs, const char *ct)
 {
 	/* need to use int's here so the char's in the assembly don't get
 	 * sign extended incorrectly when we don't want them to be
@@ -86,7 +86,7 @@ extern inline int strcmp(const char *cs, const char *ct)
 }
 
 #define __HAVE_ARCH_STRNCMP
-extern inline int strncmp(const char *cs, const char *ct, size_t count)
+static inline int strncmp(const char *cs, const char *ct, size_t count)
 {
 	/* need to use int's here so the char's in the assembly don't get
 	 * sign extended incorrectly when we don't want them to be

