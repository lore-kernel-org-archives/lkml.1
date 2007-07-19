Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbXGSGrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbXGSGrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXGSGqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:46:53 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:43078 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbXGSGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:46:52 -0400
Date: Thu, 19 Jul 2007 12:04:04 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-ID: <20070719063404.GA11228@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070718010700.1ca7fd9f.akpm@linux-foundation.org> <20070718094142.GA12330@linux.vnet.ibm.com> <20070718144637.GC5337@linux.vnet.ibm.com> <20070719062835.GE3699@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719062835.GE3699@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (gdb) thread 6
> [Switching to thread 6 (process 6233)]#0  __do_softirq ()
>     at kernel/softirq.c:231
> 231                     if (pending & 1) {
> (gdb) bt
> #0  __do_softirq () at kernel/softirq.c:231
> #1  0xc012998b in do_softirq () at kernel/softirq.c:269
> #2  0xc0129a09 in irq_exit () at kernel/softirq.c:305
> #3  0xc0117443 in smp_apic_timer_interrupt (regs=Variable "regs" is not available.
> )
>     at arch/i386/kernel/apic.c:592
> #4  0xc0105877 in apic_timer_interrupt () at include/asm/current.h:11
> #5  0xc0564480 in contig_page_data ()
> #6  0x00000007 in ?? ()
> #7  0x00000001 in ?? ()
> #8  0x00000000 in ?? ()

Looks interesting.

-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
