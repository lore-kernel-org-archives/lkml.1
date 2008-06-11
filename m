Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYFKD3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYFKD3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYFKD32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:29:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5944 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYFKD31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:29:27 -0400
Message-ID: <484F468F.5000906@ct.jp.nec.com>
Date: Tue, 10 Jun 2008 20:29:19 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix typo in Documentation/scheduler/sched-rt-group.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Fix minor typos.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 Documentation/scheduler/sched-rt-group.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 14f901f..3ef339f 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -51,9 +51,9 @@ needs only about 3% CPU time to do so, it can do with a 0.03 * 0.005s =
 0.00015s. So this group can be scheduled with a period of 0.005s and a run time
 of 0.00015s.
 
-The remaining CPU time will be used for user input and other tass. Because
+The remaining CPU time will be used for user input and other tasks. Because
 realtime tasks have explicitly allocated the CPU time they need to perform
-their tasks, buffer underruns in the graphocs or audio can be eliminated.
+their tasks, buffer underruns in the graphics or audio can be eliminated.
 
 NOTE: the above example is not fully implemented as of yet (2.6.25). We still
 lack an EDF scheduler to make non-uniform periods usable.
-- 
1.5.4.1

