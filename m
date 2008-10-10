Return-Path: <linux-kernel-owner+w=401wt.eu-S1764815AbYJJV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764815AbYJJV4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764161AbYJJV4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:56:18 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:52564 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763756AbYJJV4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:56:17 -0400
Date: Fri, 10 Oct 2008 23:56:14 +0200
From: FD Cami <francois.cami@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Alex Howells <alex@bytemark.co.uk>,
       Nick Warne <nick@ukfsn.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Remove Andrew Morton's andrewm@uow.edu.au
Message-ID: <20081010235614.35e29794@moria>
In-Reply-To: <20081010111031.9518a142.akpm@linux-foundation.org>
References: <20081010151539.6a2ff040@sauron.linicks.net>
	<48EF6B47.1080800@bytemark.co.uk>
	<20081010093427.31ddb955.randy.dunlap@oracle.com>
	<20081010192600.547eedcc@moria>
	<20081010111031.9518a142.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 11:10:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 10 Oct 2008 19:26:00 +0200 FD Cami <francois.cami@free.fr> wrote:
> 
> > Also, should we change all instances of your old email addresses to the current one ?
> 
> If they're there, please just delete any email address.  People can use
> the real name an an index into MAINTAINERS to find the current email
> address.

Remove Andrew Morton's andrewm@uow.edu.au email address.
I totally missed that one on my first pass.

Andrew, if you'd rather have a single patch for this, please ping me.

Signed-off-by: Francois Cami <francois.cami@free.fr>


diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/Documentation/networking/cs89x0.txt linux-2.6.27-mine-akpm-email-v2/Documentation/networking/cs89x0.txt
--- linux-2.6.27-mine-akpm-email-v1/Documentation/networking/cs89x0.txt	2008-10-10 23:38:31.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/Documentation/networking/cs89x0.txt	2008-10-10 23:28:00.000000000 +0200
@@ -3,7 +3,7 @@ NOTE
 ----
 
 This document was contributed by Cirrus Logic for kernel 2.2.5.  This version
-has been updated for 2.3.48 by Andrew Morton <andrewm@uow.edu.au>
+has been updated for 2.3.48 by Andrew Morton.
 
 Cirrus make a copy of this driver available at their website, as
 described below.  In general, you should use the driver version which
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/Documentation/networking/vortex.txt linux-2.6.27-mine-akpm-email-v2/Documentation/networking/vortex.txt
--- linux-2.6.27-mine-akpm-email-v1/Documentation/networking/vortex.txt	2008-10-10 23:38:31.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/Documentation/networking/vortex.txt	2008-10-10 23:27:45.000000000 +0200
@@ -1,5 +1,5 @@
 Documentation/networking/vortex.txt
-Andrew Morton <andrewm@uow.edu.au>
+Andrew Morton
 30 April 2000
 
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/drivers/char/vt.c linux-2.6.27-mine-akpm-email-v2/drivers/char/vt.c
--- linux-2.6.27-mine-akpm-email-v1/drivers/char/vt.c	2008-10-10 23:38:03.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/drivers/char/vt.c	2008-10-10 23:31:14.000000000 +0200
@@ -59,7 +59,7 @@
  * by Martin Mares <mj@atrey.karlin.mff.cuni.cz>, July 1998
  *
  * Removed old-style timers, introduced console_timer, made timer
- * deletion SMP-safe.  17Jun00, Andrew Morton <andrewm@uow.edu.au>
+ * deletion SMP-safe.  17Jun00, Andrew Morton 
  *
  * Removed console_lock, enabled interrupts across all console operations
  * 13 March 2001, Andrew Morton
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/drivers/net/3c509.c linux-2.6.27-mine-akpm-email-v2/drivers/net/3c509.c
--- linux-2.6.27-mine-akpm-email-v1/drivers/net/3c509.c	2008-10-10 23:37:54.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/drivers/net/3c509.c	2008-10-10 23:28:49.000000000 +0200
@@ -40,7 +40,7 @@
 		v1.14 10/15/97 Avoided waiting..discard message for fast machines -djb
 		v1.15 1/31/98 Faster recovery for Tx errors. -djb
 		v1.16 2/3/98 Different ID port handling to avoid sound cards. -djb
-		v1.18 12Mar2001 Andrew Morton <andrewm@uow.edu.au>
+		v1.18 12Mar2001 Andrew Morton
 			- Avoid bogus detect of 3c590's (Andrzej Krzysztofowicz)
 			- Reviewed against 1.18 from scyld.com
 		v1.18a 17Nov2001 Jeff Garzik <jgarzik@pobox.com>
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/drivers/net/cs89x0.c linux-2.6.27-mine-akpm-email-v2/drivers/net/cs89x0.c
--- linux-2.6.27-mine-akpm-email-v1/drivers/net/cs89x0.c	2008-10-10 23:37:54.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/drivers/net/cs89x0.c	2008-10-10 23:30:30.000000000 +0200
@@ -36,8 +36,7 @@
 
   Alan Cox          : Removed 1.2 support, added 2.1 extra counters.
 
-  Andrew Morton     : andrewm@uow.edu.au
-                    : Kernel 2.3.48
+  Andrew Morton     : Kernel 2.3.48
                     : Handle kmalloc() failures
                     : Other resource allocation fixes
                     : Add SMP locks
@@ -49,7 +48,7 @@
                     : Fixed an out-of-mem bug in dma_rx()
                     : Updated Documentation/networking/cs89x0.txt
 
-  Andrew Morton     : andrewm@uow.edu.au / Kernel 2.3.99-pre1
+  Andrew Morton     : Kernel 2.3.99-pre1
                     : Use skb_reserve to longword align IP header (two places)
                     : Remove a delay loop from dma_rx()
                     : Replace '100' with HZ
@@ -57,11 +56,11 @@
                     : Added 'cs89x0_dma=N' kernel boot option
                     : Correctly initialise lp->lock in non-module compile
 
-  Andrew Morton     : andrewm@uow.edu.au / Kernel 2.3.99-pre4-1
+  Andrew Morton     : Kernel 2.3.99-pre4-1
                     : MOD_INC/DEC race fix (see
                     : http://www.uwsg.indiana.edu/hypermail/linux/kernel/0003.3/1532.html)
 
-  Andrew Morton     : andrewm@uow.edu.au / Kernel 2.4.0-test7-pre2
+  Andrew Morton     : Kernel 2.4.0-test7-pre2
                     : Enhanced EEPROM support to cover more devices,
                     :   abstracted IRQ mapping to support CONFIG_ARCH_CLPS7500 arch
                     :   (Jason Gunthorpe <jgg@ualberta.ca>)
@@ -156,7 +155,7 @@
 #include "cs89x0.h"
 
 static char version[] __initdata =
-"cs89x0.c: v2.4.3-pre1 Russell Nelson <nelson@crynwr.com>, Andrew Morton <andrewm@uow.edu.au>\n";
+"cs89x0.c: v2.4.3-pre1 Russell Nelson <nelson@crynwr.com>, Andrew Morton\n";
 
 #define DRV_NAME "cs89x0"
 
@@ -1871,7 +1870,7 @@ MODULE_PARM_DESC(dmasize , "(ignored)");
 MODULE_PARM_DESC(use_dma , "(ignored)");
 #endif
 
-MODULE_AUTHOR("Mike Cruse, Russwll Nelson <nelson@crynwr.com>, Andrew Morton <andrewm@uow.edu.au>");
+MODULE_AUTHOR("Mike Cruse, Russwll Nelson <nelson@crynwr.com>, Andrew Morton");
 MODULE_LICENSE("GPL");
 
 
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/drivers/parport/ChangeLog linux-2.6.27-mine-akpm-email-v2/drivers/parport/ChangeLog
--- linux-2.6.27-mine-akpm-email-v1/drivers/parport/ChangeLog	2008-10-10 23:38:01.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/drivers/parport/ChangeLog	2008-10-10 23:30:48.000000000 +0200
@@ -311,7 +311,7 @@
 	* ieee1284_ops.c (parport_ieee1284_read_nibble): Reset nAutoFd
 	on timeout.  Matches 2.2.x behaviour.
 
-2001-03-02  Andrew Morton <andrewm@uow.edu.au>
+2001-03-02  Andrew Morton
 
 	* parport_pc.c (registered_parport): New static variable.
 	(parport_pc_find_ports): Set it when we register PCI driver.
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/kernel/printk.c linux-2.6.27-mine-akpm-email-v2/kernel/printk.c
--- linux-2.6.27-mine-akpm-email-v1/kernel/printk.c	2008-10-10 23:37:41.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/kernel/printk.c	2008-10-10 23:28:32.000000000 +0200
@@ -13,7 +13,7 @@
  * Fixed SMP synchronization, 08/08/99, Manfred Spraul
  *     manfred@colorfullife.com
  * Rewrote bits to get rid of console_lock
- *	01Mar01 Andrew Morton <andrewm@uow.edu.au>
+ *	01Mar01 Andrew Morton
  */
 
 #include <linux/kernel.h>
diff -uprN -X linux-2.6.27/Documentation/dontdiff linux-2.6.27-mine-akpm-email-v1/kernel/workqueue.c linux-2.6.27-mine-akpm-email-v2/kernel/workqueue.c
--- linux-2.6.27-mine-akpm-email-v1/kernel/workqueue.c	2008-10-10 23:37:41.000000000 +0200
+++ linux-2.6.27-mine-akpm-email-v2/kernel/workqueue.c	2008-10-10 23:28:18.000000000 +0200
@@ -9,7 +9,7 @@
  * Derived from the taskqueue/keventd code by:
  *
  *   David Woodhouse <dwmw2@infradead.org>
- *   Andrew Morton <andrewm@uow.edu.au>
+ *   Andrew Morton
  *   Kai Petzke <wpp@marie.physik.tu-berlin.de>
  *   Theodore Ts'o <tytso@mit.edu>
  *
