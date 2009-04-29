Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbZD2NQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbZD2NQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbZD2NJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:09:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397AbZD2NJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:09:32 -0400
Date: Wed, 29 Apr 2009 13:08:46 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-30-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-30-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter: update 'perf top' documentation
Message-ID: <tip-38105f0234d4795c77c7c6845916caf3a395c451@git.kernel.org>
Git-Commit-ID: 38105f0234d4795c77c7c6845916caf3a395c451
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:08:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38105f0234d4795c77c7c6845916caf3a395c451
Gitweb:     http://git.kernel.org/tip/38105f0234d4795c77c7c6845916caf3a395c451
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:15 +0200

perf_counter: update 'perf top' documentation

The documentation about the perf-top build was outdated after
perfstat has been implemented. This updates it.

[ Impact: update documentation ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-30-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 6a276d2..8d28864 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -3,7 +3,7 @@
 
    Build with:
 
-     cc -O6 -Wall -c -o kerneltop.o kerneltop.c -lrt
+     make -C Documentation/perf_counter/
 
    Sample output:
 
