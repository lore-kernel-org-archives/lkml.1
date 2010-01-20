Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124Ab0ATHOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0ATHOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865Ab0ATHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:14:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:40211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0ATHOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:14:07 -0500
Date: Wed, 20 Jan 2010 07:13:26 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi,
       xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263921971-10782-1-git-send-email-penberg@cs.helsinki.fi>
References: <1263921971-10782-1-git-send-email-penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem: Print usage help for unknown commands
Message-ID: <tip-b00eca8cd66029128615e8be9a19e284a950c0f2@git.kernel.org>
Git-Commit-ID: b00eca8cd66029128615e8be9a19e284a950c0f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 07:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b00eca8cd66029128615e8be9a19e284a950c0f2
Gitweb:     http://git.kernel.org/tip/b00eca8cd66029128615e8be9a19e284a950c0f2
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 19 Jan 2010 19:26:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Jan 2010 07:20:08 +0100

perf kmem: Print usage help for unknown commands

This patch fixes "perf kmem" to print usage help instead of
doing nothing.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <1263921971-10782-1-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
