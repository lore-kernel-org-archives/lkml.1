Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbZLUJ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbZLUJ6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZLUJ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:58:13 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:35718 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZLUJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:58:12 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, mingo@elte.hu, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] perf: fix typo in builtin-kmem.c
Date: Mon, 21 Dec 2009 17:52:55 +0800
Message-Id: <1261389175-2227-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4B2F4699.0086:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace bytes_req with bytes_alloc.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
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
-- 
1.5.6

