Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbZA2A01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbZA2A01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbZA1XrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:53428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbZA1XrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:14 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 104/114] x86/Voyager: remove HOTPLUG_CPU Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:50 +0000
Message-Id: <1233186180-29883-105-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this Kconfig quirk:

 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
	depends on SMP && HOTPLUG && !X86_VOYAGER

But this exception will be moot once Voyager starts using the
generic x86 code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7cf9f0a..206645a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1470,7 +1470,7 @@ config PHYSICAL_ALIGN
 
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
-	depends on SMP && HOTPLUG && !X86_VOYAGER
+	depends on SMP && HOTPLUG
 	---help---
 	  Say Y here to allow turning CPUs off and on. CPUs can be
 	  controlled through /sys/devices/system/cpu.
-- 
1.6.0.2

