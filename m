Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbYJKGmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbYJKGmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJKGhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:37 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:32774 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYJKGhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:23 -0400
Date: Sat, 11 Oct 2008 02:36:21 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 61/85] PNP: fix debug formatting (cosmetic)
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <6a0b93bae96f292b6c091cce5abfb9a644e649e9.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This patch just fixes indentation of a couple debug messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
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
-- 
1.5.5.1

