Return-Path: <linux-kernel-owner+w=401wt.eu-S1030661AbXAZAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030661AbXAZAL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030662AbXAZALZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:11:25 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:36597 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030661AbXAZALZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:11:25 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 25 Jan 2007 19:10:52 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] Fix apparent typo "CONFIG_SERIAL_CPM_SMC".
Message-ID: <Pine.LNX.4.64.0701251908001.16270@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace an apparent typo of CONFIG_SERIAL_CPM_SMC with
CONFIG_SERIAL_CPM_SMC2.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/ppc/platforms/mpc866ads_setup.c b/arch/ppc/platforms/mpc866ads_setup.c
index 8a0c07e..5b05d4b 100644
--- a/arch/ppc/platforms/mpc866ads_setup.c
+++ b/arch/ppc/platforms/mpc866ads_setup.c
@@ -369,7 +369,7 @@ int __init mpc866ads_init(void)
 	ppc_sys_device_setfunc(MPC8xx_CPM_SMC1, PPC_SYS_FUNC_UART);
 #endif

-#ifdef CONFIG_SERIAL_CPM_SMC
+#ifdef CONFIG_SERIAL_CPM_SMC2
 	ppc_sys_device_enable(MPC8xx_CPM_SMC2);
 	ppc_sys_device_setfunc(MPC8xx_CPM_SMC2, PPC_SYS_FUNC_UART);
 #endif

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
