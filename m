Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbZA2AVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbZA2AVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbZA1Xqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:53349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758679AbZA1Xqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:54 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 094/114] x86/Voyager: remove X86_HT Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:40 +0000
Message-Id: <1233186180-29883-95-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this Kconfig quirk:

	depends on (X86_32 && !X86_VOYAGER) || X86_64

That is unnecessary as HT support is CPUID driven and explicitly
 enumerated.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f4dd851..1d50c9d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -188,7 +188,6 @@ config X86_64_SMP
 config X86_HT
 	bool
 	depends on SMP
-	depends on (X86_32 && !X86_VOYAGER) || X86_64
 	default y
 
 config X86_BIOS_REBOOT
-- 
1.6.0.2

