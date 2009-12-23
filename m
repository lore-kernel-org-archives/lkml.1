Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZLWJt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZLWJt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZLWJtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:49:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33997 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZLWJtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:49:24 -0500
Date: Wed, 23 Dec 2009 10:49:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux Kernel
Message-ID: <20091223094905.GC24181@elf.ucw.cz>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
 <20091218170407.GA1396@ucw.cz>
 <4352991a0912221310k40f42498nba2081011398c7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a0912221310k40f42498nba2081011398c7e@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-22 13:10:36, Salman Qazi wrote:
> On Fri, Dec 18, 2009 at 9:04 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi
> >
> >
> >> Why not use voltage and frequency scaling?
> >>
> >> Forced Idle Injection is more effective[1] and more widely available.
> >> Even with voltage and frequency scaling, interpolation is needed
> >> between the available settings.  So, if we did use voltage and
> >
> > It is only more efficient on new hardware.
> >
> > You should also explain 'why not throttling' because that is actually
> > designed for power capping.
> 
> Do you mean t-states?

Yes.

> >> Application to Laptops and Cellphones:
> >>
> >> Imagine being in a tent in Death Valley with a laptop.  You are bored,
> >> and you want to watch a movie.  However, you also want to do your best
> >> to make the battery last and watch as much of the movie as possible.
> >> Forced idle power capping is a solution.  If your machine has a knob
> >> that allows you to control the available power, you can turn that knob
> >> until your video starts getting choppy.  And then, turn the knob back
> >
> > That's bad example. Video player should already sleep between frames.
> 
> Yes, the video player should sleep.  However, there will be other
> things running.  And certainly, it is possible to cap the power and
> discriminate so that those things are prevented from running while the
> video player is allowed to run with minimal latency impact.

I don't see how it would work without much of extra setup. Lets say
your windowmanager wants to do some work, and you starve it
indefinitely?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
