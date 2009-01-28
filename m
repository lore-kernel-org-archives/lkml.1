Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbZA2AWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbZA2AWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbZA1XrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:53369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863AbZA1Xq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:59 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 097/114] x86/VisWS: remove Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:43 +0000
Message-Id: <1233186180-29883-98-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VisWS has this quirk currently:

 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
	depends on X86_32 && PCI && !X86_VOYAGER && X86_MPPARSE && PCI_GODIRECT

The !Voyager quirk is unnecessary.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df7cb8d..f59d292 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -351,7 +351,7 @@ endchoice
 
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
-	depends on X86_32 && PCI && !X86_VOYAGER && X86_MPPARSE && PCI_GODIRECT
+	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
 	help
 	  The SGI Visual Workstation series is an IA32-based workstation
 	  based on SGI systems chips with some legacy PC hardware attached.
-- 
1.6.0.2

