Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXFWHUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXFWHUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 03:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXFWHUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 03:20:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:16244 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXFWHUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 03:20:12 -0400
Date: Sat, 23 Jun 2007 09:20:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Oliver Neukum <oneukum@suse.de>, Trent Piepho <xyzzy@speakeasy.org>
Subject: [patch] 2.6.22-rc Kconfig troubles when using menuconfig
In-Reply-To: <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0706230915540.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de>
 <200706211231.53898.luca.risolia@studio.unibo.it> <200706211326.45031.toralf.foerster@gmx.de>
 <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Anyone with strong objections to this patch? (Hopefully) fixes the 
kconfig issue for now.


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index f5a47a4..d340ebb 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -3,9 +3,8 @@
 #
 
 menuconfig ATM_DRIVERS
-	bool "ATM drivers"
+	tristate "ATM drivers"
 	depends on NETDEVICES && ATM
-	default y
 
 if ATM_DRIVERS
 
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index efd2b74..19ea410 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -5,7 +5,7 @@
 source "drivers/media/dvb/dvb-core/Kconfig"
 
 menuconfig DVB_CAPTURE_DRIVERS
-	bool "DVB/ATSC adapters"
+	tristate "DVB/ATSC adapters"
 	depends on DVB_CORE
 	default y
 	---help---
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index a6ac82a..cd8c891 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig RADIO_ADAPTERS
-	bool "Radio Adapters"
+	tristate "Radio Adapters"
 	depends on VIDEO_DEV
 	default y
 	---help---
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 7d57f4a..d888cfb 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1899,9 +1899,8 @@ endmenu
 #
 
 menuconfig NETDEV_1000
-	bool "Ethernet (1000 Mbit)"
+	tristate "Ethernet (1000 Mbit)"
 	depends on !UML
-	default y
 
 if NETDEV_1000
 
@@ -2337,9 +2336,8 @@ endif # NETDEV_1000
 #
 
 menuconfig NETDEV_10000
-	bool "Ethernet (10000 Mbit)"
+	tristate "Ethernet (10000 Mbit)"
 	depends on !UML
-	default y
 
 if NETDEV_10000
 
diff --git a/drivers/net/pcmcia/Kconfig b/drivers/net/pcmcia/Kconfig
index 5d658bc..37369ec 100644
--- a/drivers/net/pcmcia/Kconfig
+++ b/drivers/net/pcmcia/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig NET_PCMCIA
-	bool "PCMCIA network device support"
+	tristate "PCMCIA network device support"
 	depends on PCMCIA
 	---help---
 	  Say Y if you would like to include support for any PCMCIA or CardBus
