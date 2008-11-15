Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYKOL70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYKOL70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 06:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYKOL7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 06:59:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54621 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754749AbYKOL7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 06:59:16 -0500
Date: Sat, 15 Nov 2008 12:58:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: linux-kernel@vger.kernel.org, jonsmirl@gmail.com, jrm8005@gmail.com
Subject: Re: In-kernel IR remote control support
Message-ID: <20081115115859.GA1572@ucw.cz>
References: <7f0c6fc9-556c-41a1-9750-ffb3455589ab@35g2000pry.googlegroups.com> <ApnRmVyojFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ApnRmVyojFB@christoph>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-13 00:09:00, Christoph Bartelmus wrote:
> Hi,
> 
> on 12 Nov 08 at 14:39, J.R. Mauro wrote:
> [...]
> > On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl <jonsm...@gmail.com> wrote:
> >> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro <jrm8...@gmail.com> wrote:
> >>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl <jonsm...@gmail.com> wrote:
> >>>> New release of in-kernel IR support implementing evdev support. The goal
> >>>> of in-kernel IR is to integrate IR events into the evdev input event
> >>>> queue and maintain ordering of events from all input devices. Still
> >>>> looking for help with this project.
> 
> >>> (Forgive me if this has already been asked or dealt with)
> 
> >>> Have you contacted the LIRC developers? Is there any overlap between
> >>> your projects?
> 
> >> The LIRC people know about this. Pieces of the code are coming from
> >> the LIRC source base and being reworked for kernel inclusion.
> 
> > Great, it's nice to see there's cooperation.
> 
> LOL. There's just a small omission from Jon's side...
> Yes, LIRC people know about this. And Jon has a no-go from me.
> 
> Decoding IR protocols in-kernel is the wrong way IMHO and this will not be  
> supported by LIRC as long as I maintain LIRC.

Time to fork lirc...?

Can you elaborate?  I don't see why IR remotes deserve special
handling. I'd expect to just plug in the receiver and have it work as
/dev/input/*.

> It's simply not possible to decode all existing IR protocols and LIRC just  
> stores the timing data for these protocols as-is without trying to decode  
> them. With the in-kernel decoding approach these remotes cannot be  
> supported. I'm not willing to sacrifice the support for these even though  
> they only consist of a very small fraction of remotes in use.

So you make it suck for everyone just because few obscure IR
remotes. Perfect enemy of good, I'd say :-(.

Can we merge the common ones into the kernel, while still keeping the
obscure ones in userspace using uinput or something?

I don't see why Jon's work bothers you. He's trying to do the right
support for the common remotes. That seems like a net plus to me, and
you can still keep the obscure ones in userland.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
