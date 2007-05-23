Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXEXBMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXEXBMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbXEXBML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:12:11 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:1607 "EHLO critter"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756578AbXEXBML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:12:11 -0400
X-Greylist: delayed 3555 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 21:12:10 EDT
To: linux-kernel@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Maxim Krasnyansky <maxk@qualcomm.com>
Message-Id: <cc9d2edaa0e2f0806a002fd04a930957780651b3.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <98cd38b5.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 18:21:25 -0400
Subject: [PATCH 3/6] HCIUSB: Initialize the Broadcom USB Bluetooth device in Dell laptops.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Marcel Holtmann <marcel@holtmann.org>
CC: Maxim Krasnyansky <maxk@qualcomm.com>
Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
Signed-off-by: Phillip lougher <phillip@ubuntu.com>
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
---
 drivers/bluetooth/hci_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index b0238b4..d636142 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -131,7 +131,7 @@ static struct usb_device_id blacklist_ids[] = {
 	{ USB_DEVICE(0x03f0, 0x171d), .driver_info = HCI_WRONG_SCO_MTU },
 
 	/* Dell laptop with Broadcom chip */
-	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_WRONG_SCO_MTU },
+	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_WRONG_SCO_MTU|HCI_RESET },
 
 	/* Microsoft Wireless Transceiver for Bluetooth 2.0 */
 	{ USB_DEVICE(0x045e, 0x009c), .driver_info = HCI_RESET },
-- 
1.5.1.4

