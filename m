Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZAJW4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZAJW4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZAJWzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:55:54 -0500
Received: from relay3.sgi.com ([192.48.171.31]:33028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbZAJWzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:55:54 -0500
Message-ID: <49692772.9010504@sgi.com>
Date: Sat, 10 Jan 2009 14:55:46 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] updates for tip/cpus4096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Please pull the following changes that reduce the static amount of memory used
for irq_desc_ptrs and kstat_irqs_legacy for SPARSE_IRQS.

(Note that tip/cpus4096 does not have the previous pull yet but these follow them.)

Thanks,
Mike
---

The following changes since commit 076645f7bbf48dfc9528d21cfefc719f0e15de8b:
  Mike Travis (1):
        Xen: reduce memory required for cpu_evtchn_mask

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Mike Travis (4):
      irq: change references from NR_IRQS to nr_irqs
      irq: allocate irq_desc_ptrs array based on nr_irqs
      irq: initialize nr_irqs based on nr_cpu_ids
      kstat: modify kstat_irqs_legacy to be variable sized

 arch/x86/kernel/io_apic.c |    2 +-
 kernel/irq/handle.c       |   35 ++++++++++++++++++++++++++---------
 kernel/irq/internals.h    |    4 ++++
 3 files changed, 31 insertions(+), 10 deletions(-)
