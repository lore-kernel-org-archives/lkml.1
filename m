Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZKXG7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZKXG7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbZKXG7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:59:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbZKXG7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:59:07 -0500
Date: Tue, 24 Nov 2009 07:59:10 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091124065910.GE20981@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258987059.6193.73.camel@marge.simson.net> <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop> <20091123152931.GD19175@wotan.suse.de> <20091123170445.GA29058@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123170445.GA29058@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:04:45PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > .32 is kind of closed, with us being at -rc8.
> > 
> > It's a bad regression though.
> 
> It's about 3 months too late for that. Ideally we want performance 

Too late for what? Reporting and reverting a regression? I don't
think so. It is not my problem if patches aren't tested well
enough before being merged.

If we release a kernel with this known problematic scheduler behaviour
then it gives userspace application writers far harder targets, and
also it will give *some* 2.6.32 users regressions if we find it has
to be fixed in 2.6.33.


> regressions to be looked for and reported when the patches go into the 
> devel tree. Failing that, -rc1 would be the good time to re-test 
> whatever workload you care about.
> 
> If you cannot test it in a regular fashion you can offload the testing 
> to us, by adding a similar/equivalent workload to 'perf bench sched'. 
> We'll make sure it stays sane.

What exactly tests *were* done on it? Anything that might possibly
trigger its obvious possibility for detremental behaviour? Something
like netperf?

