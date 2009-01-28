Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbZA2ARi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbZA2ARi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbZA1Xqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:53273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758740AbZA1Xq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:29 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 087/114] x86/Voyager: remove NATSEMI Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:33 +0000
Message-Id: <1233186180-29883-88-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager has this quirk for SCx200 support:

 config SCx200
 	tristate "NatSemi SCx200 support"
	depends on !X86_VOYAGER

Remove it - Voyager users can disable drivers they dont need.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ae37a75..9727dd5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1884,7 +1884,6 @@ source "drivers/mca/Kconfig"
 
 config SCx200
 	tristate "NatSemi SCx200 support"
-	depends on !X86_VOYAGER
 	help
 	  This provides basic support for National Semiconductor's
 	  (now AMD's) Geode processors.  The driver probes for the
-- 
1.6.0.2

