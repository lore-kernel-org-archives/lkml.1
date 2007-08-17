Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbXHQUvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbXHQUvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXHQUvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:51:33 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:51115 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755620AbXHQUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:51:33 -0400
Date: Fri, 17 Aug 2007 16:51:15 -0400
From: Joe Korty <joe.korty@ccur.com>
To: akpm@osdl.org
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix section mismatch in the Adaptec DPT SCSI Raid driver
Message-ID: <20070817205115.GA12416@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section mismatch in the Adaptec DPT SCSI Raid driver.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c
===================================================================
--- 2.6.23-rc3-git1.orig/drivers/scsi/dpt_i2o.c	2007-08-17 16:36:05.000000000 -0400
+++ 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c	2007-08-17 16:50:13.000000000 -0400
@@ -3351,7 +3351,7 @@
 	return count > 0 ? 0 : -ENODEV;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_exit(void)
 {
 	while (hba_chain)
 		adpt_release(hba_chain);

