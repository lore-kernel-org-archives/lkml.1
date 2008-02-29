Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbYB2Md3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbYB2Md3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYB2MdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:33:21 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3423 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYB2MdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:33:20 -0500
Date: Fri, 29 Feb 2008 07:32:01 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
Message-ID: <20080229123201.GA25987@hmsreliant.think-freely.org>
References: <20080208145950.GA3910@kernel.sg> <1202483445.6292.1.camel@lappy> <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com> <1204212100.12120.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204212100.12120.9.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 04:21:40PM +0100, Peter Zijlstra wrote:
> 
> On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> > Peter,
> > 
> > Could you please provide some text describing RLIMIT_RTTIMEfor the
> > getrlimit.2 man page.
> 
> The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
> This time is measured between sleeps, so a schedule in RR or a
> preemption in either is not a sleep - the task needs to be dequeued and
> enqueued for the timer to reset.
> 
> Upon reaching the cur limit we start giving SIGXCPU every second, upon
> reaching the hard limit we give SIGKILL - matching RLIMIT_CPU.
> 
> Time is measured in tick granularity (for now).
> 
> > Cheers,
> > 
> > Michael
> > 
> > On Fri, Feb 8, 2008 at 4:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > On Fri, 2008-02-08 at 22:59 +0800, Eugene Teo wrote:
> > > > RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
> > > > real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
> > > > /proc/<pid>/limits with the new rlimit.
> > >
> > > Ah, didn't know about that file, thanks!
> > >
> > > > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> > >
> > > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Neil Horman <nhorman@tuxdriver.com>


-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
