Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbXKET2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbXKET2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXKET2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:28:11 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:47849 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbXKET2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:28:05 -0500
Date: Mon, 5 Nov 2007 14:27:46 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] UML - SMP needs to depend on BROKEN for now
Message-ID: <20071105192746.GA8788@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SMP still needs to depend on BROKEN for now.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/um/Kconfig
===================================================================
--- linux-2.6.orig/arch/um/Kconfig	2007-11-05 14:08:07.000000000 -0500
+++ linux-2.6/arch/um/Kconfig	2007-11-05 14:12:35.000000000 -0500
@@ -189,8 +189,7 @@ config MAGIC_SYSRQ
 config SMP
 	bool "Symmetric multi-processing support (EXPERIMENTAL)"
 	default n
-	#SMP_BROKEN is for x86_64.
-	depends on EXPERIMENTAL && (!SMP_BROKEN || (BROKEN && SMP_BROKEN))
+	depends on BROKEN
 	help
 	  This option enables UML SMP support.
 	  It is NOT related to having a real SMP box. Not directly, at least.
