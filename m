Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZHMKsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZHMKsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZHMKsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:48:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:47437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZHMKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:48:12 -0400
Message-Id: <20090813103655.334194326@chello.nl>
References: <20090813094752.433445710@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:47:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf tools: Add some comments to the event definitions
Content-Disposition: inline; filename=perf-tools-fix-read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to make it clear that these are _not_ generic event structures
but do rely on the counter configuration.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/util/event.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/tools/perf/util/event.h
===================================================================
--- linux-2.6.orig/tools/perf/util/event.h
+++ linux-2.6/tools/perf/util/event.h
@@ -4,6 +4,9 @@
 #include "util.h"
 #include <linux/list.h>
 
+/*
+ * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
+ */
 struct ip_event {
 	struct perf_event_header header;
 	u64 ip;
@@ -38,6 +41,9 @@ struct lost_event {
 	u64 lost;
 };
 
+/*
+ * PERF_FORMAT_ENABLED | PERF_FORMAT_RUNNING | PERF_FORMAT_ID
+ */
 struct read_event {
 	struct perf_event_header header;
 	u32 pid,tid;

-- 

