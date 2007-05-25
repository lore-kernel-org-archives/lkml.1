Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbXEYJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbXEYJqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXEYJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:46:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50720 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXEYJqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:46:42 -0400
Date: Fri, 25 May 2007 11:46:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525094640.GL8094@one.firstfloor.org>
References: <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525091928.GA3177@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 11:19:28AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > This?    I sent it to you earlier this week:
> > 
> > Sorry haven't processed those yet.
> > 
> > Ah. The correct fix here is to clear the tsc flag in boot_cpu_data 
> > when the option is set. Will do that.
> 
> please indicate that you've picked up my style cleanups, i dont want to 
> redo all this a few days/weeks down the line ...

It's done slightly differently now due to conflicting earlier
changes, but the end result should be about what you intended.  
You're also still credited in the cleanup patch of course.

-Andi
