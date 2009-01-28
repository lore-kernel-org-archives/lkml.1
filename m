Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbZA2A23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbZA2A23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbZA1Xr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:53448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbZA1XrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:25 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 112/114] x86: remove the subarch menu
Date: Wed, 28 Jan 2009 23:42:58 +0000
Message-Id: <1233186180-29883-113-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the subarch menu and standardize on X86_PC.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ddddfb8..4773f1c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -262,16 +262,8 @@ config X86_MPPARSE
 	  For old smp systems that do not have proper acpi support. Newer systems
 	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
 
-choice
-	prompt "Subarchitecture Type"
-	default X86_PC
-
 config X86_PC
-	bool "PC-compatible"
-	help
-	  Choose this option if your computer is a standard PC or compatible.
-
-endchoice
+	def_bool y
 
 config X86_NON_STANDARD
 	bool "Support for non-standard x86 platforms"
-- 
1.6.0.2

