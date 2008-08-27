Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYH0XfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYH0XfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYH0Xew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:34:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:2689 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbYH0Xev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:34:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,283,1217833200"; 
   d="scan'208";a="432779358"
From: Seth Heasley <seth.heasley@intel.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: [PATCH 2.6.26.7-rc4] ata_piix: IDE Mode SATA patch for Intel Ibex Peak DeviceIDs
Date: Wed, 27 Aug 2008 16:40:06 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271640.06762.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the Intel Ibex Peak (PCH) IDE mode SATA Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6/drivers/ata/ata_piix.c.orig	2008-08-27 11:32:28.000000000 -0700
+++ linux-2.6/drivers/ata/ata_piix.c	2008-08-27 11:47:59.000000000 -0700
@@ -278,12 +278,15 @@
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
+	{ 0x8086, 0x3b28, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
-
 	{ }	/* terminate list */
 };
 
