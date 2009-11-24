Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZKXF1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZKXF1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZKXF1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:27:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56944 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZKXF1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:27:42 -0500
Message-ID: <4B0B6EAF.80802@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 13:27:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 5/5] perf kmem: Add help file
References: <4B0B6E44.6090106@cn.fujitsu.com>
In-Reply-To: <4B0B6E44.6090106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Documentation/perf-kmem.txt

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-kmem.txt |   44 ++++++++++++++++++++++++++++++++
 tools/perf/command-list.txt            |    1 +
 2 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-kmem.txt

diff --git a/tools/perf/Documentation/perf-kmem.txt b/tools/perf/Documentation/perf-kmem.txt
new file mode 100644
index 0000000..44b0ce3
--- /dev/null
+++ b/tools/perf/Documentation/perf-kmem.txt
@@ -0,0 +1,44 @@
+perf-kmem(1)
+==============
+
+NAME
+----
+perf-kmem - Tool to trace/measure kernel memory(slab) properties
+
+SYNOPSIS
+--------
+[verse]
+'perf kmem' {record} [<options>]
+
+DESCRIPTION
+-----------
+There's two variants of perf kmem:
+
+  'perf kmem record <command>' to record the kmem events
+  of an arbitrary workload.
+
+  'perf kmem' to report kernel memory statistics.
+
+OPTIONS
+-------
+-i <file>::
+--input=<file>::
+	Select the input file (default: perf.data)
+
+--stat=<caller|alloc>::
+	Select per callsite or per allocation statistics
+
+-s <key[,key2...]>::
+--sort=<key[,key2...]>::
+	Sort the output (default: frag,hit,bytes)
+
+-l <num>::
+--line=<num>::
+	Print n lines only
+
+--raw-ip::
+	Print raw ip instead of symbol
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index d3a6e18..02b09ea 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -14,3 +14,4 @@ perf-timechart			mainporcelain common
 perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
+perf-kmem			mainporcelain common
-- 
1.6.3

