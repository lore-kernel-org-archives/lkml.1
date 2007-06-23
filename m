Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbXFWAaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbXFWAaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXFWA3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:29:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:53623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbXFWA3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:29:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070623229.766711000@suse.de>
In-Reply-To: <20070623229.766711000@suse.de>
To: olaf@aepfle.de, patches@x86-64.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.22] [2/3] x86_64: Fix only make Macintosh drivers default on Macs
Message-Id: <20070623002924.E08E114B2C@wotan.suse.de>
Date: Sat, 23 Jun 2007 02:29:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Olaf Hering <olaf@aepfle.de>

Include PPC_MAC in the default too, not only MAC which only covers
m68k MACs.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/macintosh/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/macintosh/Kconfig
===================================================================
--- linux.orig/drivers/macintosh/Kconfig
+++ linux/drivers/macintosh/Kconfig
@@ -2,7 +2,7 @@
 menuconfig MACINTOSH_DRIVERS
 	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
-	default y if MAC
+	default y if (PPC_PMAC || MAC)
 
 if MACINTOSH_DRIVERS
 
