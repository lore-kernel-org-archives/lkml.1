Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbXKET3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbXKET3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbXKET2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:28:13 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:47840 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXKET2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:28:06 -0500
Date: Mon, 5 Nov 2007 14:27:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Karol Swietlicki <magotari@gmail.com>
Subject: [PATCH 3/6] UML - GPROF needs to depend on FRAME_POINTER
Message-ID: <20071105192747.GA8803@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karol Swietlicki <magotari@gmail.com>

This is a short Kconfig fix for a problem in User Mode Linux.
Frame pointers are required for gprof support to work.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/um/Kconfig.debug	2007-11-05 14:06:09.000000000 -0500
+++ linux-2.6/arch/um/Kconfig.debug	2007-11-05 14:12:59.000000000 -0500
@@ -4,7 +4,7 @@ source "lib/Kconfig.debug"
 
 config GPROF
 	bool "Enable gprof support"
-	depends on DEBUG_INFO
+	depends on DEBUG_INFO && FRAME_POINTER
 	help
 	  This allows profiling of a User-Mode Linux kernel with the gprof
 	  utility.
