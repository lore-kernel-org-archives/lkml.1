Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbYA2A2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbYA2A2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYA2A2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:28:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:59393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYA2A2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:28:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="331191518"
From: Jason Gaston <jason.d.gaston@intel.com>
To: perex@suse.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       tiwai@suse.de, jason.d.gaston@intel.com
Subject: [PATCH 2.6.24] hda_intel: ALSA HD Audio patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 17:31:00 -0800
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281731.00789.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel ICH10 HD Audio Controller DeviceID's.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.24/sound/pci/hda/hda_intel.c.orig	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24/sound/pci/hda/hda_intel.c	2008-01-28 14:58:22.000000000 -0800
@@ -98,6 +98,7 @@
 			 "{Intel, ESB2},"
 			 "{Intel, ICH8},"
 			 "{Intel, ICH9},"
+			 "{Intel, ICH10},"
 			 "{ATI, SB450},"
 			 "{ATI, SB600},"
 			 "{ATI, RS600},"
@@ -1936,6 +1937,8 @@
 	{ 0x8086, 0x284b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ICH }, /* ICH8 */
 	{ 0x8086, 0x293e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ICH }, /* ICH9 */
 	{ 0x8086, 0x293f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ICH }, /* ICH9 */
+	{ 0x8086, 0x3a3e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ICH }, /* ICH10 */
+	{ 0x8086, 0x3a6e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ICH }, /* ICH10 */
 	{ 0x1002, 0x437b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ATI }, /* ATI SB450 */
 	{ 0x1002, 0x4383, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ATI }, /* ATI SB600 */
 	{ 0x1002, 0x793b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, AZX_DRIVER_ATIHDMI }, /* ATI RS600 HDMI */
