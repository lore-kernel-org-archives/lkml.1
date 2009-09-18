Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZIRTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZIRTTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZIRTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:19:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZIRTTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:19:22 -0400
Date: Fri, 18 Sep 2009 19:18:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Fix up swcounter throttling
Message-ID: <tip-cf450a7355a116af793998c118a6bcf7f5a8367e@git.kernel.org>
Git-Commit-ID: cf450a7355a116af793998c118a6bcf7f5a8367e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 19:18:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf450a7355a116af793998c118a6bcf7f5a8367e
Gitweb:     http://git.kernel.org/tip/cf450a7355a116af793998c118a6bcf7f5a8367e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 18 Sep 2009 12:18:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 20:43:22 +0200

perf_counter: Fix up swcounter throttling

/me dons the brown paper bag.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 2158452..6944bd5 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3634,7 +3634,7 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 			 */
 			break;
 		}
-		throttle = 0;
+		throttle = 1;
 	}
 }
 
