Return-Path: <linux-kernel-owner+w=401wt.eu-S1761843AbYEESb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761843AbYEESb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbYEES1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:27:00 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44758 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760674AbYEES07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:26:59 -0400
Date: Mon, 5 May 2008 21:25:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] pcmcia: kill IN_CARD_SERVICES
Message-ID: <20080505182552.GU17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IN_CARD_SERVICES was #define'd but not used, so let's remove it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch hasbeen sent on:
- 17 Apr 2008

 drivers/pcmcia/cardbus.c         |    1 -
 drivers/pcmcia/cs.c              |    1 -
 drivers/pcmcia/ds.c              |    1 -
 drivers/pcmcia/pcmcia_ioctl.c    |    1 -
 drivers/pcmcia/pcmcia_resource.c |    1 -
 drivers/pcmcia/socket_sysfs.c    |    1 -
 6 files changed, 6 deletions(-)

cb5bd5e7e5b70225228c7b33bea4a7c82061e657 diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index 714baae..dc8aca1 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -30,7 +30,6 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 56230db..1f3eb86 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -32,7 +32,6 @@
 #include <asm/system.h>
 #include <asm/irq.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 5a85871..4f6a6cf 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -25,7 +25,6 @@
 #include <linux/kref.h>
 #include <linux/dma-mapping.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
diff --git a/drivers/pcmcia/pcmcia_ioctl.c b/drivers/pcmcia/pcmcia_ioctl.c
index 27523c5..9e507ba 100644
--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ b/drivers/pcmcia/pcmcia_ioctl.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 1d128fb..31f1c5d 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -21,7 +21,6 @@
 #include <linux/pci.h>
 #include <linux/device.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index b440900..2b8531f 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -27,7 +27,6 @@
 #include <asm/system.h>
 #include <asm/irq.h>
 
-#define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
 #include <pcmcia/cs.h>

