Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYJBWJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYJBWJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYJBWJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:09:15 -0400
Received: from kroah.org ([198.145.64.141]:56030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540AbYJBWJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:09:15 -0400
Date: Thu, 2 Oct 2008 15:06:12 -0700
From: Greg KH <greg@kroah.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
Message-ID: <20081002220612.GB9201@kroah.com>
References: <20081001223213.078984344@linutronix.de> <20081001223301.900862899@linutronix.de> <1222908459.31183.73.camel@perihelion.int.jonmasters.org> <alpine.DEB.1.10.0810020107210.11373@gandalf.stny.rr.com> <1222944709.26632.19.camel@perihelion.int.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222944709.26632.19.camel@perihelion.int.jonmasters.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 06:51:49AM -0400, Jon Masters wrote:
> On Thu, 2008-10-02 at 01:09 -0400, Steven Rostedt wrote:
> > On Wed, 1 Oct 2008, Jon Masters wrote:
> > > 
> > > We probably need some documentation eventually so people realize what
> > > this "quickcheck" handler is for and what it's not for - under no
> > > circumstances should anything more than the bare minimum be done.
> > > Otherwise it breaks the benefit of deferred threaded handling. It's hard
> > > to enforce that - but this is *not* a return of top/bottom half handling
> > > where you can do whatever crap you like in the quickcheck bit.
> > > 
> > 
> > We could always implement something similar to what I was told Microsoft 
> > does (I was just told this, I don't know for fact). Time this function and 
> > if it takes longer than, say 50us, print a warning and kill the device
> > ;-)
> 
> You know, it's funny you suggested that because I thought about going
> there. But there's probably some silly patent on that groundshattering
> Microsoft solution to the halting problem.
> 
> Anyway, I like to think we in the Linux community trust developers to do
> the right thing more than Microsoft does :)

"Trust, but verify" :)

We should just print out something if it takes longer than Xus, that way
we can fix the code, something that other operating systems can't do.

thanks,

greg k-h
