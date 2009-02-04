Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZBDOK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZBDOK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZBDOKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:10:50 -0500
Received: from woodchuck.wormnet.eu ([77.75.105.223]:55634 "EHLO
	woodchuck.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZBDOKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:10:49 -0500
Date: Wed, 4 Feb 2009 13:38:44 +0000 (GMT)
From: Jamie Lentin <jm@lentin.co.uk>
X-X-Sender: lentinj@woodchuck.wormnet.eu
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28.2] at76_usb: Add support for OQO Model 01+
Message-ID: <alpine.DEB.2.00.0902041304560.16577@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB device ID for OQO 01+'s internal wireless LAN

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>

---

An OQO employee mentions the chip's true identity here:-
   ftp://ftp.oqo.com/unsupported/linux/OQOLinux.html
Works fine with the current staging driver.  I see there's a mac80211 port 
in the works which I haven't tried, but more than happy to help test if
required.

--- a/drivers/staging/at76_usb/at76_usb.c       2009-02-04 
12:29:57.000000000 +0000
+++ b/drivers/staging/at76_usb/at76_usb.c       2009-01-28 
20:44:23.000000000 +0000
@@ -231,6 +231,8 @@ static struct usb_device_id dev_table[]
  	{USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A)},
  	/* Siemens Gigaset USB WLAN Adapter 11 */
  	{USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A)},
+	/* OQO Model 01+ Internal Wi-Fi */
+	{USB_DEVICE(0x1557, 0x0002), USB_DEVICE_DATA(BOARD_505A)},
  	/*
  	 * at76c505amx-rfmd
  	 */
