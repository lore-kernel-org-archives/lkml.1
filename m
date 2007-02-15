Return-Path: <linux-kernel-owner+w=401wt.eu-S964856AbXBOCRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856AbXBOCRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964858AbXBOCRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:17:06 -0500
Received: from imf19aec.mail.bellsouth.net ([205.152.59.67]:25986 "EHLO
	imf19aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964855AbXBOCRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:17:04 -0500
Date: Wed, 14 Feb 2007 20:17:01 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: [PATCH 5/6] atl1: add L1 device id to pci_ids, then use it
Message-ID: <20070215021701.GF9753@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2007-01-26)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Add device id for the Attansic L1 chip to pci_ids.h, then use it.

Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---

 drivers/net/atl1/atl1_main.c |    2 +-
 include/linux/pci_ids.h      |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index abce97e..09f3375 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -99,7 +99,7 @@ MODULE_VERSION(DRIVER_VERSION);
  * atl1_pci_tbl - PCI Device ID Table
  */
 static const struct pci_device_id atl1_pci_tbl[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ATTANSIC, 0x1048)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ATTANSIC, PCI_DEVICE_ID_ATTANSIC_L1)},
 	/* required last entry */
 	{0,}
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 68a7be9..bd21933 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2067,6 +2067,7 @@
 #define PCI_DEVICE_ID_TDI_EHCI          0x0101
 
 #define PCI_VENDOR_ID_ATTANSIC		0x1969
+#define PCI_DEVICE_ID_ATTANSIC_L1	0x1048
 
 #define PCI_VENDOR_ID_JMICRON		0x197B
 #define PCI_DEVICE_ID_JMICRON_JMB360	0x2360
