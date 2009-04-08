Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbZDHI2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbZDHI2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762033AbZDHI2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZDHI2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:28:18 -0400
Date: Wed, 8 Apr 2009 08:27:36 GMT
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penguin-kernel@I-love.SAKURA.ne.jp, tglx@linutronix.de, mingo@elte.hu,
       penguin-kernel@I-love.SAKURA.ne.jp
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penguin-kernel@I-love.SAKURA.ne.jp, tglx@linutronix.de,
       penguin-kernel@I-love.SAKURA.ne.jp, mingo@elte.hu
In-Reply-To: <200904080505.n3855hcn017109@www262.sakura.ne.jp>
References: <200904080505.n3855hcn017109@www262.sakura.ne.jp>
Subject: [tip:tracing/urgent] tracing: append a comma to INIT_FTRACE_GRAPH
Message-ID: <tip-f876d346e3807647b1de411de6a86c44821896ca@git.kernel.org>
Git-Commit-ID: f876d346e3807647b1de411de6a86c44821896ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 08:27:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f876d346e3807647b1de411de6a86c44821896ca
Gitweb:     http://git.kernel.org/tip/f876d346e3807647b1de411de6a86c44821896ca
Author:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
AuthorDate: Wed, 8 Apr 2009 14:05:43 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 10:25:25 +0200

tracing: append a comma to INIT_FTRACE_GRAPH

Impact: dont break future extensions of INIT_TASK

While not a problem right now, due to lack of a comma, build fails if
elements are appended to INIT_TASK() macro in development code:

 arch/x86/kernel/init_task.c:33: error: request for member `XXXXXXXXXX' in something not a structure or union
 arch/x86/kernel/init_task.c:33: error: initializer element is not constant
 arch/x86/kernel/init_task.c:33: error: (near initialization for `init_task.ret_stack')
 make[1]: *** [arch/x86/kernel/init_task.o] Error 1
 make: *** [arch/x86/kernel] Error 2

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: srostedt@redhat.com
LKML-Reference: <200904080505.n3855hcn017109@www262.sakura.ne.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index da5405d..ff112a8 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -357,7 +357,7 @@ struct ftrace_graph_ret {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
-#define INIT_FTRACE_GRAPH		.ret_stack = NULL
+#define INIT_FTRACE_GRAPH		.ret_stack = NULL,
 
 /*
  * Stack of return addresses for functions
