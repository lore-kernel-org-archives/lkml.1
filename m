Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbYBWOIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbYBWOIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYBWOFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:05:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:35830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbYBWOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=paxzx+KqoIzduJBRcM+/V8iufZ49F/EmPEOOdV1gf2e5+4JNDBx4I5PLOfpS5VykUOo0x49ryny1we3n2sSfQHh3RsWvzl3ZHZ4w7rg/jTxgbQikS5xxi2Cf864YKNYs4T+7wGYDfxoGB6nFq2tqIz15u2E5keFoV+IAM8ii148=
Date: Sat, 23 Feb 2008 15:05:38 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 07/10] IDE: Coding Style fixes to drivers/ide/pci/slc90e66.c
Message-ID: <20080223150538.7bd86335@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free, only 1 warning left.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/pci/slc90e66.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 2ce384a..eab557c 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -27,9 +27,9 @@ static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
 	unsigned long flags;
 	u16 master_data;
 	u8 slave_data;
- 	int control = 0;
+	int control = 0;
 				     /* ISP  RTC */
-	static const u8 timings[][2]= {
+	static const u8 timings[][2] = {
 					{ 0, 0 },
 					{ 0, 0 },
 					{ 1, 0 },
@@ -136,7 +136,7 @@ static void __devinit init_hwif_slc90e66(ide_hwif_t *hwif)
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
 	.name		= "SLC90E66",
 	.init_hwif	= init_hwif_slc90e66,
-	.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
+	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.host_flags	= IDE_HFLAG_LEGACY_IRQS,
 	.pio_mask	= ATA_PIO4,
 	.swdma_mask	= ATA_SWDMA2_ONLY,
-- 
1.5.4.2.316.gf7a7

