Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbZJQJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbZJQJ6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZJQJ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:58:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:40369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZJQJ6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:58:47 -0400
Date: Sat, 17 Oct 2009 09:58:25 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, jkenisto@us.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090828221326.8778.70723.stgit@localhost.localdomain>
References: <20090828221326.8778.70723.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Remove unused config macros from instruction decoder selftest
Message-ID: <tip-70069577323e6f72b845166724f34b9858134437@git.kernel.org>
Git-Commit-ID: 70069577323e6f72b845166724f34b9858134437
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:58:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70069577323e6f72b845166724f34b9858134437
Gitweb:     http://git.kernel.org/tip/70069577323e6f72b845166724f34b9858134437
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 28 Aug 2009 18:13:26 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 4 Sep 2009 18:14:15 +0200

x86: Remove unused config macros from instruction decoder selftest

Remove dummy definitions of CONFIG_X86_64 and CONFIG_X86_32 because
those macros are not used in the instruction decoder anymore.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090828221326.8778.70723.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/tools/test_get_len.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index a3273f4..376d338 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -21,11 +21,6 @@
 #include <string.h>
 #include <assert.h>
 
-#ifdef __x86_64__
-#define CONFIG_X86_64
-#else
-#define CONFIG_X86_32
-#endif
 #define unlikely(cond) (cond)
 
 #include <asm/insn.h>
