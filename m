Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYBCWMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYBCWMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYBCWMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:12:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47901 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYBCWMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:12:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:12:17 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 8/9] firewire: fw-sbp2: sort includes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.433c46cc2c1ddf50@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -28,15 +28,15 @@
  * and many others.
  */
 
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mod_devicetable.h>
-#include <linux/delay.h>
-#include <linux/device.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-mapping.h>
-#include <linux/blkdev.h>
 #include <linux/string.h>
 #include <linux/stringify.h>
 #include <linux/timer.h>
@@ -48,9 +48,9 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
-#include "fw-transaction.h"
-#include "fw-topology.h"
 #include "fw-device.h"
+#include "fw-topology.h"
+#include "fw-transaction.h"
 
 /*
  * So far only bridges from Oxford Semiconductor are known to support

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

