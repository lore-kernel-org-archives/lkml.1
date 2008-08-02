Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYHBTYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYHBTYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYHBTXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:23:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:21641 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbYHBTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=pfhnVpCdjmf0ZCHMFofPUP2xIdx5Msw3s4HMQZeaKaCJE3CS41+twSZ5g1Ren9YTVa
         Aw+0+rh4sOwX6D0M/N5jotOLQb3lcypwY470eMvnot02HahUt7RZqYlC0Pblkges95nb
         iLty5Os/spCRDGc+9PIiE+wfokJ4Bs01noDg4=
Date: Sat, 2 Aug 2008 21:23:36 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>
Subject: [PATCH 1/5] x86: Coding style fixes to
 arch/x86/boot/compressed/misc.c
Message-ID: <20080802212336.6defeb03@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 4 errors, 6 warnings, 439 lines checked

After:
total: 1 errors, 5 warnings, 441 lines checked

Before

 -#include <asm/io.h>
 +#include <linux/io.h>

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/misc.o.*
8b2394e1fe519a9542e9a7e3e7b69c39  /tmp/misc.o.after
8b2394e1fe519a9542e9a7e3e7b69c39  /tmp/misc.o.before

After

 -#include <asm/io.h>
 +#include <linux/io.h>

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/misc.o.*
59a2d264284be5e72b5af4f3a8ccfb47  /tmp/misc.o.after
8b2394e1fe519a9542e9a7e3e7b69c39  /tmp/misc.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/boot/compressed/misc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 9fea737..2a3f77e 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -27,7 +27,7 @@
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
 #include <linux/elf.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
@@ -251,7 +251,7 @@ static void __putstr(int error, const char *s)
 				y--;
 			}
 		} else {
-			vidmem [(x + cols * y) * 2] = c;
+			vidmem[(x + cols * y) * 2] = c;
 			if (++x >= cols) {
 				x = 0;
 				if (++y >= lines) {
@@ -277,7 +277,8 @@ static void *memset(void *s, int c, unsigned n)
 	int i;
 	char *ss = s;
 
-	for (i = 0; i < n; i++) ss[i] = c;
+	for (i = 0; i < n; i++)
+		ss[i] = c;
 	return s;
 }
 
@@ -287,7 +288,8 @@ static void *memcpy(void *dest, const void *src, unsigned n)
 	const char *s = src;
 	char *d = dest;
 
-	for (i = 0; i < n; i++) d[i] = s[i];
+	for (i = 0; i < n; i++)
+		d[i] = s[i];
 	return dest;
 }
 
-- 
1.5.6.rc1.21.g03300

