Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZFDN2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZFDN2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZFDN2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:28:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:43975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbZFDN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:28:13 -0400
Date: Thu, 4 Jun 2009 13:27:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Print out the total number of events
Message-ID: <tip-05ca061eb9704ad9b0739f88046276792b75f2c1@git.kernel.org>
Git-Commit-ID: 05ca061eb9704ad9b0739f88046276792b75f2c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 13:27:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05ca061eb9704ad9b0739f88046276792b75f2c1
Gitweb:     http://git.kernel.org/tip/05ca061eb9704ad9b0739f88046276792b75f2c1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 14:21:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 14:21:16 +0200

perf report: Print out the total number of events

So that the statistical quality of the profile can be estimated at a glance.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 15fe9da..be392e0 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -722,6 +722,8 @@ static size_t output__fprintf(FILE *fp, uint64_t total_samples)
 	size_t ret = 0;
 
 	fprintf(fp, "#\n");
+	fprintf(fp, "# (%Ld profiler events)\n", (__u64)total_samples);
+	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
 	list_for_each_entry(se, &hist_entry__sort_list, list)
