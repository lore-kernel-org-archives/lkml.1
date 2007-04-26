Return-Path: <linux-kernel-owner+w=401wt.eu-S1031254AbXDZPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031254AbXDZPLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031257AbXDZPLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:11:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47399 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031254AbXDZPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:11:13 -0400
X-Originating-Ip: 74.109.98.66
Date: Thu, 26 Apr 2007 11:10:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Ian Molton <spyro@f2s.com>
Subject: [PATCH] ARM: Remove useless config option GENERIC_BUST_SPINLOCK.
Message-ID: <Pine.LNX.4.64.0704260911110.2493@localhost.localdomain>
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


Remove the apparently useless config option GENERIC_BUST_SPINLOCK,
since nothing in the source tree refers to it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  along with the single reference under AVR32 reported earlier, these
are the only other references to GENERIC_BUST_SPINLOCK in the entire
tree.  so i have to believe this feature is dead, not just resting.

 arch/arm/Kconfig   |    3 ---
 arch/arm26/Kconfig |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e7baca2..5a4869f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -102,9 +102,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y

-config GENERIC_BUST_SPINLOCK
-	bool
-
 config ARCH_MAY_HAVE_PC_FDC
 	bool

diff --git a/arch/arm26/Kconfig b/arch/arm26/Kconfig
index 989113d..20688bc 100644
--- a/arch/arm26/Kconfig
+++ b/arch/arm26/Kconfig
@@ -57,9 +57,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y

-config GENERIC_BUST_SPINLOCK
-	bool
-
 config ZONE_DMA
 	bool
 	default y

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
