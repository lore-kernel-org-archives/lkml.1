Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbZGIJxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbZGIJxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbZGIJxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:53:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57838 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485AbZGIJxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:53:30 -0400
Date: Thu, 9 Jul 2009 11:53:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Greg KH <greg@kroah.com>, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090709095322.GB10937@elf.ucw.cz>
References: <20090629114339.GA25552@elf.ucw.cz> <20090702200824.GJ10957@kroah.com> <20090708084439.GC20020@elf.ucw.cz> <a55d774e0907080247x23a2f134p1ecdb079c158df5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0907080247x23a2f134p1ecdb079c158df5@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Can you resubmit it with the original author descriptions?  It's not
> >> fair to them to have it shown up as coming from you.
> >
> > Yes, done... and thanks.
> >
> > Brian... I'd like to submit qdsp5 and smd code, too. Who should be
> > listed as their authors?
> 
> smd is pretty much my fault at this point, though Arve hacks on the
> PM-related bits.
> 
> The latest incarnation of the rpcrouter is me, with a lot of the
> original work by Iliyan, based heavily on the work Qualcomm did (thus
> their copyright on it as well as Google's).
> 
> qdsp5 is Iliyan.
> 
> Might be worth breaking these into at least three pieces (smd,
> rpcrouter, qdsp5)?

Sorry, I already submitted the patch. I just listed everyone I could
find in the sources in From: ; that included san@google but not
Arve. I hope that's not too bad.

> Are you highly opposed to having smd and rpcrouter under
> arch/arm/mach-msm?  They're (for better or worse) pretty integral to
> the core operation of the platform (suspend/resume and a lot of other
> core SoC functions require coordination with the modem core).

I am not opposed to having the code under mach-msm/ ... it would be
actually preffered. But it is quite a lot of code, and I guess it
makes sense to clean it up in staging/ then move it to the proper
place.

Alternatively if you can create nice git series for rmk/-next; that
would work, too. 

But I guess that staging/ stuff is quite easy to remove, and useful
for people that want to use the phones in the meantime :-).

> The qdsp5 stuff could exist elsewhere easily (though I'm not sure
> where the logical place is), and stuff on top of it like the v4l2
> camera stuff has obvious homes in the usual driver hierarchy.

Ack.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
