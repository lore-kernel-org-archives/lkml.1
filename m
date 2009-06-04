Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZFDLWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZFDLWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbZFDLWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:22:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:47567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbZFDLWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:22:41 -0400
Date: Thu, 4 Jun 2009 11:21:31 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18983.3111.770392.800486@cargo.ozlabs.ibm.com>
References: <18983.3111.770392.800486@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Use new identifier names in powerpc-specific code
Message-ID: <tip-1b58c2515be48d5df79d20210ac5a86e30094de2@git.kernel.org>
Git-Commit-ID: 1b58c2515be48d5df79d20210ac5a86e30094de2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Jun 2009 11:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b58c2515be48d5df79d20210ac5a86e30094de2
Gitweb:     http://git.kernel.org/tip/1b58c2515be48d5df79d20210ac5a86e30094de2
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 4 Jun 2009 09:49:59 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Jun 2009 13:20:11 +0200

perf_counter: powerpc: Use new identifier names in powerpc-specific code

Commit b23f3325 ("perf_counter: Rename various fields") fixed up
most of the uses of the renamed fields, but missed one instance
of "record_type" in powerpc-specific code which needs to be changed
to "sample_type", and a "PERF_RECORD_ADDR" in the same statement that
needs to be changed to "PERF_SAMPLE_ADDR", causing compilation
errors on powerpc.  This fixes it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18983.3111.770392.800486@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 4cc4ac5..232b00a 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1002,7 +1002,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 */
 	if (record) {
 		addr = 0;
-		if (counter->attr.record_type & PERF_RECORD_ADDR) {
+		if (counter->attr.sample_type & PERF_SAMPLE_ADDR) {
 			/*
 			 * The user wants a data address recorded.
 			 * If we're not doing instruction sampling,
