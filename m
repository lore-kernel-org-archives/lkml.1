Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbZD0TLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbZD0TLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbZD0TJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:09:50 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:51150 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbZD0TJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:09:49 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
Date: Mon, 27 Apr 2009 15:09:33 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3; KDE/4.2.2; i686; ; )
MIME-version: 1.0
Subject: Fwd:
To: linux-kernel@vger.kernel.org
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-disposition: inline
Message-id: <200904271509.33922.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------  Forwarded Message  ----------

Subject: 
Date: Monday 27 April 2009
From: arnd@arndb.de
To: "no To-header on input" <unlisted-recipients:; @gmail-pop.l.google.com>

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:11 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>,
 Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 01/17] asm-generic: rename termios.h to termios-base.h
Content-Disposition: inline; filename=0001-asm-generic-add-complete-
termios.h.patch
X-Provags-ID: V01U2FsdGVkX1/xu4vJssORo5JEwJmCN0zaKrLACm0pXgcgS8L
 nEdWOCrcNmDlQGMPLb2pcu4w/QxDwJ8yUkFlayzHvuBS0VbefM
 dtqNTnEx2sYlQA9QUc7pA==

The existing asm-generic/termios.h file only contains a part
of the required termios.h contents. This renames it to termios-base.h
and changes all users, so we can add a full termios.h file for
new archtitectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/avr32/include/asm/termios.h      |    2 	1 +	1 -	0 !
 arch/frv/include/asm/termios.h        |    2 	1 +	1 -	0 !
 arch/microblaze/include/asm/termios.h |    2 	1 +	1 -	0 !
 arch/powerpc/include/asm/termios.h    |    2 	1 +	1 -	0 !
 arch/s390/include/asm/termios.h       |    2 	1 +	1 -	0 !
 include/asm-generic/termios-base.h    |   77 	77 +	0 -	0 !
 include/asm-generic/termios.h         |   77 	0 +	77 -	0 !
 7 files changed, 82 insertions(+), 82 deletions(-)
 create mode 100644 include/asm-generic/termios-base.h

Index: linux-2.6/arch/avr32/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/avr32/include/asm/termios.h
+++ linux-2.6/arch/avr32/include/asm/termios.h
@@ -55,7 +55,7 @@ struct termio {
 */
 #define INIT_C_CC 
"\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6/arch/frv/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/termios.h
+++ linux-2.6/arch/frv/include/asm/termios.h
@@ -52,7 +52,7 @@ struct termio {
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 
 #ifdef __KERNEL__
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 #endif
 
 #endif /* _ASM_TERMIOS_H */
Index: linux-2.6/arch/powerpc/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/termios.h
+++ linux-2.6/arch/powerpc/include/asm/termios.h
@@ -78,7 +78,7 @@ struct termio {
 
 #ifdef __KERNEL__
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6/arch/s390/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/termios.h
+++ linux-2.6/arch/s390/include/asm/termios.h
@@ -60,7 +60,7 @@ struct termio {
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, 
sizeof(struct termios2))
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct 
termios2))
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6/include/asm-generic/termios-base.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/termios-base.h
@@ -0,0 +1,77 @@
+/* termios.h: generic termios/termio user copying/translation
+ */
+
+#ifndef _ASM_GENERIC_TERMIOS_BASE_H
+#define _ASM_GENERIC_TERMIOS_BASE_H
+
+#include <asm/uaccess.h>
+
+#ifndef __ARCH_TERMIO_GETPUT
+
+/*
+ * Translate a "termio" structure into a "termios". Ugh.
+ */
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
+						struct termio __user *termio)
+{
+	unsigned short tmp;
+
+	if (get_user(tmp, &termio->c_iflag) < 0)
+		goto fault;
+	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
+
+	if (get_user(tmp, &termio->c_oflag) < 0)
+		goto fault;
+	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
+
+	if (get_user(tmp, &termio->c_cflag) < 0)
+		goto fault;
+	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
+
+	if (get_user(tmp, &termio->c_lflag) < 0)
+		goto fault;
+	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
+
+	if (get_user(termios->c_line, &termio->c_line) < 0)
+		goto fault;
+
+	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
+		goto fault;
+
+	return 0;
+
+ fault:
+	return -EFAULT;
+}
+
+/*
+ * Translate a "termios" structure into a "termio". Ugh.
+ */
+static inline int kernel_termios_to_user_termio(struct termio __user *termio,
+						struct ktermios *termios)
+{
+	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
+	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
+	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
+	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
+	    put_user(termios->c_line,  &termio->c_line) < 0 ||
+	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
+		return -EFAULT;
+
+	return 0;
+}
+
+#ifndef user_termios_to_kernel_termios
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, 
sizeof(struct termios))
+#endif
+
+#ifndef kernel_termios_to_user_termios
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct 
termios))
+#endif
+
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, 
sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, 
sizeof(struct termios))
+
+#endif	/* __ARCH_TERMIO_GETPUT */
+
+#endif /* _ASM_GENERIC_TERMIOS_BASE_H */
Index: linux-2.6/include/asm-generic/termios.h
===================================================================
--- linux-2.6.orig/include/asm-generic/termios.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/* termios.h: generic termios/termio user copying/translation
- */
-
-#ifndef _ASM_GENERIC_TERMIOS_H
-#define _ASM_GENERIC_TERMIOS_H
-
-#include <asm/uaccess.h>
-
-#ifndef __ARCH_TERMIO_GETPUT
-
-/*
- * Translate a "termio" structure into a "termios". Ugh.
- */
-static inline int user_termio_to_kernel_termios(struct ktermios *termios,
-						struct termio __user *termio)
-{
-	unsigned short tmp;
-
-	if (get_user(tmp, &termio->c_iflag) < 0)
-		goto fault;
-	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
-
-	if (get_user(tmp, &termio->c_oflag) < 0)
-		goto fault;
-	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
-
-	if (get_user(tmp, &termio->c_cflag) < 0)
-		goto fault;
-	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
-
-	if (get_user(tmp, &termio->c_lflag) < 0)
-		goto fault;
-	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
-
-	if (get_user(termios->c_line, &termio->c_line) < 0)
-		goto fault;
-
-	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
-		goto fault;
-
-	return 0;
-
- fault:
-	return -EFAULT;
-}
-
-/*
- * Translate a "termios" structure into a "termio". Ugh.
- */
-static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-						struct ktermios *termios)
-{
-	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
-	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
-	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
-	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
-	    put_user(termios->c_line,  &termio->c_line) < 0 ||
-	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
-		return -EFAULT;
-
-	return 0;
-}
-
-#ifndef user_termios_to_kernel_termios
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, 
sizeof(struct termios))
-#endif
-
-#ifndef kernel_termios_to_user_termios
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct 
termios))
-#endif
-
-#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, 
sizeof(struct termios))
-#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, 
sizeof(struct termios))
-
-#endif	/* __ARCH_TERMIO_GETPUT */
-
-#endif /* _ASM_GENERIC_TERMIOS_H */
Index: linux-2.6/arch/microblaze/include/asm/termios.h
===================================================================
--- linux-2.6.orig/arch/microblaze/include/asm/termios.h
+++ linux-2.6/arch/microblaze/include/asm/termios.h
@@ -81,7 +81,7 @@ struct termio {
 
 #ifdef __KERNEL__
 
-#include <asm-generic/termios.h>
+#include <asm-generic/termios-base.h>
 
 #endif	/* __KERNEL__ */
 

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-------------------------------------------------------

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"The four building blocks of the universe are fire, water, gravel and vinyl."
		-- Dave Barry

