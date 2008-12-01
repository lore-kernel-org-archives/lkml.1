Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYLAV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYLAV7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLAV72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:59:28 -0500
Received: from rtr.ca ([76.10.145.34]:55272 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYLAV71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:59:27 -0500
Message-ID: <49345E82.3020704@rtr.ca>
Date: Mon, 01 Dec 2008 17:00:34 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Tobias Lorenz <tobias.lorenz@gmx.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PATCH: radio-si470x: add USB ID for dealextreme usb radio
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB ID for the Sil4701 radio from DealExtreme.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- linux/drivers/media/radio/radio-si470x.c.orig	2008-12-01 16:20:39.000000000 -0500
+++ linux/drivers/media/radio/radio-si470x.c	2008-12-01 16:20:18.000000000 -0500
@@ -142,6 +142,8 @@
 static struct usb_device_id si470x_usb_driver_id_table[] = {
 	/* Silicon Labs USB FM Radio Reference Design */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a,	USB_CLASS_HID, 0, 0) },
+	/* DealExtreme USB Radio */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c5, 0x819a,	USB_CLASS_HID, 0, 0) },
 	/* ADS/Tech FM Radio Receiver (formerly Instant FM Music) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x06e1, 0xa155,	USB_CLASS_HID, 0, 0) },
 	/* Terminating entry */
