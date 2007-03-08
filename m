Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbXCHQWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbXCHQWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXCHQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:22:49 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:39746 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXCHQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:22:48 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 8 Mar 2007 11:19:39 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] PPC: Correct apparently misspelled "XMON" preprocessor
 directive.
Message-ID: <Pine.LNX.4.64.0703081116400.3502@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.986, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	SARE_PROLOSTOCK_SYM1 1.66, TW_KB 0.08, TW_QA 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Correct the apparent misspelling of "XMON" to "CONFIG_XMON".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  i'm only *guessing* that this is a typo, given that the file
"arch/powerpc/Kconfig.debug" defines the XMON config variable.


diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 117c9a0..1edce72 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -427,7 +427,7 @@ static void __init chrp_find_openpic(void)
 	of_node_put(np);
 }

-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 static struct irqaction xmon_irqaction = {
 	.handler = xmon_irq,
 	.mask = CPU_MASK_NONE,
@@ -493,7 +493,7 @@ static void __init chrp_find_8259(void)

 void __init chrp_init_IRQ(void)
 {
-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 	struct device_node *kbd;
 #endif
 	chrp_find_openpic();
@@ -510,7 +510,7 @@ void __init chrp_init_IRQ(void)
 	if (_chrp_type == _CHRP_Pegasos)
 		ppc_md.get_irq        = i8259_irq;

-#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(XMON)
+#if defined(CONFIG_VT) && defined(CONFIG_INPUT_ADBHID) && defined(CONFIG_XMON)
 	/* see if there is a keyboard in the device tree
 	   with a parent of type "adb" */
 	for (kbd = find_devices("keyboard"); kbd; kbd = kbd->next)

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
