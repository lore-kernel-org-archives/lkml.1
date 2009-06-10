Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZFJVhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZFJVhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZFJVhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:37:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45558 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZFJVhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:37:31 -0400
Date: Wed, 10 Jun 2009 23:37:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090610213710.GA8472@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Wed, Jun 10, 2009 at 12:31:31PM +0200, Pavel Machek wrote:
> >> Is there patch for Dream support for 2.6.30 somewhere? The best I
> >> could find is linux-msm tree, which is ... quite a big diff against
> >> 2.6.24:
> >
> > In short not as far as I know, and I'm very disappointed with the state
> > of affairs with google.
> >
> > Basically, the situation surrounding msm can be described as severely
> > wanting - bear in mind that it's been over a year since we last heard
> > anything from the msm guys as far as code submissions go.
> >
> > Personally, I think we should delete the entire codeset which was
> > submitted into mainline - it's next to useless and all the time that
> > folk sit on their hands not maintaining it, it's just not worth having
> > it anywhere near mainline.
> 
> I'd love to find an effective way to get more of the msm support
> cleaned up (as necessary) and into the mainline.  We're bringing our
> work forward and rebasing to keep tracking the latest released kernel,
> and working on getting core bits we need that other stuff depends on
> in -- look at the thread on linux-pm where the wakelock/suspendblocker
> framework has been reviewed, revised, resent repeatedly, etc.

I guess wakelocks should be removed from first version of drivers for merge.

> The msm7k unfortunately requires a lot of infrastructure to work given
> that the baseband (a black box to us) controls much of the world.
> Last time around when I tried submitting some of the core ipc support
> to talk to it on the lakml, there seemed to be uncertainty about who
> even would review that.

Try again, then :-). [Merging to drivers/staging is _very_ easy, and
even that is good first step.]

Actually, mailing patches so that people do not have to do git pull +
diff is very good zeroth step :-).

> We have full support for MSM7201A, including fully functional power
> management, working on a number of commercially shipping devices that
> we'd absolutely love to get into mainline.  Rebasing and bringing this
> stuff forward all the time is a lot of work and certainly not the
> optimal way to do it.  Getting it in a couple pieces at a time is slow
> going, but it seemed to cause frustration with just the small number
> of things we were looking for review/approval for...

I have some experience with patch merging, lets see if I can
help... It would be good to merge it upstream before the hw is
obsolete...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
