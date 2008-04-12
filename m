Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYDLF3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYDLF3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYDLF24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:28:56 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48207 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYDLF2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:28:55 -0400
Date: Sat, 12 Apr 2008 01:28:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080412052855.GA16140@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_ali.c |    2 +-
 drivers/ata/sata_svw.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Adrian Bunk (1):
      [libata] make ali_atapi_dma static

Jeff Garzik (1):
      [libata] sata_svw: fix reversed port count

diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index ce830fe..511a830 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -36,7 +36,7 @@
 #define DRV_NAME "pata_ali"
 #define DRV_VERSION "0.7.5"
 
-int ali_atapi_dma = 0;
+static int ali_atapi_dma = 0;
 module_param_named(atapi_dma, ali_atapi_dma, int, 0644);
 MODULE_PARM_DESC(atapi_dma, "Enable ATAPI DMA (0=disable, 1=enable)");
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 840d1c4..019e367 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -531,8 +531,8 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
  * */
 static const struct pci_device_id k2_sata_pci_tbl[] = {
 	{ PCI_VDEVICE(SERVERWORKS, 0x0240), chip_svw4 },
-	{ PCI_VDEVICE(SERVERWORKS, 0x0241), chip_svw4 },
-	{ PCI_VDEVICE(SERVERWORKS, 0x0242), chip_svw8 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0241), chip_svw8 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0242), chip_svw4 },
 	{ PCI_VDEVICE(SERVERWORKS, 0x024a), chip_svw4 },
 	{ PCI_VDEVICE(SERVERWORKS, 0x024b), chip_svw4 },
 	{ PCI_VDEVICE(SERVERWORKS, 0x0410), chip_svw42 },
