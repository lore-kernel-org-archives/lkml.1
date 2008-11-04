Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYKDQZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYKDQZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYKDQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:24:57 -0500
Received: from mail.tpi.com ([198.107.51.143]:4340 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbYKDQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:24:55 -0500
To: marcel@holtmann.org
Subject: Dell Wireless 365 requires reset quirk
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20081104162448.A338EF8A65@sepang.rtg.net>
Date: Tue,  4 Nov 2008 09:24:48 -0700 (MST)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 931ccb629d739aa563347a4e866bc26107e6b545 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 4 Nov 2008 09:18:06 -0700
Subject: [PATCH] Dell Wireless 365 needs BTUSB_RESET quirk.
 OriginalAuthor: Mario Limonciello <mario_limonciello@dell.com>

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 drivers/bluetooth/btusb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index af472e0..051b758 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -125,6 +125,9 @@ static struct usb_device_id blacklist_table[] = {
 	/* Dell laptop with Broadcom chip */
 	{ USB_DEVICE(0x413c, 0x8126), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
 
+	/* Dell Wireless 365 */
+	{ USB_DEVICE(0x413c, 0x8160), .driver_info = BTUSB_RESET },
+
 	/* Dell Wireless 370 */
 	{ USB_DEVICE(0x413c, 0x8156), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
 
-- 
1.5.6.3

