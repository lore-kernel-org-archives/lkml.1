Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYFZQO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYFZQO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYFZQOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:14:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46669 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYFZQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:14:06 -0400
Subject: [PATCH] ipaq: Remove duplicate device entry
From: Ben Collins <ben.collins@canonical.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 11:59:17 -0400
Message-Id: <1214495957.7150.12.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index ea924dc..abe3b6c 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -546,7 +546,6 @@ static struct usb_device_id ipaq_id_table [] = {
 	{ USB_DEVICE(0x413C, 0x4009) }, /* Dell Axim USB Sync */
 	{ USB_DEVICE(0x4505, 0x0010) }, /* Smartphone */
 	{ USB_DEVICE(0x5E04, 0xCE00) }, /* SAGEM Wireless Assistant */
-	{ USB_DEVICE(0x0BB4, 0x00CF) }, /* HTC smartphone modems */
 	{ }                             /* Terminating entry */
 };
 


