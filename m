Return-Path: <linux-kernel-owner+w=401wt.eu-S1030856AbXCNN6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030856AbXCNN6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXCNN6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:58:47 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:59857 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030856AbXCNN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:58:46 -0400
Date: Wed, 14 Mar 2007 09:58:45 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Stolen and degraded time and schedulers
Message-ID: <20070314135845.GG22466@csclub.uwaterloo.ca>
References: <45F6D1D0.6080905@goop.org> <1173816769.22180.14.camel@localhost> <45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F77C27.8090604@goop.org>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:37:59PM -0700, Jeremy Fitzhardinge wrote:
> (By monotonic time, I presume you mean monotonic real time.)  Yes, I
> suppose you could, but I don't think that's terribly useful.   I think
> work_time is probably most naturally measured in cpu clock cycles rather
> than an actual time unit.  You could convert it to ns, but I don't see
> the point.
> 
> I know its a term in general use, but I don't think the term "stolen
> time" is all that useful, particularly when we're talking about a more
> general notion of cpu work contributing to the progress of process
> execution.  In the cpufreq case, time isn't "stolen" per se.

How would you deal with something like a pentium 4 HT processor where
you may run slower just because you got scheduled on the sibling of a
cpu that happens to run something else needing the same execution units
you do, causing you to get delayed more, even though the cpu is running
full speed and nothing else is trying to use your "cpu"?  I don't think
there is any way to know what the real impact of two processes on a HT
cpu have on each other.

Interesting goal.  Not sure it can be done.

--
Len Sorensen
