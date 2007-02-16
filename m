Return-Path: <linux-kernel-owner+w=401wt.eu-S1946312AbXBPXj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946312AbXBPXj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946305AbXBPXjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:39546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946303AbXBPXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sergei Organov <osv@javad.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/10] serial: Add PCMCIA IDs for Quatech DSP-100 dual RS232 adapter.
Date: Fri, 16 Feb 2007 15:37:29 -0800
Message-Id: <11716690633694-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <11716690591400-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Organov <osv@javad.com>

Add PCMCIA IDs for Quatech DSP-100 dual RS232 adapter.

Signed-off-by: Sergei Organov <osv@javad.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_cs.c |    5 +++++
 include/pcmcia/ciscode.h   |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index c2f1012..6b76bab 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -248,6 +248,10 @@ static const struct serial_quirk quirks[] = {
 		.multi	= 2,
 	}, {
 		.manfid	= MANFID_QUATECH,
+		.prodid	= PRODID_QUATECH_DUAL_RS232_G,
+		.multi	= 2,
+	}, {
+		.manfid	= MANFID_QUATECH,
 		.prodid	= PRODID_QUATECH_QUAD_RS232,
 		.multi	= 4,
 	}, {
@@ -891,6 +895,7 @@ static struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
+	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "PCMCIA", "EN2218-LAN/MODEM", 0x281f1c5d, 0x570f348e, "PCMLM28.cis"),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "PCMCIA", "UE2218-LAN/MODEM", 0x281f1c5d, 0x6fdcacee, "PCMLM28.cis"),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "Psion Dacom", "Gold Card V34 Ethernet", 0xf5f025c2, 0x338e8155, "PCMLM28.cis"),
diff --git a/include/pcmcia/ciscode.h b/include/pcmcia/ciscode.h
index c1da855..eae7e2e 100644
--- a/include/pcmcia/ciscode.h
+++ b/include/pcmcia/ciscode.h
@@ -95,6 +95,7 @@
 #define PRODID_QUATECH_DUAL_RS232	0x0012
 #define PRODID_QUATECH_DUAL_RS232_D1	0x0007
 #define PRODID_QUATECH_DUAL_RS232_D2	0x0052
+#define PRODID_QUATECH_DUAL_RS232_G	0x004d
 #define PRODID_QUATECH_QUAD_RS232	0x001b
 #define PRODID_QUATECH_DUAL_RS422	0x000e
 #define PRODID_QUATECH_QUAD_RS422	0x0045
-- 
1.5.0

