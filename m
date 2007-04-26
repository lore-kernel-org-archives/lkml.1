Return-Path: <linux-kernel-owner+w=401wt.eu-S1031214AbXDZMyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031214AbXDZMyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031219AbXDZMyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:54:00 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40630 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031214AbXDZMx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:53:59 -0400
X-Originating-Ip: 74.109.98.66
Date: Thu, 26 Apr 2007 08:53:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: hskinnemoen@atmel.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] AVR32: Remove useless config option "GENERIC_BUST_SPINLOCK".
Message-ID: <Pine.LNX.4.64.0704260851420.2138@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the clearly useless config option GENERIC_BUST_SPINLOCK, which
is not used anywhere in the tree.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index ce4013a..747922d 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -57,9 +57,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n

-config GENERIC_BUST_SPINLOCK
-	bool
-
 config GENERIC_HWEIGHT
 	bool
 	default y
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
