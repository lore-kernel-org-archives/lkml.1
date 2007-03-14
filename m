Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbXCNFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbXCNFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbXCNFMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:30 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45367 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855AbXCNFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:20 -0400
Message-Id: <20070314051050.150456280@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 15/18] create x86/mm/Makefile
Content-Disposition: inline; filename=mm-makefile.patch
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

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
new file mode 100644
index 0000000..1b6e922
--- /dev/null
+++ b/arch/x86/mm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
diff --git a/arch/i386/mm/Makefile b/arch/i386/mm/Makefile
index 80908b5..0cb01e6 100644
--- a/arch/i386/mm/Makefile
+++ b/arch/i386/mm/Makefile
@@ -5,6 +5,5 @@
 obj-y	:= init.o pgtable.o fault.o ioremap.o extable.o pageattr.o mmap.o
 
 obj-$(CONFIG_NUMA) += discontig.o
-obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_HIGHMEM) += highmem.o
 obj-$(CONFIG_BOOT_IOREMAP) += boot_ioremap.o
diff --git a/arch/x86_64/mm/Makefile b/arch/x86_64/mm/Makefile
index d25ac86..4beaed8 100644
--- a/arch/x86_64/mm/Makefile
+++ b/arch/x86_64/mm/Makefile
@@ -3,9 +3,6 @@
 #
 
 obj-y	 := init.o fault.o ioremap.o extable.o pageattr.o mmap.o
-obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_K8_NUMA) += k8topology.o
 obj-$(CONFIG_ACPI_NUMA) += srat.o
-
-hugetlbpage-y = ../../i386/mm/hugetlbpage.o

--
