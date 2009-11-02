Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZKBD40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZKBD40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 22:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZKBD4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 22:56:25 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:5507 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZKBD4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 22:56:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [patch 1/1 v3] pata_via.c : extend the rev_max for VIA VT6330
Date: Mon, 2 Nov 2009 11:56:25 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB80A302871@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/1 v3] pata_via.c : extend the rev_max for VIA VT6330
Thread-Index: AcpbcHMN4lnxNUqBQYK/YezAo2s8Wg==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <tj@kernel.org>, <jeff@garzik.org>,
       <JosephChan@via.com.tw>
X-OriginalArrivalTime: 02 Nov 2009 03:56:26.0849 (UTC) FILETIME=[73AA5D10:01CA5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA23uw16022661

Re-send.

Fix the VIA VT6330 issue, it's because the rev_max of VT6330 exceeds 0x2f.
The VIA VT6415 and VT6330 share the same device ID.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

--- a/drivers/ata/pata_via.c	2009-10-15 23:12:49.000000000 +0800
+++ b/drivers/ata/pata_via.c	2009-10-15 23:12:57.000000000 +0800
@@ -111,7 +111,7 @@
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
 	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
