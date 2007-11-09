Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbXKIGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbXKIGDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXKIGCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:02:44 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52854 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712AbXKIGCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:02:43 -0500
Date: Fri, 9 Nov 2007 07:02:20 +0100
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] remove additional pci_scan_child_bus() prototype
Message-ID: <20071109060220.GQ26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's already a prototype for pci_scan_child_bus() at the correct 
place in pci.h, so there's no reason for an additional one.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
23fdba3eb3ed7b531fbe005a810d10679b113d2e 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index de33a02..4b73d57 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -486,8 +486,6 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 	}
 }
 
-unsigned int pci_scan_child_bus(struct pci_bus *bus);
-
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will

