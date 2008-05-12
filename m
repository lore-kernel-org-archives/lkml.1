Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYELJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYELJ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYELJ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:28:07 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:50177 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755297AbYELJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:28:05 -0400
Date: Mon, 12 May 2008 10:27:19 +0100
From: Ben Dooks <ben@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, dpn@isomerica.net,
       torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080512092718.GG16284@fluff.org.uk>
References: <20080429.190352.137408408.davem@davemloft.net> <4818DAC4.0@isomerica.net> <20080430135938.82e46e67.akpm@linux-foundation.org> <200805010053.31894.m.kozlowski@tuxland.pl> <20080430161130.4328b830.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430161130.4328b830.akpm@linux-foundation.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:11:30PM -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 00:53:31 +0200
> Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> 
> > Hello,
> > 
> > > > Perhaps we should be clear and simple about what potential testers 
> > > > should be running at any given point in time.  With -mm, linux-next, 
> > > > linux-2.6, etc, as a newcomer I find it difficult to know where my 
> > > > testing time and energy is best directed.
> > 
> > Speaking of energy and time of a tester. I'd like to know where these resources
> > should be directed from the arch point of view. Once I had a plan to buy as
> > many arches as I could get and run a farm of test boxes 8-) But that's hard
> > because of various reasons (money, time, room, energy). What arches need more
> > attention? Which are forgotten? Which are going away? For example does buying
> > an alphaserver DS 20 (hey - it's cheap) and running tests on it makes sense
> > these days?
> > 
> 
> gee.
> 
> I think to a large extent this problem solves itself - the "more important"
> architectures have more people using them, so they get more testing and
> more immediate testing.
> 
> However there are gaps.  I'd say that arm is one of the more important
> architectures, but many people who are interested in arm tend to shy away
> from bleeding-edge kernels for various reasons.  Mainly because they have
> real products to get out the door, rather than dinking around with mainline
> kernel developement.  So testing bleeding-edge on some arm systems would be
> good, I expect.

As both personally, and the policy of my employer we try and ensure we
can offer our customers at-least the previous 'stable' kernel release
and ensure that our development process tracks the kernel -rcX
candidates. We also run an autobuilder[1] which runs all -git releases
through an automated build (no auto-test yet) to ensure that we can
detect any build or configuration errors in the releases. 

ARM is a fast moving area due to the amount of sillicon vendors out
there who seem intent on doing their own thing, and often forking
hardware blocks they use during differing development branches. I
am currently looking at merging support for the S3C6400 (new) and
finishing S3C2443 (similar to 6400) and the S3C24A0... this means
that I have a lot of code to look through before each release and
having a stall will just keep the backlog building, making my job
a lot more difficult.


[1] http://armlinux.simtec.co.uk/kautobuild/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
