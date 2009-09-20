Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZITKem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZITKem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 06:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZITKel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 06:34:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:40806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZITKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 06:34:41 -0400
Subject: [PATCH] trace: export trace_profile_buf symbols
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 12:34:38 +0200
Message-Id: <1253442878.7542.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "trace_profile_buf_nmi" [fs/jbd2/jbd2.ko] undefined!                                                                        
ERROR: "trace_profile_buf" [fs/jbd2/jbd2.ko] undefined!
ERROR: "trace_profile_buf_nmi" [fs/ext4/ext4.ko] undefined!
ERROR: "trace_profile_buf" [fs/ext4/ext4.ko] undefined!
ERROR: "trace_profile_buf_nmi" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "trace_profile_buf" [arch/x86/kvm/kvm.ko] undefined!

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace_event_profile.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 3aaa77c..f65e966 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -17,6 +17,9 @@ typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
 char		*trace_profile_buf;
 char 		*trace_profile_buf_nmi;
 
+EXPORT_SYMBOL_GPL(trace_profile_buf);
+EXPORT_SYMBOL_GPL(trace_profile_buf_nmi);
+
 /* Count the events in use (per event id, not per instance) */
 static int	total_profile_count;
 


