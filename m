Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXFEV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXFEV1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXFEV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:27:41 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:41938 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932596AbXFEV1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:27:40 -0400
Message-id: <31712116432657116505@wsc.cz>
In-reply-to: <1058130869771517818@wsc.cz>
Subject: [PATCH 4/3] Char: stallion, remove user class report request
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue,  5 Jun 2007 23:27:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, one more.

--

stallion, remove user class report request

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 400de8dd765298a11daec2a4a936a70798f428aa
tree 81675ba379783ad98f5c0387620a59b2ff2247a7
parent d62c04c8fe3271ab2089f442e04ad522a158bf8f
author Jiri Slaby <jirislaby@gmail.com> Tue, 05 Jun 2007 23:26:16 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 05 Jun 2007 23:26:16 +0200

 drivers/char/stallion.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 45bf2a2..eeb6200 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -2357,9 +2357,6 @@ static int __devinit stl_pciprobe(struct pci_dev *pdev,
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
 		goto err;
 
-	dev_info(&pdev->dev, "please, report this to LKML: %x/%x/%x\n",
-			pdev->vendor, pdev->device, pdev->class);
-
 	retval = pci_enable_device(pdev);
 	if (retval)
 		goto err;
