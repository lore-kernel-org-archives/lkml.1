Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZFDNK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZFDNK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFDNKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:10:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:47895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZFDNKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:10:13 -0400
Date: Thu, 4 Jun 2009 13:09:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Build with native optimization
Message-ID: <tip-af794b94ae8a16fb4a9da6ce640c122efb44e2a0@git.kernel.org>
Git-Commit-ID: af794b94ae8a16fb4a9da6ce640c122efb44e2a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 13:09:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af794b94ae8a16fb4a9da6ce640c122efb44e2a0
Gitweb:     http://git.kernel.org/tip/af794b94ae8a16fb4a9da6ce640c122efb44e2a0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 4 Jun 2009 13:58:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 14:00:52 +0200

perf_counter tools: Build with native optimization

Build the tools with -march=native by default.

No measurable difference in speed though, compared to the
default, on a Nehalem testbox.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 005709b..414399c 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -159,7 +159,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6
+CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6 -march=native
 LDFLAGS = -lpthread -lrt -lelf
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
