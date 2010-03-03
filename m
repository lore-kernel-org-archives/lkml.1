Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0CCGzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:55:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50449 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0CCGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mgaid/ZjC1COJYL+PtHV7GKsGDX7+Z4Y8sdCGHKQ+Mxtr9yd0OqW4WCaWmKXmt3aa5
         tFPvtfigLjSEaf/vhw8ZtOaipxXNAWOadKiccGxWzqA3Jr9vifRQ9d/n8nZ9TlEEmKKq
         RDPHnE2fTENn9o54E5I2VHgkPzvV9CJPHRBu8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf updates
Date: Wed,  3 Mar 2010 07:54:59 +0100
Message-Id: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an rfc patch in this set, so may be it's not that
pullable.

But for those who want to test or something, the set is in the
perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      lockdep: Move lock events under lockdep recursion protection
      perf: Take a hot regs snapshot for trace events
      perf/x86-64: Use frame pointer to walk on irq and process stacks


 arch/x86/include/asm/asm.h        |    1 +
 arch/x86/include/asm/perf_event.h |   25 +++++++++++++++++++++++++
 arch/x86/kernel/dumpstack_64.c    |    4 ++--
 kernel/lockdep.c                  |    9 +++------
 kernel/perf_event.c               |   19 ++++++++++++++-----
 5 files changed, 45 insertions(+), 13 deletions(-)
