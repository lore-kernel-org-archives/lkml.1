Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYDUIxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYDUIxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbYDUIvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:51:47 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41199 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078AbYDUIvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:51:46 -0400
Date: Mon, 21 Apr 2008 11:51:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make sata_set_spd_needed() static
Message-ID: <20080421085117.GC26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sata_set_spd_needed() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |    2 +-
 drivers/ata/libata.h      |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

bb4bcf58edb56a5fc9d7401046adcafcffff46a6 diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4b918d7..8c2bb65 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2761,7 +2761,7 @@ static int __sata_set_spd_needed(struct ata_link *link, u32 *scontrol)
  *	RETURNS:
  *	1 if SATA spd configuration is needed, 0 otherwise.
  */
-int sata_set_spd_needed(struct ata_link *link)
+static int sata_set_spd_needed(struct ata_link *link)
 {
 	u32 scontrol;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 4aeeabb..ae2cfd9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -101,7 +101,6 @@ extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 			      unsigned int readid_flags);
 extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link);
-extern int sata_set_spd_needed(struct ata_link *link);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);

