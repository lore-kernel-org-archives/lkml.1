Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYFZP53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYFZP53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYFZP5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:57:21 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55119 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYFZP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:57:20 -0400
Subject: [PATCH] Comment out duplicate device entry
From: Ben Collins <ben.collins@canonical.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 11:57:18 -0400
Message-Id: <1214495838.7150.10.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Left it commented instead of removing since it referenced a different
model name. Just avoid it getting back in by mistake, and to document
that it is supported.

Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 1610a73..f0369d0 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -60,7 +60,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0baf, 0x0118)},   /* U.S. Robotics U5 802.11g Adapter*/
 	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
-	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
+// DUPE	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */


