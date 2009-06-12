Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZFLG6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZFLG6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZFLG6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:58:15 -0400
Received: from s15277822.onlinehome-server.info ([87.106.189.147]:38036 "EHLO
	s15277822.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbZFLG6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:58:14 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 02:58:14 EDT
Message-ID: <4A31FAF9.7000500@kuix.de>
Date: Fri, 12 Jun 2009 08:51:37 +0200
From: Kai Engert <kaie@kuix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090609 Lightning/1.0pre Shredder/3.0b3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.30] USB: option.c: add Qualcomm/Option iCON 210 modem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add modem portion of USB device labeled:
Model iCON 210, Qualcomm 3G HSDPA, designed in EU by Option

Signed-off-by: Kai Engert <kaie@kuix.de>
---

Device starts in usb-storage mode (1e0e:f000) and requires the use of a tool like usb_modeswitch to switch it to modem mode (1e0e:9000).
I'm not subscribed to the mailing list, please cc me on replies, thanks.
Regards, Kai

--- linux-2.6.30/drivers/usb/serial/option.c.preicon210	2009-06-12 08:11:37.000000000 +0200
+++ linux-2.6.30/drivers/usb/serial/option.c	2009-06-12 08:11:39.000000000 +0200
@@ -93,6 +93,9 @@
  #define OPTION_PRODUCT_ETNA_KOI_MODEM		0x7100
  #define OPTION_PRODUCT_GTM380_MODEM		0x7201

+#define QUALCOMM_OPTION_VENDOR_ID		0x1e0e
+#define QUALCOMM_OPTION_PRODUCT_ICON_210	0x9000
+
  #define HUAWEI_VENDOR_ID			0x12D1
  #define HUAWEI_PRODUCT_E600			0x1001
  #define HUAWEI_PRODUCT_E220			0x1003
@@ -330,6 +333,7 @@
  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_MODEM_EX) },
  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_ETNA_KOI_MODEM) },
  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTM380_MODEM) },
+	{ USB_DEVICE(QUALCOMM_OPTION_VENDOR_ID, QUALCOMM_OPTION_PRODUCT_ICON_210) },
  	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_Q101) },
  	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_Q111) },
  	{ USB_DEVICE(QUANTA_VENDOR_ID, QUANTA_PRODUCT_GLX) },
