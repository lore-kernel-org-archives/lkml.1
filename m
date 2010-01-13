Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009Ab0AMBII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0AMBII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419Ab0AMBIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:08:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:1593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab0AMBIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:08:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232069644"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de
Subject: [PATCH 2.6.32.3] hda_intel: ALSA HD Audio patch for Intel Cougar Point DeviceIDs
Date: Tue, 12 Jan 2010 17:03:35 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001121703.36016.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Cougar Point (PCH) HD Audio Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.32.3/sound/pci/hda/hda_intel.c.orig	2010-01-06 15:07:45.000000000 -0800
+++ linux-2.6.32.3/sound/pci/hda/hda_intel.c	2010-01-07 13:10:28.000000000 -0800
@@ -116,6 +116,7 @@
 			 "{Intel, ICH9},"
 			 "{Intel, ICH10},"
 			 "{Intel, PCH},"
+			 "{Intel, CPT},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
 			 "{ATI, SB600},"
@@ -2648,6 +2649,8 @@
 	{ PCI_DEVICE(0x8086, 0x3a6e), .driver_data = AZX_DRIVER_ICH },
 	/* PCH */
 	{ PCI_DEVICE(0x8086, 0x3b56), .driver_data = AZX_DRIVER_ICH },
+	/* CPT */
+	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_ICH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
 	/* ATI SB 450/600 */
