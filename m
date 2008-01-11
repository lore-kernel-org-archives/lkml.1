Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbYAKVqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbYAKVqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761289AbYAKVp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:45:56 -0500
Received: from server1.mediglia.altarisoluzione.com ([212.97.63.99]:45699 "EHLO
	server1.mediglia.altarisoluzione.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761221AbYAKVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:45:55 -0500
X-Greylist: delayed 2682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 16:45:54 EST
From: Bruno Redondi <bruno.redondi@altarisoluzione.com>
Organization: altarisoluzione.com di Redondi Bruno
To: greg@kroah.com
Subject: [PATCH 001/001] USB SERIAL SIERRA: add support for Onda H600/Zte MF330 datacard to USB Driver for Sierra Wireless
Date: Fri, 11 Jan 2008 22:00:59 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, bruno.redondi@altarisoluzione.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801112200.59577.bruno.redondi@altarisoluzione.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard
Signed-off-by: Bruno Redondi <bruno.redondi@altarisoluzione.com>
---
Linux kernel is missing support for the Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard, but this card can be used adding the USB_DEVICE(0x05C6, 0x6613) to the Sierra Wireless driver.

diff -up linux-2.6.23/drivers/usb/serial/sierra.c.orig linux-2.6.23/drivers/usb/serial/sierra.c
--- linux-2.6.23-tuxonice-r6/drivers/usb/serial/sierra.c.orig	2008-01-01 19:23:27.399785842 +0100
+++ linux-2.6.23-tuxonice-r6/drivers/usb/serial/sierra.c	2008-01-01 19:25:53.497545598 +0100
@@ -118,6 +118,7 @@ static struct usb_device_id id_table [] 
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
+	{ USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
 
 	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
 	{ }
@@ -127,6 +128,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static struct usb_device_id id_table_1port [] = {
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
+	{ USB_DEVICE(0x05C6, 0x6613) }, /* Onda H600/ZTE MF330 */
 	{ }
 };
 
