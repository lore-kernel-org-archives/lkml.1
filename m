Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZDFQl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZDFQl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZDFQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:39:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZDFQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:39:14 -0400
Message-Id: <20090406163830.552790815@goodmis.org>
References: <20090406163706.097842409@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 12:37:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/10] tracing/ftrace: fix missing include string.h
Content-Disposition: inline; filename=0004-tracing-ftrace-fix-missing-include-string.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Building a kernel with tracing can raise the following warning on
tip/master:

kernel/trace/trace.c:1249: error: implicit declaration of function 'vbin_printf'

We are missing an include to string.h

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5232201..6f15d85 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/splice.h>
 #include <linux/kdebug.h>
+#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-- 
1.6.2.1

-- 
