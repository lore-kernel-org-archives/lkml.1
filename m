Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZIWJE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZIWJE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZIWJE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:04:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:54092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZIWJEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:04:55 -0400
Date: Wed, 23 Sep 2009 09:04:20 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, zhaolei@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090922024033.GB31801@kryten>
References: <20090922024033.GB31801@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/workqueue: Use %pf in workqueue trace events
Message-ID: <tip-9961079348d43dddb1f21118c17f054f63bbaa05@git.kernel.org>
Git-Commit-ID: 9961079348d43dddb1f21118c17f054f63bbaa05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 09:04:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9961079348d43dddb1f21118c17f054f63bbaa05
Gitweb:     http://git.kernel.org/tip/9961079348d43dddb1f21118c17f054f63bbaa05
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 22 Sep 2009 12:40:33 +1000
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 22 Sep 2009 23:14:58 +0200

tracing/workqueue: Use %pf in workqueue trace events

Using %pf instead of %pF supresses printing of the function offset
which will always be 0 in the case of worklet functions.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090922024033.GB31801@kryten>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 include/trace/events/workqueue.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index fcfd9a1..e4612db 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -26,7 +26,7 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->func)
 );
 
@@ -48,7 +48,7 @@ TRACE_EVENT(workqueue_execution,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->func)
 );
 
