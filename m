Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbXIUWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbXIUWd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763129AbXIUWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:57035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762091AbXIUWcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:04 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: oliver.pntr@gmail.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/50] i386: change order in Kconfig.cpu
Message-Id: <20070921223203.3370B13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Oliver Pinter" <oliver.pntr@gmail.com>

Change the sort in arch/i386/Kconfig.cpu file, while it is logicaller (by
productions time-line).

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux/arch/i386/Kconfig.cpu
===================================================================
--- linux.orig/arch/i386/Kconfig.cpu
+++ linux/arch/i386/Kconfig.cpu
@@ -104,13 +104,6 @@ config MPENTIUMM
 	  Select this for Intel Pentium M (not Pentium-4 M)
 	  notebook chips.
 
-config MCORE2
-	bool "Core 2/newer Xeon"
-	help
-	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-	  CPUs. You can distinguish newer from older Xeons by the CPU family
-	  in /proc/cpuinfo. Newer ones have 6.
-
 config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
 	help
@@ -147,6 +140,12 @@ config MPENTIUM4
 
 	  more info: http://balusc.xs4all.nl/srv/har-cpu.html
 
+config MCORE2
+	bool "Core 2/newer Xeon"
+	help
+	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
+	  CPUs. You can distinguish newer from older Xeons by the CPU family
+	  in /proc/cpuinfo. Newer ones have 6.
 
 config MK6
 	bool "K6/K6-II/K6-III"
