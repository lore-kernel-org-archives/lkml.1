Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZLBIYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZLBIYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZLBIYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:24:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:39001 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZLBIYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:24:43 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>, mhiramat@redhat.com, fweisbec@gmail.com
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH] perf tools: fix compiling error for strndup
Date: Wed,  2 Dec 2009 15:59:10 +0800
Message-Id: <1259740750-12646-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 02 Dec 2009 08:24:20.0937 (UTC) FILETIME=[D8F60B90:01CA7328]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant include files to avoid compiling error.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/string.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0977cf4..f24a8cc 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,3 @@
-#include <string.h>
-#include <stdlib.h>
 #include "string.h"
 #include "util.h"
 
-- 
1.6.0.3

