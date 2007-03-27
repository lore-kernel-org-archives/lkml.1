Return-Path: <linux-kernel-owner+w=401wt.eu-S934160AbXC0Sbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbXC0Sbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934163AbXC0Sba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:31:30 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45443 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbXC0SbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:31:11 -0400
Date: Tue, 27 Mar 2007 14:27:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/6] i386 - fix cmpxchg warning
Message-ID: <20070327182746.GA8395@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I started getting warnings from atomic.h about cmpxchg not having a
prototype.  It's declared in system.h, so including that fixes the UML
build warnings and has no noticable ill effects on the i386 build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-i386/atomic.h |    1 +
 1 file changed, 1 insertion(+)

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--

Index: linux-2.6.21-mm/include/asm-i386/atomic.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-i386/atomic.h	2007-03-27 12:25:16.000000000 -0400
+++ linux-2.6.21-mm/include/asm-i386/atomic.h	2007-03-27 12:26:38.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <asm/processor.h>
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
