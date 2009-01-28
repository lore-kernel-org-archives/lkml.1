Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbZA2AYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbZA2AYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbZA1XrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:53384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875AbZA1XrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:03 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 098/114] x86/Voyager: remove VMI Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:44 +0000
Message-Id: <1233186180-29883-99-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/Voyager has this build-time quirk:

 	bool "VMI Guest support"
 	select PARAVIRT
 	depends on X86_32
	depends on !X86_VOYAGER

Since VMI is auto-detected (and Voyager will be auto-detected) there's no
reason for this quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f59d292..4bd0c8f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -406,7 +406,6 @@ config VMI
 	bool "VMI Guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on !X86_VOYAGER
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
-- 
1.6.0.2

