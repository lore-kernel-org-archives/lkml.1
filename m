Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbXLQToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbXLQToX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXLQTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:56 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2989 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761115AbXLQTbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:44 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: [PATCH] drivers/ata/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:27 -0800
Message-Id: <1197919875-5288-28-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/ata_piix.c    |    2 +-
 drivers/ata/libata-core.c |    4 ++--
 drivers/ata/pata_at32.c   |    2 +-
 drivers/ata/pata_efar.c   |    2 +-
 drivers/ata/pata_it8213.c |    2 +-
 drivers/ata/pata_sis.c    |    4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index bb62a58..ee51853 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -769,7 +769,7 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (is_slave) {
 		/* clear TIME1|IE1|PPE1|DTE1 */
 		master_data &= 0xff0f;
-		/* Enable SITRE (seperate slave timing register) */
+		/* Enable SITRE (separate slave timing register) */
 		master_data |= 0x4000;
 		/* enable PPE1, IE1 and TIME1 as needed */
 		master_data |= (control << 4);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e4dea86..debbfc3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3065,7 +3065,7 @@ static int ata_dev_set_mode(struct ata_device *dev)
 /**
  *	ata_do_set_mode - Program timings and issue SET FEATURES - XFER
  *	@link: link on which timings will be programmed
- *	@r_failed_dev: out paramter for failed device
+ *	@r_failed_dev: out parameter for failed device
  *
  *	Standard implementation of the function used to tune and set
  *	ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
@@ -3173,7 +3173,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 /**
  *	ata_set_mode - Program timings and issue SET FEATURES - XFER
  *	@link: link on which timings will be programmed
- *	@r_failed_dev: out paramter for failed device
+ *	@r_failed_dev: out parameter for failed device
  *
  *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
  *	ata_set_mode() fails, pointer to the failing device is
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index 67e574d..db057b1 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -324,7 +324,7 @@ static int __init pata_at32_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	/* Setup struct containing private infomation */
+	/* Setup struct containing private information */
 	info = kzalloc(sizeof(struct at32_ide_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 043dcd3..dc33220 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -135,7 +135,7 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		idetm_data &= 0xCC0F;
 		idetm_data |= (control << 4);
 
-		/* Slave timing in seperate register */
+		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= 0x0F << shift;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 1eda821..e0c2cc2 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -128,7 +128,7 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		idetm_data &= 0xCC0F;
 		idetm_data |= (control << 4);
 
-		/* Slave timing in seperate register */
+		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= 0xF0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << 4;
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 87546d9..dc7e915 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -345,7 +345,7 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
-		   the higer bits are dependant on the device */
+		   the higher bits are dependant on the device */
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -385,7 +385,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
-		   the higer bits are dependant on the device, bit 15 udma */
+		   the higher bits are dependant on the device, bit 15 udma */
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
-- 
1.5.3.7.949.g2221a6

