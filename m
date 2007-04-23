Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXDWFgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXDWFgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030970AbXDWFgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:36:48 -0400
Received: from smtp-out-46.synserver.de ([217.119.50.46]:1393 "HELO
	smtp-out-46.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030802AbXDWFgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:36:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-ViaOpenRelay-IP: 212.202.34.50
X-SynServer-RBL-IP: 212.202.34.50
X-SynServer-RBL-ReportedBy: dynablock.njabl.org dnsbl.sorbs.net
X-SynServer-RBL-ReportedByCount: **
X-SynServer-RBL-Weights: 100 50
X-SynServer-RBL-WeightSum: 150
X-SynServer-RBL-WeightStr: ***************
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Mon, 23 Apr 2007 07:16:59 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423051659.GA3929@gentoox2.trippelsdorf.de>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423011229.GA20367@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 03:12:29AM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce release -v5 of the CFS scheduler patchset. The 
> patch against v2.6.21-rc7 and v2.6.20.7 can be downloaded from:
...
>  - feature: add initial sys_sched_yield_to() implementation. Not hooked 
>    into the futex code yet, but testers are encouraged to give the 
>    syscalls a try, on i686 the new syscall is __NR_yield_to==320, on 
>    x86_64 it's __NR_yield_to==280. The prototype is 
>    sys_sched_yield_to(pid_t), as suggested by Ulrich Drepper.

The new version does not link here (amd64,smp):

  LD      .tmp_vmlinux1
  arch/x86_64/kernel/built-in.o:(.rodata+0x1dd8): undefined reference to
  `sys_yield_to'

-- 
Markus
