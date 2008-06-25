Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYFYQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYFYQ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYFYQ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:05 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59374 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYFYQ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:04 -0400
Date: Wed, 25 Jun 2008 19:24:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] remove the unused SCSI_QLOGIC_FC_FIRMWARE option
Message-ID: <20080625162458.GC10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option was forgotten when the SCSI_QLOGIC_FC driver was removed.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
92547181b79610ddd207a9cdbea35653a1d63b8a diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 81ccbd7..a72993c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1305,14 +1305,6 @@ config SCSI_QLOGIC_FAS
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicfas.
 
-config SCSI_QLOGIC_FC_FIRMWARE
-	bool "Include loadable firmware in driver"
-	depends on SCSI_QLOGIC_FC
-  	help
-	  Say Y to include ISP2X00 Fabric Initiator/Target Firmware, with
-	  expanded LUN addressing and FcTape (FCP-2) support, in the
-	  qlogicfc driver. This is required on some platforms.
-
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
 	depends on PCI && SCSI

