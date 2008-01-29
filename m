Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbYA2Abr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbYA2Abr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYA2Abj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:31:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:34024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYA2Abi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:31:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="255546970"
From: Jason Gaston <jason.d.gaston@intel.com>
To: jgarzik@pobox.com, jason.d.gaston@intel.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24] ahci: RAID mode SATA patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 17:34:14 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281734.14535.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 SATA RAID Controllers DeviceID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24/drivers/ata/ahci.c.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/drivers/ata/ahci.c	2008-01-28 14:58:22.000000000 -0800
@@ -475,6 +475,8 @@
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
