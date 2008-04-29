Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbYD2UQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbYD2UQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYD2UQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:16:42 -0400
Received: from mail.tpi.com ([198.107.51.143]:1411 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYD2UQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:16:41 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 16:16:41 EDT
To: klloyd@sierrawireless.com
Subject: [PATCH] USB: sierra: add support for Onda H600/Zte MF330
Cc: linux-kernel@vger.kernel.org, tim.gardner@canonical.com
Message-Id: <20080429194710.174E2BB413C@sepang.rtg.net>
Date: Tue, 29 Apr 2008 13:47:10 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruno Redondi <bruno.redondi@altarisoluzione.com>
Date: Fri, 1 Feb 2008 15:16:52 -0800
Subject: [PATCH] USB: sierra: add support for Onda H600/Zte MF330 datacard to USB Driver for
 Sierra Wireless

Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard

Signed-off-by: Bruno Redondi <bruno.redondi@altarisoluzione.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Amit Kucheria <amit.kucheria@ubuntu.com>
Cc: stable@kernel.org
---
 drivers/usb/serial/sierra.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index ed67881..da5a519 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -179,6 +179,7 @@ static struct usb_device_id id_table [] = {
 
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
+	{ USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
 
 	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
 	{ }
-- 
1.5.4.3

