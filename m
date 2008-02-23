Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYBWGJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYBWGJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYBWGIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:08:49 -0500
Received: from mail.queued.net ([207.210.101.209]:1144 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYBWGIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:08:18 -0500
Date: Sat, 23 Feb 2008 01:11:00 -0500
From: Andres Salomon <dilinger@queued.net>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, Jordan Crouse <jordan.crouse@amd.com>
Subject: [PATCH 4/4] gxfb: use PCI_DEVICE() for gxfb's pci device table
Message-ID: <20080223011100.72ca0c4f@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Drop the class/class_mask stuff; it's unnecessary
as long as the vendor and device IDs match.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/gxfb_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 07ff4bc..08fa25e 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -396,9 +396,7 @@ static void gxfb_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id gxfb_id_table[] = {
-	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_GX_VIDEO,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  0xff0000, 0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_GX_VIDEO) },
 	{ 0, }
 };
 
-- 
1.5.3.7

