Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZFFT2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZFFT2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 15:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZFFT2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 15:28:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZFFT2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 15:28:05 -0400
Date: Sat, 6 Jun 2009 19:27:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf annotate: Fix command line help text
Message-ID: <tip-23b87116c7c4f73597965218b66041acbdb4e79f@git.kernel.org>
Git-Commit-ID: 23b87116c7c4f73597965218b66041acbdb4e79f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 19:27:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23b87116c7c4f73597965218b66041acbdb4e79f
Gitweb:     http://git.kernel.org/tip/23b87116c7c4f73597965218b66041acbdb4e79f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 6 Jun 2009 21:25:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 21:25:29 +0200

perf annotate: Fix command line help text

Arjan noticed this bug in the perf annotate help output:

    -s, --symbol <file>   symbol to annotate

that should be <symbol> instead.

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 80c5aa0..0e23fe9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -1300,7 +1300,7 @@ static const char * const annotate_usage[] = {
 static const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
-	OPT_STRING('s', "symbol", &sym_hist_filter, "file",
+	OPT_STRING('s', "symbol", &sym_hist_filter, "symbol",
 		    "symbol to annotate"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
