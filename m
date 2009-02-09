Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZBIRmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZBIRmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZBIRmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:42:08 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:46490 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbZBIRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:42:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAEz1j0lMQWt2/2dsb2JhbACBbs5vhBoG
Date: Mon, 9 Feb 2009 12:42:02 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090209174202.GB12934@Krystal>
References: <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209131653.GS7120@linux.vnet.ibm.com> <36ca99e90902090919r297ad4c3re2248c321b36baf8@mail.gmail.com> <20090209173427.GC6802@linux.vnet.ibm.com> <36ca99e90902090935u7fef1cb1g27303e546527e3d8@mail.gmail.com> <20090209174030.GD6802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090209174030.GD6802@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:41:10 up 39 days, 17:39,  4 users,  load average: 1.53, 1.11,
	0.76
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Feb 09, 2009 at 06:35:38PM +0100, Bert Wesarg wrote:
> > On Mon, Feb 9, 2009 at 18:34, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Mon, Feb 09, 2009 at 06:19:45PM +0100, Bert Wesarg wrote:
> > >> On Mon, Feb 9, 2009 at 14:16, Paul E. McKenney
> > >> <paulmck@linux.vnet.ibm.com> wrote:
> > >> > On Sun, Feb 08, 2009 at 11:53:52PM -0500, Mathieu Desnoyers wrote:
> > >> >> Yes, I guess the signal is not so bad.
> > >> >
> > >> > Now if there were a /proc entry that listed out the tids of the
> > >> > currently running threads, then it might be possible to do something,
> > >> > especially for applications with many more threads than CPUs.
> > >>
> > >> Do you mean something like: `ls /proc/$pid/tasks/*`? Or is this not
> > >> atomic enough?
> > >
> > > Won't that give me all the threads rather than only the ones currently
> > > running?
> >
> > What do you mean by 'running'?
> 
> Sitting on a CPU and executing, as opposed to blocked or preempted.
> 
> It is pretty easy to scan the running tasks within the kernel, but I
> don't know of an efficient way to do it from user mode.  The only way
> I know of would be to cat out the /proc/$pid/tasks/*/status (IIRC)
> and look for the task state.
> 

The thing I dislike about this approach is the non-portability. Ideally,
if we want to integrate urcu to pthreads, we should also aim at
BSD-based OSes.

Mathieu

> 							Thanx, Paul
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
