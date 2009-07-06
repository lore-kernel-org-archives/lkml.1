Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZGFLUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZGFLUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZGFLT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:19:59 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50439 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZGFLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:19:58 -0400
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: dpotts@arkhamtechnology.com, craig@microtron.org.uk, gregkh@suse.de
Subject: [PATCH] USB: Serial: Add support for Arkham Technology adapters
Date: Mon,  6 Jul 2009 14:19:59 +0300
Message-Id: <1246879199-12304-1-git-send-email-amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by David Potts from Arkham Technology, the current driver
works with their hardware on addition of the device ids.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 2b9eeda..e9a40b8 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -67,6 +67,8 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
 	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */
 	{ USB_DEVICE(0x10C4, 0x0F91) }, /* Vstabi */
+	{ USB_DEVICE(0x10C4, 0x1101) }, /* Arkham Technology DS101 Bus Monitor */
+	{ USB_DEVICE(0x10C4, 0x1601) }, /* Arkham Technology DS101 Adapter */
 	{ USB_DEVICE(0x10C4, 0x800A) }, /* SPORTident BSM7-D-USB main station */
 	{ USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
 	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
-- 
1.6.3.3

