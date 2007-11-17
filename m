Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbXKQLLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbXKQLLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXKQLK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:10:58 -0500
Received: from mail.cs.umu.se ([130.239.40.25]:42089 "EHLO mail.cs.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbXKQLK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:10:57 -0500
X-Greylist: delayed 760 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Nov 2007 06:10:57 EST
Date: Sat, 17 Nov 2007 11:58:14 +0100
From: Peter Hagervall <hager@cs.umu.se>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH] Fix voyager build issue
Message-ID: <20071117105814.GA23520@peppar.cs.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix fallout from the x86 32/64-bit merge.

asm-x86/setup_32.h no longer exists.

Signed-off-by: Peter Hagervall <hager@cs.umu.se>
---

diff --git a/include/asm-x86/mach-voyager/setup_arch.h b/include/asm-x86/mach-voyager/setup_arch.h
index 1710ae1..71729ca 100644
--- a/include/asm-x86/mach-voyager/setup_arch.h
+++ b/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,5 @@
 #include <asm/voyager.h>
-#include <asm/setup_32.h>
+#include <asm/setup.h>
 #define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
 			(&boot_params.apm_bios_info))
 
