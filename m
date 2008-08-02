Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYHBTZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYHBTZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYHBTZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:25:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:22126 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbYHBTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MtovoaxCDO9eRHrMjaNnxlQr+K6m3c19Ep/VxHKvxdE/ddw4ybwET3Uq5DYQPt+RqL
         MR6SQLvZ/AiosHnWwcSLOhN1sqRg6sCqAQDg4Z3U1Jj7WGLqKAKk7X3P0i8nSjZJ5+fX
         oTx8zJ7vVIuypYO/HGH0ho62U9nvlhNPNTqZ8=
Date: Sat, 2 Aug 2008 21:25:13 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa <hpa@zytor.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       tglx <tglx@linutronix.de>
Subject: [PATCH 4/5] x86: Coding style fixes to arch/x86/lib/string_32.c
Message-ID: <20080802212513.6562fa8f@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 21 errors, 0 warnings, 237 lines checked

After:
total: 0 errors, 0 warnings, 237 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/string_32.o.*
c55d059ef1612b32a8bb2771a72ae0d5  /tmp/string_32.o.after
c55d059ef1612b32a8bb2771a72ae0d5  /tmp/string_32.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/string_32.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/lib/string_32.c b/arch/x86/lib/string_32.c
index 94972e7..82004d2 100644
--- a/arch/x86/lib/string_32.c
+++ b/arch/x86/lib/string_32.c
@@ -22,7 +22,7 @@ char *strcpy(char *dest, const char *src)
 		"testb %%al,%%al\n\t"
 		"jne 1b"
 		: "=&S" (d0), "=&D" (d1), "=&a" (d2)
-		:"0" (src), "1" (dest) : "memory");
+		: "0" (src), "1" (dest) : "memory");
 	return dest;
 }
 EXPORT_SYMBOL(strcpy);
@@ -42,7 +42,7 @@ char *strncpy(char *dest, const char *src, size_t count)
 		"stosb\n"
 		"2:"
 		: "=&S" (d0), "=&D" (d1), "=&c" (d2), "=&a" (d3)
-		:"0" (src), "1" (dest), "2" (count) : "memory");
+		: "0" (src), "1" (dest), "2" (count) : "memory");
 	return dest;
 }
 EXPORT_SYMBOL(strncpy);
@@ -60,7 +60,7 @@ char *strcat(char *dest, const char *src)
 		"testb %%al,%%al\n\t"
 		"jne 1b"
 		: "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
-		: "0" (src), "1" (dest), "2" (0), "3" (0xffffffffu): "memory");
+		: "0" (src), "1" (dest), "2" (0), "3" (0xffffffffu) : "memory");
 	return dest;
 }
 EXPORT_SYMBOL(strcat);
@@ -105,9 +105,9 @@ int strcmp(const char *cs, const char *ct)
 		"2:\tsbbl %%eax,%%eax\n\t"
 		"orb $1,%%al\n"
 		"3:"
-		:"=a" (res), "=&S" (d0), "=&D" (d1)
-		:"1" (cs), "2" (ct)
-		:"memory");
+		: "=a" (res), "=&S" (d0), "=&D" (d1)
+		: "1" (cs), "2" (ct)
+		: "memory");
 	return res;
 }
 EXPORT_SYMBOL(strcmp);
@@ -130,9 +130,9 @@ int strncmp(const char *cs, const char *ct, size_t count)
 		"3:\tsbbl %%eax,%%eax\n\t"
 		"orb $1,%%al\n"
 		"4:"
-		:"=a" (res), "=&S" (d0), "=&D" (d1), "=&c" (d2)
-		:"1" (cs), "2" (ct), "3" (count)
-		:"memory");
+		: "=a" (res), "=&S" (d0), "=&D" (d1), "=&c" (d2)
+		: "1" (cs), "2" (ct), "3" (count)
+		: "memory");
 	return res;
 }
 EXPORT_SYMBOL(strncmp);
@@ -152,9 +152,9 @@ char *strchr(const char *s, int c)
 		"movl $1,%1\n"
 		"2:\tmovl %1,%0\n\t"
 		"decl %0"
-		:"=a" (res), "=&S" (d0)
-		:"1" (s), "0" (c)
-		:"memory");
+		: "=a" (res), "=&S" (d0)
+		: "1" (s), "0" (c)
+		: "memory");
 	return res;
 }
 EXPORT_SYMBOL(strchr);
@@ -169,9 +169,9 @@ size_t strlen(const char *s)
 		"scasb\n\t"
 		"notl %0\n\t"
 		"decl %0"
-		:"=c" (res), "=&D" (d0)
-		:"1" (s), "a" (0), "0" (0xffffffffu)
-		:"memory");
+		: "=c" (res), "=&D" (d0)
+		: "1" (s), "a" (0), "0" (0xffffffffu)
+		: "memory");
 	return res;
 }
 EXPORT_SYMBOL(strlen);
@@ -189,9 +189,9 @@ void *memchr(const void *cs, int c, size_t count)
 		"je 1f\n\t"
 		"movl $1,%0\n"
 		"1:\tdecl %0"
-		:"=D" (res), "=&c" (d0)
-		:"a" (c), "0" (cs), "1" (count)
-		:"memory");
+		: "=D" (res), "=&c" (d0)
+		: "a" (c), "0" (cs), "1" (count)
+		: "memory");
 	return res;
 }
 EXPORT_SYMBOL(memchr);
@@ -228,9 +228,9 @@ size_t strnlen(const char *s, size_t count)
 		"cmpl $-1,%1\n\t"
 		"jne 1b\n"
 		"3:\tsubl %2,%0"
-		:"=a" (res), "=&d" (d0)
-		:"c" (s), "1" (count)
-		:"memory");
+		: "=a" (res), "=&d" (d0)
+		: "c" (s), "1" (count)
+		: "memory");
 	return res;
 }
 EXPORT_SYMBOL(strnlen);
-- 
1.5.6.rc1.21.g03300

