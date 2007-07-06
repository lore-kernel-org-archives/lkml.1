Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbXGFMvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbXGFMvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXGFMve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:51:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39114 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbXGFMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:51:34 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 08:48:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] I386: Deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
 variable.
Message-ID: <Pine.LNX.4.64.0707060847470.23786@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/i386/kernel/vmi.c b/arch/i386/kernel/vmi.c
index c12720d..e3ce5c8 100644
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -235,7 +235,7 @@ static void vmi_nop(void)
 {
 }

-#ifdef CONFIG_DEBUG_PAGE_TYPE
+#if 0 /* debug page type */

 #ifdef CONFIG_X86_PAE
 #define MAX_BOOT_PTS (2048+4+1)
@@ -336,7 +336,7 @@ static void vmi_check_page_type(u32 pfn, int type)
 #else
 #define vmi_set_page_type(p,t) do { } while (0)
 #define vmi_check_page_type(p,t) do { } while (0)
-#endif
+#endif /* debug page type */

 #ifdef CONFIG_HIGHPTE
 static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
