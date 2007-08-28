Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXH1Kqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXH1Kqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXH1KqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:46:25 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27548
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbXH1KqZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:46:25 -0400
Message-Id: <46D4193E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 11:46:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: remove stub early_printk.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. and handle use of the x86-64 file by make logic instead.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/Makefile       |    1 +
 arch/i386/kernel/early_printk.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc4/arch/i386/kernel/Makefile	2007-08-28 09:38:03.000000000 +0200
+++ 2.6.23-rc4-i386-early-printk/arch/i386/kernel/Makefile	2007-08-28 00:00:00.000000000 +0200
@@ -83,6 +83,7 @@ $(obj)/vsyscall-syms.o: $(src)/vsyscall.
 			$(obj)/vsyscall-sysenter.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
 
+early_printk-y            += ../../x86_64/kernel/early_printk.o
 k8-y                      += ../../x86_64/kernel/k8.o
 stacktrace-y		  += ../../x86_64/kernel/stacktrace.o
 
--- linux-2.6.23-rc4/arch/i386/kernel/early_printk.c	2004-04-04 05:36:57.000000000 +0200
+++ 2.6.23-rc4-i386-early-printk/arch/i386/kernel/early_printk.c	2007-08-28 00:00:00.000000000 +0200
@@ -1,2 +0,0 @@
-
-#include "../../x86_64/kernel/early_printk.c"



