Return-Path: <linux-kernel-owner+w=401wt.eu-S1946587AbXBIPjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946587AbXBIPjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946575AbXBIPjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:39:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946574AbXBIPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=of9Jf1bkN8Lv3M8x7endElATaeT1eFu8YQ4KUmGTZeA14GhOLAB+wV2Q9fzHL9ENGWPL4DRazDJTUMZ49x0qXsjjVGrzIpXG2+nkL8SnBGN+3akXiedtaEZUNIpzouK3Q/TV62OSXX8Au4HaOEcsbUCiRKgoplWvRuNxtGJRaOM=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, dmitry.torokhov@gmail.com, dtor@mail.ru
Subject: [PATCH 25/34] __initdata cleanup - input
Date: Fri, 9 Feb 2007 17:30:11 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091730.11563.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/input/joystick/db9.c linux-2.6.20-rc6-mm3/drivers/input/joystick/db9.c
--- linux-2.6.20-rc6-mm3.org/drivers/input/joystick/db9.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/input/joystick/db9.c	2007-01-31 23:18:42.000000000 +0200
@@ -50,7 +50,7 @@ struct db9_config {
 };
 
 #define DB9_MAX_PORTS		3
-static struct db9_config db9[DB9_MAX_PORTS] __initdata;
+static struct db9_config db9[DB9_MAX_PORTS] __initdata = {{{0}}};
 
 module_param_array_named(dev, db9[0].args, int, &db9[0].nargs, 0);
 MODULE_PARM_DESC(dev, "Describes first attached device (<parport#>,<type>)");
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/input/joystick/gamecon.c linux-2.6.20-rc6-mm3/drivers/input/joystick/gamecon.c
--- linux-2.6.20-rc6-mm3.org/drivers/input/joystick/gamecon.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/input/joystick/gamecon.c	2007-01-31 23:18:54.000000000 +0200
@@ -51,7 +51,7 @@ struct gc_config {
 	int nargs;
 };
 
-static struct gc_config gc[GC_MAX_PORTS] __initdata;
+static struct gc_config gc[GC_MAX_PORTS] __initdata = {{{0}}};
 
 module_param_array_named(map, gc[0].args, int, &gc[0].nargs, 0);
 MODULE_PARM_DESC(map, "Describes first set of devices (<parport#>,<pad1>,<pad2>,..<pad5>)");
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/input/joystick/turbografx.c linux-2.6.20-rc6-mm3/drivers/input/joystick/turbografx.c
--- linux-2.6.20-rc6-mm3.org/drivers/input/joystick/turbografx.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/input/joystick/turbografx.c	2007-01-31 23:19:07.000000000 +0200
@@ -51,7 +51,7 @@ struct tgfx_config {
 	int nargs;
 };
 
-static struct tgfx_config tgfx[TGFX_MAX_PORTS] __initdata;
+static struct tgfx_config tgfx[TGFX_MAX_PORTS] __initdata = {{{0}}};
 
 module_param_array_named(map, tgfx[0].args, int, &tgfx[0].nargs, 0);
 MODULE_PARM_DESC(map, "Describes first set of devices (<parport#>,<js1>,<js2>,..<js7>");
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/input/keyboard/amikbd.c linux-2.6.20-rc6-mm3/drivers/input/keyboard/amikbd.c
--- linux-2.6.20-rc6-mm3.org/drivers/input/keyboard/amikbd.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/input/keyboard/amikbd.c	2007-01-31 22:19:30.000000000 +0200
@@ -215,7 +215,7 @@ static int __init amikbd_init(void)
 		set_bit(i, amikbd_dev->keybit);
 
 	for (i = 0; i < MAX_NR_KEYMAPS; i++) {
-		static u_short temp_map[NR_KEYS] __initdata;
+		static u_short temp_map[NR_KEYS] __initdata = {0};
 		if (!key_maps[i])
 			continue;
 		memset(temp_map, 0, sizeof(temp_map));
