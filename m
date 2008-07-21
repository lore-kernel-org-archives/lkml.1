Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYGUE02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYGUE02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYGUE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:26:20 -0400
Received: from www.swissdisk.com ([216.66.254.197]:48631 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYGUE0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:26:19 -0400
X-Greylist: delayed 1905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 00:26:19 EDT
From: Ben Collins <ben.collins@canonical.com>
Date: Sun, 20 Jul 2008 21:54:48 -0400
Subject: [PATCH 5/7] [airprime] Add support for more devices
To: linux-kernel@vger.kernel.org
In-Reply-To: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Message-Id: <E1KKl4J-00068N-2b@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference: https://launchpad.net/bugs/208250

Add support for:
- Audiovox PC5740
- Huawei E220
- Momo design
- AirPrime 5220
- Dell Wireless HSDPA 5500
- Sprint Pantech PX-500
- Novatel U727
- Onda MT505UP

CC: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
---
 drivers/usb/serial/airprime.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/airprime.c b/drivers/usb/serial/airprime.c
index 0798c14..164191b 100644
--- a/drivers/usb/serial/airprime.c
+++ b/drivers/usb/serial/airprime.c
@@ -18,6 +18,15 @@
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0c88, 0x17da) }, /* Kyocera Wireless KPC650/Passport */
+	{ USB_DEVICE(0x413c, 0x8115) }, /* Dell Wireless HSDPA 5500 */
+	{ USB_DEVICE(0x0930, 0x1303) }, /* Toshiba (Novatel Wireless) HSDPA for M400 */
+	{ USB_DEVICE(0x106c, 0x3701) }, /* Audiovox PC5740 */
+	{ USB_DEVICE(0x106c, 0x3702) }, /* Sprint Pantech PX-500 DGE */
+	{ USB_DEVICE(0x1410, 0x4100) }, /* Novatel Wireless U727 */
+	{ USB_DEVICE(0x12d1, 0x1003) }, /* Huawei E220 */
+	{ USB_DEVICE(0x05c6, 0x6000) }, /* Momo design */
+	{ USB_DEVICE(0xf3d0, 0x0112) }, /* AirPrime 5220 */
+	{ USB_DEVICE(0X19d2, 0x0002) }, /* Onda MT505UP GPRS-EDGE-HSPDA-hsups */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
1.5.4.3

