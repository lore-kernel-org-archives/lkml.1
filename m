Return-Path: <linux-kernel-owner+w=401wt.eu-S1759663AbXK1TFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663AbXK1TFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbXK1TFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:05:30 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:42875 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295AbXK1TF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:05:29 -0500
Date: Wed, 28 Nov 2007 14:04:38 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - Keep UML Kconfig in sync with x86
Message-ID: <20071128190438.GA8298@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a UML build breakage introduced by commit
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
