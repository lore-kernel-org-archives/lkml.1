Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbXI1TvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbXI1TvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXI1TvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:51:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbXI1TvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:51:08 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, hirofumi@mail.parknet.co.jp,
       galak@kernel.crashing.org, zaitcev@redhat.com, greg@kroah.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mbligh@google.com
Subject: Re: [PATCH] writeback: remove unnecessary wait in throttle_vm_writeout()
References: <390857819.00313@ustc.edu.cn> <20070928080202.GA10293@elte.hu>
	<20070928162347.GA11024@Krystal>
	<200709281010.28086.nickpiggin@yahoo.com.au>
	<20070928175756.GA16066@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 28 Sep 2007 15:50:14 -0400
In-Reply-To: <20070928175756.GA16066@Krystal> (Mathieu Desnoyers's message of "Fri, 28 Sep 2007 13:57:56 -0400")
Message-ID: <y0mabr6vabt.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

>> [...]
>> > I totally agree with Ingo here. Having a basic instrumentation that is
>> > enabled by default will help to identify code paths causing unexpected
>> > delays in the kernel. [...]
>
>> It is. See: CONFIG_VM_EVENT_COUNTERS and all the other vm specific
>> crap littered in /proc/ (buddyinfo, zoneinfo, meminfo, etc).  [...]

> Isn't the actual instrumentation present in the VM subsystem
> consisting mostly of event counters ? This kind of profiling
> provides limited help in following specific delays in the
> kernel. [...]

These existing VM events/counters could be a good target for a second
worked-out example (after blktrace) of reimplementation using generic
markers.

- FChE
