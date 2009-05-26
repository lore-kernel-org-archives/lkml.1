Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZEZWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZEZWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760195AbZEZWtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:25 -0400
Received: from mga07.intel.com ([143.182.124.22]:40998 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760189AbZEZWtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="147191876"
Message-Id: <20090526225134.148561079@linux.intel.com>
References: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michel Ludwig <michel.ludwig@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/7 v2] tuners/xc2028: prepare for FIRMWARE_NAME_MAX removal
Content-Disposition: inline; filename=firmware-xc202.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>
To: Michel Ludwig <michel.ludwig@gmail.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch gets rid of the xc2028 FIRMWARE_NAME_MAX reference.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/common/tuners/tuner-xc2028.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: iwm-2.6/drivers/media/common/tuners/tuner-xc2028.c
===================================================================
--- iwm-2.6.orig/drivers/media/common/tuners/tuner-xc2028.c	2009-05-26 17:15:54.000000000 +0200
+++ iwm-2.6/drivers/media/common/tuners/tuner-xc2028.c	2009-05-26 17:19:01.000000000 +0200
@@ -48,7 +48,7 @@ MODULE_PARM_DESC(audio_std,
 	"NICAM/A\n"
 	"NICAM/B\n");
 
-static char firmware_name[FIRMWARE_NAME_MAX];
+static char firmware_name[30];
 module_param_string(firmware_name, firmware_name, sizeof(firmware_name), 0);
 MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
 				"default firmware name\n");

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
