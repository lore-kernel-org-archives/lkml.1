Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0BOWcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:32:51 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41272 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab0BOWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=n4LTy7IUAX4OIeqHBQiANzW+eOuDNcIGknEcfoMKKhEFDHAHvacwZpWzIlIFjgUfv0
         J+Twj6zWh0zCjF/gotyUB6j1vsOPja2ShxMOBH/GfslcHrSl68u4Rtfww0ddDHiEbiOv
         ndfl3B2xsrRCus7t7C/n0B+C3GUlZdtyEspOc=
Message-ID: <4B79CD49.8070607@gmail.com>
Date: Mon, 15 Feb 2010 23:40:09 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: misplaced parenthesis
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parenthesis was misplaced

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this maybe, as the comment states, why blanking a cdrw at speed 4
was unreliable?

diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index b62a288..b958db5 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1645,8 +1645,8 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	if ((result = usbat_write_block(us,
 			USBAT_ATA, srb->cmnd, 12,
-				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), 0) !=
-			     USB_STOR_TRANSPORT_GOOD)) {
+				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), 0)) !=
+			     USB_STOR_TRANSPORT_GOOD) {
 		return result;
 	}
 
