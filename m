Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0BDOqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:46:10 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38738 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab0BDOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:26 -0500
Subject: [PATCH 10/30] hpsa: remove unwanted debug code
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:42:14 -0600
Message-ID: <20100204144214.10406.23996.stgit@beardog.cce.hp.com>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: remove unwanted debug code

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bd081fe..4594200 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1580,9 +1580,6 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	}
 	memcpy(nphysicals, &physdev->LUNListLength[0], sizeof(*nphysicals));
 	*nphysicals = be32_to_cpu(*nphysicals) / 8;
-#ifdef DEBUG
-	dev_info(&h->pdev->dev, "number of physical luns is %d\n", *nphysicals);
-#endif
 	if (*nphysicals > HPSA_MAX_PHYS_LUN) {
 		dev_warn(&h->pdev->dev, "maximum physical LUNs (%d) exceeded."
 			"  %d LUNs ignored.\n", HPSA_MAX_PHYS_LUN,
@@ -1595,9 +1592,6 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	}
 	memcpy(nlogicals, &logdev->LUNListLength[0], sizeof(*nlogicals));
 	*nlogicals = be32_to_cpu(*nlogicals) / 8;
-#ifdef DEBUG
-	dev_info(&h->pdev->dev, "number of logical luns is %d\n", *nlogicals);
-#endif
 	/* Reject Logicals in excess of our max capability. */
 	if (*nlogicals > HPSA_MAX_LUN) {
 		dev_warn(&h->pdev->dev,

