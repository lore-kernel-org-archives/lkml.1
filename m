Return-Path: <linux-kernel-owner+w=401wt.eu-S1762559AbZE0LZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762559AbZE0LZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZE0LZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:25:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbZE0LZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:25:21 -0400
Date: Wed, 27 May 2009 11:24:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Remove <ctype.h> include
Message-ID: <tip-d716fba49c7445ec87c3f045c59624fac03ee3f2@git.kernel.org>
Git-Commit-ID: d716fba49c7445ec87c3f045c59624fac03ee3f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 11:24:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d716fba49c7445ec87c3f045c59624fac03ee3f2
Gitweb:     http://git.kernel.org/tip/d716fba49c7445ec87c3f045c59624fac03ee3f2
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 13:19:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 13:19:59 +0200

perf report: Remove <ctype.h> include

Pekka reported build failure in builtin-report.c:

    CC builtin-report.o
    In file included from builtin-report.c:7:
    /usr/include/ctype.h:102: error: expected expression before token

And observed:

| Removing #include <ctype.h> from builtin-report.c makes the problem
| go away. I am running Ubuntu 9.04 that has gcc 4.3.3 and libc 2.9.

Reported-by: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 9aef7c5..6265bed 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -4,7 +4,6 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
-#include <ctype.h>
 
 #include "util/list.h"
 #include "util/cache.h"
