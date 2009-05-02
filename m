Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbZEBUEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbZEBUEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbZEBUCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:02:09 -0400
Received: from www.tglx.de ([62.245.132.106]:55742 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbZEBUCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:02:08 -0400
Message-Id: <20090502195925.908223458@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:01:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [patch 08/11] m32r: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=m32r-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Hirokazu Takata <takata@linux-m32r.org>

---
 arch/m32r/platforms/m32104ut/setup.c |    2 +-
 arch/m32r/platforms/m32700ut/setup.c |    8 ++++----
 arch/m32r/platforms/mappi/setup.c    |    2 +-
 arch/m32r/platforms/mappi2/setup.c   |    2 +-
 arch/m32r/platforms/mappi3/setup.c   |    2 +-
 arch/m32r/platforms/oaks32r/setup.c  |    2 +-
 arch/m32r/platforms/opsput/setup.c   |    8 ++++----
 arch/m32r/platforms/usrv/setup.c     |    4 ++--
 8 files changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/m32r/platforms/m32104ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32104ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32104ut/setup.c
@@ -63,7 +63,7 @@ static void shutdown_m32104ut_irq(unsign
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32104ut_irq_type =
+static struct irq_chip m32104ut_irq_type =
 {
 	.typename = "M32104UT-IRQ",
 	.startup = startup_m32104ut_irq,
Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -69,7 +69,7 @@ static void shutdown_m32700ut_irq(unsign
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_irq_type =
+static struct irq_chip m32700ut_irq_type =
 {
 	.typename = "M32700UT-IRQ",
 	.startup = startup_m32700ut_irq,
@@ -146,7 +146,7 @@ static void shutdown_m32700ut_pld_irq(un
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_pld_irq_type =
+static struct irq_chip m32700ut_pld_irq_type =
 {
 	.typename = "M32700UT-PLD-IRQ",
 	.startup = startup_m32700ut_pld_irq,
@@ -215,7 +215,7 @@ static void shutdown_m32700ut_lanpld_irq
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_lanpld_irq_type =
+static struct irq_chip m32700ut_lanpld_irq_type =
 {
 	.typename = "M32700UT-PLD-LAN-IRQ",
 	.startup = startup_m32700ut_lanpld_irq,
@@ -284,7 +284,7 @@ static void shutdown_m32700ut_lcdpld_irq
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_lcdpld_irq_type =
+static struct irq_chip m32700ut_lcdpld_irq_type =
 {
 	.typename = "M32700UT-PLD-LCD-IRQ",
 	.startup = startup_m32700ut_lcdpld_irq,
Index: linux-2.6/arch/m32r/platforms/mappi/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi/setup.c
@@ -63,7 +63,7 @@ static void shutdown_mappi_irq(unsigned 
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi_irq_type =
+static struct irq_chip mappi_irq_type =
 {
 	.typename = "MAPPI-IRQ",
 	.startup = startup_mappi_irq,
Index: linux-2.6/arch/m32r/platforms/mappi2/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi2/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi2/setup.c
@@ -70,7 +70,7 @@ static void shutdown_mappi2_irq(unsigned
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi2_irq_type =
+static struct irq_chip mappi2_irq_type =
 {
 	.typename = "MAPPI2-IRQ",
 	.startup = startup_mappi2_irq,
Index: linux-2.6/arch/m32r/platforms/mappi3/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi3/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi3/setup.c
@@ -70,7 +70,7 @@ static void shutdown_mappi3_irq(unsigned
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi3_irq_type =
+static struct irq_chip mappi3_irq_type =
 {
 	.typename = "MAPPI3-IRQ",
 	.startup = startup_mappi3_irq,
Index: linux-2.6/arch/m32r/platforms/oaks32r/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/oaks32r/setup.c
+++ linux-2.6/arch/m32r/platforms/oaks32r/setup.c
@@ -61,7 +61,7 @@ static void shutdown_oaks32r_irq(unsigne
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type oaks32r_irq_type =
+static struct irq_chip oaks32r_irq_type =
 {
 	.typename = "OAKS32R-IRQ",
 	.startup = startup_oaks32r_irq,
Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -70,7 +70,7 @@ static void shutdown_opsput_irq(unsigned
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_irq_type =
+static struct irq_chip opsput_irq_type =
 {
 	.typename = "OPSPUT-IRQ",
 	.startup = startup_opsput_irq,
@@ -147,7 +147,7 @@ static void shutdown_opsput_pld_irq(unsi
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_pld_irq_type =
+static struct irq_chip opsput_pld_irq_type =
 {
 	.typename = "OPSPUT-PLD-IRQ",
 	.startup = startup_opsput_pld_irq,
@@ -216,7 +216,7 @@ static void shutdown_opsput_lanpld_irq(u
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_lanpld_irq_type =
+static struct irq_chip opsput_lanpld_irq_type =
 {
 	.typename = "OPSPUT-PLD-LAN-IRQ",
 	.startup = startup_opsput_lanpld_irq,
@@ -285,7 +285,7 @@ static void shutdown_opsput_lcdpld_irq(u
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_lcdpld_irq_type =
+static struct irq_chip opsput_lcdpld_irq_type =
 {
 	"OPSPUT-PLD-LCD-IRQ",
 	startup_opsput_lcdpld_irq,
Index: linux-2.6/arch/m32r/platforms/usrv/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/usrv/setup.c
+++ linux-2.6/arch/m32r/platforms/usrv/setup.c
@@ -61,7 +61,7 @@ static void shutdown_mappi_irq(unsigned 
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi_irq_type =
+static struct irq_chip mappi_irq_type =
 {
 	.typename = "M32700-IRQ",
 	.startup = startup_mappi_irq,
@@ -134,7 +134,7 @@ static void shutdown_m32700ut_pld_irq(un
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_pld_irq_type =
+static struct irq_chip m32700ut_pld_irq_type =
 {
 	.typename = "USRV-PLD-IRQ",
 	.startup = startup_m32700ut_pld_irq,


