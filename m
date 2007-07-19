Return-Path: <linux-kernel-owner+w=401wt.eu-S938195AbXGSN4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938195AbXGSN4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763272AbXGSNss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:48622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937205AbXGSNsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:46 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: Yinghai.Lu@Sun.COM, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [16/48] x86_64: Geode HW Random Number Generator depends on X86_32
Message-Id: <20070719134845.941B314E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/char/hw_random/Kconfig
===================================================================
--- linux.orig/drivers/char/hw_random/Kconfig
+++ linux/drivers/char/hw_random/Kconfig
@@ -41,7 +41,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
-	depends on HW_RANDOM && X86 && PCI
+	depends on HW_RANDOM && X86_32 && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
