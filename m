Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0BXHlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:41:18 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:26207 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab0BXHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:40:56 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH -tip 4/5] tracing: return accurate value for print_graph_prologue
Date: Wed, 24 Feb 2010 15:40:25 +0800
Message-Id: <1266997226-6833-4-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
 <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
 <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B84D805.00B6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return TRACE_TYPE_HANDLED instead of zero to avoid confusion.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_functions_graph.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 112561d..bd0bdeb 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -806,7 +806,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	return 0;
+	return TRACE_TYPE_HANDLED;
 }
 
 static enum print_line_t
-- 
1.5.6

