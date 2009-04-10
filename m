Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbZDJLN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbZDJLN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZDJLNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:13:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:38948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbZDJLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:13:15 -0400
Date: Fri, 10 Apr 2009 11:12:31 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       penberg@cs.helsinki.fi, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DE97EF.7080208@cn.fujitsu.com>
References: <49DE97EF.7080208@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: fix document references
Message-ID: <tip-4d1f4372dbea068ba4ee3d98231133a4a4ee15bd@git.kernel.org>
Git-Commit-ID: 4d1f4372dbea068ba4ee3d98231133a4a4ee15bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 11:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d1f4372dbea068ba4ee3d98231133a4a4ee15bd
Gitweb:     http://git.kernel.org/tip/4d1f4372dbea068ba4ee3d98231133a4a4ee15bd
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 10 Apr 2009 08:48:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:08:50 +0200

tracing: fix document references

When moving documents to Documentation/trace/, I forgot to
grep Kconfig to find out those references.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pekka Paalanen <pq@iki.fi>
Cc: eduard.munteanu@linux360.ro
LKML-Reference: <49DE97EF.7080208@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2246141..417d198 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -312,7 +312,7 @@ config KMEMTRACE
 	  and profile kernel code.
 
 	  This requires an userspace application to use. See
-	  Documentation/vm/kmemtrace.txt for more information.
+	  Documentation/trace/kmemtrace.txt for more information.
 
 	  Saying Y will make the kernel somewhat larger and slower. However,
 	  if you disable kmemtrace at run-time or boot-time, the performance
@@ -403,7 +403,7 @@ config MMIOTRACE
 	  implementation and works via page faults. Tracing is disabled by
 	  default and can be enabled at run-time.
 
-	  See Documentation/tracers/mmiotrace.txt.
+	  See Documentation/trace/mmiotrace.txt.
 	  If you are not helping to develop drivers, say N.
 
 config MMIOTRACE_TEST
