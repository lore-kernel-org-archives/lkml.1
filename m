Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbYHHWwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbYHHWwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYHHWv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:51:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:26862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYHHWv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:51:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="427522940"
From: Seth Heasley <seth.heasley@intel.com>
To: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26.2] hda_intel: ALSA HD Audio patch for Intel Ibex Peak DeviceIDs
Date: Fri, 8 Aug 2008 15:56:39 -0700
User-Agent: KMail/1.9.1
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081556.40013.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Ibex Peak (PCH) HD Audio Controller DeviceIDs.

Signed-off by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.26.2/sound/pci/hda/hda_intel.c.orig       2008-08-08 11:25:05.000000000 -0700
+++ linux-2.6.26.2/sound/pci/hda/hda_intel.c    2008-08-08 11:27:24.000000000 -0700
@@ -98,6 +98,7 @@
                         "{Intel, ICH8},"
                         "{Intel, ICH9},"
                         "{Intel, ICH10},"
+                        "{Intel, PCH},"
                         "{Intel, SCH},"
                         "{ATI, SB450},"
                         "{ATI, SB600},"
@@ -2181,6 +2182,8 @@
        { PCI_DEVICE(0x8086, 0x293f), .driver_data = AZX_DRIVER_ICH },
        { PCI_DEVICE(0x8086, 0x3a3e), .driver_data = AZX_DRIVER_ICH },
        { PCI_DEVICE(0x8086, 0x3a6e), .driver_data = AZX_DRIVER_ICH },
+       /* PCH */
+       { PCI_DEVICE(0x8086, 0x3b56), .driver_data = AZX_DRIVER_ICH },
        /* SCH */
        { PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
        /* ATI SB 450/600 */
