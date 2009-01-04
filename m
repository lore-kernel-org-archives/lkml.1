Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbZADP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbZADP0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZADP0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:26:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44047 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZADP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:26:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:25:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 03/11] firewire: cdev: sort includes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.ff88cfe039b945a4@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -18,28 +18,30 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/module.h>
+#include <linux/compat.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/firewire-cdev.h>
+#include <linux/idr.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
-#include <linux/wait.h>
-#include <linux/errno.h>
-#include <linux/device.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/preempt.h>
-#include <linux/time.h>
 #include <linux/spinlock.h>
-#include <linux/delay.h>
-#include <linux/mm.h>
-#include <linux/idr.h>
-#include <linux/compat.h>
-#include <linux/firewire-cdev.h>
+#include <linux/time.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+
 #include <asm/system.h>
 #include <asm/uaccess.h>
-#include "fw-transaction.h"
-#include "fw-topology.h"
+
 #include "fw-device.h"
+#include "fw-topology.h"
+#include "fw-transaction.h"
 
 struct client {
 	u32 version;

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

