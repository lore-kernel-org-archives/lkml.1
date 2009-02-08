Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZBHVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZBHVWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZBHVWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:22:09 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38670 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZBHVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:22:08 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 8 Feb 2009 13:22:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: mtk.manpages@gmail.com
cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and 
 CLOCK_MONOTONIC?
In-Reply-To: <cfd18e0f0902081318p3b7efde5u3977a9fdadf3f542@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902081320560.18839@alien.or.mcafeemobile.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com>  <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>  <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
 <cfd18e0f0902081318p3b7efde5u3977a9fdadf3f542@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Michael Kerrisk wrote:

> On Mon, Feb 9, 2009 at 9:46 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Sun, 8 Feb 2009, Davide Libenzi wrote:
> >
> >> On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> >>
> >> > Hi Davide,
> >> >
> >> > At the moment I'm looking into writing man pages for timer_create(2)
> >> > and friends.  (Somewhat bizarrely, these pages do not yet exist.)  As
> >> > I looked into the source code of timer_create(), etc., and did some
> >> > tests, I saw that timer_create() supports the following clocks:
> >> >
> >> > TIMER_REALTIME
> >> > TIMER_MONOTONIC
> >> > TIMER_PROCESS_CPUTIME_ID
> >> > TIMER_THREAD_CPUTIME_ID
> >> > clockid obtained from clock_getcpuclockid(3)
> >> > clockid obtained from pthread_getcpuclockid(3)
> >> >
> >> > On the other hand, timerfd() only permits the first two of these.
> >> > What's the reason for that limitation of timerfd()?  (It may be worth
> >> > adding something to the man page on this point.)
> >>
> >> No particular reason I can think of. If Thomas makes invalid_clockid()
> >> available, we could allow timerfd() to support all time timers
> >> timer_create() supports.
> >> Do you see any reason why this won't work Thomas?
> >
> > Patch, not tested, below.
> 
> (Has it been compiled?)

Yes, it builds fine. I just haven't had time to test it ATM...



- Davide


