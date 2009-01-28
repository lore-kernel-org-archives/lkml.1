Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbZA2AR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbZA2AR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbZA1Xqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:53266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631AbZA1Xq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:27 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 085/114] x86: disable Voyager temporarily
Date: Wed, 28 Jan 2009 23:42:31 +0000
Message-Id: <1233186180-29883-86-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager does not build right now and it's unclear whether it will
be cleaned up and ported to the subarch-less 32-bit x86 code - so disable
it for now.

If it's fixed we'll re-enable it - or remove it after some time. There's
a very low number of systems running development kernels on x86/Voyager
currently. (one or two on the whole planet)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 45c7bdb..f983f40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -303,7 +303,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
-	depends on X86_32 && SMP && !PCI
+	depends on X86_32 && SMP && !PCI && BROKEN
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
-- 
1.6.0.2

