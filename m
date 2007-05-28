Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbXE1UNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbXE1UNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbXE1UNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:13:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4744 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759958AbXE1UNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:13:04 -0400
Date: Mon, 28 May 2007 20:12:13 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garzik <jeff@garzik.org>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Message-ID: <20070528201213.GA5840@ucw.cz>
References: <200705171423.46748.jesse.barnes@intel.com> <465228E2.1030405@garzik.org> <9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com> <200705211856.56228.jbarnes@virtuousgeek.org> <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com> <21d7e9970705220735j37bc8eeck87db7193c08c4c24@mail.gmail.com> <9e4733910705220813i479a68faxf365697962317c60@mail.gmail.com> <21d7e9970705221025r2f798dc5x310947db040c6521@mail.gmail.com> <9e4733910705221258v660d8f42j16cc596ca820e8b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910705221258v660d8f42j16cc596ca820e8b8@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> These are not isolated problems. Linux needs a 
> >properly designed
> >> graphics subsystem. One way to achieve that is to 
> >design it all on
> >> paper first so that we can try and locate the 
> >interactions between
> >> modules. For example the current mode setting design 
> >is definitely
> >> broken for multi-seat support, that's because you 
> >didn't take that
> >> feature into account when writing the code.
> >
> >No it isn't the code Jesse posted can handle multi-seat 
> >fine in the
> >areas that it makes sense as we've pointed out to you 
> >you cannot just
> 
> The code doesn't create one device per CRTC. Missing 
> that feature
> means that we need a persistent root priv app around 
> that owns the
> single device and then listens for messages from each 
> seat asking it
> to do things. That root priv app is not necessary, it is 
> a security
> risk and it should be eliminated.

Fine, submit a patch. But don't block other people patches just
because they do not address your favourite problem.

> >Fine, but nobody has succeeded at this, because the 
> >effort of doing it
> >this way is not incrementally developed, we are not 
> >designing DX10, we
> >are improving Linux graphics one step at a time.
> 
> And the right way to build a house is to build the 
> kitchen first and
> figure out the rest after the kitchen is finished.

...and the right way to build a house is to do nothing, and chase away
anyone trying to do something?

> >The thing is we need integration with memory 
> >management, the memory
> >management is in the drm as it is complicated and the 
> >work is done, I
> >know you aren't even reading this sentence at this 
> >point.
> 
> A new memory manager for drm is a nice piece of work. It 
> was something
> that needed to get done. But right now it is being done 
> in an X
> specific manner without consideration of alternative 
> graphics
> environments.

Feel free to post alternative patch that addresses that...

Fact is, everyone runs X these days. 'Your patches can't go in,
because you do not support alternative graphics systems (that don't
exist)' is pretty weak argument.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
