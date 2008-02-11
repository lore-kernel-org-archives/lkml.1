Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYBKTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYBKTZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbYBKTZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:25:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbYBKTZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:25:28 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 1/5] Change vsmp compile dependency
Date: Mon, 11 Feb 2008 17:16:01 -0200
Message-Id: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Makefile so vsmp_64.o object is dependent
on PARAVIRT, rather than X86_VSMP

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 21dc1a0..71a92a2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
-obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
+obj-$(CONFIG_PARAVIRT)		+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
-- 
1.4.2

