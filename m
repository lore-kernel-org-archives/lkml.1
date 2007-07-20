Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbXGTDWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbXGTDWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXGTDWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:22:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54999 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbXGTDWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:22:08 -0400
Date: Fri, 20 Jul 2007 13:22:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: [PATCH] dpt_i2o depends on virt_to_bus
Message-Id: <20070720132213.bf509831.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3727231..a947257 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -483,7 +483,7 @@ source "drivers/scsi/aic94xx/Kconfig"
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on !64BIT && SCSI && PCI
+	depends on !64BIT && SCSI && PCI && VIRT_TO_BUS
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
-- 
1.5.2.3

