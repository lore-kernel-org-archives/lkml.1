Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZCDRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZCDRnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZCDRnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:43:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:35723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZCDRnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:43:05 -0500
Date: Wed, 4 Mar 2009 17:42:22 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236167295.5330.7240.camel@laptop>
References: <1236167295.5330.7240.camel@laptop>
Subject: [tip:core/locking] lockdep: require framepointers for x86
Message-ID: <tip-1075414b06109a99b0e87601e84c74a95bd45681@git.kernel.org>
Git-Commit-ID: 1075414b06109a99b0e87601e84c74a95bd45681
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 17:42:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1075414b06109a99b0e87601e84c74a95bd45681
Gitweb:     http://git.kernel.org/tip/1075414b06109a99b0e87601e84c74a95bd45681
Author:     "Peter Zijlstra" <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 4 Mar 2009 12:27:27 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 18:39:23 +0100

lockdep: require framepointers for x86

Require framepointers for x86, because otherwise we'll be having
empty stack traces, which is useless.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1236167295.5330.7240.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..9b4efb1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -402,7 +402,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS && !PPC
+	select FRAME_POINTER if !MIPS && !PPC
 	select KALLSYMS
 	select KALLSYMS_ALL
 
