Return-Path: <linux-kernel-owner+w=401wt.eu-S1764528AbZA2AX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764528AbZA2AX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZA1XrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:53373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758872AbZA1XrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:00 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 100/114] x86/Voyager: remove KVM_GUEST quirk
Date: Wed, 28 Jan 2009 23:42:46 +0000
Message-Id: <1233186180-29883-101-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this quirk currently:

 config KVM_GUEST
 	bool "KVM Guest support"
 	select PARAVIRT
	depends on !X86_VOYAGER

Voyager support built into a kernel image does not exclude
KVM paravirt guest support - so remove this quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0bf0653..363111f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -426,7 +426,6 @@ config KVM_CLOCK
 config KVM_GUEST
 	bool "KVM Guest support"
 	select PARAVIRT
-	depends on !X86_VOYAGER
 	help
 	 This option enables various optimizations for running under the KVM
 	 hypervisor.
-- 
1.6.0.2

