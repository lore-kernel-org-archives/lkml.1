Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXCNFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXCNFQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCNFMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:32 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:51796 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbXCNFMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:19 -0400
Message-Id: <20070314051049.092023381@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 09/18] create x86/kernel/cpu/mcheck/Makefile
Content-Disposition: inline; filename=cpu-mcheck-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the Makefile in the common hold and adjust the i386 and
x86_64 code accordingly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
new file mode 100644
index 0000000..6e7cb4c
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -0,0 +1 @@
+obj-y	= therm_throt.o
\ No newline at end of file
diff --git a/arch/i386/kernel/cpu/mcheck/Makefile b/arch/i386/kernel/cpu/mcheck/Makefile
index f1ebe1c..30808f3 100644
--- a/arch/i386/kernel/cpu/mcheck/Makefile
+++ b/arch/i386/kernel/cpu/mcheck/Makefile
@@ -1,2 +1,2 @@
-obj-y	=	mce.o k7.o p4.o p5.o p6.o winchip.o therm_throt.o
+obj-y	=	mce.o k7.o p4.o p5.o p6.o winchip.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+=	non-fatal.o

--
