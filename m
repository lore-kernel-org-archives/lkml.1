Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYLRW0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYLRW0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYLRWZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:25:53 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51045 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYLRWZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:25:53 -0500
Subject: Re: TSC not updating after resume: Bug or Feature?
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200812182319.57235.rjw@sisk.pl>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu>
	 <200812182319.57235.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 16:25:49 -0600
Message-Id: <1229639149.6613.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 23:19 +0100, Rafael J. Wysocki wrote:
> On Thursday, 18 of December 2008, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Rafael, would something like this explain why we had to revert Shaggy's 
> > > patch?
> 
> Well, I have yet to understand what the suspend-resume of the timekeeping code
> actually does.
> 
> The original description sounds worrisome to me, it looks like we've overlooked
> something at least.
> 
> > > His patch fixes the backward motion filter and I'm at an utter  
> > > loss why that would break suspend.
> > 
> > yes, i'd love to have this commit reinstated:
> > 
> >  5b7dba4: sched_clock: prevent scd->clock from moving backwards
> > 
> > and the bug triggered by hibernation fixed instead.
> 
> Shaggy said he had an idea of what was wrong, so I expect an updated version
> of the patch to appear.

Not really.  I said I'd look at it, but all I know is that it looks like
something clock-related isn't initialized correctly after resume.  I
don't know enough to have any idea how to fix it.

> Thanks,
> Rafael
-- 
David Kleikamp
IBM Linux Technology Center

