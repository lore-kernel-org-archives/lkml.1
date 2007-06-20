Return-Path: <linux-kernel-owner+w=401wt.eu-S1763296AbXFTK0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296AbXFTK0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760786AbXFTKXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:36149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbXFTKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [6/10] x86: Only make Macintosh drivers default on Macs
Message-Id: <20070620102334.DD01814AD0@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It's already annoying that they appear on x86 now -- that's for the 3button
emulation needed on x86 macs -- but at least don't make them default.

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
-	default y
+	default y if MAC
 
 if MACINTOSH_DRIVERS
 
