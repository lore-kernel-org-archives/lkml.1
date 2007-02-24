Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXBXLUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXBXLUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933499AbXBXLUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:20:50 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:59065 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbXBXLUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:20:49 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 24 Feb 2007 06:17:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] MIPS: Remove unreferenced _IOC_SLMASK macro in ioctl.h.
Message-ID: <Pine.LNX.4.64.0702240613250.13622@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_XF 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete the definition of the apparently unreferenced macro
_IOC_SLMASK.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/include/asm-mips/ioctl.h b/include/asm-mips/ioctl.h
index cba641a..2036fcb 100644
--- a/include/asm-mips/ioctl.h
+++ b/include/asm-mips/ioctl.h
@@ -38,11 +38,6 @@
 #define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)

 /*
- * We to additionally limit parameters to a maximum 255 bytes.
- */
-#define _IOC_SLMASK	0xff
-
-/*
  * Direction bits _IOC_NONE could be 0, but OSF/1 gives it a bit.
  * And this turns out useful to catch old ioctl numbers in header
  * files for us.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
