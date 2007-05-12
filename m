Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXELUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXELUTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbXELUTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:19:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49039 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbXELUTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:19:07 -0400
Date: Sat, 12 May 2007 22:14:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mchehab@infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: default y idiocy
In-Reply-To: <20070512194510.GR4629@kernel.dk>
Message-ID: <Pine.LNX.4.61.0705122212180.9570@yvahk01.tjqt.qr>
References: <20070512182343.GO4629@kernel.dk> <Pine.LNX.4.61.0705122121340.9570@yvahk01.tjqt.qr>
 <20070512192726.GQ4629@kernel.dk> <Pine.LNX.4.61.0705122135510.9570@yvahk01.tjqt.qr>
 <20070512194510.GR4629@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


>> >> On May 12 2007 20:23, Jens Axboe wrote:
>> >> >Hi,
>> >> >
>> >> >This has bothered me for a long time, and it just seems to be getting
>> >> >worse. Can people please STOP defaulting non-essential stuff to 'y'?
>> >> >Grrr.
>> >> 
>> >> http://lkml.org/lkml/2007/5/8/76
>> >
>> >Sorry, I don't buy that reason at all - it's a short term advantage,
>> >causing long term pain. It's not what we have done in the past, don't
>> >start doing crap like that now.
>> 
>> Right, I shall create some patches to revert that and send them off
>> to Linus ASAP.
>
>Thanks!

Revert "default y" in Kconfig files that were introduced as part of my 
menuconfig objects series (unfortunately, more patches may find their 
way into mainline as subsystem maintainers merge). Apply this for now, 
please.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 drivers/atm/Kconfig         |    1 -
 drivers/macintosh/Kconfig   |    1 -
 drivers/media/radio/Kconfig |    1 -
 drivers/media/video/Kconfig |    2 --
 drivers/net/Kconfig         |    1 -
 5 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index f5a47a4..b466a5c 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -5,7 +5,6 @@
 menuconfig ATM_DRIVERS
 	bool "ATM drivers"
 	depends on NETDEVICES && ATM
-	default y
 
 if ATM_DRIVERS
 
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 58926da..adbb5ca 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -2,7 +2,6 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y
 
 if MACINTOSH_DRIVERS
 
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index a6ac82a..0486780 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -5,7 +5,6 @@
 menuconfig RADIO_ADAPTERS
 	bool "Radio Adapters"
 	depends on VIDEO_DEV
-	default y
 	---help---
 	  Say Y here to enable selecting AM/FM radio adapters.
 
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 5cb3f54..ca33d55 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -5,7 +5,6 @@
 menuconfig VIDEO_CAPTURE_DRIVERS
 	bool "Video capture adapters"
 	depends on VIDEO_DEV
-	default y
 	---help---
 	  Say Y here to enable selecting the video adapters for
 	  webcams, analog TV, and hybrid analog/digital TV.
@@ -689,7 +688,6 @@ config VIDEO_CAFE_CCIC
 menuconfig V4L_USB_DRIVERS
 	bool "V4L USB devices"
 	depends on USB
-	default y
 
 if V4L_USB_DRIVERS
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index fb99cd4..80f5413 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1901,7 +1901,6 @@ endmenu
 menuconfig NETDEV_1000
 	bool "Ethernet (1000 Mbit)"
 	depends on !UML
-	default y
 
 if NETDEV_1000
 
#<EOF>

	Jan
-- 
