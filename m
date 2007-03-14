Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbXCNFMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbXCNFMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbXCNFMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:24 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63766 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856AbXCNFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:20 -0400
Message-Id: <20070314051049.805214464@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 13/18] create x86/lib/Makefile
Content-Disposition: inline; filename=lib-makefile.patch
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

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
new file mode 100644
index 0000000..d683d55
--- /dev/null
+++ b/arch/x86/lib/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SMP)	+= msr-on-cpu.o
diff --git a/arch/i386/lib/Makefile b/arch/i386/lib/Makefile
index 22d8ac5..304f754 100644
--- a/arch/i386/lib/Makefile
+++ b/arch/i386/lib/Makefile
@@ -8,4 +8,3 @@ lib-y = checksum.o delay.o usercopy.o getuser.o putuser.o memcpy.o strstr.o \
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
 
-obj-$(CONFIG_SMP)	+= msr-on-cpu.o
diff --git a/arch/x86_64/lib/Makefile b/arch/x86_64/lib/Makefile
index c943271..8d5f835 100644
--- a/arch/x86_64/lib/Makefile
+++ b/arch/x86_64/lib/Makefile
@@ -5,7 +5,6 @@
 CFLAGS_csum-partial.o := -funroll-loops
 
 obj-y := io.o iomap_copy.o
-obj-$(CONFIG_SMP)	+= msr-on-cpu.o
 
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \

--
