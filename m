Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXAYXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXAYXLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030497AbXAYXLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:11:53 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:34023 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030494AbXAYXLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:11:53 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 25 Jan 2007 18:11:23 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, jdyke@karaya.com
Subject: [PATCH] Fix apparent "CONFIG_64_BIT" typo.
Message-ID: <Pine.LNX.4.64.0701251808520.15498@CPE00045a9c397f-CM001225dbafb6>
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


  Fix apparent typo, where CONFIG_64_BIT should read CONFIG_64BIT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/include/asm-um/elf-ppc.h b/include/asm-um/elf-ppc.h
index 9971113..d3b90b7 100644
--- a/include/asm-um/elf-ppc.h
+++ b/include/asm-um/elf-ppc.h
@@ -11,7 +11,7 @@ extern long elf_aux_hwcap;

 #define elf_check_arch(x) (1)

-#ifdef CONFIG_64_BIT
+#ifdef CONFIG_64BIT
 #define ELF_CLASS ELFCLASS64
 #else
 #define ELF_CLASS ELFCLASS32

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
