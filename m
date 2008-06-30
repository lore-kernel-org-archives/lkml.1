Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbYF3Vs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbYF3Vs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933293AbYF3VlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:23 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50429 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933278AbYF3VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:12 -0400
Message-Id: <20080630214110.950340268@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:34 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 11/16] MMC: S3C24XX: Add MODULE_ALIAS() entries for the platform devices
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-modalias.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MODULE_ALIAS() declerations for all the supported platform
devices for this driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:53.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:55.000000000 +0100
@@ -1405,3 +1405,6 @@ module_exit(s3cmci_exit);
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>");
+MODULE_ALIAS("platform:s3c2410-sdi");
+MODULE_ALIAS("platform:s3c2412-sdi");
+MODULE_ALIAS("platform:s3c2440-sdi");

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
