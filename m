Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZCOGNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZCOGNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZCOGNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:13:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:47195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758192AbZCOGNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:13:18 -0400
Date: Sun, 15 Mar 2009 06:12:36 GMT
From: Tim Blechmann <tim@klingt.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
In-Reply-To: <20090314142925.49c29c17@thinkpad>
References: <20090314142925.49c29c17@thinkpad>
Subject: [tip:perfcounters/core] perf_counter: include missing header
Message-ID: <tip-c04b033bfe196bb4cac45e46d20d3affbaebf23b@git.kernel.org>
Git-Commit-ID: c04b033bfe196bb4cac45e46d20d3affbaebf23b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 15 Mar 2009 06:12:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c04b033bfe196bb4cac45e46d20d3affbaebf23b
Gitweb:     http://git.kernel.org/tip/c04b033bfe196bb4cac45e46d20d3affbaebf23b
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Sat, 14 Mar 2009 14:29:25 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Mar 2009 07:09:22 +0100

perf_counter: include missing header

Impact: build fix

In order to compile a kernel with performance counter patches,
<asm/irq_regs.h> has to be included to provide the declaration of
struct pt_regs *get_irq_regs(void);

[ This bug was masked by unrelated x86 header file changes in the
  x86 tree, but occurs in the tip:perfcounters/core standalone
  tree. ]

Signed-off-by: Tim Blechmann <tim@klingt.org>
LKML-Reference: <20090314142925.49c29c17@thinkpad>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d6cc222..0018c5e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -24,6 +24,8 @@
 #include <linux/vmstat.h>
 #include <linux/rculist.h>
 
+#include <asm/irq_regs.h>
+
 /*
  * Each CPU has a list of per CPU counters:
  */
