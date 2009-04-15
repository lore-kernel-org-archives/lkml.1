Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZDODQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZDODQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZDODQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:16:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZDODQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:16:08 -0400
Message-Id: <20090415031604.933829085@goodmis.org>
References: <20090415031511.128139334@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 23:15:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 2/4] tracing/events: fix lockdep system name
Content-Disposition: inline; filename=0002-tracing-events-fix-lockdep-system-name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix compile error of lockdep event tracer

Ingo Molnar pointed out that the system name for the lockdep tracer was "lock"
which is used to include the event trace file name. It should be "lockdep"

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/lockdep.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/lockdep.h b/include/trace/lockdep.h
index 4d301e7..45e326b 100644
--- a/include/trace/lockdep.h
+++ b/include/trace/lockdep.h
@@ -5,7 +5,7 @@
 #include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM lock
+#define TRACE_SYSTEM lockdep
 
 #ifdef CONFIG_LOCKDEP
 
-- 
1.6.2.1

-- 
