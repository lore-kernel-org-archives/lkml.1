Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbZDIFbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbZDIFbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbZDIFbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:31:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:59017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894AbZDIFb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:31:29 -0400
Date: Thu, 9 Apr 2009 05:30:47 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49DD6E2B.6090200@cn.fujitsu.com>
References: <49DD6E2B.6090200@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing: consolidate documents
Message-ID: <tip-66bb74888eb4bef4ba7c87c931ecb7ecca3a240c@git.kernel.org>
Git-Commit-ID: 66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 05:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
Gitweb:     http://git.kernel.org/tip/66bb74888eb4bef4ba7c87c931ecb7ecca3a240c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 9 Apr 2009 11:40:27 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 07:28:10 +0200

tracing: consolidate documents

Move kmemtrace.txt, tracepoints.txt, ftrace.txt and mmiotrace.txt to
the new trace/ directory.

I didnt find any references to those documents in both source
files and documents, so no extra work needs to be done.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
LKML-Reference: <49DD6E2B.6090200@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/{ => trace}/ftrace.txt           |    0
 Documentation/{vm => trace}/kmemtrace.txt      |    0
 Documentation/{tracers => trace}/mmiotrace.txt |    0
 Documentation/{ => trace}/tracepoints.txt      |    0
 4 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/trace/ftrace.txt
similarity index 100%
rename from Documentation/ftrace.txt
rename to Documentation/trace/ftrace.txt
diff --git a/Documentation/vm/kmemtrace.txt b/Documentation/trace/kmemtrace.txt
similarity index 100%
rename from Documentation/vm/kmemtrace.txt
rename to Documentation/trace/kmemtrace.txt
diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/trace/mmiotrace.txt
similarity index 100%
rename from Documentation/tracers/mmiotrace.txt
rename to Documentation/trace/mmiotrace.txt
diff --git a/Documentation/tracepoints.txt b/Documentation/trace/tracepoints.txt
similarity index 100%
rename from Documentation/tracepoints.txt
rename to Documentation/trace/tracepoints.txt
