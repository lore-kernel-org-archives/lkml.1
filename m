Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0CBXsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:48:42 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:42292 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0CBXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:48:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GVbUohRIfuWrM+znMx6XQIvfgEGNbeZ4BLCT/D2JEwRbgHppjHPEfrWiKY50xQwK7A
         hNEDhC8bF9WniVg9lcyu/yE2IYgVgB+rgUAdVI+TA2oH2cP6LvN1QO6Bh+uQYA0RoM6U
         C0CUs96gQyEPEciOeCL0hbA72/WCir0VieF3I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003021536280.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
	 <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>
	 <alpine.DEB.2.00.1003022305070.4099@skynet.skynet.ie>
	 <21d7e9971003021527t41268786q302a218ffe410763@mail.gmail.com>
	 <alpine.LFD.2.00.1003021536280.3616@localhost.localdomain>
Date: Wed, 3 Mar 2010 09:48:36 +1000
Message-ID: <21d7e9971003021548u7509651fyfc875d4e30472486@mail.gmail.com>
Subject: Re: [git pull] drm request 2
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 9:40 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 3 Mar 2010, Dave Airlie wrote:
>>
>> Did I mention that driver is in STAGING?
>
> Staging is for _improving_ the quality of the drivers, not for making it
> worse.
>
> We still very much have quality standards. The staging tree is for things
> to get in that don't quite _reach_ the standards we expect, but it's not a
> blanket excuse for not testing things.
>
> And yes, I expect that stuff can be a bit rough during the merge window,
> after all, the whole point is that we can fix things up. But quite
> frankly, if _I_ find problems on the few machines I personally build and
> test on, then what does that say about the bigger picture?
>
> IOW, I refuse to pull code that doesn't even work for me. If I did, where
> would we end up? What do you think should be my minimal quality
> requirements, if "Oh, it doesn't even build for me" is too much to ask
> for?
>
> So if I find code that doesn't work, I'm not going to just say "whatever".
> I'm going to reject it.

So can we get linux-next builds to build with *your* Kconfig? This should
cut down the amount of crap you see considerably.

I'm not saying we have too many configuration options and testing them all
is insane, granted I admit I should have found this one since I do generally
try and build with nouveau on here.

I've sent a new pull, take it or not it builds here at least under
staging/acpi/vga_switcheroo off

Dave.
