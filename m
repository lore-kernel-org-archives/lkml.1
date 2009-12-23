Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZLWJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZLWJwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZLWJws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:52:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33004 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZLWJwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:52:46 -0500
Date: Wed, 23 Dec 2009 10:52:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux Kernel
Message-ID: <20091223095239.GD24181@elf.ucw.cz>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
 <20091221085713.GA1622@ucw.cz>
 <4352991a0912221315y5ba409cbh26baa5937cdf2f76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a0912221315y5ba409cbh26baa5937cdf2f76@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > OTOH realtime people already have tools you could make good use of:
> > your power capping approach looks like 'high priority idle task that
> > needs to run for 2 seconds every 5 seconds' or something...
> >
> > Talk to rt people?
> 
> At the core of it, you are correct.  However, in our implementation it
> also avoids running when the system is already idle and operates at
> much finer granularities than seconds.

Seconds were examples, I suspect rt kernels need lower granularities,
to.

> Which specific tools are you referring to?  Real-time Linux as a whole
> is a trade off:  one gets predictable latency in exchange for some
> performance.  Any specific contacts that I should direct my inquiries
> to?

I guess Peter and Ingo (added to the Cc)....

Anyway, I guess that what you really want is to be able to change
priority of the idle threads, even making them realtime...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
