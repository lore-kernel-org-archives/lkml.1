Return-Path: <linux-kernel-owner+w=401wt.eu-S1764829AbZA2AYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764829AbZA2AYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbZA1XrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:53410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758426AbZA1XrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:08 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 101/114] x86/Voyager: remove PARAVIRT Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:47 +0000
Message-Id: <1233186180-29883-102-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this Kconfig quirk:

 config PARAVIRT
 	bool "Enable paravirtualization code"
	depends on !X86_VOYAGER
 	help

Voyager support built into a kernel does not preclude paravirt support.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 363111f..8210534 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -434,7 +434,6 @@ source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
 	bool "Enable paravirtualization code"
-	depends on !X86_VOYAGER
 	help
 	  This changes the kernel so it can modify itself when it is run
 	  under a hypervisor, potentially improving performance significantly
-- 
1.6.0.2

