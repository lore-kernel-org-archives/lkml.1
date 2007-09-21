Return-Path: <linux-kernel-owner+w=401wt.eu-S1764737AbXIUWdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764737AbXIUWdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762842AbXIUWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:57030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762048AbXIUWcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:03 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: oliver.pntr@gmail.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Message-Id: <20070921223202.2504813DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Oliver Pinter" <oliver.pntr@gmail.com>

add cpu core name for arch/i386/Kconfig.cpu:Pentium 4 sections help
add Pentium D for arch/i386/Kconfig.cpu
add Pentium D for arch/x86_64/Kconfig

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu |   34 +++++++++++++++++++++++++++++++---
 arch/x86_64/Kconfig   |    6 +++---
 2 files changed, 34 insertions(+), 6 deletions(-)

Index: linux/arch/i386/Kconfig.cpu
===================================================================
--- linux.orig/arch/i386/Kconfig.cpu
+++ linux/arch/i386/Kconfig.cpu
@@ -115,11 +115,39 @@ config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
 	help
 	  Select this for Intel Pentium 4 chips.  This includes the
-	  Pentium 4, P4-based Celeron and Xeon, and Pentium-4 M
-	  (not Pentium M) chips.  This option enables compile flags
-	  optimized for the chip, uses the correct cache shift, and
+	  Pentium 4, Pentium D, P4-based Celeron and Xeon, and
+	  Pentium-4 M (not Pentium M) chips.  This option enables compile
+	  flags optimized for the chip, uses the correct cache shift, and
 	  applies any applicable Pentium III optimizations.
 
+	  CPUIDs: F[0-6][1-A] (in /proc/cpuinfo show = cpu family : 15 )
+
+	  Select this for:
+	    Pentiums (Pentium 4, Pentium D, Celeron, Celeron D) corename:
+		-Willamette
+		-Northwood
+		-Mobile Pentium 4
+		-Mobile Pentium 4 M
+		-Extreme Edition (Gallatin)
+		-Prescott
+		-Prescott 2M
+		-Cedar Mill
+		-Presler
+		-Smithfiled
+	    Xeons (Intel Xeon, Xeon MP, Xeon LV, Xeon MV) corename:
+	    	-Foster
+		-Prestonia
+		-Gallatin
+		-Nocona
+		-Irwindale
+		-Cranford
+		-Potomac
+		-Paxville
+		-Dempsey
+
+	  more info: http://balusc.xs4all.nl/srv/har-cpu.html
+
+
 config MK6
 	bool "K6/K6-II/K6-III"
 	help
Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -169,9 +169,9 @@ config MK8
 config MPSC
        bool "Intel P4 / older Netburst based Xeon"
        help
-	  Optimize for Intel Pentium 4 and older Nocona/Dempsey Xeon CPUs
-	  with Intel Extended Memory 64 Technology(EM64T). For details see
-	  <http://www.intel.com/technology/64bitextensions/>.
+	  Optimize for Intel Pentium 4, Pentium D and older Nocona/Dempsey
+	  Xeon CPUs with Intel Extended Memory 64 Technology(EM64T). For
+	  details see <http://www.intel.com/technology/64bitextensions/>.
 	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
           Netburst core and shouldn't use this option. You can distinguish them
 	  using the cpu family field
