Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZBIThB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZBIThB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZBITf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:35:59 -0500
Received: from kroah.org ([198.145.64.141]:34763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754000AbZBITfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:35:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jamie Lentin <jm@lentin.co.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] Staging: at76_usb: Add support for OQO Model 01+
Date: Mon,  9 Feb 2009 11:34:03 -0800
Message-Id: <1234208046-2295-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <20090209193201.GB2194@kroah.com>
References: <20090209193201.GB2194@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Lentin <jm@lentin.co.uk>

Add USB device ID for OQO 01+'s internal wireless LAN

An OQO employee mentions the chip's true identity here:-
   ftp://ftp.oqo.com/unsupported/linux/OQOLinux.html

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/at76_usb/at76_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 06ae163..c8e4d31 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -231,6 +231,8 @@ static struct usb_device_id dev_table[] = {
 	{USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A)},
 	/* Siemens Gigaset USB WLAN Adapter 11 */
 	{USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A)},
+	/* OQO Model 01+ Internal Wi-Fi */
+	{USB_DEVICE(0x1557, 0x0002), USB_DEVICE_DATA(BOARD_505A)},
 	/*
 	 * at76c505amx-rfmd
 	 */
-- 
1.6.0.2

