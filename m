Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZAZQGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZAZQGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZAZQFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:05:54 -0500
Received: from smtp2.u-psud.fr ([129.175.33.42]:60200 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZAZQFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:05:53 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 11:05:53 EST
From: =?utf-8?q?St=C3=A9phane_Cl=C3=A9rambault?= 
	<stephane.clerambault@free.fr>
To: linux-kernel@vger.kernel.org
Subject: ftdi support
Date: Mon, 26 Jan 2009 16:58:19 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_b2dfJg2tzzmn1SG"
Message-Id: <200901261658.19582.stephane.clerambault@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_b2dfJg2tzzmn1SG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Here is a patch to add support for the NDI Polaris system=20
(http://www.ndigital.com/)

Thanks,
=2D-=20
St=C3=A9phane Cl=C3=A9rambault

--Boundary-00=_b2dfJg2tzzmn1SG
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="ftdi_sio.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ftdi_sio.diff"

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c70a8f6..e879ce7 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -660,6 +660,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NDI_HUC_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 373ee09..b1f6d75 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -844,6 +844,9 @@
 #define TML_VID			0x1B91	/* Vendor ID */
 #define TML_USB_SERIAL_PID	0x0064	/* USB - Serial Converter */
 
+/* NDI Polaris System */
+#define FTDI_NDI_HUC_PID        0xDA70
+
 /* Propox devices */
 #define FTDI_PROPOX_JTAGCABLEII_PID	0xD738
 

--Boundary-00=_b2dfJg2tzzmn1SG--
