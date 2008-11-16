Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYKPJq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYKPJq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYKPJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:44:32 -0500
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46879 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYKPJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=StlTiejcB3sYyT5m3YUeXa5K3N4yIZnYRhqIXSNDqDKe5x+0xG6JUG4X//OnLFY5pr
         eadTWsRtu7MIe/e8kXaTPsPuETvvsoMpfTecqbbBhGFwKgGtQqGFgymy1eNvbny9WGFJ
         p/22de42VKW45pPFV2oSP+hxDw352i6RgiF3Y=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: [PATCH 7/7] drivers/ata/pata_*c: the rest, remove redundant comments
Date: Sun, 16 Nov 2008 17:44:19 +0800
User-Agent: sniper-patch-carrier/1.04
Message-ID: <491feb7c.02066e0a.13b3.ffffa19e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove some redundant argument comments in pata_*.c

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 1266924..1050fed 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -356,7 +356,6 @@ static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	bfin_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: um
- *	@udma: udma mode, 0 - 6
  *
  *	Set UDMA mode for device.
  *
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index cf3707e..d447f1c 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -210,7 +210,6 @@ static void scc_set_piomode (struct ata_port *ap, struct ata_device *adev)
  *	scc_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: um
- *	@udma: udma mode, 0 - 6
  *
  *	Set UDMA mode for device.
  *
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 72e41c9..8d2fd9d 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -138,7 +138,6 @@ static struct sv_cable_table cable_detect[] = {
 /**
  *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 2b24ae5..8691863 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1836,7 +1836,6 @@ static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
 /**
  *      mv_err_intr - Handle error interrupts on the port
  *      @ap: ATA channel to manipulate
- *      @qc: affected command (non-NCQ), or NULL
  *
  *      Most cases require a full reset of the chip's state machine,
  *      which also performs a COMRESET.

