Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYFTPFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYFTPFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759868AbYFTPE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:04:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:53283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759844AbYFTPE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:04:56 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: sassmann@suse.de, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Remove unused variable.
Date: Fri, 20 Jun 2008 17:05:33 +0200
Message-Id: <1213974333-12179-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just fixes the compiler warning:

  drivers/pci/quirks.c: In function ‘quirk_reroute_to_boot_interrupts_intel’:
  drivers/pci/quirks.c:1375: warning: unused variable ‘i’


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 drivers/pci/quirks.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4b5b49e..292cf26 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1372,8 +1372,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
  */
 static void quirk_reroute_to_boot_interrupts_intel(struct pci_dev *dev)
 {
-	int i;
-
 	if (noioapicquirk)
 		return;
 
-- 
1.5.4.5

