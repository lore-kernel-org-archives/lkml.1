Return-Path: <linux-kernel-owner+w=401wt.eu-S1945999AbXBBRn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945999AbXBBRn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 12:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946000AbXBBRn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 12:43:27 -0500
Received: from javad.com ([216.122.176.236]:1046 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945999AbXBBRn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 12:43:27 -0500
From: Sergei Organov <osv@javad.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: Add PCMCIA IDs for Quatech DSP-100 dual RS232
 adapter.
References: <87hcu522tp.fsf@javad.com>
Date: Fri, 02 Feb 2007 20:43:12 +0300
In-Reply-To: <87hcu522tp.fsf@javad.com> (Sergei Organov's message of "Thu,
 01
	Feb 2007 20:41:06 +0300")
Message-ID: <87wt30zc9b.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add PCMCIA IDs for Quatech DSP-100 dual RS232 adapter.

Signed-off-by: Sergei Organov <osv@javad.com>

---
diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index 431433f..5757442 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -249,6 +249,10 @@ static const struct serial_quirk quirks[] = {
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
@@ -893,6 +897,7 @@ static struct pcmcia_device_id serial_ids[] = {
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
