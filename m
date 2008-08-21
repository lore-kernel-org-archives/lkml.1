Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYHULq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYHULq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbYHULqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:46:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:50630 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758533AbYHULqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:46:17 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1/OygxYnQfOFgH7qrjdKRpssEh8wP/zWDXiFpAVz4
	EmRwIw+UwSSafQ
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Thomas Winischhofer <thomas@winischhofer.net>
Subject: [PATCH] sisusbvga: add USB ID for 0711:0918 Magic Control Technology Corp.
Date: Thu, 21 Aug 2008 13:46:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211346.13628.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sisusbvga: add USB ID for 0711:0918 Magic Control Technology Corp.

usb 1-2: new high speed USB device using ehci_hcd and address 4
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: USB2VGA dongle found at address 4
usb 1-2: Allocated 8 output buffers
usb 1-2: 8MB 1 ch/1 r SDR SDRAM, bus width 32
usb 1-2: New USB device found, idVendor=0711, idProduct=0918
usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0

Signed-off-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index fbace41..69c34a5 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3270,6 +3270,7 @@ static struct usb_device_id sisusb_table [] = {
 	{ USB_DEVICE(0x0711, 0x0900) },
 	{ USB_DEVICE(0x0711, 0x0901) },
 	{ USB_DEVICE(0x0711, 0x0902) },
+	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }
