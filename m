Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYHSWyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYHSWyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYHSWxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:20 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28987 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYHSWxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:18 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 1/8] PNP: fix debug formatting (cosmetic)
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:16 -0600
Message-ID: <20080819225315.28206.69286.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch just fixes indentation of a couple debug messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/resource.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 4cfe3a1..e0206da 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -294,7 +294,7 @@ static int pci_dev_uses_irq(struct pnp_dev *pnp, struct pci_dev *pci,
 	u8 progif;
 
 	if (pci->irq == irq) {
-		dev_dbg(&pnp->dev, "device %s using irq %d\n",
+		dev_dbg(&pnp->dev, "  device %s using irq %d\n",
 			pci_name(pci), irq);
 		return 1;
 	}
@@ -316,7 +316,7 @@ static int pci_dev_uses_irq(struct pnp_dev *pnp, struct pci_dev *pci,
 		if ((progif & 0x5) != 0x5)
 			if (pci_get_legacy_ide_irq(pci, 0) == irq ||
 			    pci_get_legacy_ide_irq(pci, 1) == irq) {
-				dev_dbg(&pnp->dev, "legacy IDE device %s "
+				dev_dbg(&pnp->dev, "  legacy IDE device %s "
 					"using irq %d\n", pci_name(pci), irq);
 				return 1;
 			}

