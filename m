Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbZF3X2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbZF3X2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbZF3X2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:28:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:60486 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606AbZF3X2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:28:17 -0400
Date: Tue, 30 Jun 2009 23:27:44 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630230140.714204656@samba.org>
References: <20090630230140.714204656@samba.org>
Subject: [tip:perfcounters/urgent] perf report: Fix -z option
Message-ID: <tip-1f208ea67821703fd4de056ea6f0baa81f4ad4a5@git.kernel.org>
Git-Commit-ID: 1f208ea67821703fd4de056ea6f0baa81f4ad4a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:27:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f208ea67821703fd4de056ea6f0baa81f4ad4a5
Gitweb:     http://git.kernel.org/tip/1f208ea67821703fd4de056ea6f0baa81f4ad4a5
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 09:00:44 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 01:25:18 +0200

perf report: Fix -z option

Fix a copy and paste error, -z was setting the group option.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <20090630230140.714204656@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cf0d21f..5c29655 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -675,7 +675,7 @@ static const struct option options[] = {
 			    "put the counters into a counter group"),
 	OPT_STRING('s', "sym-filter", &sym_filter, "pattern",
 		    "only display symbols matchig this pattern"),
-	OPT_BOOLEAN('z', "zero", &group,
+	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
 		    "profile at this frequency"),
