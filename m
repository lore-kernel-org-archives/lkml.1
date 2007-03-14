Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXCNFRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXCNFRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933869AbXCNFRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:17:25 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45250 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbXCNFMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:01 -0400
Message-Id: <20070314051048.029055418@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 03/18] acpi Makefile updates
Content-Disposition: inline; filename=acpi-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the arch/x86/acpi/Makefile, and remove the associate stuff
from the i386 and x86_64.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
new file mode 100644
index 0000000..f4aa6dc
--- /dev/null
+++ b/arch/x86/kernel/acpi/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_ACPI)		+= boot.o
+
+ifneq ($(CONFIG_ACPI_PROCESSOR),)
+obj-y		+= processor.o cstate.o
+endif
diff --git a/arch/x86_64/kernel/acpi/Makefile b/arch/x86_64/kernel/acpi/Makefile
index 080b996..eb4bc11 100644
--- a/arch/x86_64/kernel/acpi/Makefile
+++ b/arch/x86_64/kernel/acpi/Makefile
@@ -1,9 +1,2 @@
-obj-y			:= boot.o
-boot-y			:= ../../../i386/kernel/acpi/boot.o
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
 
-ifneq ($(CONFIG_ACPI_PROCESSOR),)
-obj-y			+= processor.o
-processor-y		:= ../../../i386/kernel/acpi/processor.o ../../../i386/kernel/acpi/cstate.o
-endif
-

--
