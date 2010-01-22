Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255Ab0AVOzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0AVOzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596Ab0AVOzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:12 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:10391
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752009Ab0AVOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:11 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i87h6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFJ-01-748-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/12] perf/core, x86: remove cpu_hw_events.interrupts
Date: Fri, 22 Jan 2010 15:21:59 +0100
Message-ID: <1264170127-17402-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0299 (UTC) FILETIME=[DBFF2930:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This member in the struct is not used anymore and can be removed.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4291f86..c49221b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -70,7 +70,6 @@ struct cpu_hw_events {
 	struct perf_event	*events[X86_PMC_IDX_MAX];
 	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	unsigned long		interrupts;
 	int			enabled;
 	struct debug_store	*ds;
 };
-- 
1.6.6


