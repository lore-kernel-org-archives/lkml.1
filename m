Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYDUIyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYDUIyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbYDUIwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:52:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36269 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758357AbYDUIv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:51:59 -0400
Date: Mon, 21 Apr 2008 11:51:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove ata_cable_sata()
Message-ID: <20080421085131.GE26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used ata_cable_sata()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |   13 -------------
 include/linux/libata.h    |    1 -
 2 files changed, 14 deletions(-)

7da50f40b2e2a1db9e8d506e65082e90a6eb4ae5 diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a84df42..0f8807f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2432,18 +2432,6 @@ int ata_cable_ignore(struct ata_port *ap)
 }
 
 /**
- *	ata_cable_sata	-	return SATA cable type
- *	@ap: port
- *
- *	Helper method for drivers which have SATA cables
- */
-
-int ata_cable_sata(struct ata_port *ap)
-{
-	return ATA_CBL_SATA;
-}
-
-/**
  *	ata_bus_probe - Reset and probe ATA bus
  *	@ap: Bus to probe
  *
@@ -6295,4 +6283,3 @@ EXPORT_SYMBOL_GPL(ata_cable_40wire);
 EXPORT_SYMBOL_GPL(ata_cable_80wire);
 EXPORT_SYMBOL_GPL(ata_cable_unknown);
 EXPORT_SYMBOL_GPL(ata_cable_ignore);
-EXPORT_SYMBOL_GPL(ata_cable_sata);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 9836213..84618df 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -943,7 +943,6 @@ extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_d
 
 extern int ata_cable_40wire(struct ata_port *ap);
 extern int ata_cable_80wire(struct ata_port *ap);
-extern int ata_cable_sata(struct ata_port *ap);
 extern int ata_cable_ignore(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
 

