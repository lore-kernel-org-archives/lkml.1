Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYFTR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYFTR3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYFTR3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:29:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:13897 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYFTR3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=SvLNKIkj/qQ+O3n7aAGDn7Lqj1BXb8vCfXqQry9f4S4b9FkFDdaDNDyPoDUhII/Boh
         riuT5LZ1lA2LPoXYhLuaq99uGjfz9b+HtHCDcrHOgKBE1IGbbPLBxlYcCsszQTE8Kh7q
         e7/hdPTanTQB5UGePKmak+MkMjKtyjTS8JA4I=
Subject: [PATCH] [Trivial] Update contact information
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 20 Jun 2008 19:28:50 +0200
Message-Id: <1213982930.2355.7.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excuse me for the delay.

On Thu, May 8, 2008 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>  
>  The preferred approach here is to remove the email address from the various
>  .c and .h files altogether.  People can then look up "Miguel Ojeda
>  Sandonis" in ./MAINTAINERS and ./CREDITS to find you.  And next time you
>  move, we only need to alter those files.

Sure, I prefer that. Here is the new patch, thank you. For the next time, should I CC trivial@kernel.org? In addition, should I remove the email field in the MODULE_AUTHOR macros?

BTW, I checked the trivial mailing list's URL stated in SubmittingPatches (http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/) and seems wrong. I was going to write a patch but I haven't been able to find the right page (only git's one: git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial.git).

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

---
diff -uprN linux-2.6.25-o/CREDITS linux-2.6.25/CREDITS
--- linux-2.6.25-o/CREDITS	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/CREDITS	2008-05-08 22:06:13.000000000 +0200
@@ -2609,8 +2609,9 @@ S: Perth, Western Australia
 S: Australia
 
 N: Miguel Ojeda Sandonis
-E: maxextreme@gmail.com
-W: http://maxextreme.googlepages.com/
+E: miguel.ojeda.sandonis@gmail.com
+W: http://miguelojeda.es
+W: http://jair.lab.fi.uva.es/~migojed/
 D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display drivers.
 D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
 S: C/ Mieses 20, 9-B
diff -uprN linux-2.6.25-o/Documentation/auxdisplay/cfag12864b linux-2.6.25/Documentation/auxdisplay/cfag12864b
--- linux-2.6.25-o/Documentation/auxdisplay/cfag12864b	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/Documentation/auxdisplay/cfag12864b	2008-05-08 23:03:43.000000000 +0200
@@ -3,7 +3,7 @@
 	===================================
 
 License:		GPLv2
-Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
+Author & Maintainer:	Miguel Ojeda Sandonis
 Date:			2006-10-27
 
 
@@ -22,7 +22,7 @@ Date:			2006-10-27
 1. DRIVER INFORMATION
 ---------------------
 
-This driver support one cfag12864b display at time.
+This driver supports a cfag12864b LCD.
 
 
 ---------------------
diff -uprN linux-2.6.25-o/Documentation/auxdisplay/cfag12864b-example.c linux-2.6.25/Documentation/auxdisplay/cfag12864b-example.c
--- linux-2.6.25-o/Documentation/auxdisplay/cfag12864b-example.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/Documentation/auxdisplay/cfag12864b-example.c	2008-05-08 22:06:59.000000000 +0200
@@ -4,7 +4,7 @@
  * Description: cfag12864b LCD userspace example program
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
diff -uprN linux-2.6.25-o/Documentation/auxdisplay/ks0108 linux-2.6.25/Documentation/auxdisplay/ks0108
--- linux-2.6.25-o/Documentation/auxdisplay/ks0108	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/Documentation/auxdisplay/ks0108	2008-05-08 23:01:42.000000000 +0200
@@ -3,7 +3,7 @@
 	==========================================
 
 License:		GPLv2
-Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
+Author & Maintainer:	Miguel Ojeda Sandonis
 Date:			2006-10-27
 
 
@@ -21,7 +21,7 @@ Date:			2006-10-27
 1. DRIVER INFORMATION
 ---------------------
 
-This driver support the ks0108 LCD controller.
+This driver supports the ks0108 LCD controller.
 
 
 ---------------------
diff -uprN linux-2.6.25-o/drivers/auxdisplay/cfag12864b.c linux-2.6.25/drivers/auxdisplay/cfag12864b.c
--- linux-2.6.25-o/drivers/auxdisplay/cfag12864b.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/cfag12864b.c	2008-05-08 22:07:36.000000000 +0200
@@ -5,7 +5,7 @@
  *     License: GPLv2
  *     Depends: ks0108
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -398,5 +398,5 @@ module_init(cfag12864b_init);
 module_exit(cfag12864b_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("cfag12864b LCD driver");
diff -uprN linux-2.6.25-o/drivers/auxdisplay/cfag12864bfb.c linux-2.6.25/drivers/auxdisplay/cfag12864bfb.c
--- linux-2.6.25-o/drivers/auxdisplay/cfag12864bfb.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/cfag12864bfb.c	2008-05-08 22:07:27.000000000 +0200
@@ -5,7 +5,7 @@
  *     License: GPLv2
  *     Depends: cfag12864b
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -186,5 +186,5 @@ module_init(cfag12864bfb_init);
 module_exit(cfag12864bfb_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("cfag12864b LCD framebuffer driver");
diff -uprN linux-2.6.25-o/drivers/auxdisplay/Kconfig linux-2.6.25/drivers/auxdisplay/Kconfig
--- linux-2.6.25-o/drivers/auxdisplay/Kconfig	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/Kconfig	2008-05-08 22:08:48.000000000 +0200
@@ -64,7 +64,7 @@ config KS0108_DELAY
 	  Amount of time the ks0108 should wait between each control write
 	  to the parallel port.
 
-	  If your driver seems to miss random writings, increment this.
+	  If your LCD seems to miss random writings, increment this.
 
 	  If you don't know what I'm talking about, ignore it.
 
diff -uprN linux-2.6.25-o/drivers/auxdisplay/ks0108.c linux-2.6.25/drivers/auxdisplay/ks0108.c
--- linux-2.6.25-o/drivers/auxdisplay/ks0108.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/auxdisplay/ks0108.c	2008-05-08 22:07:20.000000000 +0200
@@ -5,7 +5,7 @@
  *     License: GPLv2
  *     Depends: parport
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -173,6 +173,6 @@ module_init(ks0108_init);
 module_exit(ks0108_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <maxextreme@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
 MODULE_DESCRIPTION("ks0108 LCD Controller driver");
 
diff -uprN linux-2.6.25-o/include/linux/cfag12864b.h linux-2.6.25/include/linux/cfag12864b.h
--- linux-2.6.25-o/include/linux/cfag12864b.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/include/linux/cfag12864b.h	2008-05-08 22:58:42.000000000 +0200
@@ -4,7 +4,7 @@
  * Description: cfag12864b LCD driver header
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-12
  *
  *  This program is free software; you can redistribute it and/or modify
diff -uprN linux-2.6.25-o/include/linux/ks0108.h linux-2.6.25/include/linux/ks0108.h
--- linux-2.6.25-o/include/linux/ks0108.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/include/linux/ks0108.h	2008-05-08 22:58:37.000000000 +0200
@@ -4,7 +4,7 @@
  * Description: ks0108 LCD Controller driver header
  *     License: GPLv2
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
+ *      Author: Copyright (C) Miguel Ojeda Sandonis
  *        Date: 2006-10-31
  *
  *  This program is free software; you can redistribute it and/or modify
diff -uprN linux-2.6.25-o/MAINTAINERS linux-2.6.25/MAINTAINERS
--- linux-2.6.25-o/MAINTAINERS	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/MAINTAINERS	2008-05-08 22:04:54.000000000 +0200
@@ -750,9 +750,10 @@ S:	Maintained
 
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 AVR32 ARCHITECTURE
@@ -1050,16 +1051,18 @@ S:	Maintained
 
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 CFG80211 and NL80211
@@ -2333,9 +2336,10 @@ S:	Maintained
 
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
-M:	maxextreme@gmail.com
+M:	miguel.ojeda.sandonis@gmail.com
 L:	linux-kernel@vger.kernel.org
-W:	http://auxdisplay.googlepages.com/
+W:	http://miguelojeda.es/auxdisplay.htm
+W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
 
 LAPB module


