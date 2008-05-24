Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbYEXOsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbYEXOsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYEXOsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:48:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48322 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYEXOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:48:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 May 2008 16:48:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: clean up some includes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.8e3da82f7efa1c13@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -20,12 +20,12 @@
 #define __fw_transaction_h
 
 #include <linux/device.h>
-#include <linux/timer.h>
-#include <linux/interrupt.h>
-#include <linux/list.h>
-#include <linux/fs.h>
 #include <linux/dma-mapping.h>
 #include <linux/firewire-constants.h>
+#include <linux/list.h>
+#include <linux/spinlock_types.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <asm/atomic.h>
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)

-- 
Stefan Richter
-=====-==--- -=-= ==---
http://arcgraph.de/sr/

