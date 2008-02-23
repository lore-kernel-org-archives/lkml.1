Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbYBWOJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbYBWOJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYBWOGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:06:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:35830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758946AbYBWOGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:06:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=QfOwP82SrsXNbeCI0mv4DwVtutAywbnQlTjhLYOkv1/IAvIG3miR0N9HpRodWlv5vcwT2fPWVRP255SBbeV6F8HClw9VWYGTk4AbZU/pS2x+VJVo7vGVWXEEz6lYyC2LDgSuOE2h7ELxwr7qsGEJhrkMHE3lTdN+OBtAfTPWPYg=
Date: Sat, 23 Feb 2008 15:06:02 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 10/10] IDE: Coding Style fixes to drivers/ide/pci/tc86c001.c
Message-ID: <20080223150602.79b44695@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/pci/tc86c001.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 1e4a626..c154351 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -18,20 +18,20 @@ static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 	u16 mode, scr		= inw(scr_port);
 
 	switch (speed) {
-		case XFER_UDMA_4:	mode = 0x00c0; break;
-		case XFER_UDMA_3:	mode = 0x00b0; break;
-		case XFER_UDMA_2:	mode = 0x00a0; break;
-		case XFER_UDMA_1:	mode = 0x0090; break;
-		case XFER_UDMA_0:	mode = 0x0080; break;
-		case XFER_MW_DMA_2:	mode = 0x0070; break;
-		case XFER_MW_DMA_1:	mode = 0x0060; break;
-		case XFER_MW_DMA_0:	mode = 0x0050; break;
-		case XFER_PIO_4:	mode = 0x0400; break;
-		case XFER_PIO_3:	mode = 0x0300; break;
-		case XFER_PIO_2:	mode = 0x0200; break;
-		case XFER_PIO_1:	mode = 0x0100; break;
-		case XFER_PIO_0:
-		default:		mode = 0x0000; break;
+	case XFER_UDMA_4:	mode = 0x00c0; break;
+	case XFER_UDMA_3:	mode = 0x00b0; break;
+	case XFER_UDMA_2:	mode = 0x00a0; break;
+	case XFER_UDMA_1:	mode = 0x0090; break;
+	case XFER_UDMA_0:	mode = 0x0080; break;
+	case XFER_MW_DMA_2:	mode = 0x0070; break;
+	case XFER_MW_DMA_1:	mode = 0x0060; break;
+	case XFER_MW_DMA_0:	mode = 0x0050; break;
+	case XFER_PIO_4:	mode = 0x0400; break;
+	case XFER_PIO_3:	mode = 0x0300; break;
+	case XFER_PIO_2:	mode = 0x0200; break;
+	case XFER_PIO_1:	mode = 0x0100; break;
+	case XFER_PIO_0:
+	default:		mode = 0x0000; break;
 	}
 
 	scr &= (speed < XFER_MW_DMA_0) ? 0xf8ff : 0xff0f;
-- 
1.5.4.2.316.gf7a7

