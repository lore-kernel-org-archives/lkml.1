Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYHGSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYHGSV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYHGSVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:21:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58100 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYHGSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:21:19 -0400
Message-Id: <20080807182117.497733404@goodmis.org>
References: <20080807182013.984175558@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 14:20:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: enable using mcount recording on x86
Content-Disposition: inline; filename=ftrace-x86-enable-mcount-record.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the use of the __mcount_loc infrastructure on x86_64 and i386.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-tip.git/arch/x86/Kconfig
===================================================================
--- linux-tip.git.orig/arch/x86/Kconfig	2008-08-07 10:18:30.000000000 -0400
+++ linux-tip.git/arch/x86/Kconfig	2008-08-07 10:18:41.000000000 -0400
@@ -26,6 +26,7 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)

-- 
