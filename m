Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbXFQLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbXFQLz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXFQLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:55:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbXFQLzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:55:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Date: Sun, 17 Jun 2007 14:01:41 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <p73d51n1fup.fsf@bingen.suse.de> <20070617025552.addd1c41.akpm@linux-foundation.org> <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com>
In-Reply-To: <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171401.42860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 June 2007 12:22, Michal Piotrowski wrote:
> On 17/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sun, 17 Jun 2007 11:41:36 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > > +If the patch introduces a new regression and this regression was not fixed
> > > +in seven days, then the patch will be reverted.
> >
> > Those regressions where we know which patch caused them are the easy ones.

Except when the bisection points us to a patch exposing a bug that is present
regardless (see http://lkml.org/lkml/2007/6/13/273 for example).

Besides, if a patch is merged before -rc1 as a bugfix, there are several
patches depending on it and only after -rc5 has been released we find out
that it breaks someone's system, then reverting it is not a solution, IMO.

> > Often we don't know which patch (or even which subsystem merge) is at
> > fault.
> >
> > I think.  How many of the present 2.6.22-rc regressions which you're
> > presently tracking have such a well-identified cause?
> >
> 
> Here lays the problem.
> 
> git-bisect is a killer app, people should start using it.

People should test _all_ of the -rc kernels and report problems.  Otherwise, we
may assume that there are no problems and go on.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
