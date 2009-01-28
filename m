Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbZA2AYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbZA2AYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbZA1XrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:53394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbZA1XrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:03 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 103/114] x86/Voyager: remove MCE quirk
Date: Wed, 28 Jan 2009 23:42:49 +0000
Message-Id: <1233186180-29883-104-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no MCE code is desired on Voyager hw then the solution
is to turn them off in the .config - and to extend the MCE
code to not initialize on Voyager.

Remove the build-time quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6fbb363..7cf9f0a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -703,7 +703,6 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 
 config X86_MCE
 	bool "Machine Check Exception"
-	depends on !X86_VOYAGER
 	---help---
 	  Machine Check Exception support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, component failure).
-- 
1.6.0.2

