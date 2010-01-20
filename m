Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289Ab0ATUBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0ATUBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0ATUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:01:05 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54789 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab0ATUBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:01:03 -0500
Subject: [PATCH 0/2] sched: arch_scale_smt_powers
From: Joel Schopp <jschopp@austin.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       jschopp@austin.ibm.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:00:38 -0600
Message-ID: <1264017638.5717.121.camel@jschopp-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Power7 processor has 4 way SMT.  This 4 way SMT benefits from
dynamic power updates that arch_scale_smt_power was designed to provide.
The first patch fixes a generic scheduler bug necessary for arch_scale_smt
to properly function.  The second patch implements arch_scale_smt_power 
for powerpc, and in particular for Power7 processors.

---
Gautham R Shenoy (1):
sched: Fix the place where group powers are updated.

Joel Schopp (1):
powerpc: implement arch_scale_smt_power for Power7

 arch/powerpc/kernel/smp.c |   41 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c            |    7 +++----
 kernel/sched_features.h   |    2 +-
 3 files changed, 45 insertions(+), 5 deletions(-)


