Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZLBGh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZLBGh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZLBGh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:37:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:52624 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZLBGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:37:27 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>, mhiramat@redhat.com, fweisbec@gmail.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH]  perf tools: Add _GNU_SOURCE macro for strndup()
Date: Wed,  2 Dec 2009 14:11:46 +0800
Message-Id: <1259734306-26323-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 02 Dec 2009 06:36:56.0958 (UTC) FILETIME=[D80CE1E0:01CA7319]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strndup is a GNU extension. So add _GNU_SOURCE macro
to avoid compiling error.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/string.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 0977cf4..ea3eb39 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,8 @@
+#define _GNU_SOURCE
 #include <string.h>
 #include <stdlib.h>
+
+#undef _GNU_SOURCE
 #include "string.h"
 #include "util.h"
 
-- 
1.6.0.3

