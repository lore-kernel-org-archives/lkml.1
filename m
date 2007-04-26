Return-Path: <linux-kernel-owner+w=401wt.eu-S2993106AbXDZJtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993106AbXDZJtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161818AbXDZJtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:49:46 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:21382 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161873AbXDZJtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:49:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] pata_pcmcia: recognize 2GB CompactFlash from Transcend
Date: Thu, 26 Apr 2007 11:49:35 +0200
Message-ID: <D7810733513F4840B4EBAAFA64D9C6A40130764F@stgw002a.ww002.siemens.net>
In-Reply-To: <D7810733513F4840B4EBAAFA64D9C6A4012D5C9F@stgw002a.ww002.siemens.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] pata_pcmcia: recognize 2GB CompactFlash from Transcend
Thread-Index: AceF7Dxw1HG7Z+0/Q922AExek2MqSwBLNw6AADNlyPA=
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
To: <linux-pcmcia@lists.infradead.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       "Peter Stuge" <stuge-linux-pcmcia@cdy.org>,
       "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
X-OriginalArrivalTime: 26 Apr 2007 09:48:53.0057 (UTC) FILETIME=[1955E310:01C787E8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the pata_pcmcia driver to automatically detect 2GB
CompactFlash cards from Transcend.

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>

=====================================================================
--- linux-2.6.20.7-orig/drivers/ata/pata_pcmcia.c	2007-04-15
21:08:02.000000000 +0200
+++ linux-2.6.20.7/drivers/ata/pata_pcmcia.c	2007-04-26
11:35:38.000000000 +0200
@@ -350,6 +350,7 @@
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a,
0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1,
0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1,
0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1,
0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c,
0x212bb918),
