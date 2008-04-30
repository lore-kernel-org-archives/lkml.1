Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbYD3VbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbYD3VbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbYD3Va4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:30:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbYD3Vaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:30:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Wed, 30 Apr 2008 23:30:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Dan Noe <dpn@isomerica.net>, torvalds@linux-foundation.org,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20080429.190352.137408408.davem@davemloft.net> <4818DAC4.0@isomerica.net> <20080430135938.82e46e67.akpm@linux-foundation.org>
In-Reply-To: <20080430135938.82e46e67.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302330.21743.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 of April 2008, Andrew Morton wrote:
> On Wed, 30 Apr 2008 16:47:00 -0400
> Dan Noe <dpn@isomerica.net> wrote:
> 
> > On 4/30/2008 16:31, Linus Torvalds wrote:
> > > 
> > > On Wed, 30 Apr 2008, Andrew Morton wrote:
> > >> <jumps up and down>
> > >>
> > >> There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
> > > 
> > > The problem I see with both -mm and linux-next is that they tend to be 
> > > better at finding the "physical conflict" kind of issues (ie the merge 
> > > itself fails) than the "code looks ok but doesn't actually work" kind of 
> > > issue.
> > > 
> > > Why?
> > > 
> > > The tester base is simply too small.
> > > 
> > > Now, if *that* could be improved, that would be wonderful, but I'm not 
> > > seeing it as very likely.
> > 
> > Perhaps we should be clear and simple about what potential testers 
> > should be running at any given point in time.  With -mm, linux-next, 
> > linux-2.6, etc, as a newcomer I find it difficult to know where my 
> > testing time and energy is best directed.
> 
> -mm consists of the sum of
> 
> a) the ~80 subsytem maintainers trees (git and quilt)
> 
> b) the ~100 subsytem trees which are hosted only in -mm.
> 
> 
> linux-next consists of only a)
> 
> Soon I shall remove a) from -mm and will replace it with linux-next (this
> should be a no-op).
> 
> Later, I shall start feeding those 100 random subsystems into linux-next
> as well (somehow).
> 
> > Is linux-next the right thing to be running at this point?
> 
> yes.  85% of the code which goes into Linux goes via the ~80 subsystem
> maintainers' trees and is (or should be) in linux-next.  The other 15%
> is the hosted-in-mm work.
> 
> >  Is there a 
> > need for testing in a particular tree (netdev, x86, etc)?
> 
> No, please test the sum-of-all-trees in linux-next.  If you hit problems
> then, as part of the problem resolving process a developer _might_ ask you
> to test one tree specifically, but that would be a pretty unusual
> circumstance.

How bisectable is linux-next, BTW?
