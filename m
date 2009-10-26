Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZJZLjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZJZLjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZJZLji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:39:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbZJZLjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:39:37 -0400
Date: Mon, 26 Oct 2009 11:38:29 GMT
From: tip-bot for Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, ink@jurassic.park.msu.ru,
       tglx@linutronix.de, rth@twiddle.net, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
       mingo@elte.hu, mcree@orcon.net.nz
In-Reply-To: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools, Alpha: Add Alpha support to perf.h
Message-ID: <tip-fcd14b3203b538dca04a2b065c774c0b57863eec@git.kernel.org>
Git-Commit-ID: fcd14b3203b538dca04a2b065c774c0b57863eec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcd14b3203b538dca04a2b065c774c0b57863eec
Gitweb:     http://git.kernel.org/tip/fcd14b3203b538dca04a2b065c774c0b57863eec
Author:     Michael Cree <mcree@orcon.net.nz>
AuthorDate: Mon, 26 Oct 2009 21:32:06 +1300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 09:45:41 +0100

perf tools, Alpha: Add Alpha support to perf.h

For the perf tool the patch implements an Alpha specific section
in the perf.h header file.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 8cc4623..216bdb2 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -47,6 +47,12 @@
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
+#ifdef __alpha__
+#include "../../arch/alpha/include/asm/unistd.h"
+#define rmb()		asm volatile("mb" ::: "memory")
+#define cpu_relax()	asm volatile("" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
