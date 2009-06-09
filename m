Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbZFINiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbZFINiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFINim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:38:42 -0400
Received: from ozlabs.org ([203.10.76.45]:43237 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbZFINim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:38:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] cpumask fixes
Date: Tue, 9 Jun 2009 23:08:37 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906092308.39505.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3af968e066d593bc4dacc021715f3e95ddf0996f:
  Linus Torvalds (1):
        async: Fix lack of boot-time console due to insufficient synchronization

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Avi Kivity (1):
      kvm: fix kvm reboot crash when MAXSMP is used

Yinghai Lu (2):
      cpumask: introduce zalloc_cpumask_var
      cpumask: alloc zeroed cpumask for static cpumask_var_ts

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c              |    2 +-
 arch/x86/kernel/tlb_uv.c                         |    2 +-
 drivers/acpi/processor_core.c                    |    2 +-
 drivers/cpufreq/cpufreq.c                        |    2 +-
 include/linux/cpumask.h                          |   15 +++++++++++++++
 kernel/sched_cpupri.c                            |    2 +-
 kernel/sched_rt.c                                |    2 +-
 kernel/smp.c                                     |    2 +-
 lib/cpumask.c                                    |   12 ++++++++++++
 virt/kvm/kvm_main.c                              |    2 +-
 14 files changed, 39 insertions(+), 12 deletions(-)

