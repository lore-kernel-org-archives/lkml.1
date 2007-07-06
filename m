Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXGFK0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXGFK0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbXGFK0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:26:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58008 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255AbXGFK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:26:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 06:24:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, gregkh@suse.de
Subject: [PATCH] USB:  Remove Makefile reference to obsolete OHCI_AT91.
Message-ID: <Pine.LNX.4.64.0707060623170.11885@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 72464b5..4d65404 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_USB_OHCI_HCD)	+= host/
 obj-$(CONFIG_USB_UHCI_HCD)	+= host/
 obj-$(CONFIG_USB_SL811_HCD)	+= host/
 obj-$(CONFIG_USB_U132_HCD)	+= host/
-obj-$(CONFIG_USB_OHCI_AT91)	+= host/

 obj-$(CONFIG_USB_ACM)		+= class/
 obj-$(CONFIG_USB_PRINTER)	+= class/
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
