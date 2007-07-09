Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbXGIIZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbXGIIZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 04:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXGIIY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 04:24:56 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37830 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGIIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 04:24:56 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 9 Jul 2007 04:22:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Roman Zippel <zippel@linux-m68k.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] KCONFIG: Make "Instrumentation support" non-EXPERIMENTAL.
Message-ID: <Pine.LNX.4.64.0707090419350.23692@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It makes more sense to make instrumentation support experimental on a
case-by-case basis.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 arch/i386/Kconfig    |    1 -
 arch/ia64/Kconfig    |    1 -
 arch/powerpc/Kconfig |    1 -
 arch/sparc/Kconfig   |    1 -
 arch/sparc64/Kconfig |    1 -
 arch/x86_64/Kconfig  |    1 -
 6 files changed, 6 deletions(-)

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index b1b2b30..02412aa 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1213,7 +1213,6 @@ source "drivers/Kconfig"
 source "fs/Kconfig"

 menu "Instrumentation Support"
-	depends on EXPERIMENTAL

 source "arch/i386/oprofile/Kconfig"

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index de1bff6..4b32cca 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -575,7 +575,6 @@ config IRQ_PER_CPU
 source "arch/ia64/hp/sim/Kconfig"

 menu "Instrumentation Support"
-        depends on EXPERIMENTAL

 source "arch/ia64/oprofile/Kconfig"

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 5eaeafd..07a5e21 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -889,7 +889,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconfig"
 source "lib/Kconfig"

 menu "Instrumentation Support"
-	depends on EXPERIMENTAL

 source "arch/powerpc/oprofile/Kconfig"

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index fbcc00c..e6dff84 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -309,7 +309,6 @@ endmenu
 source "fs/Kconfig"

 menu "Instrumentation Support"
-	depends on EXPERIMENTAL

 source "arch/sparc/oprofile/Kconfig"

diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 89a1b46..964cd19 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -434,7 +434,6 @@ source "drivers/fc4/Kconfig"
 source "fs/Kconfig"

 menu "Instrumentation Support"
-        depends on EXPERIMENTAL

 source "arch/sparc64/oprofile/Kconfig"

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 5ce9443..0a598fc 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -765,7 +765,6 @@ source "drivers/firmware/Kconfig"
 source fs/Kconfig

 menu "Instrumentation Support"
-        depends on EXPERIMENTAL

 source "arch/x86_64/oprofile/Kconfig"

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
