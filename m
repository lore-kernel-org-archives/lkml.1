Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbZEZWvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbZEZWvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760137AbZEZWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:34 -0400
Received: from mga10.intel.com ([192.55.52.92]:13974 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760227AbZEZWtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="460626026"
Message-Id: <20090526225140.732164177@linux.intel.com>
References: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/7 v2] dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
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
Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>
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
