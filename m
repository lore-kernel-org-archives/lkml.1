Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbYBVVNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbYBVVNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765874AbYBVVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:10:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:20175 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765679AbYBVVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dr5B7etphn4a5oMB1mdSgUGZ3EK6erfG1A3UTUZM/++Bbh8nibiEUlbSJBONrdrIz9ej9nlMYBRq/UETHN7S6sfc8S3d4FfSpAGBU2vsP/i7xzjitHP+p6+vcnMOFvJCkSCB/lzhS22aOTXZx5+IzfTP/iuxAkDYDLZqALauM4w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove stale comments from ide-dma.c
Date: Fri, 22 Feb 2008 22:24:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222224.53642.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- ide-dma.c is not a separate module

- ide-dma.c is not PCI specific anymore

- DMA is enabled by default nowadays

- link for Intel Zappa BIOS is dead

etc.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   48 ------------------------------------------------
 1 file changed, 48 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -11,49 +11,6 @@
  */
 
 /*
- * This module provides support for the bus-master IDE DMA functions
- * of various PCI chipsets, including the Intel PIIX (i82371FB for
- * the 430 FX chipset), the PIIX3 (i82371SB for the 430 HX/VX and 
- * 440 chipsets), and the PIIX4 (i82371AB for the 430 TX chipset)
- * ("PIIX" stands for "PCI ISA IDE Xcellerator").
- *
- * Pretty much the same code works for other IDE PCI bus-mastering chipsets.
- *
- * DMA is supported for all IDE devices (disk drives, cdroms, tapes, floppies).
- *
- * By default, DMA support is prepared for use, but is currently enabled only
- * for drives which already have DMA enabled (UltraDMA or mode 2 multi/single),
- * or which are recognized as "good" (see table below).  Drives with only mode0
- * or mode1 (multi/single) DMA should also work with this chipset/driver
- * (eg. MC2112A) but are not enabled by default.
- *
- * Use "hdparm -i" to view modes supported by a given drive.
- *
- * The hdparm-3.5 (or later) utility can be used for manually enabling/disabling
- * DMA support, but must be (re-)compiled against this kernel version or later.
- *
- * To enable DMA, use "hdparm -d1 /dev/hd?" on a per-drive basis after booting.
- * If problems arise, ide.c will disable DMA operation after a few retries.
- * This error recovery mechanism works and has been extremely well exercised.
- *
- * IDE drives, depending on their vintage, may support several different modes
- * of DMA operation.  The boot-time modes are indicated with a "*" in
- * the "hdparm -i" listing, and can be changed with *knowledgeable* use of
- * the "hdparm -X" feature.  There is seldom a need to do this, as drives
- * normally power-up with their "best" PIO/DMA modes enabled.
- *
- * Testing has been done with a rather extensive number of drives,
- * with Quantum & Western Digital models generally outperforming the pack,
- * and Fujitsu & Conner (and some Seagate which are really Conner) drives
- * showing more lackluster throughput.
- *
- * Keep an eye on /var/adm/messages for "DMA disabled" messages.
- *
- * Some people have reported trouble with Intel Zappa motherboards.
- * This can be fixed by upgrading the AMI BIOS to version 1.00.04.BS0,
- * available from ftp://ftp.intel.com/pub/bios/10004bs0.exe
- * (thanks to Glen Morrell <glen@spin.Stanford.edu> for researching this).
- *
  * Thanks to "Christopher J. Reimer" <reimer@doe.carleton.ca> for
  * fixing the problem with the BIOS on some Acer motherboards.
  *
@@ -65,11 +22,6 @@
  *
  * Most importantly, thanks to Robert Bringman <rob@mars.trion.com>
  * for supplying a Promise UDMA board & WD UDMA drive for this work!
- *
- * And, yes, Intel Zappa boards really *do* use both PIIX IDE ports.
- *
- * ATA-66/100 and recovery functions, I forgot the rest......
- *
  */
 
 #include <linux/module.h>
