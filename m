Return-Path: <linux-kernel-owner+w=401wt.eu-S1765320AbZA2A1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765320AbZA2A1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZA1XrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbZA1XrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:24 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 109/114] x86: move VOYAGER to the NON_STANDARD_PLATFORM section
Date: Wed, 28 Jan 2009 23:42:55 +0000
Message-Id: <1233186180-29883-110-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move X86_ELAN (old, NCR hw platform built on Intel CPUs) from the
subarchitecture menu to the non-standard-platform section.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b7617e3..207dc95 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -271,18 +271,6 @@ config X86_PC
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
-config X86_VOYAGER
-	bool "Voyager (NCR)"
-	depends on X86_32 && SMP && !PCI && BROKEN
-	help
-	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
-	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
-
-	  *** WARNING ***
-
-	  If you do not specifically know you have a Voyager based machine,
-	  say N here, otherwise the kernel you build will not be bootable.
-
 config X86_GENERICARCH
        bool "Generic architecture"
 	depends on X86_32
@@ -395,6 +383,19 @@ config X86_ELAN
 
 	  If unsure, choose "PC-compatible" instead.
 
+config X86_VOYAGER
+	bool "Voyager (NCR)"
+	depends on X86_32 && SMP && !PCI && BROKEN
+	depends on X86_NON_STANDARD
+	help
+	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
+	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
+
+	  *** WARNING ***
+
+	  If you do not specifically know you have a Voyager based machine,
+	  say N here, otherwise the kernel you build will not be bootable.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
-- 
1.6.0.2

