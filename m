Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYHHWrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYHHWrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYHHWq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:46:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:50772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYHHWq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="427521834"
From: Seth Heasley <seth.heasley@intel.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26.2] ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs
Date: Fri, 8 Aug 2008 15:52:05 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081552.05712.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) SATA RAID Controllers DeviceIDs.

Signed-off by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.26.2/drivers/ata/ahci.c.orig      2008-08-08 11:34:48.000000000 -0700
+++ linux-2.6.26.2/drivers/ata/ahci.c   2008-08-08 11:36:06.000000000 -0700
@@ -445,6 +445,8 @@
        { PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
        { PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
        { PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+       { PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
+       { PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */

        /* JMicron 360/1/3/5/6, match class to avoid IDE function */
        { PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
