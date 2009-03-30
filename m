Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZC3RLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZC3RLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZC3RLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZC3RLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:22 -0400
Message-Id: <20090330171024.133985461@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:13 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/15] pref_counter: kerneltop: update event_types
Content-Disposition: inline; filename=kerneltop-rearrange-event-types.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

go along with the new perf_event_type

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -1263,8 +1263,8 @@ static void mmap_read(struct mmap_data *
 		old += size;
 
 		switch (event->header.type) {
-		case PERF_EVENT_IP:
-		case PERF_EVENT_IP | __PERF_EVENT_TID:
+		case PERF_EVENT_OVERFLOW | __PERF_EVENT_IP:
+		case PERF_EVENT_OVERFLOW | __PERF_EVENT_IP | __PERF_EVENT_TID:
 			process_event(event->ip.ip, md->counter);
 			break;
 

-- 

