Return-Path: <linux-kernel-owner+w=401wt.eu-S937359AbZDDAc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937359AbZDDAc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936744AbZDDA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936669AbZDDA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:11 -0400
Message-Id: <20090404002808.700094050@goodmis.org>
References: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 222bbba..c005130 100644
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
