Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbXI3DTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbXI3DTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXI3DTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:19:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39644
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273AbXI3DTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:19:45 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add missing entries to top level Documentation/00-INDEX
Date: Sat, 29 Sep 2007 22:19:41 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709292219.41891.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add missing entries to Documentation/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/00-INDEX |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -r dc28e4e17791 Documentation/00-INDEX
--- a/Documentation/00-INDEX	Wed Sep 26 15:52:17 2007 -0700
+++ b/Documentation/00-INDEX	Sat Sep 29 14:07:39 2007 -0500
@@ -22,6 +21,8 @@ CodingStyle
 	- how the boss likes the C code in the kernel to look.
 DMA-API.txt
 	- DMA API, pci_ API & extensions for non-consistent memory machines.
+DMA-ISA-LPC.txt
+	- How to do DMA with ISA (and LPC) devices.
 DMA-mapping.txt
 	- info for PCI drivers using DMA portably across all platforms.
 DocBook/
@@ -50,6 +51,8 @@ README.cycladesZ
 	- info on Cyclades-Z firmware loading.
 SAK.txt
 	- info on Secure Attention Keys.
+SM501.txt
+	- Silicon Motion SM501 multimedia companion chip
 SecurityBugs
 	- procedure for reporting security bugs found in the kernel.
 SubmitChecklist
@@ -248,6 +251,8 @@ md.txt
 	- info on boot arguments for the multiple devices driver.
 memory-barriers.txt
 	- info on Linux kernel memory barriers.
+memory-hotplug.txt
+	- Hotpluggable memory support, how to use and current status.
 memory.txt
 	- info on typical Linux memory problems.
 mips/
@@ -298,6 +303,8 @@ pm.txt
 	- info on Linux power management support.
 pnp.txt
 	- Linux Plug and Play documentation.
+power_supply_class.txt
+	- Tells userspace about battery, UPS, AC or DC power supply properties
 power/
 	- directory with info on Linux PCI power management.
 powerpc/
@@ -334,8 +341,12 @@ sched-coding.txt
 	- reference for various scheduler-related methods in the O(1) scheduler.
 sched-design.txt
 	- goals, design and implementation of the Linux O(1) scheduler.
+sched-design-CFS.txt
+	- goals, design and implementation of the Complete Fair Scheduler.
 sched-domains.txt
 	- information on scheduling domains.
+sched-nice-design.txt
+	- How and why the scheduler's nice levels are implemented.
 sched-stats.txt
 	- information on schedstats (Linux Scheduler Statistics).
 scsi/
@@ -380,6 +391,8 @@ stallion.txt
 	- info on using the Stallion multiport serial driver.
 svga.txt
 	- short guide on selecting video modes at boot via VGA BIOS.
+sysfs-rules.txt
+	- How not to use sysfs.
 sx.txt
 	- info on the Specialix SX/SI multiport serial driver.
 sysctl/
@@ -410,6 +423,8 @@ video4linux/
 	- directory with info regarding video/TV/radio cards and linux.
 vm/
 	- directory with info on the Linux vm code.
+volatile-considered-harmful.txt
+	- Why the "volatile" type class should not be used
 voyager.txt
 	- guide to running Linux on the Voyager architecture.
 w1/

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
