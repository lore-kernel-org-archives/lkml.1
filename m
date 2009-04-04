Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZDDQYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZDDQYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZDDQYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:24:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53301 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZDDQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:24:29 -0400
Date: Sat, 4 Apr 2009 17:24:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, shurik@gwu.edu
Subject: [PATCH] qcserial: Add extra device IDs
Message-ID: <20090404162424.GA5799@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> <20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> <20090403151237.GA25994@suse.de> <20090403164551.GA23689@srcf.ucam.org> <20090404152731.GA5080@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090404152731.GA5080@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a set of device IDs from the Windows drivers. These aren't complete 
(there's a couple of cases where a QDL device is identified without the 
associated modem being identified), but it's better than the current 
situation.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index e6d6b0c..7528b8d 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -26,6 +26,27 @@ static struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
+	{USB_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
+	{USB_DEVICE(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
+	{USB_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */
+	{USB_DEVICE(0x413c, 0x8171)},	/* Dell Gobi QDL device */
+	{USB_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
+	{USB_DEVICE(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
+	{USB_DEVICE(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
+	{USB_DEVICE(0x0b05, 0x1774)},	/* Asus Gobi QDL device */
+	{USB_DEVICE(0x19d2, 0xfff3)},	/* ONDA Gobi Modem device */
+	{USB_DEVICE(0x19d2, 0xfff2)},	/* ONDA Gobi QDL device */
+	{USB_DEVICE(0x1557, 0x0a80)},	/* OQO Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9001)},   /* Generic Gobi Modem device */
+	{USB_DEVICE(0x05c6, 0x9002)},	/* Generic Gobi Modem device */
+	{USB_DEVICE(0x05c6, 0x9202)},	/* Generic Gobi Modem device */
+	{USB_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
+	{USB_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
+	{USB_DEVICE(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
+	{USB_DEVICE(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
