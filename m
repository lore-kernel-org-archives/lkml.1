Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXEPUuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXEPUuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbXEPUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:49:58 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:45103 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbXEPUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:49:57 -0400
Subject: [PATCH] Remove duplicate IDs from option card driver
From: Ben Collins <ben.collins@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-usb-devel@lists.sourceforge.net,
       Matthias Urlichs <smurf@smurf.noris.de>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 16 May 2007 16:49:54 -0400
Message-Id: <1179348594.6510.13.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-usb-devel@lists.sourceforge.net
Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 8c3f55b..89f067d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -165,7 +165,6 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1410) }, /* Novatel U740 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1420) }, /* Novatel EU870 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1430) }, /* Novatel Merlin XU870 HSDPA/3G */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x1430) }, /* Novatel XU870 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2100) }, /* Novatel EV620 CDMA/EV-DO */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2110) }, /* Novatel Merlin ES620 / Merlin ES720 / Ovation U720 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, 0x2130) }, /* Novatel Merlin ES620 SM Bus */


-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

