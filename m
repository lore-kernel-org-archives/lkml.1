Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZJZDzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZJZDzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 23:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZJZDzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 23:55:50 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33311 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZJZDzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 23:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Aeam9Vv/uDTqqDUjCqYVX80lGr69Vyo98LNXyqtd0o/RdWeH98LAPyUz0jrNHfCTEM
         rYWnekqIi3bHyxYyU4+7gNceeL6z1t4v6sKUlEuVNnA4yG21oMt36LHCqbOaVbvzeGDA
         k0NQjOtLfXYSuM1smhQdnZWnmXYw3+bBi7MOQ=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH] 8250_pci: Remove duplicate struct pciserial_board
Date: Sun, 25 Oct 2009 22:55:07 -0500
Message-Id: <1256529307-32177-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pbn_exsys_4055 is the same thing as pbn_b2_4_115200 so replace it with
the standard pattern.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/serial/8250_pci.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index e7108e7..8087d0a 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1545,7 +1545,6 @@ enum pci_board_num_t {
 	pbn_panacom,
 	pbn_panacom2,
 	pbn_panacom4,
-	pbn_exsys_4055,
 	pbn_plx_romulus,
 	pbn_oxsemi,
 	pbn_oxsemi_1_4000000,
@@ -2011,13 +2010,6 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.reg_shift	= 7,
 	},
 
-	[pbn_exsys_4055] = {
-		.flags		= FL_BASE2,
-		.num_ports	= 4,
-		.base_baud	= 115200,
-		.uart_offset	= 8,
-	},
-
 	/* I think this entry is broken - the first_offset looks wrong --rmk */
 	[pbn_plx_romulus] = {
 		.flags		= FL_BASE2,
@@ -2736,7 +2728,7 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_EXSYS,
 		PCI_SUBDEVICE_ID_EXSYS_4055, 0, 0,
-		pbn_exsys_4055 },
+		pbn_b2_4_115200 },
 	/*
 	 * Megawolf Romulus PCI Serial Card, from Mike Hudson
 	 * (Exoray@isys.ca)
-- 
1.6.5

