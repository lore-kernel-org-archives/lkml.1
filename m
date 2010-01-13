Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171Ab0AMJGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0AMJGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794Ab0AMJGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:06:41 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:28754 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0AMJGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:06:40 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, jkacur@redhat.com, acme@redhat.com, mingo@elte.hu,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] perf: make cmd_to_page function compact
Date: Wed, 13 Jan 2010 17:01:38 +0800
Message-Id: <1263373298-13282-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B4D8D07.00B0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove branch for is_perf_command

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 tools/perf/builtin-help.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 9f810b1..65e2691 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -314,8 +314,6 @@ static const char *cmd_to_page(const char *perf_cmd)
 		return "perf";
 	else if (!prefixcmp(perf_cmd, "perf"))
 		return perf_cmd;
-	else if (is_perf_command(perf_cmd))
-		return prepend("perf-", perf_cmd);
 	else
 		return prepend("perf-", perf_cmd);
 }
-- 
1.5.6

