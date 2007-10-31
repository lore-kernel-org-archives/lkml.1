Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXJaWC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXJaWC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760643AbXJaWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:00:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760638AbXJaWAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:00:35 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/16] Wipe out traditional opt from x86_64 Makefile
Date: Wed, 31 Oct 2007 16:14:46 -0300
Message-Id: <11938581073775-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1193858101367-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Among other things, using -traditional as a gcc option stops us from
using macro token pasting, which is a feature we heavily rely on.

There was still a use of -traditional in arch/x86/kernel/Makefile_64,
which this patch removes.

I don't see any problems building kernels in my x86_64 box without
-traditional.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile_64 |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 24671c3..74d3727 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -3,7 +3,6 @@
 #
 
 extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
-EXTRA_AFLAGS	:= -traditional
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		ptrace_64.o time_64.o ioport_64.o ldt_64.o setup_64.o i8259_64.o sys_x86_64.o \
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
-- 
1.4.4.2

