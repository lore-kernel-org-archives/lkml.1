Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZBFLgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZBFLgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbZBFLgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:36:07 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:53064 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756085AbZBFLgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:36:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAPmui0lMQWt2/2dsb2JhbACBbs0rhBYG
Date: Fri, 6 Feb 2009 06:36:00 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ltt-dev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux
Message-ID: <20090206113600.GA21377@Krystal>
References: <20090206030543.GB8560@Krystal> <36ca99e90902060055g67e53ae5k938a4e94c4637885@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <36ca99e90902060055g67e53ae5k938a4e94c4637885@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:35:49 up 36 days, 11:33,  3 users,  load average: 0.47, 0.39,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bert Wesarg (bert.wesarg@googlemail.com) wrote:
> On Fri, Feb 6, 2009 at 04:05, Mathieu Desnoyers
> <compudj@krystal.dyndns.org> wrote:
> > Hi Paul,
> >
> > I figured out I needed some userspace RCU for the userspace tracing part
> > of LTTng (for quick read access to the control variables) to trace
> > userspace pthread applications. So I've done a quick-and-dirty userspace
> > RCU implementation.
> >
> > It works so far, but I have not gone through any formal verification
> > phase. It seems to work on paper, and the tests are also OK (so far),
> > but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
> > want to comment on it, it would be welcome. It's a userland-only
> > library. It's also currently x86-only, but only a few basic definitions
> > must be adapted in urcu.h to port it.
> >
> > Here is the link to my git tree :
> >
> > git://lttng.org/userspace-rcu.git
> >
> > http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=summary
> >
> Really interesting, thanks.
> 
> But you should use pthread_equal() for you equality test of pthread_t.
> 

It's merged, thanks !

Mathieu

> Regards,
> Bert
> 
> > Thanks,
> >
> > Mathieu
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
