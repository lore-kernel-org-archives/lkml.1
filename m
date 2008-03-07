Return-Path: <linux-kernel-owner+w=401wt.eu-S1765239AbYCGUKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765239AbYCGUKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbYCGUKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:10:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:56791 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbYCGUKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:10:39 -0500
Date: Fri, 7 Mar 2008 21:10:34 +0100
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: marcel@holtmann.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [BLUETOOTH] Add another Broadcom device
Message-ID: <20080307201034.GA671@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	marcel@holtmann.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds another Broadcom BCM2045 based device to the
blacklist, with these settings the micro dongle works on my system.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/bluetooth/hci_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 372c7ef..f16c94c 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -116,6 +116,7 @@ static struct usb_device_id blacklist_ids[] = {
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
 
 	/* Broadcom BCM2045 */
+	{ USB_DEVICE(0x0a5c, 0x2039), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2101), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 
 	/* IBM/Lenovo ThinkPad with Broadcom chip */

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
