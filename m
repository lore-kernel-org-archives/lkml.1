Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZFCSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZFCSnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbZFCSnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:43:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZFCSnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:43:11 -0400
Date: Wed, 3 Jun 2009 18:42:33 GMT
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
Subject: [tip:perfcounters/core] perf report: Display 100% correctly
Message-ID: <tip-e98e96fe43ae92fad0930f05fb2b298e49b9f3b5@git.kernel.org>
Git-Commit-ID: e98e96fe43ae92fad0930f05fb2b298e49b9f3b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 18:42:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e98e96fe43ae92fad0930f05fb2b298e49b9f3b5
Gitweb:     http://git.kernel.org/tip/e98e96fe43ae92fad0930f05fb2b298e49b9f3b5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 19:30:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 19:30:38 +0200

perf report: Display 100% correctly

Needs to be 6.2 not 5.2, for 100.00% to be aligned properly.

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
 Documentation/perf_counter/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 6d359c9..e837bb9 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -529,7 +529,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
 	size_t ret;
 
 	if (total_samples) {
-		ret = fprintf(fp, "    %5.2f%%",
+		ret = fprintf(fp, "   %6.2f%%",
 				(self->count * 100.0) / total_samples);
 	} else
 		ret = fprintf(fp, "%12d ", self->count);
