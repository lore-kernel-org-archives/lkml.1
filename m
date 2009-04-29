Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZD2K5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZD2K5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZD2Kv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:28 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21216 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbZD2KvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:05 -0400
X-BigFish: VPS1(zzzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KIUZGQ-02-18R-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 17/29] x86/perfcounters: make x86_pmu_read() static inline
Date: Wed, 29 Apr 2009 12:47:14 +0200
Message-ID: <1241002046-8832-18-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0586 (UTC) FILETIME=[5BC3B520:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 15d2c03..3f3ae47 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1002,7 +1002,7 @@ void __init init_hw_perf_counters(void)
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
 
-static void x86_pmu_read(struct perf_counter *counter)
+static inline void x86_pmu_read(struct perf_counter *counter)
 {
 	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
 }
-- 
1.6.1.3


