Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYHARoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYHARoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYHARog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:44:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:41968 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYHARof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:44:35 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] pata_sil680: convert CONFIG_PPC_MERGE to CONFIG_PPC
Date: Fri,  1 Aug 2008 11:44:19 -0500
Message-Id: <1217609060-6381-10-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1217609060-6381-9-git-send-email-galak@kernel.crashing.org>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-2-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-3-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-4-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-5-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-6-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-7-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-8-git-send-email-galak@kernel.crashing.org>
 <1217609060-6381-9-git-send-email-galak@kernel.crashing.org>
CC: linux-ide@vger.kernel.org
CC: jgarzik@pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms and we want to get rid of CONFIG_PPC_MERGE use
CONFIG_PPC instead.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/ata/pata_sil680.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 720b864..9655511 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -230,7 +230,7 @@ static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
 		tmpbyte & 1, tmpbyte & 0x30);
 
 	*try_mmio = 0;
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 	if (machine_is(cell))
 		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
 #endif
-- 
1.5.5.1

