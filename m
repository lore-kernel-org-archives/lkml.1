Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZIMGl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZIMGl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 02:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZIMGl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 02:41:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:41876 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752563AbZIMGl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 02:41:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/AWRVqWN3ADYrUCLSeDTsrFEKEDS5ihIRzu/MPJk
	7YzLgmdtVqB2ZB
Subject: Re: [GIT PULL] sched/core for v2.6.32
From: Mike Galbraith <efault@gmx.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.LNX.2.00.0909122354260.23341@swampdragon.chaosbits.net>
References: <20090911192505.GA20006@elte.hu>
	 <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net>
	 <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain>
	 <alpine.LNX.2.00.0909120119190.31018@swampdragon.chaosbits.net>
	 <12c511ca0909111924s42d000dsbf378009d9434ddc@mail.gmail.com>
	 <20090912054917.GB9420@elte.hu>
	 <alpine.LNX.2.00.0909122354260.23341@swampdragon.chaosbits.net>
Content-Type: text/plain
Date: Sun, 13 Sep 2009 08:41:54 +0200
Message-Id: <1252824114.16650.130.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 00:07 +0200, Jesper Juhl wrote:
> On Sat, 12 Sep 2009, Ingo Molnar wrote:
> 

> > It was a statistical property based on performance considerations - 
> > and now we flipped it around based on latency and for kbuild 
> > performance/throughput reasons: Serge Belyshev reported a 7% 
> > increase on a quad due to this change and i measured a 1.5% 
> > peak-kbuild performance increase.
> > 
> Impressive. I wouldn't have expected that much gain by running the parent 
> first. Actually I personally would have expected child-first to perform 
> better since (in my experience) it's usually the child that's just forked 
> that matters the most.

How can waiting for child1 to run a bit before forking off child2 _not_
hurt?  The parent is the worker bee creator, the queen bee if you will.
Seems to me that making the queen wait until one egg hatches and ages a
bit before laying another egg is a very bad plan if the goal is to have
a hive full of short lived worker bees.

	-Mike

