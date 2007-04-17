Return-Path: <linux-kernel-owner+w=401wt.eu-S1031236AbXDQRJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031236AbXDQRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031244AbXDQRJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:09:56 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:53192 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031239AbXDQRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:09:51 -0400
Date: Tue, 17 Apr 2007 13:08:06 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [PATCH] documentation: convert the Documentation directory to
 UTF-8
Message-ID: <alpine.DEB.0.83.0704171247230.27446@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-1222175207-1176828544=:27446"
Content-ID: <alpine.DEB.0.83.0704171249360.914@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-1222175207-1176828544=:27446
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.0.83.0704171249361.914@sigma.j-a-k-j.com>

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the following files within the Documentation directory to UTF-8.

Documentation/binfmt_misc.txt
Documentation/kernel-docs.txt
Documentation/java.txt
Documentation/pcieaer-howto.txt
Documentation/sonypi.txt
Documentation/arm/Samsung-S3C24XX/H1940.txt
Documentation/auxdisplay/cfag12864b
Documentation/crypto/api-intro.txt
Documentation/dvb/{contributors.txt,README.dvb-usb}
Documentation/fb/{sstfb.txt,framebuffer.txt}
Documentation/hwmon/{via686a,lm83,w83792d,gl518sm,adm1026,sis5595}
Documentation/i2c/busses/{i2c-viapro,i2c-via,i2c-sis96x,i2c-i810}
Documentation/i2c/i2c-protocol
Documentation/i2o/README
Documentation/isdn/{CREDITS,README,README.icn}
Documentation/m68k/README.buddha
Documentation/networking/{slicecom.hun,packet_mmap.txt,6pack.txt}
Documentation/networking/{tms380tr.txt,slicecom.txt}
Documentation/power/swsusp.txt
Documentation/s390/Debugging390.txt
Documentation/scsi/{tmscsim.txt,aha152x.txt,st.txt}
Documentation/sound/oss/{mwave,AD1816}
Documentation/usb/{usb-serial.txt,CREDITS}
Documentation/video4linux/{ov511.txt,meye.txt,Zoran,README.pvrusb2}

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I can't get my mail client to send in ISO-8859-1 instead of UTF-8, so the 
actual patch is attached in octet-stream format. The below patch is just 
for reference and will almost certainly NOT work.

Also, since the patch includes both encodings, whichever encoding you 
select while viewing it will display one correct and one garbled line. 
However, the bytecodes -are- correct.

(I stopped collecting maintainers' Cc: addresses after the first 40. This 
patch doesn't change any information, but rather only binary 
representation of text, so hopefully this will be fine.)

This means the only file not in UTF-8 will of course be "logo.gif". 
(Shouldn't that be PNG?)

diff -uprN linux-2.6.21-rc7.orig/Documentation/arm/Samsung-S3C24XX/H1940.txt linux-2.6.21-rc7.mod/Documentation/arm/Samsung-S3C24XX/H1940.txt
--- linux-2.6.21-rc7.orig/Documentation/arm/Samsung-S3C24XX/H1940.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/arm/Samsung-S3C24XX/H1940.txt	2007-04-17 12:44:09.000000000 -0400
@@ -23,7 +23,7 @@ Support
 
     http://handhelds.org/moin/moin.cgi/HpIpaqH1940
 
-  Herbert Pˆtzl pages:
+  Herbert P√∂tzl pages:
 
     http://vserver.13thfloor.at/H1940/
 
@@ -32,7 +32,7 @@ Maintainers
 -----------
 
   This project is being maintained and developed by a variety
-  of people, including Ben Dooks, Arnaud Patard, and Herbert Pˆtzl.
+  of people, including Ben Dooks, Arnaud Patard, and Herbert P√∂tzl.
 
   Thanks to the many others who have also provided support.
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/auxdisplay/cfag12864b linux-2.6.21-rc7.mod/Documentation/auxdisplay/cfag12864b
--- linux-2.6.21-rc7.orig/Documentation/auxdisplay/cfag12864b	2007-04-17 11:41:41.000000000 -0400
+++ linux-2.6.21-rc7.mod/Documentation/auxdisplay/cfag12864b	2007-04-17 12:44:09.000000000 -0400
@@ -78,9 +78,9 @@ Select (17)-----------------------------
 Ground (18)---[GND]              [+5v]---(19) LED +
 Ground (19)---[GND]
 Ground (20)---[GND]              E    A             Values:
-Ground (21)---[GND]       [GND]---[P1]---(18) Vee    ∑ R = Resistor = 22 ohm
-Ground (22)---[GND]                |                 ∑ P1 = Preset = 10 Kohm
-Ground (23)---[GND]       ----   S ------( 3) V0     ∑ P2 = Preset = 1 Kohm
+Ground (21)---[GND]       [GND]---[P1]---(18) Vee    ¬∑ R = Resistor = 22 ohm
+Ground (22)---[GND]                |                 ¬∑ P1 = Preset = 10 Kohm
+Ground (23)---[GND]       ----   S ------( 3) V0     ¬∑ P2 = Preset = 1 Kohm
 Ground (24)---[GND]       |  |
 Ground (25)---[GND] [GND]---[P2]---[R]---(20) LED -
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/binfmt_misc.txt linux-2.6.21-rc7.mod/Documentation/binfmt_misc.txt
--- linux-2.6.21-rc7.orig/Documentation/binfmt_misc.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/binfmt_misc.txt	2007-04-17 12:44:09.000000000 -0400
@@ -113,4 +113,4 @@ cause unexpected behaviour and can be a 
 There is a web page about binfmt_misc at
 http://www.tat.physik.uni-tuebingen.de/~rguenth/linux/binfmt_misc.html
 
-Richard G¸nther <rguenth@tat.physik.uni-tuebingen.de>
+Richard G√ºnther <rguenth@tat.physik.uni-tuebingen.de>
diff -uprN linux-2.6.21-rc7.orig/Documentation/crypto/api-intro.txt linux-2.6.21-rc7.mod/Documentation/crypto/api-intro.txt
--- linux-2.6.21-rc7.orig/Documentation/crypto/api-intro.txt	2007-04-17 11:41:41.000000000 -0400
+++ linux-2.6.21-rc7.mod/Documentation/crypto/api-intro.txt	2007-04-17 12:44:09.000000000 -0400
@@ -177,7 +177,7 @@ Portions of this API were derived from t
 and;
   
   Nettle (http://www.lysator.liu.se/~nisse/nettle/)
-    Niels Mˆller
+    Niels M√∂ller
 
 Original developers of the crypto algorithms:
 
@@ -200,8 +200,8 @@ SHA1 algorithm contributors:
   
 DES algorithm contributors:
   Raimar Falke
-  Gisle SÊlensminde
-  Niels Mˆller
+  Gisle S√¶lensminde
+  Niels M√∂ller
 
 Blowfish algorithm contributors:
   Herbert Valerio Riedel
diff -uprN linux-2.6.21-rc7.orig/Documentation/dvb/contributors.txt linux-2.6.21-rc7.mod/Documentation/dvb/contributors.txt
--- linux-2.6.21-rc7.orig/Documentation/dvb/contributors.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/dvb/contributors.txt	2007-04-17 12:44:09.000000000 -0400
@@ -66,7 +66,7 @@ Michael Dreher <michael@5dot1.de>
 Andreas 'randy' Weinberger
   for the support of the Fujitsu-Siemens Activy budget DVB-S
 
-Kenneth Aafl¯y <ke-aa@frisurf.no>
+Kenneth Aafl√∏y <ke-aa@frisurf.no>
   for adding support for Typhoon DVB-S budget card
 
 Ernst Peinlich <e.peinlich@inode.at>
diff -uprN linux-2.6.21-rc7.orig/Documentation/dvb/README.dvb-usb linux-2.6.21-rc7.mod/Documentation/dvb/README.dvb-usb
--- linux-2.6.21-rc7.orig/Documentation/dvb/README.dvb-usb	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/dvb/README.dvb-usb	2007-04-17 12:44:09.000000000 -0400
@@ -228,5 +228,5 @@ Patches, comments and suggestions are ve
 
    Ulf Hermenau for helping me out with traditional chinese.
 
-   AndrÈ Smoktun and Christian Frˆmmel for supporting me with
+   Andr√© Smoktun and Christian Fr√∂mmel for supporting me with
     hardware and listening to my problems very patiently.
diff -uprN linux-2.6.21-rc7.orig/Documentation/fb/framebuffer.txt linux-2.6.21-rc7.mod/Documentation/fb/framebuffer.txt
--- linux-2.6.21-rc7.orig/Documentation/fb/framebuffer.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/fb/framebuffer.txt	2007-04-17 12:44:09.000000000 -0400
@@ -217,7 +217,7 @@ vsync length.
   +----------+---------------------------------------------+----------+-------+
   |          |                ^                            |          |       |
   |          |                |upper_margin                |          |       |
-  |          |                •                            |          |       |
+  |          |                ¬•                            |          |       |
   +----------###############################################----------+-------+
   |          #                ^                            #          |       |
   |          #                |                            #          |       |
@@ -238,15 +238,15 @@ vsync length.
   |          #                |                            #          |       |
   |          #                |                            #          |       |
   |          #                |                            #          |       |
-  |          #                •                            #          |       |
+  |          #                ¬•                            #          |       |
   +----------###############################################----------+-------+
   |          |                ^                            |          |       |
   |          |                |lower_margin                |          |       |
-  |          |                •                            |          |       |
+  |          |                ¬•                            |          |       |
   +----------+---------------------------------------------+----------+-------+
   |          |                ^                            |          |       |
   |          |                |vsync_len                   |          |       |
-  |          |                •                            |          |       |
+  |          |                ¬•                            |          |       |
   +----------+---------------------------------------------+----------+-------+
 
 The frame buffer device expects all horizontal timings in number of dotclocks
diff -uprN linux-2.6.21-rc7.orig/Documentation/fb/sstfb.txt linux-2.6.21-rc7.mod/Documentation/fb/sstfb.txt
--- linux-2.6.21-rc7.orig/Documentation/fb/sstfb.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/fb/sstfb.txt	2007-04-17 12:44:09.000000000 -0400
@@ -2,9 +2,9 @@
 Introduction
 
 	  This is a frame buffer device driver for 3dfx' Voodoo Graphics 
-	(aka voodoo 1, aka sst1) and Voodoo≤ (aka Voodoo 2, aka CVG) based 
+	(aka voodoo 1, aka sst1) and Voodoo¬≤ (aka Voodoo 2, aka CVG) based 
 	video boards. It's highly experimental code, but is guaranteed to work
-	on my computer, with my "Maxi Gamer 3D" and "Maxi Gamer 3d≤" boards,
+	on my computer, with my "Maxi Gamer 3D" and "Maxi Gamer 3d¬≤" boards,
 	and with me "between chair and keyboard". Some people tested other
 	combinations and it seems that it works.
 	  The main page is located at <http://sstfb.sourceforge.net>, and if
diff -uprN linux-2.6.21-rc7.orig/Documentation/hwmon/adm1026 linux-2.6.21-rc7.mod/Documentation/hwmon/adm1026
--- linux-2.6.21-rc7.orig/Documentation/hwmon/adm1026	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/hwmon/adm1026	2007-04-17 12:44:09.000000000 -0400
@@ -80,7 +80,7 @@ temperature sensor inputs. Both the PWM 
 used to control fan speed. Usually only one of these two outputs will be
 used. Write the minimum PWM or DAC value to the appropriate control
 register. Then set the low temperature limit in the tmin values for each
-temperature sensor. The range of control is fixed at 20 ∞C, and the
+temperature sensor. The range of control is fixed at 20 ¬∞C, and the
 largest difference between current and tmin of the temperature sensors sets
 the control output. See the datasheet for several example circuits for
 controlling fan speed with the PWM and DAC outputs. The fan speed sensors
diff -uprN linux-2.6.21-rc7.orig/Documentation/hwmon/gl518sm linux-2.6.21-rc7.mod/Documentation/hwmon/gl518sm
--- linux-2.6.21-rc7.orig/Documentation/hwmon/gl518sm	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/hwmon/gl518sm	2007-04-17 12:44:09.000000000 -0400
@@ -13,7 +13,7 @@ Supported chips:
 
 Authors:
         Frodo Looijaard <frodol@dds.nl>,
-        Kyˆsti M‰lkki <kmalkki@cc.hut.fi>
+        Ky√∂sti M√§lkki <kmalkki@cc.hut.fi>
         Hong-Gunn Chew <hglinux@gunnet.org>
         Jean Delvare <khali@linux-fr.org>
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/hwmon/lm83 linux-2.6.21-rc7.mod/Documentation/hwmon/lm83
--- linux-2.6.21-rc7.orig/Documentation/hwmon/lm83	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/hwmon/lm83	2007-04-17 12:44:09.000000000 -0400
@@ -45,7 +45,7 @@ Unconfirmed motherboards:
 The LM82 is confirmed to have been found on most AMD Geode reference
 designs and test platforms.
 
-The driver has been successfully tested by Magnus Forsstrˆm, who I'd
+The driver has been successfully tested by Magnus Forsstr√∂m, who I'd
 like to thank here. More testers will be of course welcome.
 
 The fact that the LM83 is only scarcely used can be easily explained.
diff -uprN linux-2.6.21-rc7.orig/Documentation/hwmon/sis5595 linux-2.6.21-rc7.mod/Documentation/hwmon/sis5595
--- linux-2.6.21-rc7.orig/Documentation/hwmon/sis5595	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/hwmon/sis5595	2007-04-17 12:44:09.000000000 -0400
@@ -8,7 +8,7 @@ Supported chips:
     Datasheet: Publicly available at the Silicon Integrated Systems Corp. site.
 
 Authors:
-        Kyˆsti M‰lkki <kmalkki@cc.hut.fi>,
+        Ky√∂sti M√§lkki <kmalkki@cc.hut.fi>,
         Mark D. Studebaker <mdsxyz123@yahoo.com>,
         Aurelien Jarno <aurelien@aurel32.net> 2.6 port
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/hwmon/via686a linux-2.6.21-rc7.mod/Documentation/hwmon/via686a
--- linux-2.6.21-rc7.orig/Documentation/hwmon/via686a	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/hwmon/via686a	2007-04-17 12:44:09.000000000 -0400
@@ -8,7 +8,7 @@ Supported chips:
     Datasheet: On request through web form (http://www.via.com.tw/en/support/datasheets/)
 
 Authors:
-        Kyˆsti M‰lkki <kmalkki@cc.hut.fi>,
+        Ky√∂sti M√§lkki <kmalkki@cc.hut.fi>,
         Mark D. Studebaker <mdsxyz123@yahoo.com>
         Bob Dougherty <bobd@stanford.edu>
         (Some conversion-factor data were contributed by
diff -uprN linux-2.6.21-rc7.orig/Documentation/hwmon/w83792d linux-2.6.21-rc7.mod/Documentation/hwmon/w83792d
--- linux-2.6.21-rc7.orig/Documentation/hwmon/w83792d	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/hwmon/w83792d	2007-04-17 12:44:09.000000000 -0400
@@ -107,7 +107,7 @@ Known problems:
 	  by CR[0x49h].
 	- The function of vid and vrm has not been finished, because I'm NOT
 	  very familiar with them. Adding support is welcome.
-†	- The function of chassis open detection needs more tests.
+¬†	- The function of chassis open detection needs more tests.
 	- If you have ASUS server board and chip was not found: Then you will
 	  need to upgrade to latest (or beta) BIOS. If it does not help please
 	  contact us.
diff -uprN linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-i810 linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-i810
--- linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-i810	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-i810	2007-04-17 12:44:09.000000000 -0400
@@ -7,7 +7,7 @@ Supported adapters:
 Authors: 
 	Frodo Looijaard <frodol@dds.nl>, 
 	Philip Edelbrock <phil@netroedge.com>,
-        Kyˆsti M‰lkki <kmalkki@cc.hut.fi>,
+        Ky√∂sti M√§lkki <kmalkki@cc.hut.fi>,
 	Ralph Metzler <rjkm@thp.uni-koeln.de>,
 	Mark D. Studebaker <mdsxyz123@yahoo.com>
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-sis96x linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-sis96x
--- linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-sis96x	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-sis96x	2007-04-17 12:44:09.000000000 -0400
@@ -60,7 +60,7 @@ Mark D. Studebaker <mdsxyz123@yahoo.com>
  - design hints and bug fixes
 Alexander Maylsh <amalysh@web.de>
  - ditto, plus an important datasheet... almost the one I really wanted
-Hans-G¸nter L¸tke Uphues <hg_lu@t-online.de>
+Hans-G√ºnter L√ºtke Uphues <hg_lu@t-online.de>
  - patch for SiS735
 Robert Zwerus <arzie@dds.nl>
  - testing for SiS645DX
diff -uprN linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-via linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-via
--- linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-via	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-via	2007-04-17 12:44:09.000000000 -0400
@@ -4,7 +4,7 @@ Supported adapters:
   * VIA Technologies, InC. VT82C586B
     Datasheet: Publicly available at the VIA website
 
-Author: Kyˆsti M‰lkki <kmalkki@cc.hut.fi>
+Author: Ky√∂sti M√§lkki <kmalkki@cc.hut.fi>
 
 Description
 -----------
diff -uprN linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-viapro linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-viapro
--- linux-2.6.21-rc7.orig/Documentation/i2c/busses/i2c-viapro	2007-04-17 11:41:41.000000000 -0400
+++ linux-2.6.21-rc7.mod/Documentation/i2c/busses/i2c-viapro	2007-04-17 12:44:09.000000000 -0400
@@ -17,7 +17,7 @@ Supported adapters:
     Datasheet: available on request and under NDA from VIA
 
 Authors:
-	Kyˆsti M‰lkki <kmalkki@cc.hut.fi>,
+	Ky√∂sti M√§lkki <kmalkki@cc.hut.fi>,
 	Mark D. Studebaker <mdsxyz123@yahoo.com>,
 	Jean Delvare <khali@linux-fr.org>
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/i2c/i2c-protocol linux-2.6.21-rc7.mod/Documentation/i2c/i2c-protocol
--- linux-2.6.21-rc7.orig/Documentation/i2c/i2c-protocol	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/i2c/i2c-protocol	2007-04-17 12:44:09.000000000 -0400
@@ -68,7 +68,7 @@ We have found some I2C devices that need
 
   Flags I2C_M_IGNORE_NAK
     Normally message is interrupted immediately if there is [NA] from the
-    client. Setting this flag treats any [NA] as†[A], and all of
+    client. Setting this flag treats any [NA] as¬†[A], and all of
     message is sent.
     These messages may still fail to SCL lo->hi timeout.
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/i2o/README linux-2.6.21-rc7.mod/Documentation/i2o/README
--- linux-2.6.21-rc7.orig/Documentation/i2o/README	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/i2o/README	2007-04-17 12:44:09.000000000 -0400
@@ -30,13 +30,13 @@ Juha Sievanen, University of Helsinki Fi
 	Bug fixes
 	Core code extensions
 
-Auvo H‰kkinen, University of Helsinki Finland
+Auvo H√§kkinen, University of Helsinki Finland
 	LAN OSM code
 	/Proc interface to LAN class
 	Bug fixes
 	Core code extensions
 
-Taneli V‰h‰kangas, University of Helsinki Finland
+Taneli V√§h√§kangas, University of Helsinki Finland
 	Fixes to i2o_config
 
 CREDITS
diff -uprN linux-2.6.21-rc7.orig/Documentation/isdn/CREDITS linux-2.6.21-rc7.mod/Documentation/isdn/CREDITS
--- linux-2.6.21-rc7.orig/Documentation/isdn/CREDITS	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/isdn/CREDITS	2007-04-17 12:44:09.000000000 -0400
@@ -2,7 +2,7 @@
 I want to thank all who contributed to this project and especially to:
 (in alphabetical order)
 
-Thomas Bogendˆrfer (tsbogend@bigbug.franken.de)
+Thomas Bogend√∂rfer (tsbogend@bigbug.franken.de)
   Tester, lots of bugfixes and hints.
 
 Alan Cox (alan@redhat.com)
@@ -11,7 +11,7 @@ Alan Cox (alan@redhat.com)
 Henner Eisen (eis@baty.hanse.de)
   For X.25 implementation.
 
-Volker Gˆtz (volker@oops.franken.de)
+Volker G√∂tz (volker@oops.franken.de)
   For contribution of man-pages, the imontty-tool and a perfect
   maintaining of the mailing-list at hub-wue.
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/isdn/README linux-2.6.21-rc7.mod/Documentation/isdn/README
--- linux-2.6.21-rc7.orig/Documentation/isdn/README	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/isdn/README	2007-04-17 12:44:09.000000000 -0400
@@ -402,7 +402,7 @@ README for the ISDN-subsystem
      the script tools/tcltk/isdnmon. You can add actions for line-status
      changes. See the comments at the beginning of the script for how to
      do that. There are other tty-based tools in the tools-subdirectory
-     contributed by Michael Knigge (imon), Volker Gˆtz (imontty) and
+     contributed by Michael Knigge (imon), Volker G√∂tz (imontty) and
      Andreas Kool (isdnmon).
 
    l) For initial testing, you can set the verbose-level to 2 (default: 0).
diff -uprN linux-2.6.21-rc7.orig/Documentation/isdn/README.icn linux-2.6.21-rc7.mod/Documentation/isdn/README.icn
--- linux-2.6.21-rc7.orig/Documentation/isdn/README.icn	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/isdn/README.icn	2007-04-17 12:44:09.000000000 -0400
@@ -3,8 +3,8 @@ $Id: README.icn,v 1.7 2000/08/06 09:22:5
 You can get the ICN-ISDN-card from:
 
 Thinking Objects Software GmbH
-Versbacher Rˆthe 159
-97078 W¸rzburg
+Versbacher R√∂the 159
+97078 W√ºrzburg
 Tel: +49 931 2877950
 Fax: +49 931 2877951
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/java.txt linux-2.6.21-rc7.mod/Documentation/java.txt
--- linux-2.6.21-rc7.orig/Documentation/java.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/java.txt	2007-04-17 12:44:09.000000000 -0400
@@ -390,7 +390,7 @@ the execution bit, then just do
 
 
 originally by Brian A. Lantz, brian@lantz.com
-heavily edited for binfmt_misc by Richard G¸nther
+heavily edited for binfmt_misc by Richard G√ºnther
 new scripts by Colin J. Watson <cjw44@cam.ac.uk>
 added executable Jar file support by Kurt Huwig <kurt@iku-netz.de>
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/kernel-docs.txt linux-2.6.21-rc7.mod/Documentation/kernel-docs.txt
--- linux-2.6.21-rc7.orig/Documentation/kernel-docs.txt	2007-04-17 11:41:41.000000000 -0400
+++ linux-2.6.21-rc7.mod/Documentation/kernel-docs.txt	2007-04-17 12:44:09.000000000 -0400
@@ -236,7 +236,7 @@
 
      * Title: "Design and Implementation of the Second Extended
        Filesystem"
-       Author: RÈmy Card, Theodore Ts'o, Stephen Tweedie.
+       Author: R√©my Card, Theodore Ts'o, Stephen Tweedie.
        URL: http://web.mit.edu/tytso/www/linux/ext2intro.html
        Keywords: ext2, linux fs history, inode, directory, link, devices,
        VFS, physical structure, performance, benchmarks, ext2fs library,
diff -uprN linux-2.6.21-rc7.orig/Documentation/m68k/README.buddha linux-2.6.21-rc7.mod/Documentation/m68k/README.buddha
--- linux-2.6.21-rc7.orig/Documentation/m68k/README.buddha	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/m68k/README.buddha	2007-04-17 12:44:09.000000000 -0400
@@ -204,7 +204,7 @@ always  shows a "no IRQ here" on the Bud
 the  third  IDE  port  are  going into data's Nirwana on the
 Buddha.
 
-			    Jens Schˆnfeld february 19th, 1997
+			    Jens Sch√∂nfeld february 19th, 1997
 					updated may 27th, 1997
 			     eMail: sysop@nostlgic.tng.oche.de
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/networking/6pack.txt linux-2.6.21-rc7.mod/Documentation/networking/6pack.txt
--- linux-2.6.21-rc7.orig/Documentation/networking/6pack.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/networking/6pack.txt	2007-04-17 12:44:09.000000000 -0400
@@ -1,6 +1,6 @@
 This is the 6pack-mini-HOWTO, written by
 
-Andreas Kˆnsgen DG3KQ
+Andreas K√∂nsgen DG3KQ
 Internet: ajk@iehk.rwth-aachen.de
 AMPR-net: dg3kq@db0pra.ampr.org
 AX.25:    dg3kq@db0ach.#nrw.deu.eu
diff -uprN linux-2.6.21-rc7.orig/Documentation/networking/packet_mmap.txt linux-2.6.21-rc7.mod/Documentation/networking/packet_mmap.txt
--- linux-2.6.21-rc7.orig/Documentation/networking/packet_mmap.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/networking/packet_mmap.txt	2007-04-17 12:44:09.000000000 -0400
@@ -13,7 +13,7 @@ You can find the latest version of this 
 
 Please send me your comments to
 
-    Ulisses Alonso CamarÛ <uaca@i.hate.spam.alumni.uv.es>
+    Ulisses Alonso Camar√≥ <uaca@i.hate.spam.alumni.uv.es>
 
 -------------------------------------------------------------------------------
 + Why use PACKET_MMAP
diff -uprN linux-2.6.21-rc7.orig/Documentation/networking/slicecom.hun linux-2.6.21-rc7.mod/Documentation/networking/slicecom.hun
--- linux-2.6.21-rc7.orig/Documentation/networking/slicecom.hun	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/networking/slicecom.hun	2007-04-17 12:44:09.000000000 -0400
@@ -1,7 +1,7 @@
 
 SliceCOM adapter felhasznaloi dokumentacioja - 0.51 verziohoz
 
-BartÛk Istv·n <bartoki@itc.hu>
+Bart√≥k Istv√°n <bartoki@itc.hu>
 Utolso modositas: Wed Aug 29 17:26:58 CEST 2001
 
 -----------------------------------------------------------------
diff -uprN linux-2.6.21-rc7.orig/Documentation/networking/slicecom.txt linux-2.6.21-rc7.mod/Documentation/networking/slicecom.txt
--- linux-2.6.21-rc7.orig/Documentation/networking/slicecom.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/networking/slicecom.txt	2007-04-17 12:44:09.000000000 -0400
@@ -1,9 +1,9 @@
 
 SliceCOM adapter user's documentation - for the 0.51 driver version
 
-Written by BartÛk Istv·n <bartoki@itc.hu>
+Written by Bart√≥k Istv√°n <bartoki@itc.hu>
 
-English translation: Lakatos Gyˆrgy <gyuri@itc.hu>
+English translation: Lakatos Gy√∂rgy <gyuri@itc.hu>
 Mon Dec 11 15:28:42 CET 2000
 
 Last modified: Wed Aug 29 17:25:37 CEST 2001
diff -uprN linux-2.6.21-rc7.orig/Documentation/networking/tms380tr.txt linux-2.6.21-rc7.mod/Documentation/networking/tms380tr.txt
--- linux-2.6.21-rc7.orig/Documentation/networking/tms380tr.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/networking/tms380tr.txt	2007-04-17 12:44:09.000000000 -0400
@@ -71,24 +71,24 @@ Below find attached the setting for the 
   CHAPTER 1     LOCATION OF DIP-SWITCH
   ==============================================================
 
-Uƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
-˛Uƒƒƒƒƒƒø                         Uƒƒƒƒƒø            Uƒƒƒø         ˛
-˛AƒƒƒƒƒƒU                      W1 AƒƒƒƒƒU     Uƒƒƒƒø ˛   ˛         ˛
-˛Uƒƒƒƒƒƒø                                     ˛    ˛ ˛   ˛      Uƒƒ≈ø
-˛AƒƒƒƒƒƒU              Uƒƒƒƒƒƒƒƒƒƒƒø          AƒƒƒƒU ˛   ˛      ˛  ˛˛
-˛Uƒƒƒƒƒƒø              ˛           ˛          Uƒƒƒø  AƒƒƒU      Aƒƒ≈U
-˛AƒƒƒƒƒƒU              ˛ TMS380C26 ˛          ˛   ˛                ˛
-˛Uƒƒƒƒƒƒø              ˛           ˛          AƒƒƒU                Aƒø
-˛AƒƒƒƒƒƒU              ˛           ˛                               ˛ ˛
-˛                      AƒƒƒƒƒƒƒƒƒƒƒU                               ˛ ˛
-˛                                                                  ˛ ˛
-˛                                                                  AƒU
-˛                                                                  ˛
-˛                                                                  ˛
-˛                                                                  ˛
-˛                                                                  ˛
-AƒƒƒƒƒƒƒƒƒƒƒƒAƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒAƒƒAƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒAƒƒƒƒƒƒƒƒƒU
-             AƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒU  AƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒU
+U√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø
+√æU√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø                         U√Ñ√Ñ√Ñ√Ñ√Ñ¬ø            U√Ñ√Ñ√Ñ¬ø         √æ
+√æA√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU                      W1 A√Ñ√Ñ√Ñ√Ñ√ÑU     U√Ñ√Ñ√Ñ√Ñ¬ø √æ   √æ         √æ
+√æU√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø                                     √æ    √æ √æ   √æ      U√Ñ√Ñ√Ö¬ø
+√æA√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU              U√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø          A√Ñ√Ñ√Ñ√ÑU √æ   √æ      √æ  √æ√æ
+√æU√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø              √æ           √æ          U√Ñ√Ñ√Ñ¬ø  A√Ñ√Ñ√ÑU      A√Ñ√Ñ√ÖU
+√æA√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU              √æ TMS380C26 √æ          √æ   √æ                √æ
+√æU√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ¬ø              √æ           √æ          A√Ñ√Ñ√ÑU                A√Ñ¬ø
+√æA√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU              √æ           √æ                               √æ √æ
+√æ                      A√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU                               √æ √æ
+√æ                                                                  √æ √æ
+√æ                                                                  A√ÑU
+√æ                                                                  √æ
+√æ                                                                  √æ
+√æ                                                                  √æ
+√æ                                                                  √æ
+A√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑA√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑA√Ñ√ÑA√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑA√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU
+             A√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU  A√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√Ñ√ÑU
 
   ==============================================================
   CHAPTER 2     DEFAULT SETTINGS
@@ -108,9 +108,9 @@ AƒƒƒƒƒƒƒƒƒƒƒƒAƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒAƒƒAƒƒƒƒƒƒ
   CHAPTER 3     DIP SWITCH W1 DESCRIPTION
   ==============================================================
 
-      UƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒø  ON
-      ˛ 1 ˛ 2 ˛ 3 ˛ 4 ˛ 5 ˛ 6 ˛ 7 ˛ 8 ˛
-      AƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒAƒƒƒU  OFF
+      U√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√Ñ¬ø  ON
+      √æ 1 √æ 2 √æ 3 √æ 4 √æ 5 √æ 6 √æ 7 √æ 8 √æ
+      A√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑA√Ñ√Ñ√ÑU  OFF
       |AD | BootROM Addr. |  I/O      |
       +-+-+-------+-------+-----+-----+
         |         |             |
diff -uprN linux-2.6.21-rc7.orig/Documentation/pcieaer-howto.txt linux-2.6.21-rc7.mod/Documentation/pcieaer-howto.txt
--- linux-2.6.21-rc7.orig/Documentation/pcieaer-howto.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/pcieaer-howto.txt	2007-04-17 12:44:09.000000000 -0400
@@ -13,7 +13,7 @@ Reporting (AER) driver and provides info
 well as how to enable the drivers of endpoint devices to conform with
 PCI Express AER driver.
 
-1.2 Copyright © Intel Corporation 2006.
+1.2 Copyright ¬© Intel Corporation 2006.
 
 1.3 What is the PCI Express AER Driver?
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/power/swsusp.txt linux-2.6.21-rc7.mod/Documentation/power/swsusp.txt
--- linux-2.6.21-rc7.orig/Documentation/power/swsusp.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/power/swsusp.txt	2007-04-17 12:44:09.000000000 -0400
@@ -48,7 +48,7 @@ before suspend (it is limited to 500 MB 
 
 Article about goals and implementation of Software Suspend for Linux
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-Author: GÇ·bor Kuti
+Author: G¬Ç√°bor Kuti
 Last revised: 2003-10-20 by Pavel Machek
 
 Idea and goals to achieve
diff -uprN linux-2.6.21-rc7.orig/Documentation/s390/Debugging390.txt linux-2.6.21-rc7.mod/Documentation/s390/Debugging390.txt
--- linux-2.6.21-rc7.orig/Documentation/s390/Debugging390.txt	2007-04-17 11:41:41.000000000 -0400
+++ linux-2.6.21-rc7.mod/Documentation/s390/Debugging390.txt	2007-04-17 12:44:09.000000000 -0400
@@ -2209,7 +2209,7 @@ Breakpoint 2 at 0x4d87a4: file top.c, li
 #3  0x5167e6 in readline_internal_char () at readline.c:454
 #4  0x5168ee in readline_internal_charloop () at readline.c:507
 #5  0x51692c in readline_internal () at readline.c:521
-#6  0x5164fe in readline (prompt=0x7ffff810 "\177ÅˇÅ¯x\177ÅˇÅ˜Åÿ\177ÅˇÅ¯xÅ¿")
+#6  0x5164fe in readline (prompt=0x7ffff810 "\177¬Å√ø¬Å√∏x\177¬Å√ø¬Å√∑¬Å√ò\177¬Å√ø¬Å√∏x¬Å√Ä")
     at readline.c:349
 #7  0x4d7a8a in command_line_input (prrompt=0x564420 "(gdb) ", repeat=1,
     annotation_suffix=0x4d6b44 "prompt") at top.c:2091
diff -uprN linux-2.6.21-rc7.orig/Documentation/scsi/aha152x.txt linux-2.6.21-rc7.mod/Documentation/scsi/aha152x.txt
--- linux-2.6.21-rc7.orig/Documentation/scsi/aha152x.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/scsi/aha152x.txt	2007-04-17 12:44:09.000000000 -0400
@@ -1,7 +1,7 @@
 $Id: README.aha152x,v 1.2 1999/12/25 15:32:30 fischer Exp fischer $
 Adaptec AHA-1520/1522 SCSI driver for Linux (aha152x)
 
-Copyright 1993-1999 J¸rgen Fischer <fischer@norbit.de>
+Copyright 1993-1999 J√ºrgen Fischer <fischer@norbit.de>
 TC1550 patches by Luuk van Dijk (ldz@xs4all.nl)
 
 
diff -uprN linux-2.6.21-rc7.orig/Documentation/scsi/st.txt linux-2.6.21-rc7.mod/Documentation/scsi/st.txt
--- linux-2.6.21-rc7.orig/Documentation/scsi/st.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/scsi/st.txt	2007-04-17 12:44:09.000000000 -0400
@@ -1,5 +1,5 @@
 This file contains brief information about the SCSI tape driver.
-The driver is currently maintained by Kai M‰kisara (email
+The driver is currently maintained by Kai M√§kisara (email
 Kai.Makisara@kolumbus.fi)
 
 Last modified: Mon Mar  7 21:14:44 2005 by kai.makisara
diff -uprN linux-2.6.21-rc7.orig/Documentation/scsi/tmscsim.txt linux-2.6.21-rc7.mod/Documentation/scsi/tmscsim.txt
--- linux-2.6.21-rc7.orig/Documentation/scsi/tmscsim.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/scsi/tmscsim.txt	2007-04-17 12:44:09.000000000 -0400
@@ -426,7 +426,7 @@ Thanks to Linus Torvalds, Alan Cox, the 
 all the others for the wonderful OS and software.
 Thanks to C.L. Huang and Philip Giang (Tekram) for the initial driver
 release and support.
-Thanks to Doug Ledford, GÈrard Roudier for support with SCSI coding.
+Thanks to Doug Ledford, G√©rard Roudier for support with SCSI coding.
 Thanks to a lot of people (espec. Chiaki Ishikawa, Andreas Haumer, Hubert 
 Tonneau) for intensively testing the driver (and even risking data loss
 doing this during early revisions).
diff -uprN linux-2.6.21-rc7.orig/Documentation/sonypi.txt linux-2.6.21-rc7.mod/Documentation/sonypi.txt
--- linux-2.6.21-rc7.orig/Documentation/sonypi.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/sonypi.txt	2007-04-17 12:44:09.000000000 -0400
@@ -1,7 +1,7 @@
 Sony Programmable I/O Control Device Driver Readme
 --------------------------------------------------
 	Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
-	Copyright (C) 2001-2002 AlcÙve <www.alcove.com>
+	Copyright (C) 2001-2002 Alc√¥ve <www.alcove.com>
 	Copyright (C) 2001 Michael Ashley <m.ashley@unsw.edu.au>
 	Copyright (C) 2001 Junichi Morita <jun1m@mars.dti.ne.jp>
 	Copyright (C) 2000 Takaya Kinjo <t-kinjo@tc4.so-net.ne.jp>
diff -uprN linux-2.6.21-rc7.orig/Documentation/sound/oss/AD1816 linux-2.6.21-rc7.mod/Documentation/sound/oss/AD1816
--- linux-2.6.21-rc7.orig/Documentation/sound/oss/AD1816	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/sound/oss/AD1816	2007-04-17 12:44:09.000000000 -0400
@@ -17,7 +17,7 @@ Features:
 List of features supported by this driver:
 - full-duplex support
 - supported audio formats: unsigned 8bit, signed 16bit little endian, 
-                           signed 16bit big endian, µ-law, A-law
+                           signed 16bit big endian, ¬µ-law, A-law
 - supported channels: mono and stereo
 - supported recording sources: Master, CD, Line, Line1, Line2, Mic
 - supports phat 3d stereo circuit (Line 3)
diff -uprN linux-2.6.21-rc7.orig/Documentation/sound/oss/mwave linux-2.6.21-rc7.mod/Documentation/sound/oss/mwave
--- linux-2.6.21-rc7.orig/Documentation/sound/oss/mwave	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/sound/oss/mwave	2007-04-17 12:44:09.000000000 -0400
@@ -163,7 +163,7 @@ OR the Default= line COULD be
 Default=SBPRO
 
 Reboot to Windows 95 and choose Linux. When booted, use sndconfig to configure
-the sound modules and voil‡ - ThinkPad sound with Linux.
+the sound modules and voil√† - ThinkPad sound with Linux.
 
 Now the gotchas - you can either have CD sound OR Mixers but not both. That's a
 problem with the SB1.5 (CD sound) or SBPRO (Mixers) settings. No one knows why
diff -uprN linux-2.6.21-rc7.orig/Documentation/usb/CREDITS linux-2.6.21-rc7.mod/Documentation/usb/CREDITS
--- linux-2.6.21-rc7.orig/Documentation/usb/CREDITS	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/usb/CREDITS	2007-04-17 12:44:09.000000000 -0400
@@ -65,7 +65,7 @@ THANKS file in Inaky's driver):
           will sell keyboards to some of the 3 million (at least)
           Linux users.
 
-        - Many thanks to ing b¸ro h doran [http://www.ibhdoran.com]!
+        - Many thanks to ing b√ºro h doran [http://www.ibhdoran.com]!
           It was almost impossible to get a PC backplate USB connector
           for the motherboard here at Europe (mine, home-made, was
           quite lousy :). Now I know where to acquire nice USB stuff!
diff -uprN linux-2.6.21-rc7.orig/Documentation/usb/usb-serial.txt linux-2.6.21-rc7.mod/Documentation/usb/usb-serial.txt
--- linux-2.6.21-rc7.orig/Documentation/usb/usb-serial.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/usb/usb-serial.txt	2007-04-17 12:44:09.000000000 -0400
@@ -45,9 +45,9 @@ ConnectTech WhiteHEAT 4 port converter
   Stuart MacDonald at stuartm@connecttech.com
 
 
-HandSpring Visor, Palm USB, and CliÈ USB driver
+HandSpring Visor, Palm USB, and Cli√© USB driver
 
-  This driver works with all HandSpring USB, Palm USB, and Sony CliÈ USB
+  This driver works with all HandSpring USB, Palm USB, and Sony Cli√© USB
   devices.
 
   Only when the device tries to connect to the host, will the device show
@@ -69,7 +69,7 @@ HandSpring Visor, Palm USB, and CliÈ USB
   the port to use for the HotSync transfer. The "Generic" port can be used
   for other device communication, such as a PPP link.
 
-  For some Sony CliÈ devices, /dev/ttyUSB0 must be used to talk to the
+  For some Sony Cli√© devices, /dev/ttyUSB0 must be used to talk to the
   device.  This is true for all OS version 3.5 devices, and most devices
   that have had a flash upgrade to a newer version of the OS.  See the
   kernel system log for information on which is the correct port to use.
diff -uprN linux-2.6.21-rc7.orig/Documentation/video4linux/meye.txt linux-2.6.21-rc7.mod/Documentation/video4linux/meye.txt
--- linux-2.6.21-rc7.orig/Documentation/video4linux/meye.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/video4linux/meye.txt	2007-04-17 12:44:09.000000000 -0400
@@ -1,7 +1,7 @@
 Vaio Picturebook Motion Eye Camera Driver Readme
 ------------------------------------------------
 	Copyright (C) 2001-2004 Stelian Pop <stelian@popies.net>
-	Copyright (C) 2001-2002 AlcÙve <www.alcove.com>
+	Copyright (C) 2001-2002 Alc√¥ve <www.alcove.com>
 	Copyright (C) 2000 Andrew Tridgell <tridge@samba.org>
 
 This driver enable the use of video4linux compatible applications with the
diff -uprN linux-2.6.21-rc7.orig/Documentation/video4linux/ov511.txt linux-2.6.21-rc7.mod/Documentation/video4linux/ov511.txt
--- linux-2.6.21-rc7.orig/Documentation/video4linux/ov511.txt	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/video4linux/ov511.txt	2007-04-17 12:44:09.000000000 -0400
@@ -195,11 +195,11 @@ MODULE PARAMETERS:
   NAME: bandingfilter
   TYPE: integer (Boolean)
   DEFAULT: 0 (off)
-  DESC: Enables the sensor¥s banding filter exposure algorithm. This reduces
+  DESC: Enables the sensor¬¥s banding filter exposure algorithm. This reduces
 	or stabilizes the "banding" caused by some artificial light sources
 	(especially fluorescent). You might have to set lightfreq correctly for
 	this to work right. As an added bonus, this sometimes makes it
-	possible to capture your monitor¥s output.
+	possible to capture your monitor¬¥s output.
 
   NAME: fastset
   TYPE: integer (Boolean)
diff -uprN linux-2.6.21-rc7.orig/Documentation/video4linux/README.pvrusb2 linux-2.6.21-rc7.mod/Documentation/video4linux/README.pvrusb2
--- linux-2.6.21-rc7.orig/Documentation/video4linux/README.pvrusb2	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-rc7.mod/Documentation/video4linux/README.pvrusb2	2007-04-17 12:44:09.000000000 -0400
@@ -8,7 +8,7 @@ Background:
 
   This driver is intended for the "Hauppauge WinTV PVR USB 2.0", which
   is a USB 2.0 hosted TV Tuner.  This driver is a work in progress.
-  Its history started with the reverse-engineering effort by Bjˆrn
+  Its history started with the reverse-engineering effort by Bj√∂rn
   Danielsson <pvrusb2@dax.nu> whose web page can be found here:
 
     http://pvrusb2.dax.nu/
diff -uprN linux-2.6.21-rc7.orig/Documentation/video4linux/Zoran linux-2.6.21-rc7.mod/Documentation/video4linux/Zoran
--- linux-2.6.21-rc7.orig/Documentation/video4linux/Zoran	2007-04-17 11:41:42.000000000 -0400
+++ linux-2.6.21-rc7.mod/Documentation/video4linux/Zoran	2007-04-17 12:44:09.000000000 -0400
@@ -242,7 +242,7 @@ can generate: PAL , NTSC , SECAM
 
 Conexant bt866 TV encoder
 is used in AVS6EYES, and
-can generate: NTSC/PAL, PAL≠M, PAL≠N
+can generate: NTSC/PAL, PAL¬≠M, PAL¬≠N
 
 The adv717x, should be able to produce PAL N. But you find nothing PAL N
 specific in the registers. Seem that you have to reuse a other standard
--1875672472-1222175207-1176828544=:27446
Content-Type: APPLICATION/octet-stream; name=patch-Documentation.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.83.0704171308060.914@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=patch-Documentation.bin

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlv
bi9hcm0vU2Ftc3VuZy1TM0MyNFhYL0gxOTQwLnR4dCBsaW51eC0yLjYuMjEt
cmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2FybS9TYW1zdW5nLVMzQzI0WFgvSDE5
NDAudHh0Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlv
bi9hcm0vU2Ftc3VuZy1TM0MyNFhYL0gxOTQwLnR4dAkyMDA3LTAyLTA0IDEz
OjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5t
b2QvRG9jdW1lbnRhdGlvbi9hcm0vU2Ftc3VuZy1TM0MyNFhYL0gxOTQwLnR4
dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMjMs
NyArMjMsNyBAQCBTdXBwb3J0CiAKICAgICBodHRwOi8vaGFuZGhlbGRzLm9y
Zy9tb2luL21vaW4uY2dpL0hwSXBhcUgxOTQwCiAKLSAgSGVyYmVydCBQ9nR6
bCBwYWdlczoKKyAgSGVyYmVydCBQw7Z0emwgcGFnZXM6CiAKICAgICBodHRw
Oi8vdnNlcnZlci4xM3RoZmxvb3IuYXQvSDE5NDAvCiAKQEAgLTMyLDcgKzMy
LDcgQEAgTWFpbnRhaW5lcnMKIC0tLS0tLS0tLS0tCiAKICAgVGhpcyBwcm9q
ZWN0IGlzIGJlaW5nIG1haW50YWluZWQgYW5kIGRldmVsb3BlZCBieSBhIHZh
cmlldHkKLSAgb2YgcGVvcGxlLCBpbmNsdWRpbmcgQmVuIERvb2tzLCBBcm5h
dWQgUGF0YXJkLCBhbmQgSGVyYmVydCBQ9nR6bC4KKyAgb2YgcGVvcGxlLCBp
bmNsdWRpbmcgQmVuIERvb2tzLCBBcm5hdWQgUGF0YXJkLCBhbmQgSGVyYmVy
dCBQw7Z0emwuCiAKICAgVGhhbmtzIHRvIHRoZSBtYW55IG90aGVycyB3aG8g
aGF2ZSBhbHNvIHByb3ZpZGVkIHN1cHBvcnQuCiAKZGlmZiAtdXByTiBsaW51
eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9hdXhkaXNwbGF5L2Nm
YWcxMjg2NGIgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9h
dXhkaXNwbGF5L2NmYWcxMjg2NGIKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3Jp
Zy9Eb2N1bWVudGF0aW9uL2F1eGRpc3BsYXkvY2ZhZzEyODY0YgkyMDA3LTA0
LTE3IDExOjQxOjQxLjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjIx
LXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9hdXhkaXNwbGF5L2NmYWcxMjg2NGIJ
MjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTc4LDkg
Kzc4LDkgQEAgU2VsZWN0ICgxNyktLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQogR3JvdW5kICgxOCktLS1bR05EXSAgICAgICAgICAgICAgWys1dl0t
LS0oMTkpIExFRCArCiBHcm91bmQgKDE5KS0tLVtHTkRdCiBHcm91bmQgKDIw
KS0tLVtHTkRdICAgICAgICAgICAgICBFICAgIEEgICAgICAgICAgICAgVmFs
dWVzOgotR3JvdW5kICgyMSktLS1bR05EXSAgICAgICBbR05EXS0tLVtQMV0t
LS0oMTgpIFZlZSAgICC3IFIgPSBSZXNpc3RvciA9IDIyIG9obQotR3JvdW5k
ICgyMiktLS1bR05EXSAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAg
ICC3IFAxID0gUHJlc2V0ID0gMTAgS29obQotR3JvdW5kICgyMyktLS1bR05E
XSAgICAgICAtLS0tICAgUyAtLS0tLS0oIDMpIFYwICAgICC3IFAyID0gUHJl
c2V0ID0gMSBLb2htCitHcm91bmQgKDIxKS0tLVtHTkRdICAgICAgIFtHTkRd
LS0tW1AxXS0tLSgxOCkgVmVlICAgIMK3IFIgPSBSZXNpc3RvciA9IDIyIG9o
bQorR3JvdW5kICgyMiktLS1bR05EXSAgICAgICAgICAgICAgICB8ICAgICAg
ICAgICAgICAgICDCtyBQMSA9IFByZXNldCA9IDEwIEtvaG0KK0dyb3VuZCAo
MjMpLS0tW0dORF0gICAgICAgLS0tLSAgIFMgLS0tLS0tKCAzKSBWMCAgICAg
wrcgUDIgPSBQcmVzZXQgPSAxIEtvaG0KIEdyb3VuZCAoMjQpLS0tW0dORF0g
ICAgICAgfCAgfAogR3JvdW5kICgyNSktLS1bR05EXSBbR05EXS0tLVtQMl0t
LS1bUl0tLS0oMjApIExFRCAtCiAKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEt
cmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9iaW5mbXRfbWlzYy50eHQgbGludXgt
Mi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9iaW5mbXRfbWlzYy50eHQK
LS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2JpbmZt
dF9taXNjLnR4dAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUw
MAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9iaW5m
bXRfbWlzYy50eHQJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0
MDAKQEAgLTExMyw0ICsxMTMsNCBAQCBjYXVzZSB1bmV4cGVjdGVkIGJlaGF2
aW91ciBhbmQgY2FuIGJlIGEgCiBUaGVyZSBpcyBhIHdlYiBwYWdlIGFib3V0
IGJpbmZtdF9taXNjIGF0CiBodHRwOi8vd3d3LnRhdC5waHlzaWsudW5pLXR1
ZWJpbmdlbi5kZS9+cmd1ZW50aC9saW51eC9iaW5mbXRfbWlzYy5odG1sCiAK
LVJpY2hhcmQgR/xudGhlciA8cmd1ZW50aEB0YXQucGh5c2lrLnVuaS10dWVi
aW5nZW4uZGU+CitSaWNoYXJkIEfDvG50aGVyIDxyZ3VlbnRoQHRhdC5waHlz
aWsudW5pLXR1ZWJpbmdlbi5kZT4KZGlmZiAtdXByTiBsaW51eC0yLjYuMjEt
cmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9jcnlwdG8vYXBpLWludHJvLnR4dCBs
aW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2NyeXB0by9hcGkt
aW50cm8udHh0Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRh
dGlvbi9jcnlwdG8vYXBpLWludHJvLnR4dAkyMDA3LTA0LTE3IDExOjQxOjQx
LjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9j
dW1lbnRhdGlvbi9jcnlwdG8vYXBpLWludHJvLnR4dAkyMDA3LTA0LTE3IDEy
OjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMTc3LDcgKzE3Nyw3IEBAIFBv
cnRpb25zIG9mIHRoaXMgQVBJIHdlcmUgZGVyaXZlZCBmcm9tIHQKIGFuZDsK
ICAgCiAgIE5ldHRsZSAoaHR0cDovL3d3dy5seXNhdG9yLmxpdS5zZS9+bmlz
c2UvbmV0dGxlLykKLSAgICBOaWVscyBN9mxsZXIKKyAgICBOaWVscyBNw7Zs
bGVyCiAKIE9yaWdpbmFsIGRldmVsb3BlcnMgb2YgdGhlIGNyeXB0byBhbGdv
cml0aG1zOgogCkBAIC0yMDAsOCArMjAwLDggQEAgU0hBMSBhbGdvcml0aG0g
Y29udHJpYnV0b3JzOgogICAKIERFUyBhbGdvcml0aG0gY29udHJpYnV0b3Jz
OgogICBSYWltYXIgRmFsa2UKLSAgR2lzbGUgU+ZsZW5zbWluZGUKLSAgTmll
bHMgTfZsbGVyCisgIEdpc2xlIFPDpmxlbnNtaW5kZQorICBOaWVscyBNw7Zs
bGVyCiAKIEJsb3dmaXNoIGFsZ29yaXRobSBjb250cmlidXRvcnM6CiAgIEhl
cmJlcnQgVmFsZXJpbyBSaWVkZWwKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEt
cmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9kdmIvY29udHJpYnV0b3JzLnR4dCBs
aW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2R2Yi9jb250cmli
dXRvcnMudHh0Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRh
dGlvbi9kdmIvY29udHJpYnV0b3JzLnR4dAkyMDA3LTAyLTA0IDEzOjQ0OjU0
LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9j
dW1lbnRhdGlvbi9kdmIvY29udHJpYnV0b3JzLnR4dAkyMDA3LTA0LTE3IDEy
OjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtNjYsNyArNjYsNyBAQCBNaWNo
YWVsIERyZWhlciA8bWljaGFlbEA1ZG90MS5kZT4KIEFuZHJlYXMgJ3JhbmR5
JyBXZWluYmVyZ2VyCiAgIGZvciB0aGUgc3VwcG9ydCBvZiB0aGUgRnVqaXRz
dS1TaWVtZW5zIEFjdGl2eSBidWRnZXQgRFZCLVMKIAotS2VubmV0aCBBYWZs
+HkgPGtlLWFhQGZyaXN1cmYubm8+CitLZW5uZXRoIEFhZmzDuHkgPGtlLWFh
QGZyaXN1cmYubm8+CiAgIGZvciBhZGRpbmcgc3VwcG9ydCBmb3IgVHlwaG9v
biBEVkItUyBidWRnZXQgY2FyZAogCiBFcm5zdCBQZWlubGljaCA8ZS5wZWlu
bGljaEBpbm9kZS5hdD4KZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9y
aWcvRG9jdW1lbnRhdGlvbi9kdmIvUkVBRE1FLmR2Yi11c2IgbGludXgtMi42
LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9kdmIvUkVBRE1FLmR2Yi11c2IK
LS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2R2Yi9S
RUFETUUuZHZiLXVzYgkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAt
MDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9k
dmIvUkVBRE1FLmR2Yi11c2IJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAw
MDAgLTA0MDAKQEAgLTIyOCw1ICsyMjgsNSBAQCBQYXRjaGVzLCBjb21tZW50
cyBhbmQgc3VnZ2VzdGlvbnMgYXJlIHZlCiAKICAgIFVsZiBIZXJtZW5hdSBm
b3IgaGVscGluZyBtZSBvdXQgd2l0aCB0cmFkaXRpb25hbCBjaGluZXNlLgog
Ci0gICBBbmRy6SBTbW9rdHVuIGFuZCBDaHJpc3RpYW4gRnL2bW1lbCBmb3Ig
c3VwcG9ydGluZyBtZSB3aXRoCisgICBBbmRyw6kgU21va3R1biBhbmQgQ2hy
aXN0aWFuIEZyw7ZtbWVsIGZvciBzdXBwb3J0aW5nIG1lIHdpdGgKICAgICBo
YXJkd2FyZSBhbmQgbGlzdGVuaW5nIHRvIG15IHByb2JsZW1zIHZlcnkgcGF0
aWVudGx5LgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1
bWVudGF0aW9uL2ZiL2ZyYW1lYnVmZmVyLnR4dCBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9Eb2N1bWVudGF0aW9uL2ZiL2ZyYW1lYnVmZmVyLnR4dAotLS0gbGlu
dXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vZmIvZnJhbWVidWZm
ZXIudHh0CTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisr
KyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2ZiL2ZyYW1l
YnVmZmVyLnR4dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQw
MApAQCAtMjE3LDcgKzIxNyw3IEBAIHZzeW5jIGxlbmd0aC4KICAgKy0tLS0t
LS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLSsKICAgfCAgICAgICAgICB8ICAg
ICAgICAgICAgICAgIF4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
ICAgICAgICB8ICAgICAgIHwKICAgfCAgICAgICAgICB8ICAgICAgICAgICAg
ICAgIHx1cHBlcl9tYXJnaW4gICAgICAgICAgICAgICAgfCAgICAgICAgICB8
ICAgICAgIHwKLSAgfCAgICAgICAgICB8ICAgICAgICAgICAgICAgIKUgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICB8ICAgICAgIHwK
KyAgfCAgICAgICAgICB8ICAgICAgICAgICAgICAgIMKlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICAgICAgICAgfCAgICAgICB8CiAgICstLS0t
LS0tLS0tIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMtLS0tLS0tLS0tKy0tLS0tLS0rCiAgIHwgICAgICAgICAgIyAg
ICAgICAgICAgICAgICBeICAgICAgICAgICAgICAgICAgICAgICAgICAgICMg
ICAgICAgICAgfCAgICAgICB8CiAgIHwgICAgICAgICAgIyAgICAgICAgICAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICMgICAgICAgICAg
fCAgICAgICB8CkBAIC0yMzgsMTUgKzIzOCwxNSBAQCB2c3luYyBsZW5ndGgu
CiAgIHwgICAgICAgICAgIyAgICAgICAgICAgICAgICB8ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICMgICAgICAgICAgfCAgICAgICB8CiAgIHwgICAg
ICAgICAgIyAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICMgICAgICAgICAgfCAgICAgICB8CiAgIHwgICAgICAgICAgIyAg
ICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICMg
ICAgICAgICAgfCAgICAgICB8Ci0gIHwgICAgICAgICAgIyAgICAgICAgICAg
ICAgICClICAgICAgICAgICAgICAgICAgICAgICAgICAgICMgICAgICAgICAg
fCAgICAgICB8CisgIHwgICAgICAgICAgIyAgICAgICAgICAgICAgICDCpSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAjICAgICAgICAgIHwgICAgICAg
fAogICArLS0tLS0tLS0tLSMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjLS0tLS0tLS0tLSstLS0tLS0tKwogICB8ICAg
ICAgICAgIHwgICAgICAgICAgICAgICAgXiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgICAgICAgIHwgICAgICAgfAogICB8ICAgICAgICAgIHwg
ICAgICAgICAgICAgICAgfGxvd2VyX21hcmdpbiAgICAgICAgICAgICAgICB8
ICAgICAgICAgIHwgICAgICAgfAotICB8ICAgICAgICAgIHwgICAgICAgICAg
ICAgICAgpSAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAg
IHwgICAgICAgfAorICB8ICAgICAgICAgIHwgICAgICAgICAgICAgICAgwqUg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICB8ICAgICAg
IHwKICAgKy0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLSsKICAgfCAg
ICAgICAgICB8ICAgICAgICAgICAgICAgIF4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgICAgICAgICB8ICAgICAgIHwKICAgfCAgICAgICAgICB8
ICAgICAgICAgICAgICAgIHx2c3luY19sZW4gICAgICAgICAgICAgICAgICAg
fCAgICAgICAgICB8ICAgICAgIHwKLSAgfCAgICAgICAgICB8ICAgICAgICAg
ICAgICAgIKUgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAg
ICB8ICAgICAgIHwKKyAgfCAgICAgICAgICB8ICAgICAgICAgICAgICAgIMKl
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgfCAgICAg
ICB8CiAgICstLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tKy0tLS0tLS0rCiAKIFRo
ZSBmcmFtZSBidWZmZXIgZGV2aWNlIGV4cGVjdHMgYWxsIGhvcml6b250YWwg
dGltaW5ncyBpbiBudW1iZXIgb2YgZG90Y2xvY2tzCmRpZmYgLXVwck4gbGlu
dXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vZmIvc3N0ZmIudHh0
IGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vZmIvc3N0ZmIu
dHh0Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9m
Yi9zc3RmYi50eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1
MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vZmIv
c3N0ZmIudHh0CTIwMDctMDQtMTcgMTI6NDQ6MDkuMDAwMDAwMDAwIC0wNDAw
CkBAIC0yLDkgKzIsOSBAQAogSW50cm9kdWN0aW9uCiAKIAkgIFRoaXMgaXMg
YSBmcmFtZSBidWZmZXIgZGV2aWNlIGRyaXZlciBmb3IgM2RmeCcgVm9vZG9v
IEdyYXBoaWNzIAotCShha2Egdm9vZG9vIDEsIGFrYSBzc3QxKSBhbmQgVm9v
ZG9vsiAoYWthIFZvb2RvbyAyLCBha2EgQ1ZHKSBiYXNlZCAKKwkoYWthIHZv
b2RvbyAxLCBha2Egc3N0MSkgYW5kIFZvb2Rvb8KyIChha2EgVm9vZG9vIDIs
IGFrYSBDVkcpIGJhc2VkIAogCXZpZGVvIGJvYXJkcy4gSXQncyBoaWdobHkg
ZXhwZXJpbWVudGFsIGNvZGUsIGJ1dCBpcyBndWFyYW50ZWVkIHRvIHdvcmsK
LQlvbiBteSBjb21wdXRlciwgd2l0aCBteSAiTWF4aSBHYW1lciAzRCIgYW5k
ICJNYXhpIEdhbWVyIDNksiIgYm9hcmRzLAorCW9uIG15IGNvbXB1dGVyLCB3
aXRoIG15ICJNYXhpIEdhbWVyIDNEIiBhbmQgIk1heGkgR2FtZXIgM2TCsiIg
Ym9hcmRzLAogCWFuZCB3aXRoIG1lICJiZXR3ZWVuIGNoYWlyIGFuZCBrZXli
b2FyZCIuIFNvbWUgcGVvcGxlIHRlc3RlZCBvdGhlcgogCWNvbWJpbmF0aW9u
cyBhbmQgaXQgc2VlbXMgdGhhdCBpdCB3b3Jrcy4KIAkgIFRoZSBtYWluIHBh
Z2UgaXMgbG9jYXRlZCBhdCA8aHR0cDovL3NzdGZiLnNvdXJjZWZvcmdlLm5l
dD4sIGFuZCBpZgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9E
b2N1bWVudGF0aW9uL2h3bW9uL2FkbTEwMjYgbGludXgtMi42LjIxLXJjNy5t
b2QvRG9jdW1lbnRhdGlvbi9od21vbi9hZG0xMDI2Ci0tLSBsaW51eC0yLjYu
MjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9od21vbi9hZG0xMDI2CTIwMDct
MDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYu
MjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2h3bW9uL2FkbTEwMjYJMjAwNy0w
NC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTgwLDcgKzgwLDcg
QEAgdGVtcGVyYXR1cmUgc2Vuc29yIGlucHV0cy4gQm90aCB0aGUgUFdNIAog
dXNlZCB0byBjb250cm9sIGZhbiBzcGVlZC4gVXN1YWxseSBvbmx5IG9uZSBv
ZiB0aGVzZSB0d28gb3V0cHV0cyB3aWxsIGJlCiB1c2VkLiBXcml0ZSB0aGUg
bWluaW11bSBQV00gb3IgREFDIHZhbHVlIHRvIHRoZSBhcHByb3ByaWF0ZSBj
b250cm9sCiByZWdpc3Rlci4gVGhlbiBzZXQgdGhlIGxvdyB0ZW1wZXJhdHVy
ZSBsaW1pdCBpbiB0aGUgdG1pbiB2YWx1ZXMgZm9yIGVhY2gKLXRlbXBlcmF0
dXJlIHNlbnNvci4gVGhlIHJhbmdlIG9mIGNvbnRyb2wgaXMgZml4ZWQgYXQg
MjAgsEMsIGFuZCB0aGUKK3RlbXBlcmF0dXJlIHNlbnNvci4gVGhlIHJhbmdl
IG9mIGNvbnRyb2wgaXMgZml4ZWQgYXQgMjAgwrBDLCBhbmQgdGhlCiBsYXJn
ZXN0IGRpZmZlcmVuY2UgYmV0d2VlbiBjdXJyZW50IGFuZCB0bWluIG9mIHRo
ZSB0ZW1wZXJhdHVyZSBzZW5zb3JzIHNldHMKIHRoZSBjb250cm9sIG91dHB1
dC4gU2VlIHRoZSBkYXRhc2hlZXQgZm9yIHNldmVyYWwgZXhhbXBsZSBjaXJj
dWl0cyBmb3IKIGNvbnRyb2xsaW5nIGZhbiBzcGVlZCB3aXRoIHRoZSBQV00g
YW5kIERBQyBvdXRwdXRzLiBUaGUgZmFuIHNwZWVkIHNlbnNvcnMKZGlmZiAt
dXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9od21v
bi9nbDUxOHNtIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24v
aHdtb24vZ2w1MThzbQotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3Vt
ZW50YXRpb24vaHdtb24vZ2w1MThzbQkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAw
MDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1l
bnRhdGlvbi9od21vbi9nbDUxOHNtCTIwMDctMDQtMTcgMTI6NDQ6MDkuMDAw
MDAwMDAwIC0wNDAwCkBAIC0xMyw3ICsxMyw3IEBAIFN1cHBvcnRlZCBjaGlw
czoKIAogQXV0aG9yczoKICAgICAgICAgRnJvZG8gTG9vaWphYXJkIDxmcm9k
b2xAZGRzLm5sPiwKLSAgICAgICAgS3n2c3RpIE3kbGtraSA8a21hbGtraUBj
Yy5odXQuZmk+CisgICAgICAgIEt5w7ZzdGkgTcOkbGtraSA8a21hbGtraUBj
Yy5odXQuZmk+CiAgICAgICAgIEhvbmctR3VubiBDaGV3IDxoZ2xpbnV4QGd1
bm5ldC5vcmc+CiAgICAgICAgIEplYW4gRGVsdmFyZSA8a2hhbGlAbGludXgt
ZnIub3JnPgogCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0Rv
Y3VtZW50YXRpb24vaHdtb24vbG04MyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9E
b2N1bWVudGF0aW9uL2h3bW9uL2xtODMKLS0tIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9Eb2N1bWVudGF0aW9uL2h3bW9uL2xtODMJMjAwNy0wMi0wNCAxMzo0
NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9k
L0RvY3VtZW50YXRpb24vaHdtb24vbG04MwkyMDA3LTA0LTE3IDEyOjQ0OjA5
LjAwMDAwMDAwMCAtMDQwMApAQCAtNDUsNyArNDUsNyBAQCBVbmNvbmZpcm1l
ZCBtb3RoZXJib2FyZHM6CiBUaGUgTE04MiBpcyBjb25maXJtZWQgdG8gaGF2
ZSBiZWVuIGZvdW5kIG9uIG1vc3QgQU1EIEdlb2RlIHJlZmVyZW5jZQogZGVz
aWducyBhbmQgdGVzdCBwbGF0Zm9ybXMuCiAKLVRoZSBkcml2ZXIgaGFzIGJl
ZW4gc3VjY2Vzc2Z1bGx5IHRlc3RlZCBieSBNYWdudXMgRm9yc3N0cvZtLCB3
aG8gSSdkCitUaGUgZHJpdmVyIGhhcyBiZWVuIHN1Y2Nlc3NmdWxseSB0ZXN0
ZWQgYnkgTWFnbnVzIEZvcnNzdHLDtm0sIHdobyBJJ2QKIGxpa2UgdG8gdGhh
bmsgaGVyZS4gTW9yZSB0ZXN0ZXJzIHdpbGwgYmUgb2YgY291cnNlIHdlbGNv
bWUuCiAKIFRoZSBmYWN0IHRoYXQgdGhlIExNODMgaXMgb25seSBzY2FyY2Vs
eSB1c2VkIGNhbiBiZSBlYXNpbHkgZXhwbGFpbmVkLgpkaWZmIC11cHJOIGxp
bnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2h3bW9uL3NpczU1
OTUgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9od21vbi9z
aXM1NTk1Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlv
bi9od21vbi9zaXM1NTk1CTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAw
IC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9u
L2h3bW9uL3NpczU1OTUJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAg
LTA0MDAKQEAgLTgsNyArOCw3IEBAIFN1cHBvcnRlZCBjaGlwczoKICAgICBE
YXRhc2hlZXQ6IFB1YmxpY2x5IGF2YWlsYWJsZSBhdCB0aGUgU2lsaWNvbiBJ
bnRlZ3JhdGVkIFN5c3RlbXMgQ29ycC4gc2l0ZS4KIAogQXV0aG9yczoKLSAg
ICAgICAgS3n2c3RpIE3kbGtraSA8a21hbGtraUBjYy5odXQuZmk+LAorICAg
ICAgICBLecO2c3RpIE3DpGxra2kgPGttYWxra2lAY2MuaHV0LmZpPiwKICAg
ICAgICAgTWFyayBELiBTdHVkZWJha2VyIDxtZHN4eXoxMjNAeWFob28uY29t
PiwKICAgICAgICAgQXVyZWxpZW4gSmFybm8gPGF1cmVsaWVuQGF1cmVsMzIu
bmV0PiAyLjYgcG9ydAogCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5v
cmlnL0RvY3VtZW50YXRpb24vaHdtb24vdmlhNjg2YSBsaW51eC0yLjYuMjEt
cmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2h3bW9uL3ZpYTY4NmEKLS0tIGxpbnV4
LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2h3bW9uL3ZpYTY4NmEJ
MjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4
LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vaHdtb24vdmlhNjg2YQky
MDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtOCw3ICs4
LDcgQEAgU3VwcG9ydGVkIGNoaXBzOgogICAgIERhdGFzaGVldDogT24gcmVx
dWVzdCB0aHJvdWdoIHdlYiBmb3JtIChodHRwOi8vd3d3LnZpYS5jb20udHcv
ZW4vc3VwcG9ydC9kYXRhc2hlZXRzLykKIAogQXV0aG9yczoKLSAgICAgICAg
S3n2c3RpIE3kbGtraSA8a21hbGtraUBjYy5odXQuZmk+LAorICAgICAgICBL
ecO2c3RpIE3DpGxra2kgPGttYWxra2lAY2MuaHV0LmZpPiwKICAgICAgICAg
TWFyayBELiBTdHVkZWJha2VyIDxtZHN4eXoxMjNAeWFob28uY29tPgogICAg
ICAgICBCb2IgRG91Z2hlcnR5IDxib2JkQHN0YW5mb3JkLmVkdT4KICAgICAg
ICAgKFNvbWUgY29udmVyc2lvbi1mYWN0b3IgZGF0YSB3ZXJlIGNvbnRyaWJ1
dGVkIGJ5CmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3Vt
ZW50YXRpb24vaHdtb24vdzgzNzkyZCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9E
b2N1bWVudGF0aW9uL2h3bW9uL3c4Mzc5MmQKLS0tIGxpbnV4LTIuNi4yMS1y
Yzcub3JpZy9Eb2N1bWVudGF0aW9uL2h3bW9uL3c4Mzc5MmQJMjAwNy0wMi0w
NCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1y
YzcubW9kL0RvY3VtZW50YXRpb24vaHdtb24vdzgzNzkyZAkyMDA3LTA0LTE3
IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMTA3LDcgKzEwNyw3IEBA
IEtub3duIHByb2JsZW1zOgogCSAgYnkgQ1JbMHg0OWhdLgogCS0gVGhlIGZ1
bmN0aW9uIG9mIHZpZCBhbmQgdnJtIGhhcyBub3QgYmVlbiBmaW5pc2hlZCwg
YmVjYXVzZSBJJ20gTk9UCiAJICB2ZXJ5IGZhbWlsaWFyIHdpdGggdGhlbS4g
QWRkaW5nIHN1cHBvcnQgaXMgd2VsY29tZS4KLaAJLSBUaGUgZnVuY3Rpb24g
b2YgY2hhc3NpcyBvcGVuIGRldGVjdGlvbiBuZWVkcyBtb3JlIHRlc3RzLgor
wqAJLSBUaGUgZnVuY3Rpb24gb2YgY2hhc3NpcyBvcGVuIGRldGVjdGlvbiBu
ZWVkcyBtb3JlIHRlc3RzLgogCS0gSWYgeW91IGhhdmUgQVNVUyBzZXJ2ZXIg
Ym9hcmQgYW5kIGNoaXAgd2FzIG5vdCBmb3VuZDogVGhlbiB5b3Ugd2lsbAog
CSAgbmVlZCB0byB1cGdyYWRlIHRvIGxhdGVzdCAob3IgYmV0YSkgQklPUy4g
SWYgaXQgZG9lcyBub3QgaGVscCBwbGVhc2UKIAkgIGNvbnRhY3QgdXMuCmRp
ZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24v
aTJjL2J1c3Nlcy9pMmMtaTgxMCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1
bWVudGF0aW9uL2kyYy9idXNzZXMvaTJjLWk4MTAKLS0tIGxpbnV4LTIuNi4y
MS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2kyYy9idXNzZXMvaTJjLWk4MTAJ
MjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4
LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vaTJjL2J1c3Nlcy9pMmMt
aTgxMAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAt
Nyw3ICs3LDcgQEAgU3VwcG9ydGVkIGFkYXB0ZXJzOgogQXV0aG9yczogCiAJ
RnJvZG8gTG9vaWphYXJkIDxmcm9kb2xAZGRzLm5sPiwgCiAJUGhpbGlwIEVk
ZWxicm9jayA8cGhpbEBuZXRyb2VkZ2UuY29tPiwKLSAgICAgICAgS3n2c3Rp
IE3kbGtraSA8a21hbGtraUBjYy5odXQuZmk+LAorICAgICAgICBLecO2c3Rp
IE3DpGxra2kgPGttYWxra2lAY2MuaHV0LmZpPiwKIAlSYWxwaCBNZXR6bGVy
IDxyamttQHRocC51bmkta29lbG4uZGU+LAogCU1hcmsgRC4gU3R1ZGViYWtl
ciA8bWRzeHl6MTIzQHlhaG9vLmNvbT4KIApkaWZmIC11cHJOIGxpbnV4LTIu
Ni4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2kyYy9idXNzZXMvaTJjLXNp
czk2eCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2kyYy9i
dXNzZXMvaTJjLXNpczk2eAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0Rv
Y3VtZW50YXRpb24vaTJjL2J1c3Nlcy9pMmMtc2lzOTZ4CTIwMDctMDItMDQg
MTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9Eb2N1bWVudGF0aW9uL2kyYy9idXNzZXMvaTJjLXNpczk2eAkyMDA3
LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtNjAsNyArNjAs
NyBAQCBNYXJrIEQuIFN0dWRlYmFrZXIgPG1kc3h5ejEyM0B5YWhvby5jb20+
CiAgLSBkZXNpZ24gaGludHMgYW5kIGJ1ZyBmaXhlcwogQWxleGFuZGVyIE1h
eWxzaCA8YW1hbHlzaEB3ZWIuZGU+CiAgLSBkaXR0bywgcGx1cyBhbiBpbXBv
cnRhbnQgZGF0YXNoZWV0Li4uIGFsbW9zdCB0aGUgb25lIEkgcmVhbGx5IHdh
bnRlZAotSGFucy1H/G50ZXIgTPx0a2UgVXBodWVzIDxoZ19sdUB0LW9ubGlu
ZS5kZT4KK0hhbnMtR8O8bnRlciBMw7x0a2UgVXBodWVzIDxoZ19sdUB0LW9u
bGluZS5kZT4KICAtIHBhdGNoIGZvciBTaVM3MzUKIFJvYmVydCBad2VydXMg
PGFyemllQGRkcy5ubD4KICAtIHRlc3RpbmcgZm9yIFNpUzY0NURYCmRpZmYg
LXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vaTJj
L2J1c3Nlcy9pMmMtdmlhIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50
YXRpb24vaTJjL2J1c3Nlcy9pMmMtdmlhCi0tLSBsaW51eC0yLjYuMjEtcmM3
Lm9yaWcvRG9jdW1lbnRhdGlvbi9pMmMvYnVzc2VzL2kyYy12aWEJMjAwNy0w
Mi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4y
MS1yYzcubW9kL0RvY3VtZW50YXRpb24vaTJjL2J1c3Nlcy9pMmMtdmlhCTIw
MDctMDQtMTcgMTI6NDQ6MDkuMDAwMDAwMDAwIC0wNDAwCkBAIC00LDcgKzQs
NyBAQCBTdXBwb3J0ZWQgYWRhcHRlcnM6CiAgICogVklBIFRlY2hub2xvZ2ll
cywgSW5DLiBWVDgyQzU4NkIKICAgICBEYXRhc2hlZXQ6IFB1YmxpY2x5IGF2
YWlsYWJsZSBhdCB0aGUgVklBIHdlYnNpdGUKIAotQXV0aG9yOiBLefZzdGkg
TeRsa2tpIDxrbWFsa2tpQGNjLmh1dC5maT4KK0F1dGhvcjogS3nDtnN0aSBN
w6Rsa2tpIDxrbWFsa2tpQGNjLmh1dC5maT4KIAogRGVzY3JpcHRpb24KIC0t
LS0tLS0tLS0tCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0Rv
Y3VtZW50YXRpb24vaTJjL2J1c3Nlcy9pMmMtdmlhcHJvIGxpbnV4LTIuNi4y
MS1yYzcubW9kL0RvY3VtZW50YXRpb24vaTJjL2J1c3Nlcy9pMmMtdmlhcHJv
Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9pMmMv
YnVzc2VzL2kyYy12aWFwcm8JMjAwNy0wNC0xNyAxMTo0MTo0MS4wMDAwMDAw
MDAgLTA0MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRp
b24vaTJjL2J1c3Nlcy9pMmMtdmlhcHJvCTIwMDctMDQtMTcgMTI6NDQ6MDku
MDAwMDAwMDAwIC0wNDAwCkBAIC0xNyw3ICsxNyw3IEBAIFN1cHBvcnRlZCBh
ZGFwdGVyczoKICAgICBEYXRhc2hlZXQ6IGF2YWlsYWJsZSBvbiByZXF1ZXN0
IGFuZCB1bmRlciBOREEgZnJvbSBWSUEKIAogQXV0aG9yczoKLQlLefZzdGkg
TeRsa2tpIDxrbWFsa2tpQGNjLmh1dC5maT4sCisJS3nDtnN0aSBNw6Rsa2tp
IDxrbWFsa2tpQGNjLmh1dC5maT4sCiAJTWFyayBELiBTdHVkZWJha2VyIDxt
ZHN4eXoxMjNAeWFob28uY29tPiwKIAlKZWFuIERlbHZhcmUgPGtoYWxpQGxp
bnV4LWZyLm9yZz4KIApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3Jp
Zy9Eb2N1bWVudGF0aW9uL2kyYy9pMmMtcHJvdG9jb2wgbGludXgtMi42LjIx
LXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9pMmMvaTJjLXByb3RvY29sCi0tLSBs
aW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9pMmMvaTJjLXBy
b3RvY29sCTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisr
KyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2kyYy9pMmMt
cHJvdG9jb2wJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAK
QEAgLTY4LDcgKzY4LDcgQEAgV2UgaGF2ZSBmb3VuZCBzb21lIEkyQyBkZXZp
Y2VzIHRoYXQgbmVlZAogCiAgIEZsYWdzIEkyQ19NX0lHTk9SRV9OQUsKICAg
ICBOb3JtYWxseSBtZXNzYWdlIGlzIGludGVycnVwdGVkIGltbWVkaWF0ZWx5
IGlmIHRoZXJlIGlzIFtOQV0gZnJvbSB0aGUKLSAgICBjbGllbnQuIFNldHRp
bmcgdGhpcyBmbGFnIHRyZWF0cyBhbnkgW05BXSBhc6BbQV0sIGFuZCBhbGwg
b2YKKyAgICBjbGllbnQuIFNldHRpbmcgdGhpcyBmbGFnIHRyZWF0cyBhbnkg
W05BXSBhc8KgW0FdLCBhbmQgYWxsIG9mCiAgICAgbWVzc2FnZSBpcyBzZW50
LgogICAgIFRoZXNlIG1lc3NhZ2VzIG1heSBzdGlsbCBmYWlsIHRvIFNDTCBs
by0+aGkgdGltZW91dC4KIApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9Eb2N1bWVudGF0aW9uL2kyby9SRUFETUUgbGludXgtMi42LjIxLXJj
Ny5tb2QvRG9jdW1lbnRhdGlvbi9pMm8vUkVBRE1FCi0tLSBsaW51eC0yLjYu
MjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9pMm8vUkVBRE1FCTIwMDctMDIt
MDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEt
cmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2kyby9SRUFETUUJMjAwNy0wNC0xNyAx
Mjo0NDowOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTMwLDEzICszMCwxMyBAQCBK
dWhhIFNpZXZhbmVuLCBVbml2ZXJzaXR5IG9mIEhlbHNpbmtpIEZpCiAJQnVn
IGZpeGVzCiAJQ29yZSBjb2RlIGV4dGVuc2lvbnMKIAotQXV2byBI5GtraW5l
biwgVW5pdmVyc2l0eSBvZiBIZWxzaW5raSBGaW5sYW5kCitBdXZvIEjDpGtr
aW5lbiwgVW5pdmVyc2l0eSBvZiBIZWxzaW5raSBGaW5sYW5kCiAJTEFOIE9T
TSBjb2RlCiAJL1Byb2MgaW50ZXJmYWNlIHRvIExBTiBjbGFzcwogCUJ1ZyBm
aXhlcwogCUNvcmUgY29kZSBleHRlbnNpb25zCiAKLVRhbmVsaSBW5Gjka2Fu
Z2FzLCBVbml2ZXJzaXR5IG9mIEhlbHNpbmtpIEZpbmxhbmQKK1RhbmVsaSBW
w6Row6RrYW5nYXMsIFVuaXZlcnNpdHkgb2YgSGVsc2lua2kgRmlubGFuZAog
CUZpeGVzIHRvIGkyb19jb25maWcKIAogQ1JFRElUUwpkaWZmIC11cHJOIGxp
bnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL2lzZG4vQ1JFRElU
UyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2lzZG4vQ1JF
RElUUwotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24v
aXNkbi9DUkVESVRTCTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0w
NTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2lz
ZG4vQ1JFRElUUwkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQw
MApAQCAtMiw3ICsyLDcgQEAKIEkgd2FudCB0byB0aGFuayBhbGwgd2hvIGNv
bnRyaWJ1dGVkIHRvIHRoaXMgcHJvamVjdCBhbmQgZXNwZWNpYWxseSB0bzoK
IChpbiBhbHBoYWJldGljYWwgb3JkZXIpCiAKLVRob21hcyBCb2dlbmT2cmZl
ciAodHNib2dlbmRAYmlnYnVnLmZyYW5rZW4uZGUpCitUaG9tYXMgQm9nZW5k
w7ZyZmVyICh0c2JvZ2VuZEBiaWdidWcuZnJhbmtlbi5kZSkKICAgVGVzdGVy
LCBsb3RzIG9mIGJ1Z2ZpeGVzIGFuZCBoaW50cy4KIAogQWxhbiBDb3ggKGFs
YW5AcmVkaGF0LmNvbSkKQEAgLTExLDcgKzExLDcgQEAgQWxhbiBDb3ggKGFs
YW5AcmVkaGF0LmNvbSkKIEhlbm5lciBFaXNlbiAoZWlzQGJhdHkuaGFuc2Uu
ZGUpCiAgIEZvciBYLjI1IGltcGxlbWVudGF0aW9uLgogCi1Wb2xrZXIgR/Z0
eiAodm9sa2VyQG9vcHMuZnJhbmtlbi5kZSkKK1ZvbGtlciBHw7Z0eiAodm9s
a2VyQG9vcHMuZnJhbmtlbi5kZSkKICAgRm9yIGNvbnRyaWJ1dGlvbiBvZiBt
YW4tcGFnZXMsIHRoZSBpbW9udHR5LXRvb2wgYW5kIGEgcGVyZmVjdAogICBt
YWludGFpbmluZyBvZiB0aGUgbWFpbGluZy1saXN0IGF0IGh1Yi13dWUuCiAK
ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlv
bi9pc2RuL1JFQURNRSBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0
aW9uL2lzZG4vUkVBRE1FCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9j
dW1lbnRhdGlvbi9pc2RuL1JFQURNRQkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAw
MDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1l
bnRhdGlvbi9pc2RuL1JFQURNRQkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAw
MDAwMCAtMDQwMApAQCAtNDAyLDcgKzQwMiw3IEBAIFJFQURNRSBmb3IgdGhl
IElTRE4tc3Vic3lzdGVtCiAgICAgIHRoZSBzY3JpcHQgdG9vbHMvdGNsdGsv
aXNkbm1vbi4gWW91IGNhbiBhZGQgYWN0aW9ucyBmb3IgbGluZS1zdGF0dXMK
ICAgICAgY2hhbmdlcy4gU2VlIHRoZSBjb21tZW50cyBhdCB0aGUgYmVnaW5u
aW5nIG9mIHRoZSBzY3JpcHQgZm9yIGhvdyB0bwogICAgICBkbyB0aGF0LiBU
aGVyZSBhcmUgb3RoZXIgdHR5LWJhc2VkIHRvb2xzIGluIHRoZSB0b29scy1z
dWJkaXJlY3RvcnkKLSAgICAgY29udHJpYnV0ZWQgYnkgTWljaGFlbCBLbmln
Z2UgKGltb24pLCBWb2xrZXIgR/Z0eiAoaW1vbnR0eSkgYW5kCisgICAgIGNv
bnRyaWJ1dGVkIGJ5IE1pY2hhZWwgS25pZ2dlIChpbW9uKSwgVm9sa2VyIEfD
tnR6IChpbW9udHR5KSBhbmQKICAgICAgQW5kcmVhcyBLb29sIChpc2RubW9u
KS4KIAogICAgbCkgRm9yIGluaXRpYWwgdGVzdGluZywgeW91IGNhbiBzZXQg
dGhlIHZlcmJvc2UtbGV2ZWwgdG8gMiAoZGVmYXVsdDogMCkuCmRpZmYgLXVw
ck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vaXNkbi9S
RUFETUUuaWNuIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24v
aXNkbi9SRUFETUUuaWNuCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9j
dW1lbnRhdGlvbi9pc2RuL1JFQURNRS5pY24JMjAwNy0wMi0wNCAxMzo0NDo1
NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0Rv
Y3VtZW50YXRpb24vaXNkbi9SRUFETUUuaWNuCTIwMDctMDQtMTcgMTI6NDQ6
MDkuMDAwMDAwMDAwIC0wNDAwCkBAIC0zLDggKzMsOCBAQCAkSWQ6IFJFQURN
RS5pY24sdiAxLjcgMjAwMC8wOC8wNiAwOToyMjo1CiBZb3UgY2FuIGdldCB0
aGUgSUNOLUlTRE4tY2FyZCBmcm9tOgogCiBUaGlua2luZyBPYmplY3RzIFNv
ZnR3YXJlIEdtYkgKLVZlcnNiYWNoZXIgUvZ0aGUgMTU5Ci05NzA3OCBX/HJ6
YnVyZworVmVyc2JhY2hlciBSw7Z0aGUgMTU5Cis5NzA3OCBXw7xyemJ1cmcK
IFRlbDogKzQ5IDkzMSAyODc3OTUwCiBGYXg6ICs0OSA5MzEgMjg3Nzk1MQog
CmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRp
b24vamF2YS50eHQgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlv
bi9qYXZhLnR4dAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50
YXRpb24vamF2YS50eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAg
LTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24v
amF2YS50eHQJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAK
QEAgLTM5MCw3ICszOTAsNyBAQCB0aGUgZXhlY3V0aW9uIGJpdCwgdGhlbiBq
dXN0IGRvCiAKIAogb3JpZ2luYWxseSBieSBCcmlhbiBBLiBMYW50eiwgYnJp
YW5AbGFudHouY29tCi1oZWF2aWx5IGVkaXRlZCBmb3IgYmluZm10X21pc2Mg
YnkgUmljaGFyZCBH/G50aGVyCitoZWF2aWx5IGVkaXRlZCBmb3IgYmluZm10
X21pc2MgYnkgUmljaGFyZCBHw7xudGhlcgogbmV3IHNjcmlwdHMgYnkgQ29s
aW4gSi4gV2F0c29uIDxjanc0NEBjYW0uYWMudWs+CiBhZGRlZCBleGVjdXRh
YmxlIEphciBmaWxlIHN1cHBvcnQgYnkgS3VydCBIdXdpZyA8a3VydEBpa3Ut
bmV0ei5kZT4KIApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9E
b2N1bWVudGF0aW9uL2tlcm5lbC1kb2NzLnR4dCBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9Eb2N1bWVudGF0aW9uL2tlcm5lbC1kb2NzLnR4dAotLS0gbGludXgt
Mi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24va2VybmVsLWRvY3MudHh0
CTIwMDctMDQtMTcgMTE6NDE6NDEuMDAwMDAwMDAwIC0wNDAwCisrKyBsaW51
eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL2tlcm5lbC1kb2NzLnR4
dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMjM2
LDcgKzIzNiw3IEBACiAKICAgICAgKiBUaXRsZTogIkRlc2lnbiBhbmQgSW1w
bGVtZW50YXRpb24gb2YgdGhlIFNlY29uZCBFeHRlbmRlZAogICAgICAgIEZp
bGVzeXN0ZW0iCi0gICAgICAgQXV0aG9yOiBS6W15IENhcmQsIFRoZW9kb3Jl
IFRzJ28sIFN0ZXBoZW4gVHdlZWRpZS4KKyAgICAgICBBdXRob3I6IFLDqW15
IENhcmQsIFRoZW9kb3JlIFRzJ28sIFN0ZXBoZW4gVHdlZWRpZS4KICAgICAg
ICBVUkw6IGh0dHA6Ly93ZWIubWl0LmVkdS90eXRzby93d3cvbGludXgvZXh0
MmludHJvLmh0bWwKICAgICAgICBLZXl3b3JkczogZXh0MiwgbGludXggZnMg
aGlzdG9yeSwgaW5vZGUsIGRpcmVjdG9yeSwgbGluaywgZGV2aWNlcywKICAg
ICAgICBWRlMsIHBoeXNpY2FsIHN0cnVjdHVyZSwgcGVyZm9ybWFuY2UsIGJl
bmNobWFya3MsIGV4dDJmcyBsaWJyYXJ5LApkaWZmIC11cHJOIGxpbnV4LTIu
Ni4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL202OGsvUkVBRE1FLmJ1ZGRo
YSBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL202OGsvUkVB
RE1FLmJ1ZGRoYQotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50
YXRpb24vbTY4ay9SRUFETUUuYnVkZGhhCTIwMDctMDItMDQgMTM6NDQ6NTQu
MDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1
bWVudGF0aW9uL202OGsvUkVBRE1FLmJ1ZGRoYQkyMDA3LTA0LTE3IDEyOjQ0
OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMjA0LDcgKzIwNCw3IEBAIGFsd2F5
cyAgc2hvd3MgYSAibm8gSVJRIGhlcmUiIG9uIHRoZSBCdWQKIHRoZSAgdGhp
cmQgIElERSAgcG9ydCAgYXJlICBnb2luZyBpbnRvIGRhdGEncyBOaXJ3YW5h
IG9uIHRoZQogQnVkZGhhLgogCi0JCQkgICAgSmVucyBTY2j2bmZlbGQgZmVi
cnVhcnkgMTl0aCwgMTk5NworCQkJICAgIEplbnMgU2Now7ZuZmVsZCBmZWJy
dWFyeSAxOXRoLCAxOTk3CiAJCQkJCXVwZGF0ZWQgbWF5IDI3dGgsIDE5OTcK
IAkJCSAgICAgZU1haWw6IHN5c29wQG5vc3RsZ2ljLnRuZy5vY2hlLmRlCiAK
ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlv
bi9uZXR3b3JraW5nLzZwYWNrLnR4dCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9E
b2N1bWVudGF0aW9uL25ldHdvcmtpbmcvNnBhY2sudHh0Ci0tLSBsaW51eC0y
LjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nLzZwYWNr
LnR4dAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysg
bGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5n
LzZwYWNrLnR4dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQw
MApAQCAtMSw2ICsxLDYgQEAKIFRoaXMgaXMgdGhlIDZwYWNrLW1pbmktSE9X
VE8sIHdyaXR0ZW4gYnkKIAotQW5kcmVhcyBL9m5zZ2VuIERHM0tRCitBbmRy
ZWFzIEvDtm5zZ2VuIERHM0tRCiBJbnRlcm5ldDogYWprQGllaGsucnd0aC1h
YWNoZW4uZGUKIEFNUFItbmV0OiBkZzNrcUBkYjBwcmEuYW1wci5vcmcKIEFY
LjI1OiAgICBkZzNrcUBkYjBhY2guI25ydy5kZXUuZXUKZGlmZiAtdXByTiBs
aW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5n
L3BhY2tldF9tbWFwLnR4dCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVu
dGF0aW9uL25ldHdvcmtpbmcvcGFja2V0X21tYXAudHh0Ci0tLSBsaW51eC0y
LjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3BhY2tl
dF9tbWFwLnR4dAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUw
MAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9uZXR3
b3JraW5nL3BhY2tldF9tbWFwLnR4dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAw
MDAwMDAwMCAtMDQwMApAQCAtMTMsNyArMTMsNyBAQCBZb3UgY2FuIGZpbmQg
dGhlIGxhdGVzdCB2ZXJzaW9uIG9mIHRoaXMgCiAKIFBsZWFzZSBzZW5kIG1l
IHlvdXIgY29tbWVudHMgdG8KIAotICAgIFVsaXNzZXMgQWxvbnNvIENhbWFy
8yA8dWFjYUBpLmhhdGUuc3BhbS5hbHVtbmkudXYuZXM+CisgICAgVWxpc3Nl
cyBBbG9uc28gQ2FtYXLDsyA8dWFjYUBpLmhhdGUuc3BhbS5hbHVtbmkudXYu
ZXM+CiAKIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICsg
V2h5IHVzZSBQQUNLRVRfTU1BUApkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1y
Yzcub3JpZy9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvc2xpY2Vjb20uaHVu
IGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vbmV0d29ya2lu
Zy9zbGljZWNvbS5odW4KLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1
bWVudGF0aW9uL25ldHdvcmtpbmcvc2xpY2Vjb20uaHVuCTIwMDctMDItMDQg
MTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvc2xpY2Vjb20uaHVuCTIw
MDctMDQtMTcgMTI6NDQ6MDkuMDAwMDAwMDAwIC0wNDAwCkBAIC0xLDcgKzEs
NyBAQAogCiBTbGljZUNPTSBhZGFwdGVyIGZlbGhhc3puYWxvaSBkb2t1bWVu
dGFjaW9qYSAtIDAuNTEgdmVyemlvaG96CiAKLUJhcnTzayBJc3R24W4gPGJh
cnRva2lAaXRjLmh1PgorQmFydMOzayBJc3R2w6FuIDxiYXJ0b2tpQGl0Yy5o
dT4KIFV0b2xzbyBtb2Rvc2l0YXM6IFdlZCBBdWcgMjkgMTc6MjY6NTggQ0VT
VCAyMDAxCiAKIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCmRpZmYgLXVwck4gbGlu
dXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9z
bGljZWNvbS50eHQgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlv
bi9uZXR3b3JraW5nL3NsaWNlY29tLnR4dAotLS0gbGludXgtMi42LjIxLXJj
Ny5vcmlnL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9zbGljZWNvbS50eHQJ
MjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4
LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9zbGlj
ZWNvbS50eHQJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAK
QEAgLTEsOSArMSw5IEBACiAKIFNsaWNlQ09NIGFkYXB0ZXIgdXNlcidzIGRv
Y3VtZW50YXRpb24gLSBmb3IgdGhlIDAuNTEgZHJpdmVyIHZlcnNpb24KIAot
V3JpdHRlbiBieSBCYXJ082sgSXN0duFuIDxiYXJ0b2tpQGl0Yy5odT4KK1dy
aXR0ZW4gYnkgQmFydMOzayBJc3R2w6FuIDxiYXJ0b2tpQGl0Yy5odT4KIAot
RW5nbGlzaCB0cmFuc2xhdGlvbjogTGFrYXRvcyBHefZyZ3kgPGd5dXJpQGl0
Yy5odT4KK0VuZ2xpc2ggdHJhbnNsYXRpb246IExha2F0b3MgR3nDtnJneSA8
Z3l1cmlAaXRjLmh1PgogTW9uIERlYyAxMSAxNToyODo0MiBDRVQgMjAwMAog
CiBMYXN0IG1vZGlmaWVkOiBXZWQgQXVnIDI5IDE3OjI1OjM3IENFU1QgMjAw
MQpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0
aW9uL25ldHdvcmtpbmcvdG1zMzgwdHIudHh0IGxpbnV4LTIuNi4yMS1yYzcu
bW9kL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy90bXMzODB0ci50eHQKLS0t
IGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL25ldHdvcmtp
bmcvdG1zMzgwdHIudHh0CTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAw
IC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9u
L25ldHdvcmtpbmcvdG1zMzgwdHIudHh0CTIwMDctMDQtMTcgMTI6NDQ6MDku
MDAwMDAwMDAwIC0wNDAwCkBAIC03MSwyNCArNzEsMjQgQEAgQmVsb3cgZmlu
ZCBhdHRhY2hlZCB0aGUgc2V0dGluZyBmb3IgdGhlIAogICBDSEFQVEVSIDEg
ICAgIExPQ0FUSU9OIE9GIERJUC1TV0lUQ0gKICAgPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KIAotVcTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTE
xMTExMTExMTExMTExMTExMTExMTExMTExMTExL8KLf5VxMTExMTEvyAgICAg
ICAgICAgICAgICAgICAgICAgICBVxMTExMS/ICAgICAgICAgICAgVcTExL8g
ICAgICAgICD+Ci3+QcTExMTExFUgICAgICAgICAgICAgICAgICAgICAgVzEg
QcTExMTEVSAgICAgVcTExMS/IP4gICD+ICAgICAgICAg/got/lXExMTExMS/
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIP4gICAg/iD+
ICAg/iAgICAgIFXExMW/Ci3+QcTExMTExFUgICAgICAgICAgICAgIFXExMTE
xMTExMTExL8gICAgICAgICAgQcTExMRVIP4gICD+ICAgICAg/iAg/v4KLf5V
xMTExMTEvyAgICAgICAgICAgICAg/iAgICAgICAgICAg/iAgICAgICAgICBV
xMTEvyAgQcTExFUgICAgICBBxMTFVQot/kHExMTExMRVICAgICAgICAgICAg
ICD+IFRNUzM4MEMyNiD+ICAgICAgICAgIP4gICD+ICAgICAgICAgICAgICAg
IP4KLf5VxMTExMTEvyAgICAgICAgICAgICAg/iAgICAgICAgICAg/iAgICAg
ICAgICBBxMTEVSAgICAgICAgICAgICAgICBBxL8KLf5BxMTExMTEVSAgICAg
ICAgICAgICAg/iAgICAgICAgICAg/iAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICD+IP4KLf4gICAgICAgICAgICAgICAgICAgICAgQcTExMTExMTE
xMTEVSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICD+IP4KLf4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICD+IP4KLf4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBB
xFUKLf4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICD+Ci3+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAg/got/iAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIP4KLf4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICD+Ci1BxMTExMTExMTExMTEQcTExMTExMTExMTExMTExMRB
xMRBxMTExMTExMTExMTExMTExMTExMTExMRBxMTExMTExMTEVQotICAgICAg
ICAgICAgIEHExMTExMTExMTExMTExMTEVSAgQcTExMTExMTExMTExMTExMTE
xMTExMTEVQorVcOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TD
hMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOE
w4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TD
hMOEw4TDhMK/CivDvlXDhMOEw4TDhMOEw4TCvyAgICAgICAgICAgICAgICAg
ICAgICAgICBVw4TDhMOEw4TDhMK/ICAgICAgICAgICAgVcOEw4TDhMK/ICAg
ICAgICAgw74KK8O+QcOEw4TDhMOEw4TDhFUgICAgICAgICAgICAgICAgICAg
ICAgVzEgQcOEw4TDhMOEw4RVICAgICBVw4TDhMOEw4TCvyDDviAgIMO+ICAg
ICAgICAgw74KK8O+VcOEw4TDhMOEw4TDhMK/ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIMO+ICAgIMO+IMO+ICAgw74gICAgICBVw4TD
hMOFwr8KK8O+QcOEw4TDhMOEw4TDhFUgICAgICAgICAgICAgIFXDhMOEw4TD
hMOEw4TDhMOEw4TDhMOEwr8gICAgICAgICAgQcOEw4TDhMOEVSDDviAgIMO+
ICAgICAgw74gIMO+w74KK8O+VcOEw4TDhMOEw4TDhMK/ICAgICAgICAgICAg
ICDDviAgICAgICAgICAgw74gICAgICAgICAgVcOEw4TDhMK/ICBBw4TDhMOE
VSAgICAgIEHDhMOEw4VVCivDvkHDhMOEw4TDhMOEw4RVICAgICAgICAgICAg
ICDDviBUTVMzODBDMjYgw74gICAgICAgICAgw74gICDDviAgICAgICAgICAg
ICAgICDDvgorw75Vw4TDhMOEw4TDhMOEwr8gICAgICAgICAgICAgIMO+ICAg
ICAgICAgICDDviAgICAgICAgICBBw4TDhMOEVSAgICAgICAgICAgICAgICBB
w4TCvworw75Bw4TDhMOEw4TDhMOEVSAgICAgICAgICAgICAgw74gICAgICAg
ICAgIMO+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIMO+IMO+CivD
viAgICAgICAgICAgICAgICAgICAgICBBw4TDhMOEw4TDhMOEw4TDhMOEw4TD
hFUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgw74gw74KK8O+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgw74gw74KK8O+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgQcOEVQorw74gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICDDvgorw74gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICDDvgorw74gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICDDvgor
w74gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICDDvgorQcOEw4TDhMOEw4TDhMOEw4TD
hMOEw4TDhEHDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhEHDhMOE
QcOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOE
w4RBw4TDhMOEw4TDhMOEw4TDhMOEVQorICAgICAgICAgICAgIEHDhMOEw4TD
hMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhFUgIEHDhMOEw4TDhMOEw4TDhMOE
w4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEw4TDhMOEVQogCiAgID09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09CiAgIENIQVBURVIgMiAgICAgREVGQVVMVCBTRVRUSU5HUwpA
QCAtMTA4LDkgKzEwOCw5IEBAIEHExMTExMTExMTExMRBxMTExMTExMTExMTE
xMTExEHExEHExMTExMQKICAgQ0hBUFRFUiAzICAgICBESVAgU1dJVENIIFcx
IERFU0NSSVBUSU9OCiAgID09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CiAKLSAgICAgIFXE
xMRBxMTEQcTExEHExMRBxMTEQcTExEHExMRBxMTEvyAgT04KLSAgICAgIP4g
MSD+IDIg/iAzIP4gNCD+IDUg/iA2IP4gNyD+IDgg/gotICAgICAgQcTExEHE
xMRBxMTEQcTExEHExMRBxMTEQcTExEHExMRVICBPRkYKKyAgICAgIFXDhMOE
w4RBw4TDhMOEQcOEw4TDhEHDhMOEw4RBw4TDhMOEQcOEw4TDhEHDhMOEw4RB
w4TDhMOEwr8gIE9OCisgICAgICDDviAxIMO+IDIgw74gMyDDviA0IMO+IDUg
w74gNiDDviA3IMO+IDggw74KKyAgICAgIEHDhMOEw4RBw4TDhMOEQcOEw4TD
hEHDhMOEw4RBw4TDhMOEQcOEw4TDhEHDhMOEw4RBw4TDhMOEVSAgT0ZGCiAg
ICAgICB8QUQgfCBCb290Uk9NIEFkZHIuIHwgIEkvTyAgICAgIHwKICAgICAg
ICstKy0rLS0tLS0tLSstLS0tLS0tKy0tLS0tKy0tLS0tKwogICAgICAgICB8
ICAgICAgICAgfCAgICAgICAgICAgICB8CmRpZmYgLXVwck4gbGludXgtMi42
LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vcGNpZWFlci1ob3d0by50eHQg
bGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9wY2llYWVyLWhv
d3RvLnR4dAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRp
b24vcGNpZWFlci1ob3d0by50eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAw
MDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50
YXRpb24vcGNpZWFlci1ob3d0by50eHQJMjAwNy0wNC0xNyAxMjo0NDowOS4w
MDAwMDAwMDAgLTA0MDAKQEAgLTEzLDcgKzEzLDcgQEAgUmVwb3J0aW5nIChB
RVIpIGRyaXZlciBhbmQgcHJvdmlkZXMgaW5mbwogd2VsbCBhcyBob3cgdG8g
ZW5hYmxlIHRoZSBkcml2ZXJzIG9mIGVuZHBvaW50IGRldmljZXMgdG8gY29u
Zm9ybSB3aXRoCiBQQ0kgRXhwcmVzcyBBRVIgZHJpdmVyLgogCi0xLjIgQ29w
eXJpZ2h0IKkgSW50ZWwgQ29ycG9yYXRpb24gMjAwNi4KKzEuMiBDb3B5cmln
aHQgwqkgSW50ZWwgQ29ycG9yYXRpb24gMjAwNi4KIAogMS4zIFdoYXQgaXMg
dGhlIFBDSSBFeHByZXNzIEFFUiBEcml2ZXI/CiAKZGlmZiAtdXByTiBsaW51
eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9wb3dlci9zd3N1c3Au
dHh0IGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vcG93ZXIv
c3dzdXNwLnR4dAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50
YXRpb24vcG93ZXIvc3dzdXNwLnR4dAkyMDA3LTAyLTA0IDEzOjQ0OjU0LjAw
MDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1l
bnRhdGlvbi9wb3dlci9zd3N1c3AudHh0CTIwMDctMDQtMTcgMTI6NDQ6MDku
MDAwMDAwMDAwIC0wNDAwCkBAIC00OCw3ICs0OCw3IEBAIGJlZm9yZSBzdXNw
ZW5kIChpdCBpcyBsaW1pdGVkIHRvIDUwMCBNQiAKIAogQXJ0aWNsZSBhYm91
dCBnb2FscyBhbmQgaW1wbGVtZW50YXRpb24gb2YgU29mdHdhcmUgU3VzcGVu
ZCBmb3IgTGludXgKIH5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Ci1BdXRob3I6
IEeC4WJvciBLdXRpCitBdXRob3I6IEfCgsOhYm9yIEt1dGkKIExhc3QgcmV2
aXNlZDogMjAwMy0xMC0yMCBieSBQYXZlbCBNYWNoZWsKIAogSWRlYSBhbmQg
Z29hbHMgdG8gYWNoaWV2ZQpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9Eb2N1bWVudGF0aW9uL3MzOTAvRGVidWdnaW5nMzkwLnR4dCBsaW51
eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL3MzOTAvRGVidWdnaW5n
MzkwLnR4dAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRp
b24vczM5MC9EZWJ1Z2dpbmczOTAudHh0CTIwMDctMDQtMTcgMTE6NDE6NDEu
MDAwMDAwMDAwIC0wNDAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1
bWVudGF0aW9uL3MzOTAvRGVidWdnaW5nMzkwLnR4dAkyMDA3LTA0LTE3IDEy
OjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMjIwOSw3ICsyMjA5LDcgQEAg
QnJlYWtwb2ludCAyIGF0IDB4NGQ4N2E0OiBmaWxlIHRvcC5jLCBsaQogIzMg
IDB4NTE2N2U2IGluIHJlYWRsaW5lX2ludGVybmFsX2NoYXIgKCkgYXQgcmVh
ZGxpbmUuYzo0NTQKICM0ICAweDUxNjhlZSBpbiByZWFkbGluZV9pbnRlcm5h
bF9jaGFybG9vcCAoKSBhdCByZWFkbGluZS5jOjUwNwogIzUgIDB4NTE2OTJj
IGluIHJlYWRsaW5lX2ludGVybmFsICgpIGF0IHJlYWRsaW5lLmM6NTIxCi0j
NiAgMHg1MTY0ZmUgaW4gcmVhZGxpbmUgKHByb21wdD0weDdmZmZmODEwICJc
MTc3gf+B+HhcMTc3gf+B94HYXDE3N4H/gfh4gcAiKQorIzYgIDB4NTE2NGZl
IGluIHJlYWRsaW5lIChwcm9tcHQ9MHg3ZmZmZjgxMCAiXDE3N8KBw7/CgcO4
eFwxNzfCgcO/woHDt8KBw5hcMTc3woHDv8KBw7h4woHDgCIpCiAgICAgYXQg
cmVhZGxpbmUuYzozNDkKICM3ICAweDRkN2E4YSBpbiBjb21tYW5kX2xpbmVf
aW5wdXQgKHBycm9tcHQ9MHg1NjQ0MjAgIihnZGIpICIsIHJlcGVhdD0xLAog
ICAgIGFubm90YXRpb25fc3VmZml4PTB4NGQ2YjQ0ICJwcm9tcHQiKSBhdCB0
b3AuYzoyMDkxCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0Rv
Y3VtZW50YXRpb24vc2NzaS9haGExNTJ4LnR4dCBsaW51eC0yLjYuMjEtcmM3
Lm1vZC9Eb2N1bWVudGF0aW9uL3Njc2kvYWhhMTUyeC50eHQKLS0tIGxpbnV4
LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0aW9uL3Njc2kvYWhhMTUyeC50
eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxp
bnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vc2NzaS9haGExNTJ4
LnR4dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAt
MSw3ICsxLDcgQEAKICRJZDogUkVBRE1FLmFoYTE1MngsdiAxLjIgMTk5OS8x
Mi8yNSAxNTozMjozMCBmaXNjaGVyIEV4cCBmaXNjaGVyICQKIEFkYXB0ZWMg
QUhBLTE1MjAvMTUyMiBTQ1NJIGRyaXZlciBmb3IgTGludXggKGFoYTE1Mngp
CiAKLUNvcHlyaWdodCAxOTkzLTE5OTkgSvxyZ2VuIEZpc2NoZXIgPGZpc2No
ZXJAbm9yYml0LmRlPgorQ29weXJpZ2h0IDE5OTMtMTk5OSBKw7xyZ2VuIEZp
c2NoZXIgPGZpc2NoZXJAbm9yYml0LmRlPgogVEMxNTUwIHBhdGNoZXMgYnkg
THV1ayB2YW4gRGlqayAobGR6QHhzNGFsbC5ubCkKIAogCmRpZmYgLXVwck4g
bGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vc2NzaS9zdC50
eHQgbGludXgtMi42LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9zY3NpL3N0
LnR4dAotLS0gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24v
c2NzaS9zdC50eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1
MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vc2Nz
aS9zdC50eHQJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAK
QEAgLTEsNSArMSw1IEBACiBUaGlzIGZpbGUgY29udGFpbnMgYnJpZWYgaW5m
b3JtYXRpb24gYWJvdXQgdGhlIFNDU0kgdGFwZSBkcml2ZXIuCi1UaGUgZHJp
dmVyIGlzIGN1cnJlbnRseSBtYWludGFpbmVkIGJ5IEthaSBN5Gtpc2FyYSAo
ZW1haWwKK1RoZSBkcml2ZXIgaXMgY3VycmVudGx5IG1haW50YWluZWQgYnkg
S2FpIE3DpGtpc2FyYSAoZW1haWwKIEthaS5NYWtpc2FyYUBrb2x1bWJ1cy5m
aSkKIAogTGFzdCBtb2RpZmllZDogTW9uIE1hciAgNyAyMToxNDo0NCAyMDA1
IGJ5IGthaS5tYWtpc2FyYQpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcu
b3JpZy9Eb2N1bWVudGF0aW9uL3Njc2kvdG1zY3NpbS50eHQgbGludXgtMi42
LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi9zY3NpL3Rtc2NzaW0udHh0Ci0t
LSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9zY3NpL3Rt
c2NzaW0udHh0CTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAw
CisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL3Njc2kv
dG1zY3NpbS50eHQJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0
MDAKQEAgLTQyNiw3ICs0MjYsNyBAQCBUaGFua3MgdG8gTGludXMgVG9ydmFs
ZHMsIEFsYW4gQ294LCB0aGUgCiBhbGwgdGhlIG90aGVycyBmb3IgdGhlIHdv
bmRlcmZ1bCBPUyBhbmQgc29mdHdhcmUuCiBUaGFua3MgdG8gQy5MLiBIdWFu
ZyBhbmQgUGhpbGlwIEdpYW5nIChUZWtyYW0pIGZvciB0aGUgaW5pdGlhbCBk
cml2ZXIKIHJlbGVhc2UgYW5kIHN1cHBvcnQuCi1UaGFua3MgdG8gRG91ZyBM
ZWRmb3JkLCBH6XJhcmQgUm91ZGllciBmb3Igc3VwcG9ydCB3aXRoIFNDU0kg
Y29kaW5nLgorVGhhbmtzIHRvIERvdWcgTGVkZm9yZCwgR8OpcmFyZCBSb3Vk
aWVyIGZvciBzdXBwb3J0IHdpdGggU0NTSSBjb2RpbmcuCiBUaGFua3MgdG8g
YSBsb3Qgb2YgcGVvcGxlIChlc3BlYy4gQ2hpYWtpIElzaGlrYXdhLCBBbmRy
ZWFzIEhhdW1lciwgSHViZXJ0IAogVG9ubmVhdSkgZm9yIGludGVuc2l2ZWx5
IHRlc3RpbmcgdGhlIGRyaXZlciAoYW5kIGV2ZW4gcmlza2luZyBkYXRhIGxv
c3MKIGRvaW5nIHRoaXMgZHVyaW5nIGVhcmx5IHJldmlzaW9ucykuCmRpZmYg
LXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vc29u
eXBpLnR4dCBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL3Nv
bnlwaS50eHQKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0
aW9uL3NvbnlwaS50eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAg
LTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24v
c29ueXBpLnR4dAkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQw
MApAQCAtMSw3ICsxLDcgQEAKIFNvbnkgUHJvZ3JhbW1hYmxlIEkvTyBDb250
cm9sIERldmljZSBEcml2ZXIgUmVhZG1lCiAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogCUNvcHlyaWdodCAo
QykgMjAwMS0yMDA0IFN0ZWxpYW4gUG9wIDxzdGVsaWFuQHBvcGllcy5uZXQ+
Ci0JQ29weXJpZ2h0IChDKSAyMDAxLTIwMDIgQWxj9HZlIDx3d3cuYWxjb3Zl
LmNvbT4KKwlDb3B5cmlnaHQgKEMpIDIwMDEtMjAwMiBBbGPDtHZlIDx3d3cu
YWxjb3ZlLmNvbT4KIAlDb3B5cmlnaHQgKEMpIDIwMDEgTWljaGFlbCBBc2hs
ZXkgPG0uYXNobGV5QHVuc3cuZWR1LmF1PgogCUNvcHlyaWdodCAoQykgMjAw
MSBKdW5pY2hpIE1vcml0YSA8anVuMW1AbWFycy5kdGkubmUuanA+CiAJQ29w
eXJpZ2h0IChDKSAyMDAwIFRha2F5YSBLaW5qbyA8dC1raW5qb0B0YzQuc28t
bmV0Lm5lLmpwPgpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9E
b2N1bWVudGF0aW9uL3NvdW5kL29zcy9BRDE4MTYgbGludXgtMi42LjIxLXJj
Ny5tb2QvRG9jdW1lbnRhdGlvbi9zb3VuZC9vc3MvQUQxODE2Ci0tLSBsaW51
eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi9zb3VuZC9vc3MvQUQx
ODE2CTIwMDctMDItMDQgMTM6NDQ6NTQuMDAwMDAwMDAwIC0wNTAwCisrKyBs
aW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL3NvdW5kL29zcy9B
RDE4MTYJMjAwNy0wNC0xNyAxMjo0NDowOS4wMDAwMDAwMDAgLTA0MDAKQEAg
LTE3LDcgKzE3LDcgQEAgRmVhdHVyZXM6CiBMaXN0IG9mIGZlYXR1cmVzIHN1
cHBvcnRlZCBieSB0aGlzIGRyaXZlcjoKIC0gZnVsbC1kdXBsZXggc3VwcG9y
dAogLSBzdXBwb3J0ZWQgYXVkaW8gZm9ybWF0czogdW5zaWduZWQgOGJpdCwg
c2lnbmVkIDE2Yml0IGxpdHRsZSBlbmRpYW4sIAotICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc2lnbmVkIDE2Yml0IGJpZyBlbmRpYW4sILUtbGF3LCBB
LWxhdworICAgICAgICAgICAgICAgICAgICAgICAgICAgc2lnbmVkIDE2Yml0
IGJpZyBlbmRpYW4sIMK1LWxhdywgQS1sYXcKIC0gc3VwcG9ydGVkIGNoYW5u
ZWxzOiBtb25vIGFuZCBzdGVyZW8KIC0gc3VwcG9ydGVkIHJlY29yZGluZyBz
b3VyY2VzOiBNYXN0ZXIsIENELCBMaW5lLCBMaW5lMSwgTGluZTIsIE1pYwog
LSBzdXBwb3J0cyBwaGF0IDNkIHN0ZXJlbyBjaXJjdWl0IChMaW5lIDMpCmRp
ZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24v
c291bmQvb3NzL213YXZlIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50
YXRpb24vc291bmQvb3NzL213YXZlCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9y
aWcvRG9jdW1lbnRhdGlvbi9zb3VuZC9vc3MvbXdhdmUJMjAwNy0wMi0wNCAx
Mzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcu
bW9kL0RvY3VtZW50YXRpb24vc291bmQvb3NzL213YXZlCTIwMDctMDQtMTcg
MTI6NDQ6MDkuMDAwMDAwMDAwIC0wNDAwCkBAIC0xNjMsNyArMTYzLDcgQEAg
T1IgdGhlIERlZmF1bHQ9IGxpbmUgQ09VTEQgYmUKIERlZmF1bHQ9U0JQUk8K
IAogUmVib290IHRvIFdpbmRvd3MgOTUgYW5kIGNob29zZSBMaW51eC4gV2hl
biBib290ZWQsIHVzZSBzbmRjb25maWcgdG8gY29uZmlndXJlCi10aGUgc291
bmQgbW9kdWxlcyBhbmQgdm9pbOAgLSBUaGlua1BhZCBzb3VuZCB3aXRoIExp
bnV4LgordGhlIHNvdW5kIG1vZHVsZXMgYW5kIHZvaWzDoCAtIFRoaW5rUGFk
IHNvdW5kIHdpdGggTGludXguCiAKIE5vdyB0aGUgZ290Y2hhcyAtIHlvdSBj
YW4gZWl0aGVyIGhhdmUgQ0Qgc291bmQgT1IgTWl4ZXJzIGJ1dCBub3QgYm90
aC4gVGhhdCdzIGEKIHByb2JsZW0gd2l0aCB0aGUgU0IxLjUgKENEIHNvdW5k
KSBvciBTQlBSTyAoTWl4ZXJzKSBzZXR0aW5ncy4gTm8gb25lIGtub3dzIHdo
eQpkaWZmIC11cHJOIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9Eb2N1bWVudGF0
aW9uL3VzYi9DUkVESVRTIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50
YXRpb24vdXNiL0NSRURJVFMKLS0tIGxpbnV4LTIuNi4yMS1yYzcub3JpZy9E
b2N1bWVudGF0aW9uL3VzYi9DUkVESVRTCTIwMDctMDItMDQgMTM6NDQ6NTQu
MDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1
bWVudGF0aW9uL3VzYi9DUkVESVRTCTIwMDctMDQtMTcgMTI6NDQ6MDkuMDAw
MDAwMDAwIC0wNDAwCkBAIC02NSw3ICs2NSw3IEBAIFRIQU5LUyBmaWxlIGlu
IEluYWt5J3MgZHJpdmVyKToKICAgICAgICAgICB3aWxsIHNlbGwga2V5Ym9h
cmRzIHRvIHNvbWUgb2YgdGhlIDMgbWlsbGlvbiAoYXQgbGVhc3QpCiAgICAg
ICAgICAgTGludXggdXNlcnMuCiAKLSAgICAgICAgLSBNYW55IHRoYW5rcyB0
byBpbmcgYvxybyBoIGRvcmFuIFtodHRwOi8vd3d3LmliaGRvcmFuLmNvbV0h
CisgICAgICAgIC0gTWFueSB0aGFua3MgdG8gaW5nIGLDvHJvIGggZG9yYW4g
W2h0dHA6Ly93d3cuaWJoZG9yYW4uY29tXSEKICAgICAgICAgICBJdCB3YXMg
YWxtb3N0IGltcG9zc2libGUgdG8gZ2V0IGEgUEMgYmFja3BsYXRlIFVTQiBj
b25uZWN0b3IKICAgICAgICAgICBmb3IgdGhlIG1vdGhlcmJvYXJkIGhlcmUg
YXQgRXVyb3BlIChtaW5lLCBob21lLW1hZGUsIHdhcwogICAgICAgICAgIHF1
aXRlIGxvdXN5IDopLiBOb3cgSSBrbm93IHdoZXJlIHRvIGFjcXVpcmUgbmlj
ZSBVU0Igc3R1ZmYhCmRpZmYgLXVwck4gbGludXgtMi42LjIxLXJjNy5vcmln
L0RvY3VtZW50YXRpb24vdXNiL3VzYi1zZXJpYWwudHh0IGxpbnV4LTIuNi4y
MS1yYzcubW9kL0RvY3VtZW50YXRpb24vdXNiL3VzYi1zZXJpYWwudHh0Ci0t
LSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi91c2IvdXNi
LXNlcmlhbC50eHQJMjAwNy0wMi0wNCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1
MDAKKysrIGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vdXNi
L3VzYi1zZXJpYWwudHh0CTIwMDctMDQtMTcgMTI6NDQ6MDkuMDAwMDAwMDAw
IC0wNDAwCkBAIC00NSw5ICs0NSw5IEBAIENvbm5lY3RUZWNoIFdoaXRlSEVB
VCA0IHBvcnQgY29udmVydGVyCiAgIFN0dWFydCBNYWNEb25hbGQgYXQgc3R1
YXJ0bUBjb25uZWN0dGVjaC5jb20KIAogCi1IYW5kU3ByaW5nIFZpc29yLCBQ
YWxtIFVTQiwgYW5kIENsaekgVVNCIGRyaXZlcgorSGFuZFNwcmluZyBWaXNv
ciwgUGFsbSBVU0IsIGFuZCBDbGnDqSBVU0IgZHJpdmVyCiAKLSAgVGhpcyBk
cml2ZXIgd29ya3Mgd2l0aCBhbGwgSGFuZFNwcmluZyBVU0IsIFBhbG0gVVNC
LCBhbmQgU29ueSBDbGnpIFVTQgorICBUaGlzIGRyaXZlciB3b3JrcyB3aXRo
IGFsbCBIYW5kU3ByaW5nIFVTQiwgUGFsbSBVU0IsIGFuZCBTb255IENsacOp
IFVTQgogICBkZXZpY2VzLgogCiAgIE9ubHkgd2hlbiB0aGUgZGV2aWNlIHRy
aWVzIHRvIGNvbm5lY3QgdG8gdGhlIGhvc3QsIHdpbGwgdGhlIGRldmljZSBz
aG93CkBAIC02OSw3ICs2OSw3IEBAIEhhbmRTcHJpbmcgVmlzb3IsIFBhbG0g
VVNCLCBhbmQgQ2xp6SBVU0IKICAgdGhlIHBvcnQgdG8gdXNlIGZvciB0aGUg
SG90U3luYyB0cmFuc2Zlci4gVGhlICJHZW5lcmljIiBwb3J0IGNhbiBiZSB1
c2VkCiAgIGZvciBvdGhlciBkZXZpY2UgY29tbXVuaWNhdGlvbiwgc3VjaCBh
cyBhIFBQUCBsaW5rLgogCi0gIEZvciBzb21lIFNvbnkgQ2xp6SBkZXZpY2Vz
LCAvZGV2L3R0eVVTQjAgbXVzdCBiZSB1c2VkIHRvIHRhbGsgdG8gdGhlCisg
IEZvciBzb21lIFNvbnkgQ2xpw6kgZGV2aWNlcywgL2Rldi90dHlVU0IwIG11
c3QgYmUgdXNlZCB0byB0YWxrIHRvIHRoZQogICBkZXZpY2UuICBUaGlzIGlz
IHRydWUgZm9yIGFsbCBPUyB2ZXJzaW9uIDMuNSBkZXZpY2VzLCBhbmQgbW9z
dCBkZXZpY2VzCiAgIHRoYXQgaGF2ZSBoYWQgYSBmbGFzaCB1cGdyYWRlIHRv
IGEgbmV3ZXIgdmVyc2lvbiBvZiB0aGUgT1MuICBTZWUgdGhlCiAgIGtlcm5l
bCBzeXN0ZW0gbG9nIGZvciBpbmZvcm1hdGlvbiBvbiB3aGljaCBpcyB0aGUg
Y29ycmVjdCBwb3J0IHRvIHVzZS4KZGlmZiAtdXByTiBsaW51eC0yLjYuMjEt
cmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9tZXllLnR4dCBs
aW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxpbnV4
L21leWUudHh0Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRh
dGlvbi92aWRlbzRsaW51eC9tZXllLnR4dAkyMDA3LTAyLTA0IDEzOjQ0OjU0
LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2QvRG9j
dW1lbnRhdGlvbi92aWRlbzRsaW51eC9tZXllLnR4dAkyMDA3LTA0LTE3IDEy
OjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMSw3ICsxLDcgQEAKIFZhaW8g
UGljdHVyZWJvb2sgTW90aW9uIEV5ZSBDYW1lcmEgRHJpdmVyIFJlYWRtZQog
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCiAJQ29weXJpZ2h0IChDKSAyMDAxLTIwMDQgU3RlbGlhbiBQb3AgPHN0
ZWxpYW5AcG9waWVzLm5ldD4KLQlDb3B5cmlnaHQgKEMpIDIwMDEtMjAwMiBB
bGP0dmUgPHd3dy5hbGNvdmUuY29tPgorCUNvcHlyaWdodCAoQykgMjAwMS0y
MDAyIEFsY8O0dmUgPHd3dy5hbGNvdmUuY29tPgogCUNvcHlyaWdodCAoQykg
MjAwMCBBbmRyZXcgVHJpZGdlbGwgPHRyaWRnZUBzYW1iYS5vcmc+CiAKIFRo
aXMgZHJpdmVyIGVuYWJsZSB0aGUgdXNlIG9mIHZpZGVvNGxpbnV4IGNvbXBh
dGlibGUgYXBwbGljYXRpb25zIHdpdGggdGhlCmRpZmYgLXVwck4gbGludXgt
Mi42LjIxLXJjNy5vcmlnL0RvY3VtZW50YXRpb24vdmlkZW80bGludXgvb3Y1
MTEudHh0IGxpbnV4LTIuNi4yMS1yYzcubW9kL0RvY3VtZW50YXRpb24vdmlk
ZW80bGludXgvb3Y1MTEudHh0Ci0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcv
RG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9vdjUxMS50eHQJMjAwNy0wMi0w
NCAxMzo0NDo1NC4wMDAwMDAwMDAgLTA1MDAKKysrIGxpbnV4LTIuNi4yMS1y
YzcubW9kL0RvY3VtZW50YXRpb24vdmlkZW80bGludXgvb3Y1MTEudHh0CTIw
MDctMDQtMTcgMTI6NDQ6MDkuMDAwMDAwMDAwIC0wNDAwCkBAIC0xOTUsMTEg
KzE5NSwxMSBAQCBNT0RVTEUgUEFSQU1FVEVSUzoKICAgTkFNRTogYmFuZGlu
Z2ZpbHRlcgogICBUWVBFOiBpbnRlZ2VyIChCb29sZWFuKQogICBERUZBVUxU
OiAwIChvZmYpCi0gIERFU0M6IEVuYWJsZXMgdGhlIHNlbnNvcrRzIGJhbmRp
bmcgZmlsdGVyIGV4cG9zdXJlIGFsZ29yaXRobS4gVGhpcyByZWR1Y2VzCisg
IERFU0M6IEVuYWJsZXMgdGhlIHNlbnNvcsK0cyBiYW5kaW5nIGZpbHRlciBl
eHBvc3VyZSBhbGdvcml0aG0uIFRoaXMgcmVkdWNlcwogCW9yIHN0YWJpbGl6
ZXMgdGhlICJiYW5kaW5nIiBjYXVzZWQgYnkgc29tZSBhcnRpZmljaWFsIGxp
Z2h0IHNvdXJjZXMKIAkoZXNwZWNpYWxseSBmbHVvcmVzY2VudCkuIFlvdSBt
aWdodCBoYXZlIHRvIHNldCBsaWdodGZyZXEgY29ycmVjdGx5IGZvcgogCXRo
aXMgdG8gd29yayByaWdodC4gQXMgYW4gYWRkZWQgYm9udXMsIHRoaXMgc29t
ZXRpbWVzIG1ha2VzIGl0Ci0JcG9zc2libGUgdG8gY2FwdHVyZSB5b3VyIG1v
bml0b3K0cyBvdXRwdXQuCisJcG9zc2libGUgdG8gY2FwdHVyZSB5b3VyIG1v
bml0b3LCtHMgb3V0cHV0LgogCiAgIE5BTUU6IGZhc3RzZXQKICAgVFlQRTog
aW50ZWdlciAoQm9vbGVhbikKZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3
Lm9yaWcvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9SRUFETUUucHZydXNi
MiBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxp
bnV4L1JFQURNRS5wdnJ1c2IyCi0tLSBsaW51eC0yLjYuMjEtcmM3Lm9yaWcv
RG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9SRUFETUUucHZydXNiMgkyMDA3
LTAyLTA0IDEzOjQ0OjU0LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42
LjIxLXJjNy5tb2QvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9SRUFETUUu
cHZydXNiMgkyMDA3LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApA
QCAtOCw3ICs4LDcgQEAgQmFja2dyb3VuZDoKIAogICBUaGlzIGRyaXZlciBp
cyBpbnRlbmRlZCBmb3IgdGhlICJIYXVwcGF1Z2UgV2luVFYgUFZSIFVTQiAy
LjAiLCB3aGljaAogICBpcyBhIFVTQiAyLjAgaG9zdGVkIFRWIFR1bmVyLiAg
VGhpcyBkcml2ZXIgaXMgYSB3b3JrIGluIHByb2dyZXNzLgotICBJdHMgaGlz
dG9yeSBzdGFydGVkIHdpdGggdGhlIHJldmVyc2UtZW5naW5lZXJpbmcgZWZm
b3J0IGJ5IEJq9nJuCisgIEl0cyBoaXN0b3J5IHN0YXJ0ZWQgd2l0aCB0aGUg
cmV2ZXJzZS1lbmdpbmVlcmluZyBlZmZvcnQgYnkgQmrDtnJuCiAgIERhbmll
bHNzb24gPHB2cnVzYjJAZGF4Lm51PiB3aG9zZSB3ZWIgcGFnZSBjYW4gYmUg
Zm91bmQgaGVyZToKIAogICAgIGh0dHA6Ly9wdnJ1c2IyLmRheC5udS8KZGlm
ZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvRG9jdW1lbnRhdGlvbi92
aWRlbzRsaW51eC9ab3JhbiBsaW51eC0yLjYuMjEtcmM3Lm1vZC9Eb2N1bWVu
dGF0aW9uL3ZpZGVvNGxpbnV4L1pvcmFuCi0tLSBsaW51eC0yLjYuMjEtcmM3
Lm9yaWcvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9ab3JhbgkyMDA3LTA0
LTE3IDExOjQxOjQyLjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjIx
LXJjNy5tb2QvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9ab3JhbgkyMDA3
LTA0LTE3IDEyOjQ0OjA5LjAwMDAwMDAwMCAtMDQwMApAQCAtMjQyLDcgKzI0
Miw3IEBAIGNhbiBnZW5lcmF0ZTogUEFMICwgTlRTQyAsIFNFQ0FNCiAKIENv
bmV4YW50IGJ0ODY2IFRWIGVuY29kZXIKIGlzIHVzZWQgaW4gQVZTNkVZRVMs
IGFuZAotY2FuIGdlbmVyYXRlOiBOVFNDL1BBTCwgUEFMrU0sIFBBTK1OCitj
YW4gZ2VuZXJhdGU6IE5UU0MvUEFMLCBQQUzCrU0sIFBBTMKtTgogCiBUaGUg
YWR2NzE3eCwgc2hvdWxkIGJlIGFibGUgdG8gcHJvZHVjZSBQQUwgTi4gQnV0
IHlvdSBmaW5kIG5vdGhpbmcgUEFMIE4KIHNwZWNpZmljIGluIHRoZSByZWdp
c3RlcnMuIFNlZW0gdGhhdCB5b3UgaGF2ZSB0byByZXVzZSBhIG90aGVyIHN0
YW5kYXJkCg==

--1875672472-1222175207-1176828544=:27446--
