Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbXKSTDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbXKSTDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbXKSTCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:02:53 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:46483 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXKSTCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:02:52 -0500
Date: Mon, 19 Nov 2007 14:02:24 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] Keep UML Kconfig in sync with x86
Message-ID: <20071119190224.GA7723@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a 2.6.24-rc3 UML build breakage introduced by commit
1032c0ba9da5c5b53173ad2dcf8b2a2da78f8b17 - it introduces X86_32, with
many things which UML needs depending on it.

This patch adds definitions of X86_32 and RWSEM_XCHGADD_ALGORITHM to
the UML/i386 Kconfig.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig.i386 |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/arch/um/Kconfig.i386
===================================================================
--- linux-2.6.orig/arch/um/Kconfig.i386	2007-11-19 12:49:30.000000000 -0500
+++ linux-2.6/arch/um/Kconfig.i386	2007-11-19 13:56:37.000000000 -0500
@@ -8,6 +8,13 @@ config UML_X86
 	bool
 	default y
 
+config X86_32
+       bool
+       default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool y
+
 config 64BIT
 	bool
 	default n
