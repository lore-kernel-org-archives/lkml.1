Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbXK1MhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbXK1MhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbXK1Mgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:36:52 -0500
Received: (root@vger.kernel.org) by vger.kernel.org id S1756140AbXK1Mgw
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:36:52 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:44601 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbXK1Kaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:30:35 -0500
Date: Wed, 28 Nov 2007 05:28:36 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] SYNCLINK:  Standardize format of linux header file include's
 with "<>".
Message-ID: <alpine.LFD.0.9999.0711280523110.5242@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use the recommended form of "<>" to include linux header files, and
move those includes up to join the rest of the linux includes.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

outside of the UML stuff, there are precious few examples of including
headers out of include/linux that don't use the "<>" notation, so
clean them up.  and it makes my scanning scripts simpler, too.  so,
yes, it *is* all about me.

not compile tested, it seemed pretty straightforward.

 drivers/char/pcmcia/synclink_cs.c |    3 +--
 drivers/char/synclink.c           |    3 +--
 drivers/char/synclink_gt.c        |    3 +--
 drivers/char/synclinkmp.c         |    3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 8caff0c..279ff50 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -57,6 +57,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/ioctl.h>
+#include <linux/synclink.h>

 #include <asm/system.h>
 #include <asm/io.h>
@@ -87,8 +88,6 @@

 #include <asm/uaccess.h>

-#include "linux/synclink.h"
-
 static MGSL_PARAMS default_params = {
 	MGSL_MODE_HDLC,			/* unsigned long mode */
 	0,				/* unsigned char loopback; */
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 905d1f5..e613e2e 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -85,6 +85,7 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/ioctl.h>
+#include <linux/synclink.h>

 #include <asm/system.h>
 #include <asm/io.h>
@@ -110,8 +111,6 @@

 #include <asm/uaccess.h>

-#include "linux/synclink.h"
-
 #define RCLRVALUE 0xffff

 static MGSL_PARAMS default_params = {
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 64e835f..5f6a5da 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -73,6 +73,7 @@
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/hdlc.h>
+#include <linux/synclink.h>

 #include <asm/system.h>
 #include <asm/io.h>
@@ -81,8 +82,6 @@
 #include <asm/types.h>
 #include <asm/uaccess.h>

-#include "linux/synclink.h"
-
 #if defined(CONFIG_HDLC) || (defined(CONFIG_HDLC_MODULE) && defined(CONFIG_SYNCLINK_GT_MODULE))
 #define SYNCLINK_GENERIC_HDLC 1
 #else
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index c63013b..f3e7807 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -66,6 +66,7 @@
 #include <linux/termios.h>
 #include <linux/workqueue.h>
 #include <linux/hdlc.h>
+#include <linux/synclink.h>

 #if defined(CONFIG_HDLC) || (defined(CONFIG_HDLC_MODULE) && defined(CONFIG_SYNCLINKMP_MODULE))
 #define SYNCLINK_GENERIC_HDLC 1
@@ -80,8 +81,6 @@

 #include <asm/uaccess.h>

-#include "linux/synclink.h"
-
 static MGSL_PARAMS default_params = {
 	MGSL_MODE_HDLC,			/* unsigned long mode */
 	0,				/* unsigned char loopback; */

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
