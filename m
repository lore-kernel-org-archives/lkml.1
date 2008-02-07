Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYBGSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYBGSWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYBGSWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:22:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144AbYBGSWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:22:08 -0500
Subject: patch usb-ftdi_sio.c-add-missing.patch added to gregkh-2.6 tree
To: 12o3l@tiscali.nl, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 07 Feb 2008 10:19:52 -0800
In-Reply-To: <47AA4B6F.20902@tiscali.nl>
Message-ID: <12024083921590@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: ftdi_sio.c add missing '|'

to my gregkh-2.6 tree.  Its filename is

     usb-ftdi_sio.c-add-missing.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From 12o3l@tiscali.nl  Thu Feb  7 10:05:29 2008
From: Roel Kluin <12o3l@tiscali.nl>
Date: Thu, 07 Feb 2008 01:06:07 +0100
Subject: USB: ftdi_sio.c add missing '|'
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, ftdi-usb-sio-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Message-ID: <47AA4B6F.20902@tiscali.nl>


add missing '|'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -394,7 +394,7 @@ static const char *ftdi_chip_name[] = {
 /* End TIOCMIWAIT */
 
 #define FTDI_IMPL_ASYNC_FLAGS = ( ASYNC_SPD_HI | ASYNC_SPD_VHI \
- ASYNC_SPD_CUST | ASYNC_SPD_SHI | ASYNC_SPD_WARP )
+ | ASYNC_SPD_CUST | ASYNC_SPD_SHI | ASYNC_SPD_WARP )
 
 /* function prototypes for a FTDI serial converter */
 static int  ftdi_sio_probe	(struct usb_serial *serial, const struct usb_device_id *id);


Patches currently in gregkh-2.6 which might be from 12o3l@tiscali.nl are

usb/usb-ftdi_sio.c-add-missing.patch
