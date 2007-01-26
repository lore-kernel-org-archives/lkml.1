Return-Path: <linux-kernel-owner+w=401wt.eu-S1030679AbXAZAfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030679AbXAZAfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXAZAfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:35:21 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:37654 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030679AbXAZAfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:35:20 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 25 Jan 2007 19:34:52 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>
Subject: [PATCH] Fix apparent typo CONFIG_USB_CDCETHER.
Message-ID: <Pine.LNX.4.64.0701251932090.16585@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace the apparent typo CONFIG_USB_CDCETHER with
CONFIG_USB_NET_CDCETHER.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  i *think* this is correct, but i'll leave the final decision to
those higher up the food chain.


diff --git a/drivers/usb/core/otg_whitelist.h b/drivers/usb/core/otg_whitelist.h
index 627a5a2..7f31a49 100644
--- a/drivers/usb/core/otg_whitelist.h
+++ b/drivers/usb/core/otg_whitelist.h
@@ -31,7 +31,7 @@ static struct usb_device_id whitelist_table [] = {
 { USB_DEVICE_INFO(7, 1, 3) },
 #endif

-#ifdef	CONFIG_USB_CDCETHER
+#ifdef	CONFIG_USB_NET_CDCETHER
 /* Linux-USB CDC Ethernet gadget */
 { USB_DEVICE(0x0525, 0xa4a1), },
 /* Linux-USB CDC Ethernet + RNDIS gadget */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
