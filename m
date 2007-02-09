Return-Path: <linux-kernel-owner+w=401wt.eu-S1946551AbXBIPom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946551AbXBIPom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946538AbXBIPeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946527AbXBIPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=r8DMMUQvQqugyfPGOqbVm+3qylObSeezaDVmqRFfssV2/52hvBwjlqwWde+smuQ4ZdfcHDx3jNDMJOjhStp1u2CI7nCqp2Wd4Dz5NDls2WrWVvXKmtc0PghInlTdpFovw+TK69orxTG0A9M+Kzs9QVssTAfeDm4vXCPHAEEm8ow=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, rth@twiddle.net
Subject: [PATCH 01/34] __initdata cleanup - alpha
Date: Fri, 9 Feb 2007 17:13:22 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091713.23091.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/alpha/kernel/setup.c linux-2.6.20-rc6-mm3/arch/alpha/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/alpha/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/alpha/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -122,7 +122,7 @@ static void get_sysnames(unsigned long, 
 			 char **, char **);
 static void determine_cpu_caches (unsigned int);
 
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 /*
  * The format of "screen_info" is strange, and due to early
diff -urNp linux-2.6.20-rc6-mm3.org/arch/alpha/kernel/smc37c669.c linux-2.6.20-rc6-mm3/arch/alpha/kernel/smc37c669.c
--- linux-2.6.20-rc6-mm3.org/arch/alpha/kernel/smc37c669.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/alpha/kernel/smc37c669.c	2007-01-31 22:19:30.000000000 +0200
@@ -996,7 +996,7 @@ static SMC37c669_CONFIG_REGS *SMC37c669 
 ** and standard ISA IRQs.
 **
 */
-static SMC37c669_IRQ_TRANSLATION_ENTRY *SMC37c669_irq_table __initdata; 
+static SMC37c669_IRQ_TRANSLATION_ENTRY *SMC37c669_irq_table __initdata = NULL; 
 
 /*
 ** The following definition is for the default IRQ 
@@ -1045,7 +1045,7 @@ static SMC37c669_IRQ_TRANSLATION_ENTRY *
 ** ISA DMA channels.
 **
 */
-static SMC37c669_DRQ_TRANSLATION_ENTRY *SMC37c669_drq_table __initdata;
+static SMC37c669_DRQ_TRANSLATION_ENTRY *SMC37c669_drq_table __initdata = NULL;
 
 /*
 ** The following definition is the default DRQ
