Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYKALPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYKALPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYKALPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:15:44 -0400
Received: from www.steve.org.uk ([80.68.85.46]:45225 "EHLO skx.xen-hosting.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYKALPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:15:43 -0400
Date: Sat, 1 Nov 2008 11:15:38 +0000
From: Steve Kemp <steve.30-11-2008.date@steve.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Many headers included multiple times
Message-ID: <20081101111538.GA16874@steve.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  There are many source files which include the same header multiple
 times.  Minimal initial patch included here, will submit the rest
 shortly if there is interest.

  Quick tool to detect these: http://www.steve.org.uk/Software/kernel/

  Signed-off-by: Steve Kemp <steve@steve.org.uk>

diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/mtd/onenand/omap2.c linux-2.6.28-rc2/drivers/mtd/onenand/omap2.c
--- linux-2.6.28-rc2.orig/drivers/mtd/onenand/omap2.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/mtd/onenand/omap2.c	2008-11-01 11:04:56.000000000 +0000
@@ -38,7 +27,6 @@
 #include <asm/arch/gpmc.h>
 #include <asm/arch/onenand.h>
 #include <asm/arch/gpio.h>
-#include <asm/arch/gpmc.h>
 #include <asm/arch/pm.h>

 #include <linux/dma-mapping.h>
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/net/irda/ks959-sir.c linux-2.6.28-rc2/drivers/net/irda/ks959-sir.c
--- linux-2.6.28-rc2.orig/drivers/net/irda/ks959-sir.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/net/irda/ks959-sir.c	2008-11-01 11:10:44.000000000 +0000
@@ -118,7 +107,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/kref.h>
 #include <linux/usb.h>
 #include <linux/device.h>
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/parisc/ccio-dma.c linux-2.6.28-rc2/drivers/parisc/ccio-dma.c
--- linux-2.6.28-rc2.orig/drivers/parisc/ccio-dma.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/parisc/ccio-dma.c	2008-11-01 11:10:10.000000000 +0000
@@ -70,7 +70,6 @@
 #undef CCIO_COLLECT_STATS
 #endif

-#include <linux/proc_fs.h>
 #include <asm/runway.h>		/* for proc_runway_root */

 #ifdef DEBUG_CCIO_INIT
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/pnp/interface.c linux-2.6.28-rc2/drivers/pnp/interface.c
--- linux-2.6.28-rc2.orig/drivers/pnp/interface.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/pnp/interface.c	2008-11-01 11:08:01.000000000 +0000
@@ -12,7 +12,6 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/types.h>
-#include <linux/pnp.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/scsi/gvp11.c linux-2.6.28-rc2/drivers/scsi/gvp11.c
--- linux-2.6.28-rc2.orig/drivers/scsi/gvp11.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/scsi/gvp11.c	2008-11-01 11:07:12.000000000 +0000
@@ -360,8 +360,6 @@

 #define HOSTS_C

-#include "gvp11.h"
-
 static struct scsi_host_template driver_template = {
 	.proc_name		= "GVP11",
 	.name			= "GVP Series II SCSI",
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/scsi/ibmvscsi/ibmvscsi.c linux-2.6.28-rc2/drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6.28-rc2.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-11-01 11:08:30.000000000 +0000
@@ -72,7 +72,6 @@
 #include <linux/delay.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
-#include <asm/firmware.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/scsi/mvme147.c linux-2.6.28-rc2/drivers/scsi/mvme147.c
--- linux-2.6.28-rc2.orig/drivers/scsi/mvme147.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/scsi/mvme147.c	2008-11-01 11:06:56.000000000 +0000
@@ -130,8 +130,6 @@

 #define HOSTS_C

-#include "mvme147.h"
-
 static struct scsi_host_template driver_template = {
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/video/via/global.h linux-2.6.28-rc2/drivers/video/via/global.h
--- linux-2.6.28-rc2.orig/drivers/video/via/global.h	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/video/via/global.h	2008-11-01 11:05:53.000000000 +0000
@@ -34,26 +34,22 @@
 #include <linux/timer.h>

 #include "debug.h"
-
 #include "iface.h"
 #include "viafbdev.h"
 #include "chip.h"
-#include "debug.h"
 #include "accel.h"
 #include "share.h"
 #include "dvi.h"
 #include "viamode.h"
 #include "via_i2c.h"
 #include "hw.h"
-
 #include "lcd.h"
 #include "ioctl.h"
-#include "viamode.h"
 #include "via_utility.h"
 #include "vt1636.h"
 #include "tblDPASetting.h"
 #include "tbl1636.h"
-#include "viafbdev.h"
+

 /* External struct*/

diff --ignore-space-change --unified --recursive linux-2.6.28-rc2.orig/drivers/xen/balloon.c linux-2.6.28-rc2/drivers/xen/balloon.c
--- linux-2.6.28-rc2.orig/drivers/xen/balloon.c	2008-10-26 19:13:29.000000000 +0000
+++ linux-2.6.28-rc2/drivers/xen/balloon.c	2008-11-01 11:04:21.000000000 +0000
@@ -41,7 +41,6 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
-#include <linux/highmem.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>

Steve
-- 
# The Debian Security Audit Project.
http://www.debian.org/security/audit

