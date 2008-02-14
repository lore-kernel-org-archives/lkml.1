Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbYBNFPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbYBNFPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYBNFOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:58818 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYBNFOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eym7rJmYSHvkRcvyL5tTL5+6X8jVXiCN3M2hHG9MYxCCZbtZKS7uXD1OnBsrYrur4GZ3OJohuTI74cCFYAAllWQu93GV4TOiWoAGxqyskQvzHmEP+jEWVOYC1ATy8nEin/WNB/5n8SwpP9w44KlJt4oPUiXGJ5P50DSit1ESkeA=
Subject: [PATCH 01/11] ata: fix sparse warning in ata_piix.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:05 -0800
Message-Id: <1202966045.2748.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata/ata_piix.c:1655:8: warning: symbol 'rc' shadows an earlier one
drivers/ata/ata_piix.c:1616:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/ata_piix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9c2515f..752e7d2 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1652,7 +1652,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		u8 tmp;
 		pci_read_config_byte(pdev, PIIX_SCC, &tmp);
 		if (tmp == PIIX_AHCI_DEVICE) {
-			int rc = piix_disable_ahci(pdev);
+			rc = piix_disable_ahci(pdev);
 			if (rc)
 				return rc;
 		}
-- 
1.5.4.1.1278.gc75be


