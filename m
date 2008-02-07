Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbYBGAhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbYBGAhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYBGAGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:06:15 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:56168 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763957AbYBGAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:06:13 -0500
Message-ID: <47AA4B6F.20902@tiscali.nl>
Date: Thu, 07 Feb 2008 01:06:07 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, ftdi-usb-sio-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/usb/serial/ftdi_sio.c] add missing '|'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add missing '|'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 90dcc62..2173561 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -394,7 +394,7 @@ static const char *ftdi_chip_name[] = {
 /* End TIOCMIWAIT */
 
 #define FTDI_IMPL_ASYNC_FLAGS = ( ASYNC_SPD_HI | ASYNC_SPD_VHI \
- ASYNC_SPD_CUST | ASYNC_SPD_SHI | ASYNC_SPD_WARP )
+ | ASYNC_SPD_CUST | ASYNC_SPD_SHI | ASYNC_SPD_WARP )
 
 /* function prototypes for a FTDI serial converter */
 static int  ftdi_sio_probe	(struct usb_serial *serial, const struct usb_device_id *id);

