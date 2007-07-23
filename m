Return-Path: <linux-kernel-owner+w=401wt.eu-S1763526AbXGWJSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbXGWJSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXGWJS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:18:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46729 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbXGWJS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:18:27 -0400
Date: Mon, 23 Jul 2007 11:19:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>, Kyle Moffett <mrlinuxman@mac.com>,
       Lars Ellenberg <lars@linbit.com>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>,
       drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070723091940.GC4996@uranus.ravnborg.org>
References: <20070721203819.GA10706@mail.linbit.com> <20070722213202.1f5d1cab.mrlinuxman@mac.com> <20070723084903.GA29443@infradead.org> <20070723090038.GA4996@uranus.ravnborg.org> <20070723090101.GA30305@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723090101.GA30305@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 10:01:01AM +0100, Christoph Hellwig wrote:
> On Mon, Jul 23, 2007 at 11:00:38AM +0200, Sam Ravnborg wrote:
> > On Mon, Jul 23, 2007 at 09:49:03AM +0100, Christoph Hellwig wrote:
> > > On Sun, Jul 22, 2007 at 09:32:02PM -0400, Kyle Moffett wrote:
> > > > First of all, if you could break this up into chunks (even if they
> > > > aren't useful individually) just to make it easier to review.
> > > 
> > > No, please don't do that I have no idea why people say that except for
> > > drinking too much "small patches" koolaid.
> > 
> > It is much more preferred to have code available in the mailer than
> > being forced to copy it from some big patch somewhere when you
> > want to point out something.
> 
> While that's a valid point I totally agree on for small patches it just
> doesn't matter for a complex driver where you need to sit down for an
> hour or more to actually do a useful review.

We do review on different levels.
I for once will look at the Makefile + Kconfig bits and some trivial
CodingStyle issues. Here it will help.
You on the other hand I assume will look at the functionality and overall
design and then for you the full patch is the best way.

Well I could try to do the same as you but that would take me maybe
10 hours or more just to come up with some limited input on the overall design.
So therefore instead of backing out I give inputs on the smaller scale
which I know is less usefull but in the hope that this can be resolved
so when you or others take your time to review at least the majority
of the simple CodingStyle things are fixed so you do not get sidetracked
and can concentrate on the important bits.

The message is quite clear.
For a driver like this do something like:
- Describe the functionality / the problem is solved
- Describe the overall design (maybe as a file in Documentation/?)
- Make a single patch available
- Submit mails in smaller chunks for on-the-list reviews

This will then be useable bot for the "triviality" reviewers like me
and for the "knowledge able" reviewers like you.

	Sam
