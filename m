Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZFYFQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZFYFQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbZFYFNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1448 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZFYFNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:46 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <pierre@ossman.eu>, Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 09/19] drivers/mmc: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:25 -0700
Message-Id: <8a43a1ce36d7680422fb1069246de3c87a56d14f.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/via-sdmmc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 632858a..64cc105 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -322,8 +322,7 @@ struct via_crdr_mmc_host {
 #define VIA_CRDR_QUIRK_300MS_PWRDELAY	0x0001
 
 static struct pci_device_id via_ids[] = {
-	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_9530,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
+	{PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_9530), 0,},
 	{0,}
 };
 
-- 
1.6.3.1.10.g659a0.dirty

