Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbXKIXzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbXKIXzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXKIXz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:55:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:49953 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751214AbXKIXz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:55:28 -0500
X-Authenticated: #12956409
X-Provags-ID: V01U2FsdGVkX1/vgroMpQzvvm1GX49z3/5ewrhUNFr+tMVWZMxNFq
	+RuuumWPsWUaC+
Message-ID: <4734F397.7080802@gmx.net>
Date: Sat, 10 Nov 2007 00:56:07 +0100
From: Cyrus Massoumi <cyrusm@gmx.net>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Micah Dowty <micah@vmware.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: High priority tasks break SMP balancer?
References: <20071109223417.GB16250@vmware.com>
In-Reply-To: <20071109223417.GB16250@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micah

> On my machine (2-way Opteron with a vanilla 2.6.23.1 kernel) this test
> program will reliably put the scheduler into a state where one CPU has
> both of the busy-looping processes in its runqueue, and the other CPU
> is usually idle. The usually-idle CPU will have a very high cpu_load,
> as reported by /proc/sched_debug.

I tried your program on my machine (C2D, 2.6.17, O(1) scheduler).

Both CPUs are 100% busy all the time. Each busy-looping thread is 
running on its own CPU. I've been watching top output for 10 minutes, 
the spreading is stable and the threads don't bounce at all.


greetings
Cyrus


