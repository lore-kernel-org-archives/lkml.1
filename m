Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZL1KJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZL1KJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZL1KJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:09:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:36351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZL1KJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:09:28 -0500
Date: Mon, 28 Dec 2009 10:08:50 GMT
From: tip-bot for Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, wenji.huang@oracle.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, wenji.huang@oracle.com,
       mingo@elte.hu
In-Reply-To: <1261389175-2227-1-git-send-email-wenji.huang@oracle.com>
References: <1261389175-2227-1-git-send-email-wenji.huang@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem: Fix statistics typo
Message-ID: <tip-4efb5290ae187514bd31af8c2d7755e175245e19@git.kernel.org>
Git-Commit-ID: 4efb5290ae187514bd31af8c2d7755e175245e19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4efb5290ae187514bd31af8c2d7755e175245e19
Gitweb:     http://git.kernel.org/tip/4efb5290ae187514bd31af8c2d7755e175245e19
Author:     Wenji Huang <wenji.huang@oracle.com>
AuthorDate: Mon, 21 Dec 2009 17:52:55 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:31:56 +0100

perf kmem: Fix statistics typo

Replace bytes_req with bytes_alloc.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: acme@redhat.com
LKML-Reference: <1261389175-2227-1-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-kmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fc21ad7..7ceb741 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -137,7 +137,7 @@ static void insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 	if (data && data->ptr == ptr) {
 		data->hit++;
 		data->bytes_req += bytes_req;
-		data->bytes_alloc += bytes_req;
+		data->bytes_alloc += bytes_alloc;
 	} else {
 		data = malloc(sizeof(*data));
 		if (!data)
@@ -177,7 +177,7 @@ static void insert_caller_stat(unsigned long call_site,
 	if (data && data->call_site == call_site) {
 		data->hit++;
 		data->bytes_req += bytes_req;
-		data->bytes_alloc += bytes_req;
+		data->bytes_alloc += bytes_alloc;
 	} else {
 		data = malloc(sizeof(*data));
 		if (!data)
