Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLRXkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLRXkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYLRXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:39:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41939 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLRXjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:39:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
Date: Fri, 19 Dec 2008 00:39:33 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <200812182319.57235.rjw@sisk.pl> <1229639149.6613.2.camel@norville.austin.ibm.com>
In-Reply-To: <1229639149.6613.2.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812190039.34184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 18 of December 2008, Dave Kleikamp wrote:
> On Thu, 2008-12-18 at 23:19 +0100, Rafael J. Wysocki wrote:
> > On Thursday, 18 of December 2008, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > Rafael, would something like this explain why we had to revert Shaggy's 
> > > > patch?
> > 
> > Well, I have yet to understand what the suspend-resume of the timekeeping code
> > actually does.
> > 
> > The original description sounds worrisome to me, it looks like we've overlooked
> > something at least.
> > 
> > > > His patch fixes the backward motion filter and I'm at an utter  
> > > > loss why that would break suspend.
> > > 
> > > yes, i'd love to have this commit reinstated:
> > > 
> > >  5b7dba4: sched_clock: prevent scd->clock from moving backwards
> > > 
> > > and the bug triggered by hibernation fixed instead.
> > 
> > Shaggy said he had an idea of what was wrong, so I expect an updated version
> > of the patch to appear.
> 
> Not really.  I said I'd look at it, but all I know is that it looks like
> something clock-related isn't initialized correctly after resume.  I
> don't know enough to have any idea how to fix it.

Well, thanks for the update.

I'm going to have a look at the thing tomorrow, but I'm not sure I'll be able
to fix it.

Thanks,
Rafael
