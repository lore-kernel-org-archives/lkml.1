Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZKKQtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZKKQtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbZKKQtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:49:22 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35307 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828AbZKKQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:49:11 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/17] hpsa: Fix vendor id check
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:50:38 -0600
Message-ID: <20091111165038.17754.4977.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: Fix vendor id check

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 186f9a2..6c4d9fd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3080,7 +3080,7 @@ static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 
 	if (prod_index == ARRAY_SIZE(products)) {
 		prod_index--;
-		if (subsystem_vendor_id == !PCI_VENDOR_ID_HP ||
+		if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||
 				!hpsa_allow_any) {
 			dev_warn(&pdev->dev, "unrecognized board ID:"
 				" 0x%08lx, ignoring.\n",

