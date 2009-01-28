Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbZA2AVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbZA2AVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZA1Xqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:53336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbZA1Xqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:50 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 090/114] x86/Voyager: remove HIBERNATION Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:36 +0000
Message-Id: <1233186180-29883-91-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this hibernation quirk:

 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
	depends on !SMP || !X86_VOYAGER

Hibernation is a generic facility provided on all x86 platforms. If it
is buggy on Voyager then that bug should be fixed - not worked around.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 12b433a..df952e7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -140,7 +140,7 @@ config HAVE_CPUMASK_OF_CPU_MAP
 
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
-	depends on !SMP || !X86_VOYAGER
+	depends on !SMP
 
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
-- 
1.6.0.2

