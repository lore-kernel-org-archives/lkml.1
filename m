Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbXGJJBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbXGJJBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763214AbXGJI6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:58:31 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:40915 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759568AbXGJI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:58:29 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] [2.6.22] USB devices misc: Trivial patch to build the IOWARRIOR when it is selected in Kconfig
Date: Tue, 10 Jul 2007 10:58:25 +0200
User-Agent: KMail/1.9.4
Organization: Privat
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101058.25833.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Beisert <juergen@kreuzholzen.de>

Trivial patch to build the IOWARRIOR when it is selected in Kconfig.

Signed-off-by: Juergen Beisert <juergen@kreuzholzen.de>

Index: drivers/usb/Makefile
===================================================================
--- drivers/usb/Makefile
+++ drivers/usb/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_USB_SISUSBVGA)	+= misc/
 obj-$(CONFIG_USB_TEST)		+= misc/
 obj-$(CONFIG_USB_TRANCEVIBRATOR)+= misc/
 obj-$(CONFIG_USB_USS720)	+= misc/
+obj-$(CONFIG_USB_IOWARRIOR)	+= misc/

 obj-$(CONFIG_USB_ATM)		+= atm/
 obj-$(CONFIG_USB_SPEEDTOUCH)	+= atm/
