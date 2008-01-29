Return-Path: <linux-kernel-owner+w=401wt.eu-S1765317AbYA2Aew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765317AbYA2Aew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765094AbYA2Adc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:33:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:10340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765021AbYA2Ada (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:33:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="331194881"
From: Jason Gaston <jason.d.gaston@intel.com>
To: jgarzik@pobox.com, jason.d.gaston@intel.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: [PATCH 2.6.24] ata_piix:  IDE mode SATA patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 17:36:45 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281736.45574.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 IDE mode SATA Controller DeviceID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24/drivers/ata/ata_piix.c.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/drivers/ata/ata_piix.c	2008-01-28 14:58:22.000000000 -0800
@@ -263,6 +263,14 @@
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (Tolapai) */
 	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata_ahci },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a06, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 
 	{ }	/* terminate list */
 };
