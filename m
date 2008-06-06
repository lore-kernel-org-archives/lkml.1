Return-Path: <linux-kernel-owner+w=401wt.eu-S1765330AbYFFP7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765330AbYFFP7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761227AbYFFPzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:36 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51798 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757616AbYFFPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:28 -0400
Message-Id: <20080606155527.039450358@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:30 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 13/15] MMC: s3cmci: Add MODULE_ALIAS() entries for the platform devices
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-modalias.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MODULE_ALIAS() declerations for all the supported platform
devices for this driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:30.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:32.000000000 +0100
@@ -1402,4 +1402,6 @@ module_exit(s3cmci_exit);
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>");
-
+MODULE_ALIAS("platform:s3c2410-sdi");
+MODULE_ALIAS("platform:s3c2412-sdi");
+MODULE_ALIAS("platform:s3c2440-sdi");

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
