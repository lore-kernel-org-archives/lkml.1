Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYGSJS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYGSJS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 05:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYGSJSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 05:18:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYGSJSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 05:18:21 -0400
Subject: Re: Problem: Load average of 6, no I/O, 25% idle time. Why?
From: Peter Zijlstra <peterz@infradead.org>
To: Timothy Normand Miller <theosib@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9871ee5f0807181512u231e1aaraee5622d0a814f97@mail.gmail.com>
References: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
	 <1216387716.28405.45.camel@twins>
	 <9871ee5f0807181512u231e1aaraee5622d0a814f97@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 19 Jul 2008 11:18:16 +0200
Message-Id: <1216459096.7257.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 18:12 -0400, Timothy Normand Miller wrote:
> On Fri, Jul 18, 2008 at 9:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2008-07-18 at 08:49 -0400, Timothy Normand Miller wrote:
> >> I have a four processor box, running three compute loads.  The kernel
> >> I'm running is 2.6.25-gentoo-r5.
> >>
> >> One process has four threads, and it's niced to 19.
> >> Another process has one thread and is niced to -10
> >> The last process has one thread and is niced to 0
> >>
> >> One processor is always idle.
> >>
> >> If I change either the 0 to a -10 or the -10 to a zero, then all four
> >> cores are properly utilized.
> 
> Interesting corollary:  If the only thing running is the one nice=19,
> four-thread process, then there's about 4% idle time.  I have to raise
> the priority to get the idle time to go away.  Since when do active
> processes yield to idle time?

They shouldn't... I'm suspecting it might be due to some form of
priority inversion or some such thing.

> Two of my three loads are finished, so when this last one is done,
> I'll try 2.6.26.  Was something like this actively discussed and fixed
> between 2.6.25 and 2.6.26?

Not much, but it has seen drastic change post .26. So if you could also
try Linus' latest -git that would be good.


