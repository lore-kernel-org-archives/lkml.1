Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZIYWCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZIYWCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZIYWCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:02:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZIYWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:02:48 -0400
Date: Fri, 25 Sep 2009 15:02:39 -0700
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] perf top: Add poll_idle to the skip list
Message-ID: <20090925220239.GA5488@ghostprotocols.net>
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
index a92e82b..15c221e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -779,6 +779,7 @@ static const char *skip_symbols[] = {
 	"exit_idle",
 	"mwait_idle",
 	"mwait_idle_with_hints",
+	"poll_idle",
 	"ppc64_runlatch_off",
 	"pseries_dedicated_idle_sleep",
 	NULL
-- 
1.6.2.5

