Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486Ab0AMBGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0AMBGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230Ab0AMBF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:05:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:53340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0AMBF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:05:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="586626018"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: [PATCH 2.6.32.3] ata_piix: IDE Mode SATA patch for Intel Cougar Point DeviceIDs
Date: Tue, 12 Jan 2010 17:01:28 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001121701.28589.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Intel Cougar Point (PCH) IDE mode SATA Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.32.3/drivers/ata/ata_piix.c.orig	2010-01-06 15:07:45.000000000 -0800
+++ linux-2.6.32.3/drivers/ata/ata_piix.c	2010-01-07 13:10:28.000000000 -0800
@@ -291,6 +291,14 @@
 	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
