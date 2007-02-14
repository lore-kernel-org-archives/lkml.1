Return-Path: <linux-kernel-owner+w=401wt.eu-S1751135AbXBNGyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbXBNGyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXBNGyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:54:17 -0500
Received: from ozlabs.org ([203.10.76.45]:56507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXBNGyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:54:17 -0500
Subject: Re: What will be in the x86-64/x86 2.6.21 merge
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
In-Reply-To: <200702121514.25449.ak@suse.de>
References: <200702101242.48467.ak@suse.de>
	 <Pine.LNX.4.64.0702120907001.23639@d.namei> <200702121514.25449.ak@suse.de>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 17:53:28 +1100
Message-Id: <1171436009.19842.139.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 15:14 +0100, Andi Kleen wrote:
> On Monday 12 February 2007 15:11, James Morris wrote:
> > On Sat, 10 Feb 2007, Andi Kleen wrote:
> > 
> > > - lguest
> > >   * still seems heavily in development. Not sure it will be ready in time.
> > 
> > How would you define ready?
> 
> Used by at least some people for something, got some real world testing, more review.

Well, I only have bug reports from around half a dozen people, so I'm
not sure what that says about my userbase (for most people it should
simply work).

lguest.ozlabs.org got 3000 hits in the last 12 hours, and they can't all
be bots 8)  Mind you, in that time only 26 unique IP addresses visited
the patches/ repository, so maybe they are...

As to "insufficient review", the reviews so far have cleaned up some
code (great!) and found 3 actual bugs, none real showstoppers and all
now fixed:

 (1) race of initialization code vs. cpu hotplug.
 (2) block driver being suboptimal
 (3) network driver sending crap for inter-guest sendfile.

In addition, you counted not handling TSC change as a bug, so I tore
that code out, instead of leaving a FIXME.  During the cleanup patches I
did introduce (and then fix) another bug, it is true.

I would not describe it as "heavily in development"; I really think it's
at the stage where it can benefit from being in-tree.

> > It's currently useful and stable, 
> 
> How do you know?

Please don't harass my users.  That's my job!

Cheers!
Rusty.

