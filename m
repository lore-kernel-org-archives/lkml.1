Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZCVSpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZCVSpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZCVSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:45:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:47617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZCVSpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:45:41 -0400
Subject: [PATCH -tip] trace: trace.c fix signedness issue
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 00:15:20 +0530
Message-Id: <1237747520.8713.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Mon, 23 Mar 2009 00:11:22 +0530
Subject: [PATCH] trace: trace.c fix signedness issue

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 17bb88d..e85fc41 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2929,8 +2929,8 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
+	unsigned long val;
 	char buf[64];
-	long val;
 	int ret;
 
 	if (cnt >= sizeof(buf))
-- 
1.6.0.6



