Return-Path: <linux-kernel-owner+w=401wt.eu-S1764994AbZA2A0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764994AbZA2A0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZA1XrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:53425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758885AbZA1XrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:13 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 108/114] x86: move ELAN to the NON_STANDARD_PLATFORM section
Date: Wed, 28 Jan 2009 23:42:54 +0000
Message-Id: <1233186180-29883-109-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move X86_ELAN (old, AMD based web-boxes) from the subarchitecture
menu to the non-standard-platform section.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b090e5a..b7617e3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -271,16 +271,6 @@ config X86_PC
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
-config X86_ELAN
-	bool "AMD Elan"
-	depends on X86_32
-	help
-	  Select this for an AMD Elan processor.
-
-	  Do not use this option for K6/Athlon/Opteron processors!
-
-	  If unsure, choose "PC-compatible" instead.
-
 config X86_VOYAGER
 	bool "Voyager (NCR)"
 	depends on X86_32 && SMP && !PCI && BROKEN
@@ -394,6 +384,17 @@ config X86_UV
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.
 
+config X86_ELAN
+	bool "AMD Elan"
+	depends on X86_32
+	depends on X86_NON_STANDARD
+	help
+	  Select this for an AMD Elan processor.
+
+	  Do not use this option for K6/Athlon/Opteron processors!
+
+	  If unsure, choose "PC-compatible" instead.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
-- 
1.6.0.2

