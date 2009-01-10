Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZAJPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZAJPaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZAJP3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:29:50 -0500
Received: from ns.konzeptpark.de ([195.226.66.162]:40767 "EHLO
	mail.konzeptpark.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZAJP3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:29:49 -0500
Subject: [PATCH][ATA] Add new CFcard pcmcia device to pata_pcmcia device
 table
From: Carsten Schlote <c.schlote@konzeptpark.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: konzeptpark.de
Date: Sat, 10 Jan 2009 16:06:26 +0100
Message-Id: <1231599986.10065.2.camel@kplaws107lx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-AVK-Virus-Check: AVF 19.212;06.01.2009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a 4GB CF card label 'adata compactflash 4GB speed'. 

The card wasn't recognized by the pata_pcmcia driver, I checked the
systool output for the pcmcia device - the reported values didn't match
any entry in pata_pcmcia driver.

This patch adds the device 0x004f and card ID 0x0000 to the pata_pcmcia
driver.

Signed-off-by: Carsten Schlote <c.schlote@konzeptpark.de>
---
 drivers/ata/pata_pcmcia.c |    1 +
 1 file changed, 1 insertion(+)

Index: .kernel/drivers/ata/pata_pcmcia.c
===================================================================
--- .kernel.orig/drivers/ata/pata_pcmcia.c	2009-01-10 13:12:30.000000000
+0100
+++ .kernel/drivers/ata/pata_pcmcia.c	2009-01-10 14:55:12.000000000
+0100
@@ -384,6 +384,7 @@
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x2904),
 	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x004f, 0x0000),	/* adata CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0097, 0x1620), 	/* TI emulated */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
