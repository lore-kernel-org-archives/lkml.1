Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbXIZU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbXIZU5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXIZU5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:57:05 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:45976 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbXIZU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:57:04 -0400
Subject: 2.6.23-rc8-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 16:56:12 -0400
Message-Id: <1190840172.5871.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23-rc8-rt1 tree, which can be
downloaded from the new location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rc4-rt1

  - update to -rc8

  - A bunch of PowerPC stuff                    (Tony Breeds)
      - rearrange thread flags
      - count_active_rt_tasks fix
      - match __rw_yield declaration
      - unsigned long flags
      - removed flush_tlb_pending

  - alternate node alloc fix                    (Andi Kleen)

  - fix compiling of timer code in !PREEMPT_RT  (Andi Kleen)

  - convert i_alloc_sem to compat_rw_semaphore  (Steven Rostedt)

  - don't let RT rw_semaphores do non_owner     (Steven Rostedt)

  - kill the union in s_files                   (Peter Zijlstra)

  - Sched sum less than zero prevention         (Luis Claudio)

  - nmi_watchdog hpet                           (David Bahi)

  - call_rcu_bh rename                          (Steven Rostedt)

Work in progress (to be included soon):

  - CFS-scheduler updates
  - high res timers updates
  - PowerPC high res timers

to build a 2.6.23-rc8-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.tar.bz2
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.23-rc8.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rc8-rt1.bz2

The broken out patches are also available.

-- Steve


