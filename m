Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZEZMQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZEZMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZEZMQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZEZMQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:16:22 -0400
Date: Tue, 26 May 2009 12:15:38 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Add help/manpage
Message-ID: <tip-0bec253c813fbb067db4dfd9f5b6cec1bd2ef026@git.kernel.org>
Git-Commit-ID: 0bec253c813fbb067db4dfd9f5b6cec1bd2ef026
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 12:15:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bec253c813fbb067db4dfd9f5b6cec1bd2ef026
Gitweb:     http://git.kernel.org/tip/0bec253c813fbb067db4dfd9f5b6cec1bd2ef026
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 09:17:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 13:11:57 +0200

perf report: Add help/manpage

Add a (minimal) manpage for perf report.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../perf_counter/Documentation/perf-report.txt     |   32 ++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/Documentation/perf-report.txt b/Documentation/perf_counter/Documentation/perf-report.txt
new file mode 100644
index 0000000..64696a2
--- /dev/null
+++ b/Documentation/perf_counter/Documentation/perf-report.txt
@@ -0,0 +1,32 @@
+perf-report(1)
+==========
+
+NAME
+----
+perf-report - Read output.perf (created by perf record) and display the profile
+
+SYNOPSIS
+--------
+[verse]
+'perf report' [-i <file> | --input=file]
+
+DESCRIPTION
+-----------
+This command displays the performance counter profile information recorded
+via perf report.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Input file name. (default: output.perf)
+
+Configuration
+-------------
+
+EXAMPLES
+--------
+
+SEE ALSO
+--------
+linkperf:perf-stat[1]
