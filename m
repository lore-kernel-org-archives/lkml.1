Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbYBHNRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbYBHNRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbYBHNRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:17:34 -0500
Received: from bb-87-81-255-5.ukonline.co.uk ([87.81.255.5]:52281 "EHLO
	pegasus." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org with ESMTP
	id S1752644AbYBHNRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:17:33 -0500
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 08:17:18 EST
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH 2/2] toshiba - Move Kconfig entry to drivers/char
To: linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Jonathan Buzzard <jonathan@buzzard.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 08 Feb 2008 12:47:32 +0000
Message-ID: <20080208124731.16369.20235.stgit@localhost>
In-Reply-To: <20080208124721.16369.76502.stgit@localhost>
References: <20080208124721.16369.76502.stgit@localhost>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source code for this driver is currently located in drivers/char, and
given that this is not an x86 processor feature, it shouldn't live in the
x86 Kconfig.

So lets move it to the Kconfig for drivers/char instead.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Jonathan Buzzard <jonathan@buzzard.org.uk>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---

 arch/x86/Kconfig     |   16 ----------------
 drivers/char/Kconfig |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beaf268..01ad8d2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -616,22 +616,6 @@ config VM86
           XFree86 to initialize some video cards via BIOS. Disabling this
           option saves about 6k.
 
-config TOSHIBA
-	tristate "Toshiba Laptop support"
-	depends on X86_32
-	---help---
-	  This adds a driver to safely access the System Management Mode of
-	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
-	  not work on models with a Phoenix BIOS. The System Management Mode
-	  is used to set the BIOS and power saving options on Toshiba portables.
-
-	  For information on utilities to make use of this driver see the
-	  Toshiba Linux utilities web site at:
-	  <http://www.buzzard.org.uk/toshiba/>.
-
-	  Say Y if you intend to run this kernel on a Toshiba portable.
-	  Say N otherwise.
-
 config X86_REBOOTFIXUPS
 	def_bool n
 	prompt "Enable X86 board specific fixups for reboot"
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 37861c4..aa3ac8e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -901,6 +901,22 @@ config SONYPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called sonypi.
 
+config TOSHIBA
+	tristate "Toshiba Laptop support"
+	depends on X86_32
+	---help---
+	  This adds a driver to safely access the System Management Mode of
+	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
+	  not work on models with a Phoenix BIOS. The System Management Mode
+	  is used to set the BIOS and power saving options on Toshiba portables.
+
+	  For information on utilities to make use of this driver see the
+	  Toshiba Linux utilities web site at:
+	  <http://www.buzzard.org.uk/toshiba/>.
+
+	  Say Y if you intend to run this kernel on a Toshiba portable.
+	  Say N otherwise.
+
 config GPIO_TB0219
 	tristate "TANBAC TB0219 GPIO support"
 	depends on TANBAC_TB022X

