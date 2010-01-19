Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052Ab0ASR0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0ASR0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659Ab0ASR0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:26:14 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34282 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0ASR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:26:13 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH] perf kmem: Print usage help for unknown commands
Date: Tue, 19 Jan 2010 19:26:11 +0200
Message-Id: <1263921971-10782-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "perf kmem" to print usage help instead of doing nothing.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tools/perf/builtin-kmem.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 33bb9df..93c67bf 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -784,7 +784,8 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 			setup_sorting(&alloc_sort, default_sort_order);
 
 		return __cmd_kmem();
-	}
+	} else
+		usage_with_options(kmem_usage, kmem_options);
 
 	return 0;
 }
-- 
1.6.0.4

