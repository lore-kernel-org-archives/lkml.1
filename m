Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0CDQe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:34:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:46469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0CDQeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:34:25 -0500
Date: Thu, 4 Mar 2010 16:33:55 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267599873-8193-2-git-send-email-tzanussi@gmail.com>
References: <1267599873-8193-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf trace/scripting: Remove extraneous header read
Message-ID: <tip-10c95f4f41889daaa8130e0bd12209825dbe8d39@git.kernel.org>
Git-Commit-ID: 10c95f4f41889daaa8130e0bd12209825dbe8d39
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:33:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10c95f4f41889daaa8130e0bd12209825dbe8d39
Gitweb:     http://git.kernel.org/tip/10c95f4f41889daaa8130e0bd12209825dbe8d39
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 3 Mar 2010 01:04:32 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:19:54 +0100

perf trace/scripting: Remove extraneous header read

perf_header__read() is already done in perf_session__open(), so
remove it from the script gen case.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1267599873-8193-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5db687f..b8153db 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -608,7 +608,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		perf_header__read(&session->header, input);
 		err = scripting_ops->generate_script("perf-trace");
 		goto out;
 	}
