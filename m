Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbXAYXnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbXAYXnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXAYXna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:43:30 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35425 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321AbXAYXn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:43:29 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 25 Jan 2007 18:41:35 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] Fix apparent typo of "CONFIG_MT_SMP".
Message-ID: <Pine.LNX.4.64.0701251839140.15699@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace apparent typo of CONFIG_MT_SMP with CONFIG_MIPS_MT_SMP.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/mips/mips-boards/sim/sim_setup.c b/arch/mips/mips-boards/sim/sim_setup.c
index 2659c1c..ea2066c 100644
--- a/arch/mips/mips-boards/sim/sim_setup.c
+++ b/arch/mips/mips-boards/sim/sim_setup.c
@@ -57,7 +57,7 @@ void __init plat_mem_setup(void)
 	board_time_init = sim_time_init;
 	prom_printf("Linux started...\n");

-#ifdef CONFIG_MT_SMP
+#ifdef CONFIG_MIPS_MT_SMP
 	sanitize_tlb_entries();
 #endif
 }

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
