Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYILU0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYILU0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbYILU0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:26:01 -0400
Received: from www.tglx.de ([62.245.132.106]:47198 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbYILU0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:26:00 -0400
Date: Fri, 12 Sep 2008 22:24:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 0/13] Turn hrtimers into a range capable timer
In-Reply-To: <200809121339.49902.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0809122210170.13819@apollo.tec.linutronix.de>
References: <20080901160343.75a89ec9@infradead.org> <200809121339.49902.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Rusty Russell wrote:
> On Tuesday 02 September 2008 09:03:43 Arjan van de Ven wrote:
> > This series is a follow-on the the nanosecond select/poll series.
> >
> > The goal of this series is to introduce the capability into hrtimers to
> > deal with a "range" rather than a specific point in time.
> > (Several people discussed this recently, but we've been toying with the
> > concept for a while)
> 
> Hi Arjen, sorry for not replying sooner.
> 
> I had half a patch to create a new "timer layer to rule them all" called 
> ktimers, which took an explicit "slop" value.  Slop is the "how long before 

Be warned, the name ktimers has already a bad history. Just ask the
oracle of google :)

> its worth waking the machine for this?" value, with friendly SLOP_USECS, 
> SLOP_SECONDS, SLOP_DAYS etc defines.  Implemented in terms of normal and hr 
> timers, which get deprecated over time.
> 
> Heuristics work for a while, but IMHO eventually this is going to have to be 
> plumbed through to userspace.

Agreed.

	tglx
