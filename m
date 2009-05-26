Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZEZKet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZEZKet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZEZKek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:34:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:56434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZEZKej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:34:39 -0400
Date: Tue, 26 May 2009 10:33:50 GMT
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
Subject: [tip:perfcounters/core] perf record: Straighten out argv types
Message-ID: <tip-69aa48ab82e17299efe2be6c21795945731a6c17@git.kernel.org>
Git-Commit-ID: 69aa48ab82e17299efe2be6c21795945731a6c17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 10:34:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69aa48ab82e17299efe2be6c21795945731a6c17
Gitweb:     http://git.kernel.org/tip/69aa48ab82e17299efe2be6c21795945731a6c17
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 09:02:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 10:05:56 +0200

perf record: Straighten out argv types

[ Impact: cleanup ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 1b19f18..f225efa 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -191,7 +191,7 @@ static void display_help(void)
 	exit(0);
 }
 
-static void process_options(int argc, const char *argv[])
+static void process_options(int argc, char * const argv[])
 {
 	int error = 0, counter;
 
@@ -538,7 +538,7 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
-int cmd_record(int argc, const char **argv)
+int cmd_record(int argc, char * const argv[])
 {
 	int i, counter;
 	pid_t pid;
