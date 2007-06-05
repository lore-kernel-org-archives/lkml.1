Return-Path: <linux-kernel-owner+w=401wt.eu-S1765742AbXFEU76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765742AbXFEU76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765722AbXFEU7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:59:37 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53453 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765671AbXFEU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:59:36 -0400
Date: Tue, 5 Jun 2007 16:50:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - Fix kernel stack size on x86_64
Message-ID: <20070605205055.GA9770@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is 2.6.22 material ]

Having KERNEL_STACK_ORDER in defconfig overrides the value provided by
Kconfig, breaking UML/x86_64, which wants 2 page stacks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/defconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/defconfig
===================================================================
--- linux-2.6.21-mm.orig/arch/um/defconfig	2007-06-05 12:18:35.000000000 -0400
+++ linux-2.6.21-mm/arch/um/defconfig	2007-06-05 12:19:12.000000000 -0400
@@ -86,7 +86,6 @@ CONFIG_MCONSOLE=y
 # CONFIG_MAGIC_SYSRQ is not set
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
-CONFIG_KERNEL_STACK_ORDER=0
 CONFIG_UML_REAL_TIME_CLOCK=y
 
 #
