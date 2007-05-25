Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbXEYIp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbXEYIp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXEYIpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:45:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXEYIpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:45:49 -0400
Date: Fri, 25 May 2007 10:45:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@osdl.org
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525084547.GJ8094@one.firstfloor.org>
References: <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525084426.GA29973@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:44:26AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > arch/i386/kernel/sched-clock.c (now built on x86_64 too with the 
> > > patch i sent) uses the tsc_disable global flag which is non-existent 
> > > on x86_64. So my tsc.h change adds that global flag, always-defined 
> > > to 0.
> > 
> > My version of sched_clock.c doesn't have any reference to tsc_disable.
> 
> must be an -mm fix. I used -mm as a basis of my work. Please apply my 
> patch.

I would prefer to find out why the mm patch was added and then hopefully
remove it.  IMNSHO it should not be needed.

-Andi
