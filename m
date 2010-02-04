Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0BDOjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:39:39 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:7732 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0BDOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:30 -0500
Subject: [PATCH 05/30] hpsa: make adjust_hpsa_scsi_table return void.
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:41:49 -0600
Message-ID: <20100204144149.10406.67225.stgit@beardog.cce.hp.com>
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

hpsa: make adjust_hpsa_scsi_table return void.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2c256e3..6fe5142 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -733,7 +733,7 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 	return DEVICE_NOT_FOUND;
 }
 
-static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
+static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
 	/* sd contains scsi3 addresses and devtypes, and inquiry
@@ -859,7 +859,6 @@ static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 free_and_out:
 	kfree(added);
 	kfree(removed);
-	return 0;
 }
 
 /*

