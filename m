Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbXEPUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbXEPUyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbXEPUyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:54:06 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:46117 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979AbXEPUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:54:05 -0400
Subject: [PATCH] Remove duplicate ID in ipaq driver
From: Ben Collins <ben.collins@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>,
       Ganesh Varadarajan <ganesh@veritas.com>,
       linux-usb-devel@lists.sourceforge.net
Content-Type: text/plain
Organization: Canonical
Date: Wed, 16 May 2007 16:54:00 -0400
Message-Id: <1179348840.6510.16.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Ganesh Varadarajan <ganesh@veritas.com>
Cc: linux-usb-devel@lists.sourceforge.net
Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index 4df0ec7..7c85be4 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -92,7 +92,6 @@ static void ipaq_destroy_lists(struct usb_serial_port *port);
 
 static struct usb_device_id ipaq_id_table [] = {
 	/* The first entry is a placeholder for the insmod-specified device */
-	{ USB_DEVICE(0x049F, 0x0003) },
 	{ USB_DEVICE(0x0104, 0x00BE) }, /* Socket USB Sync */
 	{ USB_DEVICE(0x03F0, 0x1016) }, /* HP USB Sync */
 	{ USB_DEVICE(0x03F0, 0x1116) }, /* HP USB Sync 1611 */

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

