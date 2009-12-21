Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZLUJ0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZLUJ0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbZLUJ0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:26:21 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:19155 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZLUJ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:26:21 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, mingo@elte.hu, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] perf: fix incorrect return value for else case
Date: Mon, 21 Dec 2009 17:22:39 +0800
Message-Id: <1261387359-1933-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B2F3F14.0072:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return original cmd instead of adding prefix.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 tools/perf/builtin-help.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 9f810b1..ca77df5 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -317,7 +317,7 @@ static const char *cmd_to_page(const char *perf_cmd)
 	else if (is_perf_command(perf_cmd))
 		return prepend("perf-", perf_cmd);
 	else
-		return prepend("perf-", perf_cmd);
+		return perf_cmd;
 }
 
 static void setup_man_path(void)
-- 
1.5.6

