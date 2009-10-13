Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbZJMUgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbZJMUgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761263AbZJMUgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:36:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760931AbZJMUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:36:23 -0400
Message-Id: <20091013203425.342967518@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 16:33:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] [PATCH 2/5] tracing: export symbols for kernel lock tracepoints
References: <20091013203349.814936710@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-export-symbols-for-kernel-lock-tracepoints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The big kernel lock tracepoints are used inside modules and they need
to be exported accordingly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/kernel_lock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 4ebfa5a..76f05bc 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -139,3 +139,5 @@ void __lockfunc _unlock_kernel(const char *func, const char *file, int line)
 EXPORT_SYMBOL(_lock_kernel);
 EXPORT_SYMBOL(_unlock_kernel);
 
+EXPORT_TRACEPOINT_SYMBOL(lock_kernel);
+EXPORT_TRACEPOINT_SYMBOL(unlock_kernel);
-- 
1.6.3.3


