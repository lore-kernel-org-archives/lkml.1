Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXA0VON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXA0VON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbXA0VON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:14:13 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35500 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbXA0VOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:14:12 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 27 Jan 2007 16:13:28 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Karsten Keil <kkeil@suse.de>
Subject: [PATCH] ISDN: Fix typo "CONFIG_HISAX_QUADRO" -> "CONFIG_HISAX_SCT_QUADRO".
Message-ID: <Pine.LNX.4.64.0701271607380.10953@CPE00045a9c397f-CM001225dbafb6>
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


  Replace misspelled CONFIG_HISAX_QUADRO with CONFIG_HISAX_SCT_QUADRO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 17ec0b7..29e98f7 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1881,7 +1881,7 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_DJINN_ITOO,   PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_OLITEC,       PCI_ANY_ID, PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_QUADRO
+#ifdef CONFIG_HISAX_SCT_QUADRO
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_9050,         PCI_ANY_ID, PCI_ANY_ID},
 #endif
 #ifdef CONFIG_HISAX_NICCY

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
