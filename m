Return-Path: <linux-kernel-owner+w=401wt.eu-S1161334AbXCNPIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161334AbXCNPIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161331AbXCNPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:08:23 -0400
Received: from gw.goop.org ([64.81.55.164]:45607 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161335AbXCNPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:08:22 -0400
Message-ID: <45F80FE1.3030603@goop.org>
Date: Wed, 14 Mar 2007 08:08:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org> <1173816769.22180.14.camel@localhost> <45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <20070314135845.GG22466@csclub.uwaterloo.ca>
In-Reply-To: <20070314135845.GG22466@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> How would you deal with something like a pentium 4 HT processor where
> you may run slower just because you got scheduled on the sibling of a
> cpu that happens to run something else needing the same execution units
> you do, causing you to get delayed more, even though the cpu is running
> full speed and nothing else is trying to use your "cpu"?  I don't think
> there is any way to know what the real impact of two processes on a HT
> cpu have on each other.
>
> Interesting goal.  Not sure it can be done.

You're right.  That's a very tough case.  I don't know if there's any
way to do a reasonable estimate of the slowdown.  You could handwave it
and say "if both threads are running a process, then apply an X scaling
factor to their rate of progress".  That might be enough.

    J
