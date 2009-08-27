Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZH0Rnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZH0Rnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZH0Rnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:43:49 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51769 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZH0Rnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wk6mARTFDJMx1nULP3koF9Sy5Su6UlD1M+CIIPMg4/xFIKX6mg8H1yX4lsnXT0tQ7R
         LydZamJs/QEE4zzR9GfvGgtcfj/suAfLZQh1ETujaaudFVUW1IrqZwpK4OuyO3/HF1vs
         N578un2lgOsuDavVKBbziib2pELuckxYtcDeQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Josh Stone <jistone@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anwin" <hpa@zytor.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 4/7] tracing: Define NR_syscalls for x86 (32)
Date: Thu, 27 Aug 2009 19:43:32 +0200
Message-Id: <1251395015-6329-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add a NR_syscalls #define for x86. This is used in the syscall events
tracing code. Todo: make it dynamic like x86_64.

NR_syscalls is the usual name used to determine the number of syscalls
supported by the current arch. We want to unify the use of this number
across archs that support the syscall tracing. This also prepare to move
some of the arch code to core code in the syscall tracing area.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/unistd_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 732a307..8deaada 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -345,6 +345,8 @@
 
 #ifdef __KERNEL__
 
+#define NR_syscalls 337
+
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
-- 
1.6.2.3

