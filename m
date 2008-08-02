Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYHBPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYHBPRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbYHBPPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:15:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbYHBPPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:15:40 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Date: Sat, 2 Aug 2008 16:40:37 +0200
Subject: [PATCH 4/4] Add DIP switch readout for HFC-4S IOB4ST
Message-Id: <20080802151538.9A022A3C09@pingi.kke.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also the HFC-4S IOB4ST has DIP switches and jumpers to configure
the port.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index e36360a..1eac03f 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -140,7 +140,7 @@
  * #define HFC_REGISTER_DEBUG
  */
 
-static const char *hfcmulti_revision = "2.01";
+static const char *hfcmulti_revision = "2.02";
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -5052,12 +5052,12 @@ static void __devexit hfc_remove_pci(struct pci_dev *pdev)
 
 static const struct hm_map hfcm_map[] = {
 /*0*/	{VENDOR_BN, "HFC-1S Card (mini PCI)", 4, 1, 1, 3, 0, DIP_4S, 0},
-/*1*/	{VENDOR_BN, "HFC-2S Card", 4, 2, 1, 3, 0, DIP_4S},
+/*1*/	{VENDOR_BN, "HFC-2S Card", 4, 2, 1, 3, 0, DIP_4S, 0},
 /*2*/	{VENDOR_BN, "HFC-2S Card (mini PCI)", 4, 2, 1, 3, 0, DIP_4S, 0},
 /*3*/	{VENDOR_BN, "HFC-4S Card", 4, 4, 1, 2, 0, DIP_4S, 0},
 /*4*/	{VENDOR_BN, "HFC-4S Card (mini PCI)", 4, 4, 1, 2, 0, 0, 0},
 /*5*/	{VENDOR_CCD, "HFC-4S Eval (old)", 4, 4, 0, 0, 0, 0, 0},
-/*6*/	{VENDOR_CCD, "HFC-4S IOB4ST", 4, 4, 1, 2, 0, 0, 0},
+/*6*/	{VENDOR_CCD, "HFC-4S IOB4ST", 4, 4, 1, 2, 0, DIP_4S, 0},
 /*7*/	{VENDOR_CCD, "HFC-4S", 4, 4, 1, 2, 0, 0, 0},
 /*8*/	{VENDOR_DIG, "HFC-4S Card", 4, 4, 0, 2, 0, 0, HFC_IO_MODE_REGIO},
 /*9*/	{VENDOR_CCD, "HFC-4S Swyx 4xS0 SX2 QuadBri", 4, 4, 1, 2, 0, 0, 0},
-- 
1.5.6.4

