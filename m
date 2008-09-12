Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYILFnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYILFnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 01:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYILFmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 01:42:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:60266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbYILFmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 01:42:54 -0400
Date: Thu, 11 Sep 2008 22:42:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 0/13] Turn hrtimers into a range capable timer
Message-ID: <20080911224241.13855b23@infradead.org>
In-Reply-To: <200809121339.49902.rusty@rustcorp.com.au>
References: <20080901160343.75a89ec9@infradead.org>
	<200809121339.49902.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 13:39:49 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 02 September 2008 09:03:43 Arjan van de Ven wrote:
> > This series is a follow-on the the nanosecond select/poll series.
> >
> > The goal of this series is to introduce the capability into
> > hrtimers to deal with a "range" rather than a specific point in
> > time. (Several people discussed this recently, but we've been
> > toying with the concept for a while)
> 
> Hi Arjen, sorry for not replying sooner.
> 
> I had half a patch to create a new "timer layer to rule them all"
> called ktimers, which took an explicit "slop" value.  Slop is the
> "how long before its worth waking the machine for this?" value, with
> friendly SLOP_USECS, SLOP_SECONDS, SLOP_DAYS etc defines.
> Implemented in terms of normal and hr timers, which get deprecated
> over time.
> 
> Heuristics work for a while, but IMHO eventually this is going to
> have to be plumbed through to userspace.

yes we need to add the system calls at some point (beyond the prctl);
however both Ulrich and Linus indicated that this will be one of those
"handful of users" kind of things. IMO it needs to work well enough
without having to change the whole application stack (and with my
patches that can be done; it works well in practice)
 
> 
> Cheers,
> Rusty.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
