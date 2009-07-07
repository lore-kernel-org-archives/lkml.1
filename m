Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbZGGOiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbZGGOiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbZGGOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:36:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:42780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751AbZGGOgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:36:45 -0400
Subject: [PATCH 19/22] trivial: fix typo "was was" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:54:55 +0530
Message-Id: <1246976695.3613.36.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "was was" with "was" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/microblaze/kernel/signal.c            |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 +-
 drivers/parisc/ccio-dma.c                  |    2 +-
 drivers/usb/atm/ueagle-atm.c               |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 493819c..e7ed1b5 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -11,7 +11,7 @@
  *
  * 1997-11-28 Modified for POSIX.1b signals by Richard Henderson
  *
- * This file was was derived from the sh version, arch/sh/kernel/signal.c
+ * This file was derived from the sh version, arch/sh/kernel/signal.c
  *
  * This file is subject to the terms and conditions of the GNU General
  * Public License. See the file COPYING in the main directory of this
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index f40ab69..360c2e7 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -353,7 +353,7 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		       drvdata->read_buffer + bytes_to_read,
 		       4 - bytes_to_read);
 	} else {
-		/* Get new data from the ICAP, and return was was requested. */
+		/* Get new data from the ICAP, and return was requested. */
 		kbuf = (u32 *) get_zeroed_page(GFP_KERNEL);
 		if (!kbuf) {
 			status = -ENOMEM;
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 0f0e0b9..bd3fdab 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -268,7 +268,7 @@ static int ioc_count;
 *   Each bit can represent a number of pages.
 *   LSbs represent lower addresses (IOVA's).
 *
-*   This was was copied from sba_iommu.c. Don't try to unify
+*   This was copied from sba_iommu.c. Don't try to unify
 *   the two resource managers unless a way to have different
 *   allocation policies is also adjusted. We'd like to avoid
 *   I/O TLB thrashing by having resource allocation policy
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index d171b56..774096c 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -52,7 +52,7 @@
  * HISTORY : some part of the code was base on ueagle 1.3 BSD driver,
  * Damien Bergamini agree to put his code under a DUAL GPL/BSD license.
  *
- * The rest of the code was was rewritten from scratch.
+ * The rest of the code was rewritten from scratch.
  */
 
 #include <linux/module.h>
-- 
1.6.0.6



