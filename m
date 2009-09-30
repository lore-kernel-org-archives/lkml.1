Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZI3MNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZI3MNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZI3MNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:13:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:37758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZI3MNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:13:40 -0400
Date: Wed, 30 Sep 2009 12:13:07 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090925220239.GA5488@ghostprotocols.net>
References: <20090925220239.GA5488@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Add poll_idle to the skip list
Message-ID: <tip-8357275bb919d91093bc5a959932ef7b1ea816e8@git.kernel.org>
Git-Commit-ID: 8357275bb919d91093bc5a959932ef7b1ea816e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 30 Sep 2009 12:13:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8357275bb919d91093bc5a959932ef7b1ea816e8
Gitweb:     http://git.kernel.org/tip/8357275bb919d91093bc5a959932ef7b1ea816e8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 25 Sep 2009 15:02:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Sep 2009 13:56:54 +0200

perf top: Add poll_idle to the skip list

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20090925220239.GA5488@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-top.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1ca8889..37512e9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -782,6 +782,7 @@ static const char *skip_symbols[] = {
 	"exit_idle",
 	"mwait_idle",
 	"mwait_idle_with_hints",
+	"poll_idle",
 	"ppc64_runlatch_off",
 	"pseries_dedicated_idle_sleep",
 	NULL
