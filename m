Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351Ab0ARRVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0ARRVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326Ab0ARRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:21:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5715 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0ARRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:21:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oWPQ4MY9gs/b06ggA+bcYcBU0d7WKodqfRkuDd2n1quKyiOJnyPxzweszeMiWHplJA
         TcbynX2tiGih+jCC4FZCHKx2eTsNjyPZ6OecQKobUEzzy0KfAI5DpZp4cMpJb5kAX/TK
         ReLzURFq8UYg9QCNB1+Dz38BEBzRP9yK1iBCs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:14 +0100
Message-Id: <20100118172014.14623.64693.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 44/64] via82cxxx: add support for VT6415 PCIE PATA IDE Host Controller
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: add support for VT6415 PCIE PATA IDE Host Controller

Based on commits 5955c7a and 7d948b1 for pata_via host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/via82cxxx.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -78,6 +78,7 @@ static struct via_isa_bridge {
 	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6410,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
@@ -543,6 +544,7 @@ static const struct pci_device_id via_pc
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_CX700_IDE), 0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_VX855_IDE), VIA_IDFLAG_SINGLE },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6410),      1 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6415),      1 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_SATA_EIDE), 1 },
 	{ 0, },
 };
