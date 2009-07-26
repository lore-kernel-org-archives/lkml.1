Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZGZWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZGZWGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZGZWGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 18:06:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42182 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZGZWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 18:06:40 -0400
Date: Sun, 26 Jul 2009 19:06:19 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf top: Add mwait_idle_with_hints to skip_symbols
Message-ID: <20090726220618.GB20675@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c0a4230..f139f1a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -285,6 +285,7 @@ static const char *skip_symbols[] = {
 	"enter_idle",
 	"exit_idle",
 	"mwait_idle",
+	"mwait_idle_with_hints",
 	"ppc64_runlatch_off",
 	"pseries_dedicated_idle_sleep",
 	NULL
-- 
1.6.2.5


