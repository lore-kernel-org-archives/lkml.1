Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbZFYFQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbZFYFQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZFYFNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:55 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1452 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbZFYFNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
       James Ketrenos <jketreno@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 11/19] drivers/net/wireless: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:27 -0700
Message-Id: <10b896c1a1e1f65a4a342ee5aa3452ab8cb43dfb.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c        |   10 +++++-----
 drivers/net/wireless/prism54/islpci_hotplug.c |    4 +---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 44c29b3..d726b3c 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11436,11 +11436,11 @@ static struct pci_device_id card_ids[] = {
 	{PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, 0x2754, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, 0x2761, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, 0x2762, 0, 0, 0},
-	{PCI_VENDOR_ID_INTEL, 0x104f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INTEL, 0x4220, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* BG */
-	{PCI_VENDOR_ID_INTEL, 0x4221, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* BG */
-	{PCI_VENDOR_ID_INTEL, 0x4223, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* ABG */
-	{PCI_VENDOR_ID_INTEL, 0x4224, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* ABG */
+	{PCI_VDEVICE(INTEL, 0x104f), 0},
+	{PCI_VDEVICE(INTEL, 0x4220), 0},	/* BG */
+	{PCI_VDEVICE(INTEL, 0x4221), 0},	/* BG */
+	{PCI_VDEVICE(INTEL, 0x4223), 0},	/* ABG */
+	{PCI_VDEVICE(INTEL, 0x4224), 0},	/* ABG */
 
 	/* required last entry */
 	{0,}
diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/wireless/prism54/islpci_hotplug.c
index 3087672..83d3662 100644
--- a/drivers/net/wireless/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -49,9 +49,7 @@ static const struct pci_device_id prism54_id_tbl[] = {
 
 	/* 3COM 3CRWE154G72 Wireless LAN adapter */
 	{
-	 0x10b7, 0x6001,
-	 PCI_ANY_ID, PCI_ANY_ID,
-	 0, 0, 0
+	 PCI_VDEVICE(3COM, 0x6001), 0
 	},
 
 	/* Intersil PRISM Indigo Wireless LAN adapter */
-- 
1.6.3.1.10.g659a0.dirty

