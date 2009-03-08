Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZCHLke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZCHLke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 07:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCHLkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 07:40:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:37199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZCHLkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 07:40:23 -0400
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090308104133.GA3360@elte.hu>
References: <1236507232.28127.2.camel@localhost.localdomain>
	 <1236507643.22914.3642.camel@twins>
	 <1236508753.3638.3.camel@localhost.localdomain>
	 <20090308104133.GA3360@elte.hu>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 17:09:49 +0530
Message-Id: <1236512389.3205.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 11:41 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > These leads to warnings:
> >  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> >  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> 
> ignore those checkpatch warnings, they are wrong in this case.

OK, ignored for time being.

Log messages available at:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=shortlog;h=perfcounters/core

So here is new pull request:

The following changes since commit 880860e392d92c457e8116cdee39ec4d109174ee:
  Paul Mackerras (1):
        perfcounters/powerpc: add support for POWER4 processors

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git perfcounters/core

Jaswinder Singh Rajput (2):
      x86: perf_counter.c remove unused variables
      x86: perf_counter.c remove duplicate header file

 arch/x86/kernel/cpu/perf_counter.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f585371..79d88bf 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -17,7 +17,6 @@
 #include <linux/kdebug.h>
 #include <linux/sched.h>
 
-#include <asm/perf_counter.h>
 #include <asm/apic.h>
 
 static bool perf_counters_initialized __read_mostly;
@@ -954,9 +953,6 @@ static struct pmc_x86_ops *pmc_intel_init(void)
 
 static struct pmc_x86_ops *pmc_amd_init(void)
 {
-	u64 old;
-	int bits;
-
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
 	counter_value_mask = 0x0000FFFFFFFFFFFFULL;


