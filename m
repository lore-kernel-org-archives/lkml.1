Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZD2KwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZD2KwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZD2KvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:06 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21077 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZD2KvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:00 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIUZGO-01-7AC-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/29] perfcounter: declare perf_max_counters only for CONFIG_PERF_COUNTERS
Date: Wed, 29 Apr 2009 12:46:59 +0200
Message-ID: <1241002046-8832-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0008 (UTC) FILETIME=[5B6B8300:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only needed for CONFIG_PERF_COUNTERS enabled.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/perf_counter.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9814328..be10b3f 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -512,12 +512,13 @@ struct perf_cpu_context {
 	int			recursion[4];
 };
 
+#ifdef CONFIG_PERF_COUNTERS
+
 /*
  * Set by architecture code:
  */
 extern int perf_max_counters;
 
-#ifdef CONFIG_PERF_COUNTERS
 extern const struct hw_perf_counter_ops *
 hw_perf_counter_init(struct perf_counter *counter);
 
-- 
1.6.1.3


