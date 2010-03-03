Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0CCFIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:08:00 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:54740 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab0CCFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:07:53 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 11/11] ST SPEAr: Updated Maintainers and added Documentation/arm/SPEAr
Date: Wed,  3 Mar 2010 10:37:41 +0530
Message-Id: <1267592861-26911-12-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-11-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-8-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-9-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-10-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-11-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 Documentation/arm/SPEAr/overview.txt |   60 ++++++++++++++++++++++++++++++++++
 MAINTAINERS                          |   27 +++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm/SPEAr/overview.txt

diff --git a/Documentation/arm/SPEAr/overview.txt b/Documentation/arm/SPEAr/overview.txt
new file mode 100644
index 0000000..253a35c
--- /dev/null
+++ b/Documentation/arm/SPEAr/overview.txt
@@ -0,0 +1,60 @@
+			SPEAr ARM Linux Overview
+			==========================
+
+Introduction
+------------
+
+  SPEAr (Structured Processor Enhanced Architecture).
+  weblink : http://www.st.com/spear
+
+  The ST Microelectronics SPEAr range of ARM9/CortexA9 System-on-Chip CPUs are
+  supported by the 'spear' platform of ARM Linux. Currently SPEAr300,
+  SPEAr310, SPEAr320 and SPEAr600 SOCs are supported. Support for the SPEAr13XX
+  series is in progress.
+
+  Hierarchy in SPEAr is as follows:
+
+  SPEAr (Platform)
+	- SPEAr3XX (3XX SOC series, based on ARM9)
+		- SPEAr300 (SOC)
+			- SPEAr300_EVB (Evaluation Board)
+		- SPEAr310 (SOC)
+			- SPEAr310_EVB (Evaluation Board)
+		- SPEAr320 (SOC)
+			- SPEAr320_EVB (Evaluation Board)
+	- SPEAr6XX (6XX SOC series, based on ARM9)
+		- SPEAr600 (SOC)
+			- SPEAr600_EVB (Evaluation Board)
+	- SPEAr13XX (13XX SOC series, based on ARM CORTEXA9)
+		- SPEAr1300 (SOC)
+
+  Configuration
+  -------------
+
+  A generic configuration is provided for each machine, and can be used as the
+  default by
+	make spear600_defconfig
+	make spear300_defconfig
+	make spear310_defconfig
+	make spear320_defconfig
+
+  Layout
+  ------
+
+  The common files for multiple machine families (SPEAr3XX, SPEAr6XX and
+  SPEAr13XX) are located in the platform code contained in arch/arm/plat-spear
+  with headers in plat/.
+
+  Each machine series have a directory with name arch/arm/mach-spear followed by
+  series name. Like mach-spear3xx, mach-spear6xx and mach-spear13xx.
+
+  Common file for machines of spear3xx family is mach-spear3xx/spear3xx.c and for
+  spear6xx is mach-spear6xx/spear6xx.c. mach-spear* also contain soc/machine
+  specific files, like spear300.c, spear310.c, spear320.c and spear600.c.
+  mach-spear* also contains board specific files for each machine type.
+
+
+  Document Author
+  ---------------
+
+  Viresh Kumar, (c) 2010 ST Microelectronics
diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..8f11d92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5078,6 +5078,33 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
 S:	Maintained
 F:	arch/sparc/
 
+SPEAR PLATFORM SUPPORT
+M:	Viresh Kumar <viresh.kumar@st.com>
+W:	http://www.st.com/spear
+S:	Maintained
+F:	arch/arm/plat-spear/
+
+SPEAR3XX MACHINE SUPPORT
+M:	Viresh Kumar <viresh.kumar@st.com>
+W:	http://www.st.com/spear
+S:	Maintained
+F:	arch/arm/mach-spear3xx/
+
+SPEAR6XX MACHINE SUPPORT
+M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
+W:	http://www.st.com/spear
+S:	Maintained
+F:	arch/arm/mach-spear6xx/
+
+SPEAR CLOCK FRAMEWORK SUPPORT
+M:	Viresh Kumar <viresh.kumar@st.com>
+W:	http://www.st.com/spear
+S:	Maintained
+F:	arch/arm/mach-spear*/clock.c
+F:	arch/arm/mach-spear*/include/mach/clkdev.h
+F:	arch/arm/plat-spear/clock.c
+F:	arch/arm/plat-spear/include/plat/clock.h and clkdev.h
+
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 M:	Roger Wolff <R.E.Wolff@BitWizard.nl>
 S:	Supported
-- 
1.6.0.2

