Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbZA2AZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbZA2AZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbZA1XrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:53409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbZA1XrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:08 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 105/114] x86/Voyager: remove power management Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:51 +0000
Message-Id: <1233186180-29883-106-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this PM/ACPI Kconfig quirk:

 menu "Power management and ACPI options"
	depends on !X86_VOYAGER

Most of the PM features are auto-detect so they should be safe to run
on just about any hardware. (If not, those instances need fixing.)

In any case, if a kernel is built for Voyager, the power management
options can be disabled.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 206645a..f95c3b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1551,7 +1551,6 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	depends on NUMA
 
 menu "Power management and ACPI options"
-	depends on !X86_VOYAGER
 
 config ARCH_HIBERNATION_HEADER
 	def_bool y
-- 
1.6.0.2

