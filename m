Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZJPHqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZJPHqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZJPHqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:46:03 -0400
Received: from exchtp08.via.com.tw ([61.66.243.7]:62298 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZJPHqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:46:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [patch 1/1 v2] pata_via.c : extend the rev_max for VT6330
Date: Fri, 16 Oct 2009 15:45:23 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB80A1D1E6E@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/1 v2] pata_via.c : extend the rev_max for VT6330
Thread-Index: AcpONJ4Wp6zOG0tBRzuFGXAUkcnWHg==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <tj@kernel.org>, <jeff@garzik.org>,
       <JosephChan@via.com.tw>
X-OriginalArrivalTime: 16 Oct 2009 07:45:23.0836 (UTC) FILETIME=[9E867BC0:01CA4E34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9G7od16011666

Fix the VT6330 issue, it's because the rev_max of VT6330 exceeds 0x2f.
The VT6415 and VT6330 share the same device ID.

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
