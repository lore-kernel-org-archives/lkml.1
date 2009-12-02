Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZLBIcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZLBIcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZLBIb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:31:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:46670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbZLBIb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:31:58 -0500
Date: Wed, 2 Dec 2009 08:30:53 GMT
From: tip-bot for Liming Wang <liming.wang@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de,
       liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, xiaoguangrong@cn.fujitsu.com,
       liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <1259734306-26323-1-git-send-email-liming.wang@windriver.com>
References: <1259734306-26323-1-git-send-email-liming.wang@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix _GNU_SOURCE macro related strndup() build error
Message-ID: <tip-c19e33aa840e9202ef8d4c93056b59f3edc2208d@git.kernel.org>
Git-Commit-ID: c19e33aa840e9202ef8d4c93056b59f3edc2208d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c19e33aa840e9202ef8d4c93056b59f3edc2208d
Gitweb:     http://git.kernel.org/tip/c19e33aa840e9202ef8d4c93056b59f3edc2208d
Author:     Liming Wang <liming.wang@windriver.com>
AuthorDate: Wed, 2 Dec 2009 14:11:46 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 09:24:56 +0100

perf tools: Fix _GNU_SOURCE macro related strndup() build error

strndup is a GNU extension. So dont include string.h without
defining _GNU_SOURCE (it results in a compile error otherwise).

Remove these includes as util.h does it already.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: peterz@infradead.org
Cc: mhiramat@redhat.com
LKML-Reference: <1259734306-26323-1-git-send-email-liming.wang@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
