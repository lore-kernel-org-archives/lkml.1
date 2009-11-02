Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbZKBUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbZKBUat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbZKBUas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:30:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:42849 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932428AbZKBUas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:30:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WVM0qw44WhOnNdt1SkJfalXhcTESRzaPbLv9V6Q
	/n8hIob9SZfIpB
Subject: Re: [patch] Re: [regression bisect -next] BUG: using
 smp_processor_id() in preemptible [00000000] code: rmmod
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20091102200133.GB4682@elte.hu>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>
	 <1257190811.19608.2.camel@marge.simson.net> <20091102200133.GB4682@elte.hu>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 21:15:13 +0100
Message-Id: <1257192913.6688.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 21:01 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Mon, 2009-11-02 at 19:28 +0100, Ingo Molnar wrote:
> > > FYI, non-SMP builds broke:
> > > 
> > > kernel/built-in.o: In function `kthread_bind':
> > > (.text+0x1d328): undefined reference to `sched_kthread_bind'
> > > make: *** [.tmp_vmlinux1] Error 1
> > 
> > Oops.  Outside the SMP block might work a little better.
> > 
> > sched: Move the body of kthread_bind() to sched.c.
> 
> Check the -tip commit notification, i did a somewhat cleaner approach by 
> moving all of kthread_bind() into sched.c. No need to keep that small 
> wrapper in kthread.c.

Thanks, and sorry for the fumble.

	-Mike

