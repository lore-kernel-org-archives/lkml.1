Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbZHRFUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbZHRFUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZHRFU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:20:29 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42565 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZHRFU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:20:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19082.14855.905695.140648@cargo.ozlabs.ibm.com>
Date: Tue, 18 Aug 2009 15:20:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Please pull my perfcounters.git tree
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following changes since commit 64f1607ffbbc772685733ea63e6f7f4183df1b16:
  Linus Torvalds (1):
        Linux 2.6.31-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

Paul Mackerras (3):
      powerpc/32: Always order writes to halves of 64-bit PTEs
      powerpc: Allow perf_counters to access user memory at interrupt time
      perf_counter: powerpc: Add callchain support

 arch/powerpc/include/asm/pgtable.h   |    6 +-
 arch/powerpc/kernel/Makefile         |    2 +-
 arch/powerpc/kernel/asm-offsets.c    |    2 +
 arch/powerpc/kernel/exceptions-64s.S |   19 ++
 arch/powerpc/kernel/perf_callchain.c |  527 ++++++++++++++++++++++++++++++++++
 arch/powerpc/mm/slb.c                |   37 ++-
 arch/powerpc/mm/stab.c               |   11 +-
 7 files changed, 588 insertions(+), 16 deletions(-)
 create mode 100644 arch/powerpc/kernel/perf_callchain.c

These commits implement callchain support for perf_counters on
powerpc.  They have been acked by Ben Herrenschmidt and I have asked
him to pull them into his powerpc-next branch.  It would be good if
you could pull them into the tip tree on some suitable branch so they
get tested together with the other perf_counter changes that are
pending for the 2.6.32 merge window.

Thanks,
Paul.
