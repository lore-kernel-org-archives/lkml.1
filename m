Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZIVMfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZIVMfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZIVMfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:35:18 -0400
Received: from ozlabs.org ([203.10.76.45]:48997 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZIVMfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:35:17 -0400
Date: Tue, 22 Sep 2009 22:34:24 +1000
From: Anton Blanchard <anton@samba.org>
To: Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Update PERF_EVENT_FORK header definition
Message-ID: <20090922123424.GD19453@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PERF_EVENT_FORK always outputs the time field, so update the header to
reflect this.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/include/linux/perf_counter.h
===================================================================
--- linux.trees.git.orig/include/linux/perf_counter.h	2009-09-22 20:24:37.000000000 +1000
+++ linux.trees.git/include/linux/perf_counter.h	2009-09-22 20:24:47.000000000 +1000
@@ -364,7 +364,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
-	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
Index: linux.trees.git/include/linux/perf_event.h
===================================================================
--- linux.trees.git.orig/include/linux/perf_event.h	2009-09-22 20:24:37.000000000 +1000
+++ linux.trees.git/include/linux/perf_event.h	2009-09-22 20:24:57.000000000 +1000
@@ -360,7 +360,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
-	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 *	u64				time;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
