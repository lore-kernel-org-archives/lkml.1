Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYBRSkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYBRSkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYBRSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:40:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33638 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYBRSkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:40:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 18 Feb 2008 19:40:09 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Documentation: correction to debugging-via-ohci1394
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, Bernhard Kaindl <bk@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Message-ID: <tkrat.c3c4e46842ad7e84@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rectify a factoid about firewire-ohci.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Ingo, I can get this to Linus via linux1394-2.6.git.

 Documentation/debugging-via-ohci1394.txt |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc2/Documentation/debugging-via-ohci1394.txt
===================================================================
--- linux-2.6.25-rc2.orig/Documentation/debugging-via-ohci1394.txt
+++ linux-2.6.25-rc2/Documentation/debugging-via-ohci1394.txt
@@ -36,13 +36,14 @@ available (notebooks) or too slow for ex
 Drivers
 -------
 
-The OHCI-1394 drivers in drivers/firewire and drivers/ieee1394 initialize
-the OHCI-1394 controllers to a working state and can be used to enable
-physical DMA. By default you only have to load the driver, and physical
-DMA access will be granted to all remote nodes, but it can be turned off
-when using the ohci1394 driver.
+The ohci1394 driver in drivers/ieee1394 initializes the OHCI-1394 controllers
+to a working state and enables physical DMA by default for all remote nodes.
+This can be turned off by ohci1394's module parameter phys_dma=0.
 
-Because these drivers depend on the PCI enumeration to be completed, an
+The alternative firewire-ohci driver in drivers/firewire uses filtered physical
+DMA, hence is not yet suitable for remote debugging.
+
+Because ohci1394 depends on the PCI enumeration to be completed, an
 initialization routine which can runs pretty early (long before console_init(),
 which makes the printk buffer appear on the console can be called) was written.
 

-- 
Stefan Richter
-=====-==--- --=- =--=-
http://arcgraph.de/sr/

