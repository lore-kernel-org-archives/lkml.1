Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXIUWuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXIUWuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763962AbXIUWcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764119AbXIUWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:46 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: stefanr@s5r6.in-berlin.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [45/50] x86_64: configure HPET_EMULATE_RTC automatically
Message-Id: <20070921223245.BC6CA13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
I don't know exactly what this option does...
Andi says it should be automatic rather than exposed as a prompt.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/x86_64/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -469,8 +469,9 @@ config HPET_TIMER
 	  <http://www.intel.com/hardwaredesign/hpetspec.htm>.
 
 config HPET_EMULATE_RTC
-	bool "Provide RTC interrupt"
+	bool
 	depends on HPET_TIMER && RTC=y
+	default y
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.
