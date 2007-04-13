Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXDMIwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXDMIwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXDMIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:52:23 -0400
Received: from smtp-out19.alice.it ([85.33.2.19]:2503 "EHLO
	smtp-out19.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXDMIwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:52:21 -0400
Date: Fri, 13 Apr 2007 10:52:19 +0200
From: Mattia Dongili <malattia@linux.it>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070413085219.GA2938@inferi.kami.home>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070412151402.GA3216@inferi.kami.home> <200704122126.45032.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704122126.45032.maximlevitsky@gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc6-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Apr 2007 08:52:20.0043 (UTC) FILETIME=[0B9249B0:01C77DA9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:26:44PM +0300, Maxim Levitsky wrote:
> On Thursday 12 April 2007 18:14:02 Mattia Dongili wrote:
> > On Thu, Apr 05, 2007 at 07:50:11PM -0700, Linus Torvalds wrote:
> > ...
> > > Maxim Levitsky (1):
> > >       Add suspend/resume for HPET
> > 
> > This one breaks resume for me (from STR) on a vaio SZ. Reverting this
> > commit allows resuming again but leaves me with some periodic and unpleasant:
> > 
> > [  155.232000] BUG: soft lockup detected on CPU#1!
> > [  155.232000]  [<c0104cf2>] show_trace_log_lvl+0x1a/0x2f
> > [  155.232000]  [<c0105344>] show_trace+0x12/0x14
> > [  155.232000]  [<c01053c8>] dump_stack+0x16/0x18
> > [  155.232000]  [<c0147240>] softlockup_tick+0xa7/0xb6
> > [  155.232000]  [<c01284d3>] run_local_timers+0x12/0x14
> > [  155.232000]  [<c012887a>] update_process_times+0x3e/0x63
> > [  155.232000]  [<c0137656>] tick_sched_timer+0x50/0x95
> > [  155.232000]  [<c01340e0>] hrtimer_interrupt+0x10b/0x18b
> > [  155.232000]  [<c01137b7>] smp_apic_timer_interrupt+0x6c/0x7e
> > [  155.232000]  [<c0104840>] apic_timer_interrupt+0x28/0x30
> > [  155.232000]  [<c0102318>] cpu_idle+0x1b/0xc7
> > [  155.232000]  [<c011297a>] start_secondary+0x32b/0x333
> > [  155.232000]  [<00000000>] run_init_process+0x3fefed10/0x19
> > [  155.232000]  =======================
> > 
> > FWIW: I hit the same BUG() in -rc5.
> > full boot+suspend+resume log: http://oioio.altervista.org/linux/kern-2.6.21-rc6.log
> > .config: http://oioio.altervista.org/linux/config-2.6.21-rc6-1
> > 
> > I'm available to test more patches or to provide other info.
> 
> Strange,strange...

Yes... strange. I can't reproduce the resume breakage anymore, with or
without your patch. I still have the soft lockup anyway after resuming.
I'll still keep trying, for now just disregard my previous mail.

-- 
mattia
:wq!
