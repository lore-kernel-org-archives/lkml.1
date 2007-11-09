Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbXKIXg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbXKIXg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbXKIXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:36:48 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57133 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203AbXKIXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:36:47 -0500
Message-id: <151195677314923254.slaby@pripojeni.net>
In-reply-to: <133622706419279219.slaby@pripojeni.net>
Subject: [PATCH 4/7] Char: char/serial, remove SERIAL_TYPE_NORMAL redefines
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:36:47 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

char/serial, remove SERIAL_TYPE_NORMAL redefines

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit d927dc37e63aa8347e596052615b85ff4936b3e2
tree 0c62b277b0a1b414cd1ac911de0f65b0ebcfd216
parent 585adae2019a87909ec738cbd414a330afbe04a8
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Oct 2007 22:35:24 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:33:04 +0100

 drivers/char/epca.h          |    1 -
 drivers/char/esp.c           |    3 ---
 drivers/char/ip2/ip2main.c   |    3 ---
 drivers/char/mxser.c         |    3 ---
 drivers/char/serial167.c     |    2 --
 drivers/char/sx.h            |    2 --
 drivers/serial/68328serial.c |    3 ---
 drivers/serial/crisv10.c     |    5 -----
 include/linux/isicom.h       |    2 --
 9 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/char/epca.h b/drivers/char/epca.h
index a297238..3c77c02 100644
--- a/drivers/char/epca.h
+++ b/drivers/char/epca.h
@@ -77,7 +77,6 @@ static char *board_desc[] =
 #define ON         1
 
 #define FEPTIMEOUT 200000  
-#define SERIAL_TYPE_NORMAL  1
 #define SERIAL_TYPE_INFO    3
 #define EPCA_EVENT_HANGUP   1
 #define EPCA_MAGIC          0x5c6df104L
diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index 2860776..b5df2dc 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -111,9 +111,6 @@ static char serial_version[] __initdata = "2.2";
 
 static struct tty_driver *esp_driver;
 
-/* serial subtype definitions */
-#define SERIAL_TYPE_NORMAL	1
-
 /*
  * Serial driver configuration section.  Here are the various options:
  *
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index e04e66c..d46d068 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -153,9 +153,6 @@ static char *pcVersion = "1.2.14";
 static char *pcDriver_name   = "ip2";
 static char *pcIpl    		 = "ip2ipl";
 
-/* Serial subtype definitions */
-#define SERIAL_TYPE_NORMAL    1
-
 // cheezy kludge or genius - you decide?
 int ip2_loadmain(int *, int *, unsigned char *, int);
 static unsigned char *Fip_firmware;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 4742078..5d79010 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -81,9 +81,6 @@
 #define	MXSER_ERR_IRQ_CONFLIT	-3
 #define	MXSER_ERR_VECTOR	-4
 
-#define SERIAL_TYPE_NORMAL	1
-#define SERIAL_TYPE_CALLOUT	2
-
 #define WAKEUP_CHARS		256
 
 #define UART_MCR_AFE		0x20
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index f1497ce..cbf21cc 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -90,8 +90,6 @@
 
 #define STD_COM_FLAGS (0)
 
-#define SERIAL_TYPE_NORMAL  1
-
 static struct tty_driver *cy_serial_driver;
 extern int serial_console;
 static struct cyclades_port *serial_console_info = NULL;
diff --git a/drivers/char/sx.h b/drivers/char/sx.h
index 70d9783..87c2def 100644
--- a/drivers/char/sx.h
+++ b/drivers/char/sx.h
@@ -88,8 +88,6 @@ struct vpd_prom {
 
 #define IS_CF_BOARD(board) (board->flags & (SX_CFISA_BOARD | SX_CFPCI_BOARD))
 
-#define SERIAL_TYPE_NORMAL 1
-
 /* The SI processor clock is required to calculate the cc_int_count register
    value for the SI cards. */
 #define SI_PROCESSOR_CLOCK 25000000
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index aad4012..b6bb826 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -84,9 +84,6 @@ extern wait_queue_head_t keypress_wait;
 
 struct tty_driver *serial_driver;
 
-/* serial subtype definitions */
-#define SERIAL_TYPE_NORMAL	1
- 
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS 256
 
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index a4e23cf..383c4e6 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -68,11 +68,6 @@ static char *serial_version = "$Revision: 1.25 $";
 
 struct tty_driver *serial_driver;
 
-/* serial subtype definitions */
-#ifndef SERIAL_TYPE_NORMAL
-#define SERIAL_TYPE_NORMAL	1
-#endif
-
 /* number of characters left in xmit buffer before we ask for more */
 #define WAKEUP_CHARS 256
 
diff --git a/include/linux/isicom.h b/include/linux/isicom.h
index 45b3d48..8f4c717 100644
--- a/include/linux/isicom.h
+++ b/include/linux/isicom.h
@@ -37,8 +37,6 @@
 #define		BOARD_COUNT	4
 #define		PORT_COUNT	(BOARD_COUNT*16)
 
-#define		SERIAL_TYPE_NORMAL	1
-
 /*   character sizes  */
 
 #define		ISICOM_CS5		0x0000
