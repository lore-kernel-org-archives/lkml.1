Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbXCZWLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbXCZWLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXCZWLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:11:45 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59457 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbXCZWLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:11:44 -0400
X-Originating-Ip: 74.109.98.130
Date: Mon, 26 Mar 2007 18:08:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>, dtor@mail.ru
Subject: [PATCH] Correct bad CONFIG names in drivers/usb/input/Makefile.
Message-ID: <Pine.LNX.4.64.0703261804010.2211@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the incorrect CONFIG_ variables currently in
drivers/usb/input/Makefile that prevent three of the touchscreen
source files from being built.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

it *looks* like this is the right fix, but i'm just on my way out the
door so i'll leave it to others to verify.

diff --git a/drivers/usb/input/Makefile b/drivers/usb/input/Makefile
index a9d206c..198337f 100644
--- a/drivers/usb/input/Makefile
+++ b/drivers/usb/input/Makefile
@@ -38,9 +38,9 @@ obj-$(CONFIG_USB_KBD)		+= usbkbd.o
 obj-$(CONFIG_USB_KBTAB)		+= kbtab.o
 obj-$(CONFIG_USB_KEYSPAN_REMOTE)	+= keyspan_remote.o
 obj-$(CONFIG_USB_MOUSE)		+= usbmouse.o
-obj-$(CONFIG_USB_MTOUCH)	+= mtouchusb.o
-obj-$(CONFIG_USB_ITMTOUCH)	+= itmtouch.o
-obj-$(CONFIG_USB_EGALAX)	+= touchkitusb.o
+obj-$(CONFIG_USB_TOUCHSCREEN_3M)	+= mtouchusb.o
+obj-$(CONFIG_USB_TOUCHSCREEN_ITM)	+= itmtouch.o
+obj-$(CONFIG_USB_TOUCHSCREEN_EGALAX)	+= touchkitusb.o
 obj-$(CONFIG_USB_TOUCHSCREEN)	+= usbtouchscreen.o
 obj-$(CONFIG_USB_POWERMATE)	+= powermate.o
 obj-$(CONFIG_USB_WACOM)		+= wacom.o
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
