Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030557Ab0B0SZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:25:43 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42919 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030416Ab0B0SZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZxnL6MIvVz1wak7PXjz5HDNm7E2h+leO97Pea/eB5mZCDEhSPlENlwGhioHJ4cf5Yr
         mIxOlgVcfAy4j2dTC8nuemcLSRbYTEwHbbTZ+4ocYudvxjG4MSmEx+aVoWDPxDjEqBov
         ZlgI2ora/4CeiAsn4WdluFbAEExtl/91aqsSg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Perf updates
Date: Sat, 27 Feb 2010 19:25:28 +0100
Message-Id: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      perf lock: Drop the buffers multiplexing dependency
      perf: Remove pointless breakpoint union
      x86/hw-breakpoints: Remove the name field

Hitoshi Mitake (1):
      perf lock: Fix and add misc documentally things

Tejun Heo (1):
      percpu: Add __percpu sparse annotations to hw_breakpoint


 arch/x86/include/asm/hw_breakpoint.h    |    1 -
 arch/x86/kernel/hw_breakpoint.c         |    7 --
 include/linux/hw_breakpoint.h           |    8 +-
 include/linux/perf_event.h              |    5 +-
 kernel/hw_breakpoint.c                  |   10 +-
 lib/Kconfig.debug                       |    8 ++
 samples/hw_breakpoint/data_breakpoint.c |    6 +-
 tools/perf/Documentation/perf-lock.txt  |   29 ++++++
 tools/perf/builtin-lock.c               |  148 ++++++++++++++++++++++++++++++-
 tools/perf/command-list.txt             |    1 +
 10 files changed, 198 insertions(+), 25 deletions(-)
