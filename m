Return-Path: <linux-kernel-owner+w=401wt.eu-S1764259AbYBLTVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764259AbYBLTVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYBLTVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:21:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYBLTV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:21:28 -0500
Date: Tue, 12 Feb 2008 11:19:14 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212191914.GB20883@kroah.com>
References: <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:59:00AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Feb 2008, Linus Torvalds wrote:
> > 
> > In other words, I'm perfectly happy to be an a*hole and tell people that I 
> > simply won't merge things that cause undue API churn at all, and that were 
> > not thought out sufficiently.
> 
> .. btw: I'd need to know this in advance. I usually don't see the problem 
> until it's too late.
> 
> And this is very much an area where "Linux-next" can help: if some 
> subsystem causes problems in Linux-next for other maintainers, I really 
> think it shouldn't just be a matter of "drop the git tree that didn't 
> merge cleanly", but it should literally be a question of "maybe we should 
> drop the _earlier_ git tree that caused the later one not to merge 
> cleanly".

We usually get this warning today in -mm.

> In other words, maybe things like core block layer changes or device model 
> changes should be *last* in the merge-list (or if first, also be first to 
> be dropped if they cause merge errors downstream!).
> 
> That way, infrastructure changes that screw up others can only happen if 
> the maintainer actively works with the others to make sure it works even 
> before it would ever merge into Linux-next successfully.
> 
> That may sound odd, but it actually matches what I personally believe in: 
> we have more driver code and other "outlying" things than we have core 
> things, and most of our problems come from that - so we should prioritize 
> *those* things, not the "fundmantal core changes".
> 
> So how about making that the default situation: drivers and other outliers 
> merge first. If fundamental API changes happen, they merge last, and if 
> their maintainers can't make it in time in the merge window, they just get 
> dropped.
> 
> That sure as hell would put the pain on API changes solidly where it 
> belongs.

Sure, I have no objection to that at all.

thanks,

greg k-h
