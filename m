Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYJBAQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYJBAQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYJBAQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:16:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49596 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYJBAQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:16:23 -0400
Date: Wed, 1 Oct 2008 17:21:37 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>
Subject: [PATCH] matroxfb: Support G200eV chip
Message-ID: <20081002002136.GJ10750@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the Matrox G200eV chip, based on timings that I found in the
X.org matrox driver.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/video/matrox/matroxfb_base.c |    9 +++++++++
 include/linux/pci_ids.h              |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index c021362..8e7a275 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1453,6 +1453,13 @@ static struct board {
 		MGA_G100,
 		&vbG100,
 		"MGA-G100 (AGP)"},
+	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,	0xFF,
+		0,			0,
+		DEVF_G200,
+		230000,
+		MGA_G200,
+		&vbG200,
+		"MGA-G200eV (PCI)"},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,	0xFF,
 		0,			0,
 		DEVF_G200,
@@ -2118,6 +2125,8 @@ static struct pci_device_id matroxfb_devices[] = {
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G100_AGP,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
+	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200EV_PCI,
+		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_PCI,
 		PCI_ANY_ID,	PCI_ANY_ID,	0, 0, 0},
 	{PCI_VENDOR_ID_MATROX,	PCI_DEVICE_ID_MATROX_G200_AGP,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..6260fab 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -577,6 +577,7 @@
 #define PCI_DEVICE_ID_MATROX_G200_PCI	0x0520
 #define PCI_DEVICE_ID_MATROX_G200_AGP	0x0521
 #define	PCI_DEVICE_ID_MATROX_G400	0x0525
+#define	PCI_DEVICE_ID_MATROX_G200EV_PCI	0x0530
 #define PCI_DEVICE_ID_MATROX_G550	0x2527
 #define PCI_DEVICE_ID_MATROX_VIA	0x4536
 
