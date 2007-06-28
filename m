Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbXF1Ph1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbXF1Ph1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbXF1PhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:37:14 -0400
Received: from [212.12.190.143] ([212.12.190.143]:33090 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756832AbXF1PhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:37:13 -0400
From: Al Boldi <a1426z@gawab.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Thu, 28 Jun 2007 18:37:50 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200706271653.58870.a1426z@gawab.com> <200706280132.23739.a1426z@gawab.com> <20070627231212.GD21478@ftp.linux.org.uk>
In-Reply-To: <20070627231212.GD21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200706281837.50917.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Thu, Jun 28, 2007 at 01:32:23AM +0300, Al Boldi wrote:
> > > > You are effectively inhibiting the development of an out-of-tree GPL
> > > > module pool, by constantly pulling the rug under that community.
> > >
> > > The same thing happens with any yet-to-be-merged code.
> > >
> > > > Do you think this is fair?
> > >
> > > Yes, it is fair.  Decision to maintain your code out of tree
> > > indefinitely is your decision.
> >
> > It's not my decision, it's the kernel maintainers decision to reject
> > inclusion for one reason or another.  One reason could be a simple "we
> > don't think this is useful".
>
> "I maintain a patch to $PROGRAM; maintainers of $PROGRAM don't think it's
> useful; they should abstain from making changes that might require rewrite
> of that patch".  Would you argue that this is fair?

No, that's not fair.  But, what's fair is to ask maintainers of $PROGRAM to 
be so kind and expose a stable API via some layer, which can be used to 
connect external patches which are considered not useful, in the hope that 
some day it may grow into something useful.

> BTW, "if it's GPLed, it's entitled to any internal function" is a shell
> game; it tries to convert GPL-given right to get to those functions into
> some kind of promise that those functions won't be changed.
>
> EXPORT_SYMBOL_GPL() should've been EXPORT_SYMBOL_INTERNAL(); like it or
> not, in-tree code *is* in different position exactly because it can be
> modified by whoever makes a change affecting such code.  For in-tree
> module one can expect such modifications to be done; for out-of-tree the
> same is obviously not true, but conclusion is not "you can't do changes",
> it's "authors of out-of-tree module get to do such modifications
> themselves".
>
> Sure, there are subsets of exports that have stronger promise of not being
> changed often; if a set of functions makes sense as an interface, it's
> less likely to change than randomly selected function that just had an
> export slapped on it at some point.  The promise is not absolute and it's
> not based on some obligations to out-of-tree modules; it's simply a common
> sense.
>
> Again, most of the exports had been added with very little justification
> at request of out-of-tree module authors.  That pile is many years past
> the stage when it could be described as set of sane interfaces and it's
> your [collective] fault.  Don't expect sympathy when you find the
> resulting devalvation unpleasant to deal with...

Ok, so some people made a mistake, and now everybody has to suffer?

What we need is a solution.  What is your suggestion?

Would a stable API exposing wrapper module be feasible?


Thanks!

--
Al

