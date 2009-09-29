Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZI2RNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZI2RNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZI2RNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:13:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42376 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZI2RNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:13:38 -0400
Date: Tue, 29 Sep 2009 19:13:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20090929171332.GD14405@elf.ucw.cz>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adatyz1d17q.fsf@cisco.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-17 08:45:29, Roland Dreier wrote:
> 
>  > > > Hmm, or are you saying you can only get 1 event per registered range and
>  > > > allocate the thing on registration? That'd need some registration limit
>  > > > to avoid DoS scenarios.
>  > > 
>  > > Yes, that's what I do.  You're right, I should add a limit... although
>  > > their are lots of ways for userspace to consume arbitrary amounts of
>  > > kernel resources already.
>  > 
>  > I'd be good to work at reducing that number, not adding to it ;-)
> 
> Yes, definitely.  I'll add a quick ummunotify module parameter that
> limits the number of registrations per process.
> 
>  > But yeah, I currently don't see a very nice match to perf counters.
> 
> OK.  It would be nice to tie into something more general, but I think I
> agree -- perf counters are missing the filtering and the "no lost
> events" that ummunotify does have.  And I'm not sure it's worth messing
> up the perf counters design just to jam one more not totally related
> thing in.

I believe that extending perf counters to do what you want is better
than adding one more, very strange, user<->kernel interface.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
