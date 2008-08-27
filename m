Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYH0XmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYH0XmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYH0XmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:42:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:31355 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbYH0XmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,283,1217833200"; 
   d="scan'208";a="432780899"
From: Seth Heasley <seth.heasley@intel.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4] ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs
Date: Wed, 27 Aug 2008 16:47:22 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271647.22782.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) SATA RAID Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6/drivers/ata/ahci.c.orig	2008-08-27 11:48:10.000000000 -0700
+++ linux-2.6/drivers/ata/ahci.c	2008-08-27 11:49:23.000000000 -0700
@@ -487,7 +487,9 @@
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
