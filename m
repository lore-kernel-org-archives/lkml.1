Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0A3TuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0A3TuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112Ab0A3TuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:50:06 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0A3TuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:50:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=glmYKbWEzAvxAvNDxvD36rYAUjxg7wqf+wDug0hiNUfbsI3+jWhLKT+GxLvIFirpHl
         5zuT08nMeyv/6vhmWGxz+i3zbXQY7grlhOgAKo71SriBn08vklodP3AjO7Q/8h8HNUWT
         CuaoM4jfTyYKvkQ3TMGUCkkvLjI8zmnew0c70=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:49:51 +0100
Message-Id: <20100130194951.30779.98709.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 5/9] ide2libata: add missing credits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide2libata: add missing credits

I forgot to credit myself. :)

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c  |    4 ++--
 drivers/ide/atiixp.c   |    4 ++--
 drivers/ide/cs5520.c   |    3 ++-
 drivers/ide/cs5530.c   |    4 ++--
 drivers/ide/cs5535.c   |    4 ++--
 drivers/ide/it8213.c   |    4 ++--
 drivers/ide/it821x.c   |    4 ++--
 drivers/ide/piix.c     |    3 ++-
 drivers/ide/sc1200.c   |    4 ++--
 drivers/ide/sl82c105.c |    2 +-
 drivers/ide/slc90e66.c |    3 ++-
 drivers/ide/triflex.c  |    4 +++-
 12 files changed, 24 insertions(+), 19 deletions(-)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
- *
+ * Copyright (C) 2007-2010	Bartlomiej Zolnierkiewicz
  */
 
 #include <linux/module.h>
@@ -173,6 +173,6 @@ static void __exit aec62xx_ide_exit(void
 module_init(aec62xx_ide_init);
 module_exit(aec62xx_ide_exit);
 
-MODULE_AUTHOR("Andre Hedrick");
+MODULE_AUTHOR("Andre Hedrick, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for ARTOP AEC62xx IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/atiixp.c
===================================================================
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -1,6 +1,6 @@
 /*
  *  Copyright (C) 2003 ATI Inc. <hyu@ati.com>
- *  Copyright (C) 2004,2007 Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2004,2007-2010 Bartlomiej Zolnierkiewicz
  */
 
 #include <linux/types.h>
@@ -88,6 +88,6 @@ static void __exit atiixp_ide_exit(void)
 module_init(atiixp_ide_init);
 module_exit(atiixp_ide_exit);
 
-MODULE_AUTHOR("HUI YU");
+MODULE_AUTHOR("HUI YU, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for ATI IXP IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -13,6 +13,7 @@
  *	*** This driver is strictly experimental ***
  *
  *	(c) Copyright Red Hat Inc 2002
+ *	(c) Copyright Bartlomiej Zolnierkiewicz 2010
  * 
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -127,6 +128,6 @@ static int __init cs5520_ide_init(void)
 
 module_init(cs5520_ide_init);
 
-MODULE_AUTHOR("Alan Cox");
+MODULE_AUTHOR("Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for Cyrix 5510/5520 IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/cs5530.c
===================================================================
--- a/drivers/ide/cs5530.c
+++ b/drivers/ide/cs5530.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
- * Copyright (C) 2007			Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010		Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public License
  *
@@ -173,6 +173,6 @@ static void __exit cs5530_ide_exit(void)
 module_init(cs5530_ide_init);
 module_exit(cs5530_ide_exit);
 
-MODULE_AUTHOR("Mark Lord");
+MODULE_AUTHOR("Mark Lord, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for Cyrix/NS 5530 IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2004-2005 Advanced Micro Devices, Inc.
- * Copyright (C)      2007 Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  *
  * History:
  * 09/20/2005 - Jaya Kumar <jayakumar.ide@gmail.com>
@@ -82,6 +82,6 @@ static void __exit cs5535_ide_exit(void)
 module_init(cs5535_ide_init);
 module_exit(cs5535_ide_exit);
 
-MODULE_AUTHOR("AMD");
+MODULE_AUTHOR("AMD, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for AMD/NS CS5535 IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/it8213.c
===================================================================
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2006 Jack Lee
  * Copyright (C) 2006 Alan Cox
- * Copyright (C) 2007 Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  */
 
 #include <linux/kernel.h>
@@ -79,6 +79,6 @@ static void __exit it8213_ide_exit(void)
 module_init(it8213_ide_init);
 module_exit(it8213_ide_exit);
 
-MODULE_AUTHOR("Jack Lee, Alan Cox");
+MODULE_AUTHOR("Jack Lee, Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for the ITE 8213");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2004		Red Hat
- * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010	Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *  Based in part on the ITE vendor provided SCSI driver.
@@ -352,6 +352,6 @@ module_exit(it821x_ide_exit);
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
 MODULE_PARM_DESC(noraid, "Force card into bypass mode");
 
-MODULE_AUTHOR("Alan Cox");
+MODULE_AUTHOR("Alan Cox, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for the ITE 821x");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -3,6 +3,7 @@
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2003 Red Hat
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
+ *  Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  *
  *  May be copied or modified under the terms of the GNU General Public License
  */
@@ -230,6 +231,6 @@ static void __exit piix_ide_exit(void)
 module_init(piix_ide_init);
 module_exit(piix_ide_exit);
 
-MODULE_AUTHOR("Andre Hedrick, Andrzej Krzysztofowicz");
+MODULE_AUTHOR("Andre Hedrick, Andrzej Krzysztofowicz, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for Intel PIIX IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2000-2002		Mark Lord <mlord@pobox.com>
- * Copyright (C)      2007		Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010		Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public License
  *
@@ -244,6 +244,6 @@ static void __exit sc1200_ide_exit(void)
 module_init(sc1200_ide_init);
 module_exit(sc1200_ide_exit);
 
-MODULE_AUTHOR("Mark Lord");
+MODULE_AUTHOR("Mark Lord, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for NS SC1200 IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -11,7 +11,7 @@
  *  -- Benjamin Herrenschmidt (01/11/03) benh@kernel.crashing.org
  *
  * Copyright (C) 2006-2007,2009 MontaVista Software, Inc. <source@mvista.com>
- * Copyright (C)      2007 Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  */
 
 #include <linux/types.h>
Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -1,6 +1,7 @@
 /*
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
+ *  Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  *
  * This is a look-alike variation of the ICH0 PIIX4 Ultra-66,
  * but this keeps the ISA-Bridge and slots alive.
@@ -68,6 +69,6 @@ static void __exit slc90e66_ide_exit(voi
 module_init(slc90e66_ide_init);
 module_exit(slc90e66_ide_exit);
 
-MODULE_AUTHOR("Andre Hedrick");
+MODULE_AUTHOR("Andre Hedrick, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for SLC90E66 IDE");
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/triflex.c
===================================================================
--- a/drivers/ide/triflex.c
+++ b/drivers/ide/triflex.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2002 Hewlett-Packard Development Group, L.P.
  * Author: Torben Mathiasen <torben.mathiasen@hp.com>
  *
+ * Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -90,7 +92,7 @@ static void __exit triflex_ide_exit(void
 module_init(triflex_ide_init);
 module_exit(triflex_ide_exit);
 
-MODULE_AUTHOR("Torben Mathiasen");
+MODULE_AUTHOR("Torben Mathiasen, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for Compaq Triflex IDE");
 MODULE_LICENSE("GPL");
 
