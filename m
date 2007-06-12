Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXFLQsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXFLQsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXFLQs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:48:26 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52238 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbXFLQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:48:25 -0400
Date: Tue, 12 Jun 2007 12:48:07 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - kill x86_64 STACK_TOP_MAX
Message-ID: <20070612164807.GA7522@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 a.out.h got a definition of STACK_TOP_MAX, which interferes
with the UML version.  So, just undef it like STACK_TOP.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/a.out.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-mm/include/asm-um/a.out.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-um/a.out.h	2007-06-06 09:28:48.000000000 -0400
+++ linux-2.6.21-mm/include/asm-um/a.out.h	2007-06-06 15:51:02.000000000 -0400
@@ -5,6 +5,7 @@
 #include "choose-mode.h"
 
 #undef STACK_TOP
+#undef STACK_TOP_MAX
 
 extern unsigned long stacksizelim;
 
