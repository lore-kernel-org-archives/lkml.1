Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbZDAKTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbZDAKTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZDAKPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:15:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbZDAKPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:15:07 -0400
Date: Wed, 1 Apr 2009 10:14:36 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171024.133985461@chello.nl>
References: <20090330171024.133985461@chello.nl>
Subject: [tip:perfcounters/core] perf_counter tools: kerneltop: update event_types
Message-ID: <tip-1fbb3f14bf98d66df9cec6b8321b6c8d2f87655a@git.kernel.org>
Git-Commit-ID: 1fbb3f14bf98d66df9cec6b8321b6c8d2f87655a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:14:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fbb3f14bf98d66df9cec6b8321b6c8d2f87655a
Gitweb:     http://git.kernel.org/tip/1fbb3f14bf98d66df9cec6b8321b6c8d2f87655a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:37 +0200

perf_counter tools: kerneltop: update event_types

Go along with the new perf_event_type ABI.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171024.133985461@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index c0ca015..430810d 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -1263,8 +1263,8 @@ static void mmap_read(struct mmap_data *md)
 		old += size;
 
 		switch (event->header.type) {
-		case PERF_EVENT_IP:
-		case PERF_EVENT_IP | __PERF_EVENT_TID:
+		case PERF_EVENT_OVERFLOW | __PERF_EVENT_IP:
+		case PERF_EVENT_OVERFLOW | __PERF_EVENT_IP | __PERF_EVENT_TID:
 			process_event(event->ip.ip, md->counter);
 			break;
 
