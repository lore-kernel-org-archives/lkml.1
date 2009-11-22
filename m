Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZKVIoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZKVIoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZKVIoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:44:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:44519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbZKVIny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:43:54 -0500
Date: Sun, 22 Nov 2009 08:43:20 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <1258863695-10464-3-git-send-email-fweisbec@gmail.com>
References: <1258863695-10464-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Remove x86 specific headers from core file
Message-ID: <tip-b3a75542d329ce4e1c66b293cefeb4429a2af043@git.kernel.org>
Git-Commit-ID: b3a75542d329ce4e1c66b293cefeb4429a2af043
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3a75542d329ce4e1c66b293cefeb4429a2af043
Gitweb:     http://git.kernel.org/tip/b3a75542d329ce4e1c66b293cefeb4429a2af043
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Nov 2009 05:21:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 09:03:43 +0100

hw-breakpoints: Remove x86 specific headers from core file

Remove asm/processor.h and asm/debugreg.h as these headers are
not used anymore in the hw-breakpoints core file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258863695-10464-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 9ea9414..b6d6fa2 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -40,12 +40,6 @@
 
 #include <linux/hw_breakpoint.h>
 
-#include <asm/processor.h>
-
-#ifdef CONFIG_X86
-#include <asm/debugreg.h>
-#endif
-
 /*
  * Constraints data
  */
