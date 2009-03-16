Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbZCPIVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbZCPIVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbZCPIUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:20:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:44706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552AbZCPIUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:20:22 -0400
Date: Mon, 16 Mar 2009 08:19:07 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237151439-6755-4-git-send-email-fweisbec@gmail.com>
References: <1237151439-6755-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/syscalls] tracing/syscalls: select kallsysms
Message-ID: <tip-0ea1c4156bf9e2eb370cc5c6fa6eb112bd844dec@git.kernel.org>
Git-Commit-ID: 0ea1c4156bf9e2eb370cc5c6fa6eb112bd844dec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 08:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ea1c4156bf9e2eb370cc5c6fa6eb112bd844dec
Gitweb:     http://git.kernel.org/tip/0ea1c4156bf9e2eb370cc5c6fa6eb112bd844dec
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 15 Mar 2009 22:10:38 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Mar 2009 09:13:17 +0100

tracing/syscalls: select kallsysms

Syscall tracing must select kallsysms.

The arch code builds a table to find the syscall metadata by syscall
number. It needs the syscalls names resolution from the symbol table
to know which name found on the syscalls metadatas match a function
pointer from the arch sys_call_table.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237151439-6755-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 95a0ad1..b0a46f8 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -182,6 +182,7 @@ config FTRACE_SYSCALLS
 	bool "Trace syscalls"
 	depends on HAVE_FTRACE_SYSCALLS
 	select TRACING
+	select KALLSYMS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
