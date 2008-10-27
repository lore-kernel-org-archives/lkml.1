Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYJ0Qmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYJ0Qmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYJ0QmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:42:01 -0400
Received: from styx.suse.cz ([82.119.242.94]:41856 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752321AbYJ0Ql7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:41:59 -0400
Date: Mon, 27 Oct 2008 17:41:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: fix documentation reference for
 sched_min_granularity_ns
Message-ID: <alpine.LNX.1.10.0810271739330.12928@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched-design-CFS.txt wrongly references sched_granularity_ns sysctl,
as its name in fact is sched_min_granularity_ns.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/scheduler/sched-design-CFS.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 9d8eb55..eb471c7 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -92,7 +92,7 @@ other HZ detail.  Thus the CFS scheduler has no notion of "timeslices" in the
 way the previous scheduler had, and has no heuristics whatsoever.  There is
 only one central tunable (you have to switch on CONFIG_SCHED_DEBUG):
 
-   /proc/sys/kernel/sched_granularity_ns
+   /proc/sys/kernel/sched_min_granularity_ns
 
 which can be used to tune the scheduler from "desktop" (i.e., low latencies) to
 "server" (i.e., good batching) workloads.  It defaults to a setting suitable
-- 
1.5.6

