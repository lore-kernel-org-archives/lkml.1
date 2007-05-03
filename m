Return-Path: <linux-kernel-owner+w=401wt.eu-S1162125AbXECP3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162125AbXECP3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162130AbXECP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:29:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4843 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162125AbXECP3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:29:53 -0400
Date: Thu, 3 May 2007 15:14:09 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070503151408.GC3866@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <463292C8.9000307@goop.org> <20070428010043.GA21136@srcf.ucam.org> <46329DE3.6020307@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46329DE3.6020307@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > While that would certainly be nifty, I think we're arguably starting 
> > from the wrong point here. Why are we booting a kernel, trying to poke 
> > the hardware back into some sort of mock-quiescent state, freeing memory 
> > and then (finally) overwriting the entire contents of RAM rather than 
> > just doing all of this from the bootloader?

Doing it from the bootloader sounds attractive... but it is lot of
work. I'm essentially using linux as a bootloader.

Patch for grub welcome.

> Sure, you could make suspend generate a complete bootable kernel image
> containing all RAM.  Doesn't sound too hard to me.  You know, from over
> here on the sidelines.

Ah, so we have a volunteer :-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
