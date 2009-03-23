Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZCWNrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZCWNrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZCWNrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:47:37 -0400
Received: from epiphany.epiphan.com ([217.160.251.166]:57797 "EHLO
	epiphany.epiphan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZCWNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:47:36 -0400
Subject: Re: [PATCH] V4L: em28xx: add support for Digitus/Plextor PX-AV200U
	 grabbers
From: Mikhail Jiline <misha@epiphan.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
In-Reply-To: <412bdbff0903201314r5105d373ofe6614ee08431d4b@mail.gmail.com>
References: <1237575285.26159.2.camel@T60p>
	 <412bdbff0903201228t4cb4b6c8m17763c27878434ed@mail.gmail.com>
	 <1237578912.26159.13.camel@T60p>
	 <412bdbff0903201302ib6758a8ue76a8dd235cfa4cb@mail.gmail.com>
	 <1237579738.26159.16.camel@T60p>
	 <412bdbff0903201314r5105d373ofe6614ee08431d4b@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 09:47:30 -0400
Message-Id: <1237816050.3833.20.camel@T60p>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devin,

> Ok, here's the problem.  Yeah, please do not submit profiles that
> require a card= specification.  Instead, please resubmit your patch
> including an entry in the em28xx_i2c_hash[] table that includes your
> device.  It probably needs to look something like the following:

Here is the output from the version with em28xx_i2c_hash hint. Update patch is below.

Mar 23 09:13:57 T60p kernel: usb 1-5: new high speed USB device using ehci_hcd and address 9
Mar 23 09:13:57 T60p kernel: usb 1-5: configuration #1 chosen from 1 choice
Mar 23 09:13:57 T60p kernel: em28xx new video device (eb1a:2821): interface 0, class 255
Mar 23 09:13:57 T60p kernel: em28xx Has usb audio class
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate settings: 8
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 0, max size= 0
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 1, max size= 1024
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 2, max size= 1448
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 3, max size= 2048
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 4, max size= 2304
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 5, max size= 2580
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 6, max size= 2892
Mar 23 09:13:57 T60p kernel: em28xx #0: Alternate setting 7, max size= 3072
Mar 23 09:13:57 T60p kernel: em28xx #0: em28xx chip ID = 18
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 21 28 90 00 11 03 6a 22 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 10: 00 00 04 57 06 21 01 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 20: 02 00 01 01 f0 10 00 00 00 00 00 00 5b 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 03 01 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 32 00 31 00 20 00 44 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 23 09:13:57 T60p kernel: EEPROM ID= 0x9567eb1a, hash = 0x37da7b8a
Mar 23 09:13:57 T60p kernel: Vendor/Product ID= eb1a:2821
Mar 23 09:13:57 T60p kernel: AC97 audio (5 sample rates)
Mar 23 09:13:57 T60p kernel: 500mA max power
Mar 23 09:13:57 T60p kernel: Table at 0x04, strings=0x226a, 0x0000, 0x0000
Mar 23 09:13:57 T60p kernel: em28xx #0: found i2c device @ 0x4a [saa7113h]
Mar 23 09:13:57 T60p kernel: em28xx #0: found i2c device @ 0xa0 [eeprom]
Mar 23 09:13:57 T60p kernel: em28xx #0: Your board has no unique USB ID.
Mar 23 09:13:57 T60p kernel: em28xx #0: A hint were successfully done, based on i2c devicelist hash.
Mar 23 09:13:57 T60p kernel: em28xx #0: This method is not 100% failproof.
Mar 23 09:13:57 T60p kernel: em28xx #0: If the board were missdetected, please email this log to:
Mar 23 09:13:57 T60p kernel: em28xx #0: 	V4L Mailing List  <video4linux-list@redhat.com>
Mar 23 09:13:57 T60p kernel: em28xx #0: Board detected as Plextor PX-AV200U
Mar 23 09:13:57 T60p kernel: em28xx #0: 
Mar 23 09:13:57 T60p kernel:
Mar 23 09:13:57 T60p kernel: em28xx #0: The support for this board weren't valid yet.
Mar 23 09:13:57 T60p kernel: em28xx #0: Please send a report of having this working
Mar 23 09:13:57 T60p kernel: em28xx #0: not to V4L mailing list (and/or to other addresses)
Mar 23 09:13:57 T60p kernel:
Mar 23 09:13:58 T60p kernel: saa7115' 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
Mar 23 09:13:58 T60p kernel: em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
Mar 23 09:13:58 T60p kernel: em28xx #0: Found Plextor PX-AV200U
Mar 23 09:13:58 T60p kernel: usb 1-5: New USB device found, idVendor=eb1a, idProduct=2821
Mar 23 09:13:58 T60p kernel: usb 1-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
Mar 23 09:13:58 T60p kernel: usb 1-5: Product: USB 2821 Device




From: Misha Zhilin <misha@epiphan.com>

Adds support for Digitus/Plextor PX-AV200U grabbers
Signed-off-by: Misha Zhilin <misha@epiphan.com>
---

diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c
--- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx-cards.c	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx-cards.c	2009-03-23 08:28:18.000000000 -0400
@@ -1087,6 +1087,21 @@
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
+	[EM2820_BOARD_PLEXTOR_PX_AV200U] = {
+		.name         = "Plextor PX-AV200U",
+		.valid        = EM28XX_BOARD_NOT_VALIDATED,
+		.vchannels    = 2,
+		.decoder      = EM28XX_SAA7113,
+		.input          = { {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.vmux     = SAA7115_COMPOSITE0,
+			.amux     = EM28XX_AMUX_AC97_LINE_IN,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = SAA7115_SVIDEO3,
+			.amux     = EM28XX_AMUX_AC97_LINE_IN,
+		} },
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -1269,6 +1284,7 @@
 	{0xb06a32c3, EM2800_BOARD_TERRATEC_CINERGY_200, TUNER_LG_PAL_NEW_TAPC},
 	{0xf51200e3, EM2800_BOARD_VGEAR_POCKETTV, TUNER_LG_PAL_NEW_TAPC},
 	{0x1ba50080, EM2860_BOARD_POINTNIX_INTRAORAL_CAMERA, TUNER_ABSENT},
+	{0x6ba50080, EM2820_BOARD_PLEXTOR_PX_AV200U, TUNER_ABSENT},
 };
 
 int em28xx_tuner_callback(void *ptr, int command, int arg)
diff -urN linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h
--- linux-2.6.27.x86_64.orig/drivers/media/video/em28xx/em28xx.h	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.x86_64.new/drivers/media/video/em28xx/em28xx.h	2009-03-04 15:33:24.000000000 -0500
@@ -97,6 +97,8 @@
 #define EM2882_BOARD_PINNACLE_HYBRID_PRO	  56
 #define EM2883_BOARD_KWORLD_HYBRID_A316		  57
 #define EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU	  58
+#define EM2820_BOARD_PLEXTOR_PX_AV200U            59
+
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
diff -urN linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx
--- linux-2.6.27.x86_64.orig/Documentation/video4linux/CARDLIST.em28xx	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27.x86_64.new/Documentation/video4linux/CARDLIST.em28xx	2009-03-18 11:15:00.000000000 -0400
@@ -57,3 +57,4 @@
  56 -> Pinnacle Hybrid Pro (2)                  (em2882)        [2304:0226]
  57 -> Kworld PlusTV HD Hybrid 330              (em2883)        [eb1a:a316]
  58 -> Compro VideoMate ForYou/Stereo           (em2820/em2840) [185b:2041]
+ 59 -> Plextor PX-AV200U                        (em2880)










