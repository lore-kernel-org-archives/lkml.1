Return-Path: <linux-kernel-owner+w=401wt.eu-S1763024AbZCQIkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024AbZCQIkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZCQIjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:39:52 -0400
Received: from www.tglx.de ([62.245.132.106]:38756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZCQIjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:39:51 -0400
Date: Tue, 17 Mar 2009 09:38:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup 20090317
In-Reply-To: <1237267595.2480.9.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0903170930311.29264@localhost.localdomain>
References: <1237229111.2827.2.camel@ht.satnam>  <alpine.LFD.2.00.0903162128010.29264@localhost.localdomain> <1237267595.2480.9.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:
> On Mon, 2009-03-16 at 23:33 +0100, Thomas Gleixner wrote:
> > On Tue, 17 Mar 2009, Jaswinder Singh Rajput wrote:
> > 
> > > -static struct clock_event_device pit_clockevent = {
> > > +static struct clock_event_device pit_dev = {
> > 
> >   Why do we need to change the name of the variable ? Just for fun or
> >   is pit_dev more self explaining than pit_clockevent ?
> 
> pit already means it is a clock event, but with this change:
> 
> 1. we save 8 characters per declaration
> 2. It solves various 80 characters problem

There is not a single 80 character problem in that file.

> this declaration is just few lines above the code where we are using it,
> so it will not be problem. So it seems worth to me.
> 
> If you still thinks this stinks, let me know I will revert it :-)

Yes it does. It's just a change with no value.
 
> Here is new pull request:
> 
> The following changes since commit 1f31834fbbb8de367914f044d3268c6afbfdd783:
>   Ingo Molnar (1):
>         Merge branch 'x86/mce2'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (10):
>       x86: mpparse cleanup
>       x86: cpu/intel.c cleanup

These two are the only useful ones, but the actual code changes are
mixed into mechanical cleanup noise. We want to have that separate.

Thanks,

	tglx

