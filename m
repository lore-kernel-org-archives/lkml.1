Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXKEOZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXKEOZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXKEOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:25:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:57997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbXKEOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:25:23 -0500
Date: Mon, 5 Nov 2007 15:23:30 +0100
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: buytenh@wantstofly.org, dsaxena@plexity.net,
       Andre Haupt <andre@bitwigglers.org>
Subject: [patch 1/1] ixp23xx: fix some double includes
Message-ID: <20071105142330.GA27398@ahaupt-debian-vm.localdomain>
References: <20071105142114.977138260@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=ixp23xx_fix_includes
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX18fuAfnkW6CsDnnkXeLriyaYmThrdwtNKonEzY
 1aWH3zThFEVpKYB7BZUgRtXMRMspsy/0qKlOT+L2QXla6eBe19
 bqfgJaQSL/vIy/YZyelvIWyHpUkz+7/tcAAQV0FilI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 arch/arm/mach-ixp23xx/core.c       |    1 -
 arch/arm/mach-ixp23xx/espresso.c   |    2 --
 arch/arm/mach-ixp23xx/ixdp2351.c   |    2 --
 arch/arm/mach-ixp23xx/roadrunner.c |    2 --
 4 files changed, 7 deletions(-)

Index: linus/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linus.orig/arch/arm/mach-ixp23xx/core.c	2007-11-05 15:12:25.000000000 +0100
+++ linus/arch/arm/mach-ixp23xx/core.c	2007-11-05 15:12:45.000000000 +0100
@@ -19,7 +19,6 @@
 #include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/serial.h>
Index: linus/arch/arm/mach-ixp23xx/espresso.c
===================================================================
--- linus.orig/arch/arm/mach-ixp23xx/espresso.c	2007-11-05 15:13:46.000000000 +0100
+++ linus/arch/arm/mach-ixp23xx/espresso.c	2007-11-05 15:14:46.000000000 +0100
@@ -15,7 +15,6 @@
 #include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
@@ -38,7 +37,6 @@
 #include <asm/pgtable.h>
 
 #include <asm/mach/map.h>
-#include <asm/mach/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/pci.h>
Index: linus/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linus.orig/arch/arm/mach-ixp23xx/ixdp2351.c	2007-11-05 15:15:15.000000000 +0100
+++ linus/arch/arm/mach-ixp23xx/ixdp2351.c	2007-11-05 15:15:38.000000000 +0100
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
@@ -42,7 +41,6 @@
 #include <asm/pgtable.h>
 
 #include <asm/mach/map.h>
-#include <asm/mach/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/pci.h>
Index: linus/arch/arm/mach-ixp23xx/roadrunner.c
===================================================================
--- linus.orig/arch/arm/mach-ixp23xx/roadrunner.c	2007-11-05 15:15:55.000000000 +0100
+++ linus/arch/arm/mach-ixp23xx/roadrunner.c	2007-11-05 15:16:15.000000000 +0100
@@ -19,7 +19,6 @@
 #include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
@@ -42,7 +41,6 @@
 #include <asm/pgtable.h>
 
 #include <asm/mach/map.h>
-#include <asm/mach/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/pci.h>

--
