Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0BDOjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:39:44 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11069 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab0BDOjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:41 -0500
Subject: [PATCH 06/30] hpsa: remove superfluous returns from void functions.
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:41:54 -0600
Message-ID: <20100204144154.10406.41188.stgit@beardog.cce.hp.com>
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

hpsa: remove superfluous returns from void functions.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6fe5142..9017e64 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -898,7 +898,7 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 
 static void hpsa_slave_destroy(struct scsi_device *sdev)
 {
-	return; /* nothing to do. */
+	/* nothing to do. */
 }
 
 static void hpsa_scsi_setup(struct ctlr_info *h)
@@ -906,7 +906,6 @@ static void hpsa_scsi_setup(struct ctlr_info *h)
 	h->ndevices = 0;
 	h->scsi_host = NULL;
 	spin_lock_init(&h->devlock);
-	return;
 }
 
 static void complete_scsi_command(struct CommandList *cp,
@@ -1775,7 +1774,6 @@ out:
 	kfree(inq_buff);
 	kfree(physdev_list);
 	kfree(logdev_list);
-	return;
 }
 
 /* hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
@@ -3106,7 +3104,6 @@ default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
 	h->intr[SIMPLE_MODE_INT] = pdev->irq;
-	return;
 }
 
 static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)

