Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZIJEOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZIJEOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZIJEOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:14:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZIJEM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:12:59 -0400
Message-Id: <20090910041301.589064840@goodmis.org>
References: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/6] tracing: remove stats from struct tracer
Content-Disposition: inline; filename=0005-tracing-remove-stats-from-struct-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Remove unused field @stats from struct tracer.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AA8579B.4020706@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 86a0523..2163d18 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -382,7 +382,6 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags	*flags;
-	struct tracer_stat	*stats;
 };
 
 
-- 
1.6.3.3

-- 
