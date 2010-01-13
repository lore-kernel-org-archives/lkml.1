Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816Ab0AMKi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0AMKi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680Ab0AMKiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:38:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:38570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab0AMKiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:38:20 -0500
Date: Wed, 13 Jan 2010 10:37:36 GMT
From: tip-bot for Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       wenji.huang@oracle.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, wenji.huang@oracle.com, mingo@elte.hu
In-Reply-To: <1263373298-13282-1-git-send-email-wenji.huang@oracle.com>
References: <1263373298-13282-1-git-send-email-wenji.huang@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Make cmd_to_page() function more compact
Message-ID: <tip-ff314d3903c2843de65c2148f66f277f2440ed26@git.kernel.org>
Git-Commit-ID: ff314d3903c2843de65c2148f66f277f2440ed26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:37:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff314d3903c2843de65c2148f66f277f2440ed26
Gitweb:     http://git.kernel.org/tip/ff314d3903c2843de65c2148f66f277f2440ed26
Author:     Wenji Huang <wenji.huang@oracle.com>
AuthorDate: Wed, 13 Jan 2010 17:01:38 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:53:51 +0100

perf: Make cmd_to_page() function more compact

Remove branch for is_perf_command.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Cc: fweisbec@gmail.com
Cc: jkacur@redhat.com
Cc: acme@redhat.com
LKML-Reference: <1263373298-13282-1-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-help.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index e427d69..215b584 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -313,8 +313,6 @@ static const char *cmd_to_page(const char *perf_cmd)
 		return "perf";
 	else if (!prefixcmp(perf_cmd, "perf"))
 		return perf_cmd;
-	else if (is_perf_command(perf_cmd))
-		return prepend("perf-", perf_cmd);
 	else
 		return prepend("perf-", perf_cmd);
 }
