Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0BCFWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:22:46 -0500
Received: from web82001.mail.mud.yahoo.com ([66.163.178.245]:44208 "HELO
	web82001.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751060Ab0BCFWp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:22:45 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2010 00:22:44 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MYTK2NthQnttxj4pFROOp3VihD6a+xznwRW0M5hM77hAl7EmbbbrHFQH28kGHnRCU6W1VRGMQgh4MQCHK98A40nQN7HC/8OZSyM8X8gc4CTMnle/mOb1hG8d1vf4mhc7iAK7OJPBDqMxKRfhxPBDLo4SNpB106dgVl3imFKU2Ak=;
Message-ID: <341299.48295.qm@web82001.mail.mud.yahoo.com>
X-YMail-OSG: rDIXDdgVM1kNio_s16bydf8kFWzhYtwDEwQ0SzZJsVHcS5Ys1SkmNtDZbMttpDs7weDHwxZr34WJBDpqb5K0TppYkO3cAsS82tkukB0AhX3wqczcbFVPA6Zcpb0yRTNHWgo9H5ssKZoCho7.w154Qesm1ojJgz_ZtTpj2vsvBm3znqL6CuSnz7m_YzECOGXPs0txyRCQveybvcXtGyDX8.4zeUov4L5rWb2ggairrLCMJvFEaUR3prj1y4nsknA3KFVuh3jfdMC7pf2W7a_mf8F_wLt3vncraT.CBkSIHmOcZx_oiS7qdUUs8PqOnSw_ilgjbSSMh5APTKHlPEnbwJYu_Qu0ksRVKIcCLJASAISb399IpXaVRqvKP2kyuS6vx4DRnO9WGpGkTr7Ut_pVucMhR7xLz47YANz.vZyI4vJRCFcx0jJEwn55JHUvgRcJoRY.SquiRisKDRVst5Y3nvWy9u4eQZJ7bhaYViSnznT5vVDLyig241P8J3jv0l0827dR84sFsbkCjRIpJBDFjUvdLd68PcChdozzM6kjscNXEBUGiqswR2V0C1sc0uCuQe75G08-
X-Mailer: YahooMailRC/272.7 YahooMailWebService/0.8.100.260964
Date: Tue, 2 Feb 2010 21:16:03 -0800 (PST)
From: Alex Neblett <alexneblett01@yahoo.com>
Subject: [PATCH] Support Pixart Imaging Inc. Optical Touch Screen in Quanta TouchScreen driver
To: Jerome Vidal <jerom3@free.fr>, Cedric Berthier <berthiec@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>,
       =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added support for the Pixart Imaging Inc. Optical Touch Screen found
in the MSI AE2220 and other new all in one computers to the Quanta
Optical Touch dual-touch panel driver found in the latest
git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git.

Signed-off-by: Alex Neblett <alexneblett01@yahoo.com>


diff -uNr linux-next/drivers/hid/.directory linux-next-multitouch/drivers/hid/.directory
--- linux-next/drivers/hid/.directory    1969-12-31 18:00:00.000000000 -0600
+++ linux-next-multitouch/drivers/hid/.directory    2010-02-02 22:47:41.875840766 -0600
@@ -0,0 +1,3 @@
+[Dolphin]
+Timestamp=2010,2,2,22,47,41
+ViewMode=1
diff -uNr linux-next/drivers/hid/hid-core.c linux-next-multitouch/drivers/hid/hid-core.c
--- linux-next/drivers/hid/hid-core.c    2010-02-02 22:33:15.479259757 -0600
+++ linux-next-multitouch/drivers/hid/hid-core.c    2010-02-02 22:44:33.125442262 -0600
@@ -1343,6 +1343,7 @@
     { HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
     { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
     { HID_USB_DEVICE(USB_VENDOR_IDhttp://us.mg201.mail.yahoo.com/dc/launch?dgfs=1_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
     { HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
     { HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
     { HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
diff -uNr linux-next/drivers/hid/hid-ids.h linux-next-multitouch/drivers/hid/hid-ids.h
--- linux-next/drivers/hid/hid-ids.h    2010-02-02 22:33:15.479259757 -0600
+++ linux-next-multitouch/drivers/hid/hid-ids.h    2010-02-02 22:45:08.318770969 -0600
@@ -394,6 +394,7 @@
 
 #define USB_VENDOR_ID_QUANTA        0x0408
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH    0x3000
+#define USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN    0x3001
 
 #define USB_VENDOR_ID_SAMSUNG        0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE    0x0001
diff -uNr linux-next/drivers/hid/hid-quanta.c linux-next-multitouch/drivers/hid/hid-quanta.c
--- linux-next/drivers/hid/hid-quanta.c    2010-02-02 22:33:15.482592844 -0600
+++ linux-next-multitouch/drivers/hid/hid-quanta.c    2010-02-02 22:45:42.482100482 -0600
@@ -224,6 +224,8 @@
 static const struct hid_device_id quanta_devices[] = {
     { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
             USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
+    { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
+            USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
     { }
 };
 MODULE_DEVICE_TABLE(hid, quanta_devices);
