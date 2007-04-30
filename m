Return-Path: <linux-kernel-owner+w=401wt.eu-S1422808AbXD3DKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbXD3DKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422797AbXD3DKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:10:24 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:54461 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422822AbXD3DKE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:10:04 -0400
X-BigFish: V
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [patch]add the ATI  SB700 SATA controller device id  to AHCI pci table
Date: Mon, 30 Apr 2007 11:09:52 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201927D68@shacnexch2.atitech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch]add the ATI  SB700 SATA controller device id  to AHCI pci table
Thread-Index: AceK1QVA5tGXl0txRaWzOYC3cTRbqw==
From: "Henry Su" <henry.su@amd.com>
To: <jgarzik@pobox.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Apr 2007 03:10:00.0924 (UTC) FILETIME=[0A5331C0:01C78AD5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: henry.su@amd.com
Adding the device ID to AHCI pci table for ATI SB700 SATA controller,
the subsequent chipset of SB600.
Signed-off-by:henry su<henry.su@amd.com>
----------------------------
diff -Nur linux-2.6.21.orig/drivers/ata/ahci.c
linux-2.6.21/drivers/ata/ahci.c
--- linux-2.6.21.orig/drivers/ata/ahci.c 2007-04-29 07:00:15.000000000
+0800
+++ linux-2.6.21/drivers/ata/ahci.c 2007-04-29 07:06:04.000000000 +0800
@@ -415,6 +415,7 @@
/* ATI */
{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
+ { PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */

/* VIA */
{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */

