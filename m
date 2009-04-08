Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZDHL3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZDHL3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762977AbZDHLW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:59 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39458 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762713AbZDHLWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:52 -0400
X-Sasl-enc: W8arzy7ZxfotGnZf7CMODC+JAfb3nob+BL6aXPxCaAH/ 1239189770
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 15/56] ide: Remove void casts
Date: Wed,  8 Apr 2009 12:21:47 +0100
Message-Id: <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/ide/pmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 052b9bf..f76e4e6 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1682,7 +1682,7 @@ static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
 	 * The +2 is +1 for the stop command and +1 to allow for
 	 * aligning the start address to a multiple of 16 bytes.
 	 */
-	pmif->dma_table_cpu = (struct dbdma_cmd*)pci_alloc_consistent(
+	pmif->dma_table_cpu = pci_alloc_consistent(
 		dev,
 		(MAX_DCMDS + 2) * sizeof(struct dbdma_cmd),
 		&hwif->dmatable_dma);
-- 
1.5.4.3

