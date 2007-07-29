Return-Path: <linux-kernel-owner+w=401wt.eu-S1764388AbXG2O62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764388AbXG2O62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763868AbXG2O5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47756 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763282AbXG2O5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:03 -0400
Date: Sun, 29 Jul 2007 16:56:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386 alternative.c: really stop MCEs during code
	patching
Message-ID: <20070729145638.GF16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's CONFIG_X86_MCE, not CONFIG_MCE.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/alternative.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1/arch/i386/kernel/alternative.c.old	2007-07-26 01:47:31.000000000 +0200
+++ linux-2.6.23-rc1-mm1/arch/i386/kernel/alternative.c	2007-07-26 01:47:52.000000000 +0200
@@ -379,7 +379,7 @@ void __init alternative_instructions(voi
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
 	stop_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	stop_mce();
 #endif
 
@@ -417,7 +417,7 @@ void __init alternative_instructions(voi
 	local_irq_restore(flags);
 
 	restart_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	restart_mce();
 #endif
 }

