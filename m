Return-Path: <linux-kernel-owner+w=401wt.eu-S1765354AbXEUXHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765354AbXEUXHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbXEUXHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:07:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57753 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbXEUXHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:07:36 -0400
Date: Mon, 21 May 2007 16:11:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, tglx@linutronix.de
Subject: [PATCH] doc. clocksources
Message-Id: <20070521161122.eb419bcb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Document the available clocksources per platform and move
clocksource= into the correct (alpha) location in the file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- linux-2622-rc2.orig/Documentation/kernel-parameters.txt
+++ linux-2622-rc2/Documentation/kernel-parameters.txt
@@ -396,6 +396,26 @@ and is between 256 and 4096 characters. 
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
+	clocksource=	[GENERIC_TIME] Override the default clocksource
+			Format: <string>
+			Override the default clocksource and use the clocksource
+			with the name specified.
+			Some clocksource names to choose from, depending on
+			the platform:
+			[all] jiffies (this is the base, fallback clocksource)
+			[ACPI] acpi_pm
+			[ARM] imx_timer1,OSTS,netx_timer,mpu_timer2,
+				pxa_timer,timer3,32k_counter,timer0_1
+			[AVR32] avr32
+			[IA-32] pit,hpet,tsc,vmi-timer;
+				scx200_hrt on Geode; cyclone on IBM x440
+			[MIPS] MIPS
+			[PARISC] cr16
+			[S390] tod
+			[SH] SuperH
+			[SPARC64] tick
+			[X86-64] hpet,tsc
+
 	code_bytes	[IA32] How many bytes of object code to print in an
 			oops report.
 			Range: 0 - 8192
@@ -1807,10 +1827,6 @@ and is between 256 and 4096 characters. 
 
 	time		Show timing data prefixed to each printk message line
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
-			Override the default clocksource and use the clocksource
-			with the name specified.
-
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
 			(default 15).
