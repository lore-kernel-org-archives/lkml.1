Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbXGaS0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbXGaS0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbXGaS0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:26:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1692 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbXGaS0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:26:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 45] drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 20:26:43 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       james.smart@emulex.com, linux-scsi@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312026.43947.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_init.c | 65932 -> 65881 (-51 bytes)
 drivers/scsi/lpfc/lpfc_init.o | 219760 -> 219616 (-144 bytes)

 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_init.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_init.c	2007-07-31 11:07:59.000000000 +0200
@@ -1280,11 +1280,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	uint32_t *HashWorking;
 	uint32_t *pwwnn = (uint32_t *) phba->wwnn;

-	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
+	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
 	if (!HashWorking)
 		return;

-	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
 	HashWorking[0] = HashWorking[78] = *pwwnn++;
 	HashWorking[1] = HashWorking[79] = *pwwnn;

