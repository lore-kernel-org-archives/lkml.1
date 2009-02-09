Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZBIRkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZBIRkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZBIRkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:40:32 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33075 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbZBIRkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:40:32 -0500
Date: Mon, 9 Feb 2009 09:40:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090209174030.GD6802@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209131653.GS7120@linux.vnet.ibm.com> <36ca99e90902090919r297ad4c3re2248c321b36baf8@mail.gmail.com> <20090209173427.GC6802@linux.vnet.ibm.com> <36ca99e90902090935u7fef1cb1g27303e546527e3d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90902090935u7fef1cb1g27303e546527e3d8@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 06:35:38PM +0100, Bert Wesarg wrote:
> On Mon, Feb 9, 2009 at 18:34, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Mon, Feb 09, 2009 at 06:19:45PM +0100, Bert Wesarg wrote:
> >> On Mon, Feb 9, 2009 at 14:16, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Sun, Feb 08, 2009 at 11:53:52PM -0500, Mathieu Desnoyers wrote:
> >> >> Yes, I guess the signal is not so bad.
> >> >
> >> > Now if there were a /proc entry that listed out the tids of the
> >> > currently running threads, then it might be possible to do something,
> >> > especially for applications with many more threads than CPUs.
> >>
> >> Do you mean something like: `ls /proc/$pid/tasks/*`? Or is this not
> >> atomic enough?
> >
> > Won't that give me all the threads rather than only the ones currently
> > running?
>
> What do you mean by 'running'?

Sitting on a CPU and executing, as opposed to blocked or preempted.

It is pretty easy to scan the running tasks within the kernel, but I
don't know of an efficient way to do it from user mode.  The only way
I know of would be to cat out the /proc/$pid/tasks/*/status (IIRC)
and look for the task state.

							Thanx, Paul
