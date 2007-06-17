Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXFQMHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXFQMHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 08:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbXFQMG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 08:06:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33275 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525AbXFQMG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 08:06:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Date: Sun, 17 Jun 2007 14:13:39 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com> <20070617114709.GD16016@flower.upol.cz>
In-Reply-To: <20070617114709.GD16016@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171413.40890.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 June 2007 13:47, Oleg Verych wrote:
> On Sun, Jun 17, 2007 at 12:22:26PM +0200, Michal Piotrowski wrote:
> > On 17/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >On Sun, 17 Jun 2007 11:41:36 +0200 Michal Piotrowski 
> > ><michal.k.k.piotrowski@gmail.com> wrote:
> > >
> > >> +If the patch introduces a new regression and this regression was not 
> > >fixed
> > >> +in seven days, then the patch will be reverted.
> > >
> > >Those regressions where we know which patch caused them are the easy ones.
> > >Often we don't know which patch (or even which subsystem merge) is at
> > >fault.
> > >
> > >I think.  How many of the present 2.6.22-rc regressions which you're
> > >presently tracking have such a well-identified cause?
> > >
> > 
> > Here lays the problem.
> > 
> > git-bisect is a killer app, people should start using it.
> 
> It's OK _only_ in case of unknown, hard to find *hardware* bugs.
> 
> If you think it's "a good thing" for bad, untested by developer
> code, then something is completely wrong.

Oh, I've just fixed two purely software bugs pointed out by binary searching
in the code that I'm sure has been tested, not only by its developers, but the
bugs only showed up in my configuration (on one out of four test boxes).

There are so many different kernel configurations possible that there's no way
a developer can test them all.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
