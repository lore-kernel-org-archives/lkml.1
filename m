Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZA2ATL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZA2ATL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZA1Xqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:53295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784AbZA1Xqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:37 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 086/114] x86/Voyager: remove MCA Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:32 +0000
Message-Id: <1233186180-29883-87-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Voyager Kconfig quirk: just like any other hardware platform
users of Voyager systems can configure in the hardware drivers they need.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f983f40..ae37a75 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1873,8 +1873,7 @@ config EISA
 source "drivers/eisa/Kconfig"
 
 config MCA
-	bool "MCA support" if !X86_VOYAGER
-	default y if X86_VOYAGER
+	bool "MCA support"
 	help
 	  MicroChannel Architecture is found in some IBM PS/2 machines and
 	  laptops.  It is a bus system similar to PCI or ISA. See
-- 
1.6.0.2

