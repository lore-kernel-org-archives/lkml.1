Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbXG2PJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbXG2PJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764754AbXG2O73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47855 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764753AbXG2O7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:25 -0400
Date: Sun, 29 Jul 2007 16:59:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Kevin Lloyd <linux@sierrawireless.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/usb/serial/sierra.c: make 3 functions static
Message-ID: <20070729145902.GD16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/usb/serial/sierra.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1/drivers/usb/serial/sierra.c.old	2007-07-26 21:52:27.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/usb/serial/sierra.c	2007-07-26 21:53:20.000000000 +0200
@@ -45,7 +45,7 @@
 	DEVICE_INSTALLER =	2,
 };
 
-int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
+static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "SET POWER STATE");
@@ -60,7 +60,7 @@
 	return result;
 }
 
-int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
+static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
 {
 	int result;
 	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH");
@@ -75,7 +75,8 @@
 	return result;
 }
 
-int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+static int sierra_probe(struct usb_interface *iface,
+			const struct usb_device_id *id)
 {
 	int result;
 	struct usb_device *udev;

