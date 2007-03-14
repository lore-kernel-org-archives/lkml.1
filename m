Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXCNTsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXCNTsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXCNTsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:48:11 -0400
Received: from gw.goop.org ([64.81.55.164]:35838 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXCNTsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:48:09 -0400
Message-ID: <45F8516E.0@goop.org>
Date: Wed, 14 Mar 2007 12:47:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <45F850BF.5030702@redhat.com>
In-Reply-To: <45F850BF.5030702@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Jeremy Fitzhardinge wrote:
>
>> It doesn't matter why you didn't get the time; 
>
> Oh, but it does.

I meant specifically from a scheduling perspective.

> System administrators can use steal time the same way they
> use iowait time: to spot bottlenecks on their systems.
>
> If you have a lot of iowait time, you know you want either
> faster IO or more memory.
>
> If you have a lot of steal time, you know you need to spread
> your virtual machines over more CPUs.
>
> Steal time allows you to see the difference between a busy
> system and an overloaded system.

Sure, the various accounting tools can go into as much detail as you
want.  I just added stolen time accounting to the xen-pv_ops patchset
which is equivalent to the xen-unstable stolen time accounting.  Is that
sufficient for these purposes?

    J
