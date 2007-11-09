Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbXKIVaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbXKIVaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbXKIV2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:28:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbXKIV2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:28:49 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 9/24] Wipe out traditional opt from x86_64 Makefile
Date: Fri,  9 Nov 2007 16:42:50 -0200
Message-Id: <11946338361369-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1194633831882-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Among other things, using -traditional as a gcc option stops us from
using macro token pasting, which is a feature we heavily rely on.

There was still a use of -traditional in arch/x86/kernel/Makefile_64,
which this patch removes.

I don't see any problems building kernels in my x86_64 box without
-traditional.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/Makefile_64 |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index ffee997..0714528 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -3,7 +3,6 @@
 #
 
 extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
-EXTRA_AFLAGS	:= -traditional
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		ptrace_64.o time_64.o ioport_64.o ldt.o setup_64.o i8259_64.o sys_x86_64.o \
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
-- 
1.4.4.2

