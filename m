Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092Ab0ARRU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0ARRU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988Ab0ARRUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:20:13 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57577 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0ARRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=trxJ+mV8ZuEUeh+nYhWB+gPE54tUTSjSRk+WavGOUEBTYlRy2C8OCjAZqFwPlYpsq7
         k/yG3hBM+0jrT1KZxxac6TOTxbBPls6RVcvgo4h5cmdcEj4E31vddGV7PdZMIMrI3dT6
         7da75NYevZNzUD+zchJahp+cjIcX25QEOukq0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:18:58 +0100
Message-Id: <20100118171858.14623.27828.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 34/64] cy82c693: remove stale driver history
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cy82c693: remove stale driver history

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cy82c693.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -5,39 +5,6 @@
  * CYPRESS CY82C693 chipset IDE controller
  *
  * The CY82C693 chipset is used on Digital's PC-Alpha 164SX boards.
- * Writing the driver was quite simple, since most of the job is
- * done by the generic pci-ide support.
- * The hard part was finding the CY82C693's datasheet on Cypress's
- * web page :-(. But Altavista solved this problem :-).
- *
- *
- * Notes:
- * - I recently got a 16.8G IBM DTTA, so I was able to test it with
- *   a large and fast disk - the results look great, so I'd say the
- *   driver is working fine :-)
- *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA
- * - this is my first linux driver, so there's probably a lot  of room
- *   for optimizations and bug fixing, so feel free to do it.
- * - if using PIO mode it's a good idea to set the PIO mode and
- *   32-bit I/O support (if possible), e.g. hdparm -p2 -c1 /dev/hda
- * - I had some problems with my IBM DHEA with PIO modes < 2
- *   (lost interrupts) ?????
- * - first tests with DMA look okay, they seem to work, but there is a
- *   problem with sound - the BusMaster IDE TimeOut should fixed this
- *
- * Ancient History:
- * AMH@1999-08-24: v0.34 init_cy82c693_chip moved to pci_init_cy82c693
- * ASK@1999-01-23: v0.33 made a few minor code clean ups
- *                       removed DMA clock speed setting by default
- *                       added boot message
- * ASK@1998-11-01: v0.32 added support to set BusMaster IDE TimeOut
- *                       added support to set DMA Controller Clock Speed
- * ASK@1998-10-31: v0.31 fixed problem with setting to high DMA modes
- *                       on some drives.
- * ASK@1998-10-29: v0.3 added support to set DMA modes
- * ASK@1998-10-28: v0.2 added support to set PIO modes
- * ASK@1998-10-27: v0.1 first version - chipset detection
- *
  */
 
 #include <linux/module.h>
