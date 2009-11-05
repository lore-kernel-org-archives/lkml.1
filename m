Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZKEAMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZKEAMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZKEALM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:11:12 -0500
Received: from xenotime.net ([72.52.64.118]:36779 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750973AbZKEALK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:11:10 -0500
Date: Wed, 04 Nov 2009 16:04:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lyon <andrew.lyon@gmail.com>
Subject: [PATCH 2/8] docs: use KERN_WARNING, not KERN_WARN
Message-ID: <12573794922987@xenotime.net>
In-Reply-To: <1257379492822@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Use KERN_WARNING instead of KERN_WARN, which does not exist

Reported-by: Andrew Lyon <andrew.lyon@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DMA-mapping.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-2632-rc6.orig/Documentation/DMA-mapping.txt
+++ lnx-2632-rc6/Documentation/DMA-mapping.txt
@@ -224,14 +224,14 @@ Here is pseudo-code showing how this mig
 		card->playback_enabled = 1;
 	} else {
 		card->playback_enabled = 0;
-		printk(KERN_WARN "%s: Playback disabled due to DMA limitations.\n",
+		printk(KERN_WARNING "%s: Playback disabled due to DMA limitations.\n",
 		       card->name);
 	}
 	if (!pci_set_dma_mask(pdev, RECORD_ADDRESS_BITS)) {
 		card->record_enabled = 1;
 	} else {
 		card->record_enabled = 0;
-		printk(KERN_WARN "%s: Record disabled due to DMA limitations.\n",
+		printk(KERN_WARNING "%s: Record disabled due to DMA limitations.\n",
 		       card->name);
 	}
 


-- 

