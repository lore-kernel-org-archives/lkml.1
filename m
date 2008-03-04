Return-Path: <linux-kernel-owner+w=401wt.eu-S1763758AbYCDVhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763758AbYCDVhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYCDVho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:37:44 -0500
Received: from vs147137.vserver.de ([62.75.147.137]:56468 "EHLO
	vs147137.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYCDVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:37:43 -0500
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 16:37:43 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=cryonet.de; h=message-id:date:
	from:reply-to:mime-version:to:cc:subject:content-type:
	content-transfer-encoding; q=dns; s=cryonet; b=we6JmvGJlFEMYXaNo
	Bl9bd4/bxPpN8ur05WXOxvtTj/iDzw6jcBenD4Mh5VGlqOluV20VH4WaOYpnKVwt
	R867AJpq5l04FHOD4zsL73QTBxYK15+9FuwfOsV/hOesUbSNPo3+cgk3via7Tlo9
	wKz0/MvtEJQA8/Dppv1I7vMafw=
Message-ID: <47CDBA77.2010707@cryonet.de>
Date: Tue, 04 Mar 2008 22:09:11 +0100
From: Sven Andersen <s.andersen@cryonet.de>
Reply-To: s.andersen@cryonet.de
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-usb-users@lists.sourceforge.net, stable@kernel.org
Subject: [PATCH] USB: ftdi_sio - really enable EM1010PC
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EM1010PC to ftdi_sio.c

Signed-off-by: Sven Andersen <s.andersen@cryonet.de>
---

Peter Stark submitted a patch for enabling multiple ELV-devices
and adding the EM1010PC to ftdi_sio which has already been applied.
For some reason this line got lost somewhere.

As Peters patch went into 2.6.24-stable this might be applicable
there too.

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 76db2fe..90a398b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -274,6 +274,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FS20SIG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS300PC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_EM1010PC_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_SDMUSBQSS_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_MASTERDEVEL2_PID) },

