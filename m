Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYGYOYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYGYOYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYGYOYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:24:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59145 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYGYOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:24:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 25 Jul 2008 16:24:19 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: state userland requirements in Kconfig help
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.179ae54a7af6ef02@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -16,8 +16,13 @@ config FIREWIRE
 	  enable the new stack.
 
 	  To compile this driver as a module, say M here: the module will be
-	  called firewire-core.  It functionally replaces ieee1394, raw1394,
-	  and video1394.
+	  called firewire-core.
+
+	  This module functionally replaces ieee1394, raw1394, and video1394.
+	  To access it from application programs, you generally need at least
+	  libraw1394 version 2.  IIDC/DCAM applications also need libdc1394
+	  version 2.  No libraries are required to access storage devices
+	  through the firewire-sbp2 driver.
 
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"

-- 
Stefan Richter
-=====-==--- -=== ==--=
http://arcgraph.de/sr/

