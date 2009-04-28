Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbZD1L6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbZD1L6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZD1L6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:58:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36772 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZD1L6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:58:03 -0400
From: amit.kucheria@verdurent.com
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: marcel@holtmann.org, Amit Kucheria <amit.kucheria@canonical.com>
Subject: [PATCH] Quirk for BT USB device on MacbookPro to be reset before use
Date: Tue, 28 Apr 2009 14:57:56 +0300
Message-Id: <1240919876-6204-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@canonical.com>

Reset the Bluetooth device on Macbook Pro 5.1 inorder to be able to use it

Bug: #332443
BugLink: https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/332443

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 drivers/bluetooth/btusb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 7a29a2b..c017cc5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -109,6 +109,9 @@ static struct usb_device_id blacklist_table[] = {
 	/* Apple MacBook Pro with Broadcom chip */
 	{ USB_DEVICE(0x05ac, 0x820f), .driver_info = BTUSB_RESET },
 
+	/* Apple MacBook Pro 5,1 */
+	{ USB_DEVICE(0x05ac, 0x8213), .driver_info = BTUSB_RESET },
+
 	/* IBM/Lenovo ThinkPad with Broadcom chip */
 	{ USB_DEVICE(0x0a5c, 0x201e), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2110), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
-- 
1.6.0.4

