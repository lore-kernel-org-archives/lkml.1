Return-Path: <linux-kernel-owner+w=401wt.eu-S939756AbXGUPGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939756AbXGUPGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939179AbXGUPDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:03:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939018AbXGUPC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=WWqL3YFG7dQ+EcCX1hhWpbiqVZXuoVjdrhQPGa8ZK7huUbvphHCy1DO+uV40rozwzTEh8hl/jPOjtgB0wpiTl18Un5MZFpFzj6qH+LzVRzgZoB1gjdex6mqtrR/haxKH7YVS0aTa0cFO2Tyl9OkaCSYd4pMYenLE+zGgSN641Fs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][06/37] Clean up duplicate includes in drivers/char/
Date: Sat, 21 Jul 2007 17:01:54 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Ralf Baechle <ralf@linux-mips.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211701.55015.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	drivers/char/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/char/lcd.c b/drivers/char/lcd.c
index 1f09626..4fe9206 100644
--- a/drivers/char/lcd.c
+++ b/drivers/char/lcd.c
@@ -25,7 +25,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <linux/delay.h>
 
 #include "lcd.h"
 
diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 7ee5d94..3c5802a 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mm.h>
-#include <linux/fs.h>
 #include <linux/uio.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 84ac64f..efe2f5c 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -66,7 +66,6 @@
 #include <linux/poll.h>
 #include <linux/major.h>
 #include <linux/ppdev.h>
-#include <linux/device.h>
 #include <asm/uaccess.h>
 
 #define PP_VERSION "ppdev: user-space parallel port driver"
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index fdc256b..905d1f5 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -81,13 +81,9 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-
 #include <linux/netdevice.h>
-
 #include <linux/vmalloc.h>
 #include <linux/init.h>
-
-#include <linux/delay.h>
 #include <linux/ioctl.h>
 
 #include <asm/system.h>
