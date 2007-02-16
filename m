Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbXBPMFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbXBPMFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXBPMFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:05:36 -0500
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:58839 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXBPMFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:05:36 -0500
X-Greylist: delayed 1062 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 07:05:35 EST
Date: Fri, 16 Feb 2007 12:47:49 +0100
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: craig@microtron.org.uk
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] another id for cp2101 driver
Message-ID: <20070216114748.GA14126@ojjektum.uhulinux.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds another usb id to the cp2101. It seems to work well.

Please apply, thanks.

Signed-off-by: Pozsar Balazs <pozsy@uhulinux.hu>


diff -Naurd a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c	2006-07-15 21:00:43.000000000 +0200
+++ b/drivers/usb/serial/cp2101.c	2007-02-16 12:41:47.000000000 +0100
@@ -65,6 +65,7 @@
 	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C5, 0xEA61) }, /* Silicon Labs MobiData GPRS USB Modem */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
 	{ } /* Terminating Entry */
 };


-- 
pozsy
