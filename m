Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703Ab0ARRc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0ARRc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293Ab0ARRcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:32:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:8245 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0ARRPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=A0TOlnYW6SKI3OUdkZwr4mzrCAhlWX2FnZCGhBomqIvAJXDFbENzWhyzmLGlFLILMW
         oU+FYUTwDAXtvFc6RBkXS5vdfDhUiivFSjgCFY7z362GOfMPOUQYKQyMLxeFX8jIne74
         KwKNm7jSd4a3xsfprIdSFsRQPM+P/QPZeLMQA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:05 +0100
Message-Id: <20100118171405.14623.95544.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 02/64] pata_ali: documentation fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ali: documentation fixes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ali.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -159,8 +159,7 @@ static void ali_fifo_control(struct ata_
  *	ali_program_modes	-	load mode registers
  *	@ap: ALi channel to load
  *	@adev: Device the timing is for
- *	@cmd: Command timing
- *	@data: Data timing
+ *	@t: timing data
  *	@ultra: UDMA timing or zero for off
  *
  *	Loads the timing registers for cmd/data and disable UDMA if
@@ -202,8 +201,7 @@ static void ali_program_modes(struct ata
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	Program the ALi registers for PIO mode. FIXME: add timings for
- *	PIO5.
+ *	Program the ALi registers for PIO mode.
  */
 
 static void ali_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -237,7 +235,7 @@ static void ali_set_piomode(struct ata_p
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	FIXME: MWDMA timings
+ *	Program the ALi registers for DMA mode.
  */
 
 static void ali_set_dmamode(struct ata_port *ap, struct ata_device *adev)
