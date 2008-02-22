Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbYBVWrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbYBVWrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935110AbYBVWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:45:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:46828 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934712AbYBVWpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YS/bYJb2WF1ukwX3yCKq4UF3HwN2a72opQmfWXL8/fyyI5dnoF+Nv9eXx9iDMy4qkFBCDoucoufy2zxEiO9iHW0sIy/jhdtWgexn1n+Zm3VM22Jy4h4vvDrkRtGNH5mJikTye+3VEgCrZeOXGQitq62C3CTb8Stj9Kp7CqhDNS4=
Message-ID: <f19298770802221445p21cedad5yd20864cfd3e36b3@mail.gmail.com>
Date: Sat, 23 Feb 2008 01:45:23 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Michael Buesch" <mb@bu3sch.de>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080222221233.GC9510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <f19298770802221206j4d56f002mc4c2036842a18f58@mail.gmail.com>
	 <200802222112.44317.mb@bu3sch.de>
	 <f19298770802221238m569375a9k7c94fbd8382b5538@mail.gmail.com>
	 <20080222221233.GC9510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 1:12 AM, Greg KH <greg@kroah.com> wrote:
>
> On Fri, Feb 22, 2008 at 11:38:34PM +0300, Alexey Zaytsev wrote:
>  > On Fri, Feb 22, 2008 at 11:12 PM, Michael Buesch <mb@bu3sch.de> wrote:
>  > > On Friday 22 February 2008 21:06:00 Alexey Zaytsev wrote:
>  > >  > >  It is not my problem, if you refuse to use b43.
>  > >  > >  You also still refuse to tell me details about your card and _what_
>  > >  > >  does not work. I do own lots of different card and they
>  > >  > >  all work fine with b43. There's one exception, the 4311 rev 3 (or something,
>  > >  > >  don't quite remember). But patches are available and will ship in 2.6.25.
>  > >  > >  bcm43xx won't get removed until that shipped.
>  > >  >
>  > >  > Yes, it's a 4311 rev 01, but I'm probably was just too lame to upgrade the
>  > >  > firmware or something. :E
>  > >  >
>  > >  > I really don't get it, what is going on here? You state that the new b32 driver
>  > >  > has problems on some hardware, where the old bcm43xx driver just works.
>  > >  > And at the same time, you are surprised that I "refuse" to use the b43 driver
>  > >  > and push patches for the bcm43xx driver you broke... Oh, really, why?!
>  > >
>  > >  So, please find someone who will sign-off your patch. I won't.
>  > >  What's so hard to understand about that? Do I _have_ to sign off all patches
>  > >  random people send to me?
>  > >  I do _not_ want to be made responsible for that patch by signing it off.
>  > >  It is as simple as that.
>  > >  And I officially do not care about bcm43xx since a year and a half anymore.
>  > >  So why should I ACK it or sign it off?
>  > >
>  >
>  > I thought that there was a rule that if you break something in the kernel, you
>  > normally would be the one who fixes things up. Sorry, it looks I was wrong.
>  >
>  > I'll resend the patch directly to Greg KH and Jeff Garzik for -stable and 2.6.25
>  > inclusion.
>
>  One of the rules for the -stable tree is that the patch is accepted by
>  the maintainer and it is already in the upstream kernel version.  Both
>  of these requirements do not seem to be met here.

Well, it looks like Michael is not the bcm43xx maintaner. I sent the
patch to him,
because it was his code that broke the driver, and I thought it would
be easy for him to review my patch, as it touches his code.

I'll resend the patch to the proper maintainers now.

>
>  I suggest you work _with_ Michael instead of against him to try to
>  determine why your device doesn't work properly with the recommended
>  driver.

Well, if you read my first email, that is exactly what I intended to
do, but even if
Michael would be able to fix the b43 driver to work with my hardware, the code
will only show up in 2.6.25, leaving some 2.6.24 users with broken
wifi. So I thought
it would be a good thing to add my simple fix that enabled the old driver to the
-stable tree, so that we could have working wifi soon.

This is still my intension, I'll resend to the proper maintainters.

>
>  thanks,
>
>  greg k-h
>
