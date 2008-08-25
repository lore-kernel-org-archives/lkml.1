Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYHYWCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYHYWCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYHYWCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:02:01 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40229 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbYHYWCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:02:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 4/5] IRDA: follow lspci device/vendor style
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2008 16:01:58 -0600
Message-ID: <20080825220158.19210.27264.stgit@tigger.helgaas>
In-Reply-To: <20080825220137.19210.41857.stgit@tigger.helgaas>
References: <20080825220137.19210.41857.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format
used by lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/net/irda/vlsi_ir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index 18f4b3a..9c926d2 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -165,7 +165,7 @@ static void vlsi_proc_pdev(struct seq_file *seq, struct pci_dev *pdev)
 	unsigned iobase = pci_resource_start(pdev, 0);
 	unsigned i;
 
-	seq_printf(seq, "\n%s (vid/did: %04x/%04x)\n",
+	seq_printf(seq, "\n%s (vid/did: [%04x:%04x])\n",
 		   pci_name(pdev), (int)pdev->vendor, (int)pdev->device);
 	seq_printf(seq, "pci-power-state: %u\n", (unsigned) pdev->current_state);
 	seq_printf(seq, "resources: irq=%u / io=0x%04x / dma_mask=0x%016Lx\n",

