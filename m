Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbYFFW6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbYFFW6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932885AbYFFW5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:57:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22947 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbYFFW5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:57:30 -0400
Message-ID: <4849C0D8.3050006@ct.jp.nec.com>
Date: Fri, 06 Jun 2008 15:57:28 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Update taskstats-struct document for scaled time accounting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Update Documentation/accounting/taskstats-struct.txt for TASKSTATS_VERSION 6,
adding scaled time accounting.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 Documentation/accounting/taskstats-struct.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/accounting/taskstats-struct.txt b/Documentation/accounting/taskstats-struct.txt
index 8aa7529..cd784f4 100644
--- a/Documentation/accounting/taskstats-struct.txt
+++ b/Documentation/accounting/taskstats-struct.txt
@@ -24,6 +24,8 @@ There are three different groups of fields in the struct taskstats:
 
 4) Per-task and per-thread context switch count statistics
 
+5) Time accounting for SMT machines
+
 Future extension should add fields to the end of the taskstats struct, and
 should not change the relative position of each field within the struct.
 
@@ -164,4 +166,8 @@ struct taskstats {
 	__u64	nvcsw;			/* Context voluntary switch counter */
 	__u64	nivcsw;			/* Context involuntary switch counter */
 
+5) Time accounting for SMT machines
+	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
+	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
+	__u64	cpu_scaled_run_real_total; /* scaled cpu_run_real_total */
 }
-- 
1.5.4.1

