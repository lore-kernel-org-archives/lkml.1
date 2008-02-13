Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYBMDmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYBMDmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYBMDmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:42:11 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:48590 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYBMDmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:42:10 -0500
Message-ID: <47B266AE.3040908@sdiz.net>
Date: Wed, 13 Feb 2008 11:40:30 +0800
From: SDiZ <sdiz@sdiz.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: marcel@holtmann.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla #9027)
Content-Type: multipart/mixed;
 boundary="------------070400050405050902010705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070400050405050902010705
Content-Type: text/plain; charset=Big5-HKSCS
Content-Transfer-Encoding: 7bit

This patch fix bugzilla #9027.
``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
connection handle 92" message"

see http://bugzilla.kernel.org/show_bug.cgi?id=9027







--------------070400050405050902010705
Content-Type: text/x-patch;
 name="bugzilla9027.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bugzilla9027.patch"

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index b474185..372c7ef 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -162,9 +162,6 @@ static struct usb_device_id blacklist_ids[] = {
        /* Frontline ComProbe Bluetooth Sniffer */
        { USB_DEVICE(0x16d3, 0x0002), .driver_info = HCI_SNIFFER },

+        /* Brandless USB Bluetooth Dongle */
+        { USB_DEVICE(0x0e5e, 0x6622), .driver_info = HCI_BROKEN_ISOC },
+
        { }     /* Terminating entry */
 };

--------------070400050405050902010705--
