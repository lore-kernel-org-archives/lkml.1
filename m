Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbZH1WMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbZH1WMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZH1WMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZH1WMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:12:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 2/2] x86: Remove unused config macros
	from instruction decoder selftest
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 28 Aug 2009 18:13:26 -0400
Message-ID: <20090828221326.8778.70723.stgit@localhost.localdomain>
In-Reply-To: <20090827163533.GA30268@elte.hu>
References: <20090827163533.GA30268@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dummy definitions of CONFIG_X86_64 and CONFIG_X86_32 because those
macros are not used in the instruction decoder anymore.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
