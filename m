Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXFITjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXFITjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXFITjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:39:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40441 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758248AbXFITjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:39:13 -0400
Date: Sat, 9 Jun 2007 21:38:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070609193853.GA6663@elf.ucw.cz>
References: <20070416213350.GB4030@suse.de> <1176852059.5946.128.camel@localhost.localdomain> <f03mli$8g8$1@taverner.cs.berkeley.edu> <Line.LNX.4.64.0704172143150.21359@d.namei> <f03ujo$cta$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f03ujo$cta$1@taverner.cs.berkeley.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Maybe you'd like to confine the PHP interpreter to limit what it can do.
> >> That might be a good application for something like AppArmor.  You don't
> >> need comprehensive information flow control for that kind of use, and
> >> it would likely just get in the way.
> >
> >SELinux can do this, it's policy-flexible.  You can even simulate a 
> >pathame-based policy language with a consequential loss of control:
> 
> I have no doubt that SELinux can do that, but that has about as much
> relevance to my point as the price of tea in China does.  I can use a
> screwdriver to drive in a nail into my wall, too, if I really wanted to,
> but that doesn't mean toolmakers should stop manufacturing hammers.

Well, we are talking about kernel here, and if screwdrivers work well
enough to drive nails into walls, we'll not allow hammers in.

> My point is that there are some tasks where it's plausible that AppArmor
> might well be a better (easier-to-use) tool for the job.  I'm

If SELinux can do the task, AA people are welcome to port their
userland apps to SELinux to make it user friendly. We do _not_ provide
user friendly services in kernel.

Someone wanted shell inside kernel because it is convenient to
him. Too bad, not going to be merged.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
