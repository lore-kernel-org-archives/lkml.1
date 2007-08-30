Return-Path: <linux-kernel-owner+w=401wt.eu-S1763633AbXH3WjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763633AbXH3WjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762756AbXH3WjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:39:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:55203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbXH3WjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,327,1183359600"; 
   d="scan'208";a="286227944"
From: Jason Gaston <jason.d.gaston@intel.com>
To: jgarzik@pobox.com, jason.d.gaston@intel.com
Subject: [PATCH 2.6.23-rc4] ahci: RAID mode SATA patch for Intel Tolapai
Date: Thu, 30 Aug 2007 15:41:14 -0700
User-Agent: KMail/1.9.1
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708301541.15111.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Tolapai RAID controller DID's for SATA support.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc4/drivers/ata/ahci.c.orig	2007-08-27 18:32:35.000000000 
-0700
+++ linux-2.6.23-rc4/drivers/ata/ahci.c	2007-08-28 16:58:11.000000000 -0700
@@ -411,6 +411,8 @@
 	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
