Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbYD1MJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbYD1MJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765110AbYD1MJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:09:50 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:61754 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763142AbYD1MJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:09:49 -0400
Subject: Re: RLIMIT_RTTIME documentation for getrlimit.2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       linux-man@vger.kernel.org
In-Reply-To: <cfd18e0f0804280444jd558060g6cf5ee7df0248ee1@mail.gmail.com>
References: <20080208145950.GA3910@kernel.sg>
	 <1204212100.12120.9.camel@twins>
	 <cfd18e0f0804110156l658107e5x1f2695cacfc3ac75@mail.gmail.com>
	 <1207904485.7074.28.camel@twins>
	 <cfd18e0f0804110216l3c679bb6ned83f5d58d1c9d66@mail.gmail.com>
	 <1207905668.7074.32.camel@twins>
	 <cfd18e0f0804110227w37915734r8ca31271a3dfc8ab@mail.gmail.com>
	 <1207906325.7153.2.camel@twins>
	 <cfd18e0f0804110238l66fb60c8pa8ac934a2a43baa7@mail.gmail.com>
	 <4808D1CC.80103@gmail.com>
	 <cfd18e0f0804280444jd558060g6cf5ee7df0248ee1@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:09:20 +0200
Message-Id: <1209384560.13978.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 13:44 +0200, Michael Kerrisk wrote:
> Hey Peter,
> 
> Ping!

Thanks for the reminder ;-)

> Cheers,
> 
> Michael
> 
> 
> ---------- Forwarded message ----------
> From: Michael Kerrisk <mtk.manpages@googlemail.com>
> Date: Fri, Apr 18, 2008 at 6:52 PM
> Subject: RLIMIT_RTTIME documentation for getrlimit.2
> To: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
> Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
> linux-man@vger.kernel.org
> 
> 
> Peter,
> 
> Below is the draft text that I will add to the getrlimit.2 man page to describe
> RLIMIT_RTTIME.  Does it look okay to you?  (I will add a pointer in
> sched_setscheduler.2 to this description in getrlimit.2.)
> 
>       RLIMIT_RTTIME (Since Linux 2.6.25)
>              Specifies a limit on the amount of CPU time that a
>              process  scheduled  under  a  real-time scheduling
>              policy may consume without making a blocking  sys-
>              tem  call.   For  the  purpose of this limit, each
>              time a process makes a blocking system  call,  the
>              count  of  its consumed CPU time is reset to zero.
>              The CPU time count is not  reset  if  the  process
>              continues  trying to use the CPU but is preempted,
>              its   time   slice   expires,    or    it    calls
>              sched_yield(2).
> 
>              Upon  reaching the soft limit, the process is sent
>              a SIGXCPU  signal.   If  the  process  catches  or
>              ignores  this  signal  and continues consuming CPU
>              time, then SIGXCPU will  be  generated  once  each
>              second  until  the hard limit is reached, at which
>              point the process is sent a SIGKILL signal.
> 
>              The intended use of this limit is to stop  a  run-
>              away real-time process from locking up the system.

Looks excellent, thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

in so far that is applicable to man pages ;-)

