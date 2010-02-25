Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab0BYTpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:45:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50242 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab0BYTpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=i3bM9CAoJmYA:10 a=yPCof4ZbAAAA:8 a=meVymXHHAAAA:8 a=hQDZtpOuYEoamjURNtwA:9 a=xsJZnm2CvhIlbctw0nn_rJqK1fcA:4 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194529.722609348@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:44:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 5/7] tracing: Fix typo of info text in trace_kprobe.c
References: <20100225194355.707261669@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Fix-typo-of-info-text-in-trace_kprobe.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c990299..8d4bd16 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -651,12 +651,12 @@ static int create_trace_probe(int argc, char **argv)
 			event = strchr(group, '/') + 1;
 			event[-1] = '\0';
 			if (strlen(group) == 0) {
-				pr_info("Group name is not specifiled\n");
+				pr_info("Group name is not specified\n");
 				return -EINVAL;
 			}
 		}
 		if (strlen(event) == 0) {
-			pr_info("Event name is not specifiled\n");
+			pr_info("Event name is not specified\n");
 			return -EINVAL;
 		}
 	}
-- 
1.6.5


