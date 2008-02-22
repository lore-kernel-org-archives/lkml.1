Return-Path: <linux-kernel-owner+w=401wt.eu-S935795AbYBVWXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935795AbYBVWXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934983AbYBVWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:13:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47640 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217AbYBVWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:13:06 -0500
Date: Fri, 22 Feb 2008 14:12:33 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Alexey Zaytsev <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080222221233.GC9510@kroah.com>
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de> <f19298770802221206j4d56f002mc4c2036842a18f58@mail.gmail.com> <200802222112.44317.mb@bu3sch.de> <f19298770802221238m569375a9k7c94fbd8382b5538@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770802221238m569375a9k7c94fbd8382b5538@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:38:34PM +0300, Alexey Zaytsev wrote:
> On Fri, Feb 22, 2008 at 11:12 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Friday 22 February 2008 21:06:00 Alexey Zaytsev wrote:
> >  > >  It is not my problem, if you refuse to use b43.
> >  > >  You also still refuse to tell me details about your card and _what_
> >  > >  does not work. I do own lots of different card and they
> >  > >  all work fine with b43. There's one exception, the 4311 rev 3 (or something,
> >  > >  don't quite remember). But patches are available and will ship in 2.6.25.
> >  > >  bcm43xx won't get removed until that shipped.
> >  >
> >  > Yes, it's a 4311 rev 01, but I'm probably was just too lame to upgrade the
> >  > firmware or something. :E
> >  >
> >  > I really don't get it, what is going on here? You state that the new b32 driver
> >  > has problems on some hardware, where the old bcm43xx driver just works.
> >  > And at the same time, you are surprised that I "refuse" to use the b43 driver
> >  > and push patches for the bcm43xx driver you broke... Oh, really, why?!
> >
> >  So, please find someone who will sign-off your patch. I won't.
> >  What's so hard to understand about that? Do I _have_ to sign off all patches
> >  random people send to me?
> >  I do _not_ want to be made responsible for that patch by signing it off.
> >  It is as simple as that.
> >  And I officially do not care about bcm43xx since a year and a half anymore.
> >  So why should I ACK it or sign it off?
> >
> 
> I thought that there was a rule that if you break something in the kernel, you
> normally would be the one who fixes things up. Sorry, it looks I was wrong.
> 
> I'll resend the patch directly to Greg KH and Jeff Garzik for -stable and 2.6.25
> inclusion.

One of the rules for the -stable tree is that the patch is accepted by
the maintainer and it is already in the upstream kernel version.  Both
of these requirements do not seem to be met here.

I suggest you work _with_ Michael instead of against him to try to
determine why your device doesn't work properly with the recommended
driver.

thanks,

greg k-h
