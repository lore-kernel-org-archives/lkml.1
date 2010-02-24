Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0BXHk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:40:57 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:58468 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab0BXHkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:40:53 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH -tip 2/5] tracing: fix typo of info text in trace_kprobe.c
Date: Wed, 24 Feb 2010 15:40:23 +0800
Message-Id: <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B84D802.0001:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a718cd1..505c922 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -635,12 +635,12 @@ static int create_trace_probe(int argc, char **argv)
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
1.5.6

