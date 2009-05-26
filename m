Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZEZRkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZEZRkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZEZRkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:40:08 -0400
Received: from mga05.intel.com ([192.55.52.89]:11890 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756959AbZEZRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:40:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="460538172"
Message-Id: <20090526174213.806710164@linux.intel.com>
References: <20090526174012.423883376@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 May 2009 19:40:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/6] dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
Content-Disposition: inline; filename=firmware-dvb-usb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch changes the dvb_usb_device_properties firmware field accordingly.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

---
 drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h
===================================================================
--- iwm-2.6.orig/drivers/media/dvb/dvb-usb/dvb-usb.h	2009-05-26 17:24:36.000000000 +0200
+++ iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h	2009-05-26 17:25:19.000000000 +0200
@@ -196,7 +196,7 @@ struct dvb_usb_device_properties {
 #define CYPRESS_FX2     3
 	int        usb_ctrl;
 	int        (*download_firmware) (struct usb_device *, const struct firmware *);
-	const char firmware[FIRMWARE_NAME_MAX];
+	const char *firmware;
 	int        no_reconnect;
 
 	int size_of_priv;

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
