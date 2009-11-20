Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZKTTHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZKTTHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZKTTHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:07:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59001 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZKTTHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:07:34 -0500
Date: Fri, 20 Nov 2009 20:07:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>, pavel@ucw.cz
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
	non-ASCII
Message-ID: <20091120190730.GB1434@ucw.cz>
References: <20091116222738.GQ4764@const.famille.thibault.fr> <20091116225429.GB4764@const.famille.thibault.fr> <20091116230523.GC24961@x200> <20091116231520.GD4764@const.famille.thibault.fr> <20091117115503.GB1657@x200> <20091117132358.GJ12736@const.bordeaux.inria.fr> <20091119131854.GA1628@x200.localdomain> <20091119132828.GA31025@const.bordeaux.inria.fr> <20091119133737.GE31025@const.bordeaux.inria.fr> <4B055F24.8030307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B055F24.8030307@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So we agree, and so the right solution is to either completely rework
> > the interface (ugh), or just add LED routing (which can be very useful,
> > actually, I for instance don't care at all about the num lock state, but
> > I _do_ care about the lock that lets me shift between different keyboard
> > layouts).
> > 
> 
> Adding LED routing and using keyboard levels is so clearly The Right Thing.
> 
> We already allow the LEDs to be programmed; we should probably just
> have, for each LED, the ability to program it off/on/flashing/connected
> to modifier #X.
> 
> The current KDSETLED/KDGETLED interface is of course too limited for
> this -- we need an interface with at least a byte per LED.

Actually, we already have very nice /sys/class/led interface, and we
should just use it for keyboard leds, too. Actually I have a patch,
somewhere...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
