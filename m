Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZLRREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZLRREU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZLRRET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:04:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46988 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZLRRET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:04:19 -0500
Date: Fri, 18 Dec 2009 18:04:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the
	Linux Kernel
Message-ID: <20091218170407.GA1396@ucw.cz>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


> Why not use voltage and frequency scaling?
> 
> Forced Idle Injection is more effective[1] and more widely available.
> Even with voltage and frequency scaling, interpolation is needed
> between the available settings.  So, if we did use voltage and

It is only more efficient on new hardware.

You should also explain 'why not throttling' because that is actually
designed for power capping. 

> Application to Laptops and Cellphones:
> 
> Imagine being in a tent in Death Valley with a laptop.  You are bored,
> and you want to watch a movie.  However, you also want to do your best
> to make the battery last and watch as much of the movie as possible.
> Forced idle power capping is a solution.  If your machine has a knob
> that allows you to control the available power, you can turn that knob
> until your video starts getting choppy.  And then, turn the knob back

That's bad example. Video player should already sleep between frames.

Better example would be 'make video so choppy that expected battery
time rises over length ov movie.

(And yes, this would have been useful for me on notebook with failed
fan and ineffective throttling).


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
