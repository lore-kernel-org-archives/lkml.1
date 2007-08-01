Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbXHAQMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbXHAQMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXHAQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:12:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47534 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXHAQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:12:03 -0400
Date: Wed, 1 Aug 2007 18:11:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <andi@firstfloor.org>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801161159.GA19776@one.firstfloor.org>
References: <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011525560.1817@scrub.home> <20070801143624.GA18043@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801143624.GA18043@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:36:24PM +0200, Ingo Molnar wrote:
> 
> * Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > > jiffies based sched_clock should be soon very rare. It's probably 
> > > not worth optimizing for it.
> > 
> > I'm not so sure about that. sched_clock() has to be fast, so many 
> > archs may want to continue to use jiffies. [...]
> 
> i think Andi was talking about the vast majority of the systems out 
> there. For example, check out the arch demography of current Fedora 
> installs (according to the Smolt opt-in UUID based user metrics):

I meant that in many cases where the TSC is considered unreliable
today it'll be possible to use it anyways at least for sched_clock()
(and possibly even gtod()) 

The exception would be system which really have none, but there
should be very few of those.

-Andi
