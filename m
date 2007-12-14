Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXLNTig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXLNTig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758970AbXLNTZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:25:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:15480 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbXLNTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:25:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kxSsDvaceKUuZqeO7rk7ujynYITTZ+Jx0B080GvX6p9rsCMVj3tRTeedl+/YukAcvMGxSAtgYysDJUoN4gJPsa1TxFXRZEMlGHDKlCqrD6Co4uK177VQqfrVSNnrNijjX0HNOH2Gl5zRHqb7TiD9DRS1ToTANDJEsln8oule+Fg=
Message-ID: <2c0942db0712141125g65422bc5r83c83a2ce81cc58a@mail.gmail.com>
Date: Fri, 14 Dec 2007 11:25:39 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200712142005.21375.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <200712141922.04677.mb@bu3sch.de>
	 <2c0942db0712141045nf7bf730l677936614f7db736@mail.gmail.com>
	 <200712142005.21375.mb@bu3sch.de>
X-Google-Sender-Auth: 70723ac7d756f37f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 11:05 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 14 December 2007 19:45:02 Ray Lee wrote:
> > > > One problem related to b43 source code, patch exists, has yet to be
> > > > merged upstream.
> > >
> > > Yeah. A problem preventing a LED from blinking.
> > > That's a real regression.... Come on. Stop that bullshit.
> >
> > I'm going to say this one last time. If rfkill and rfkill-input aren't
> > manually loaded before sb and b43, not one damn thing comes out in
> > dmesg. Nothing. Nada. Zilch. Zero. Bupkis. Zot. Null. The only way to
> > find out that those modules had to be loaded by hand was to go read
> > the bcm43xx-dev archives. Once those were loaded, messages came out in
> > dmesg pointing me to the URL for updated firmware.
>
> I'm sorry. The patch that _you_ quoted fixes a blinking LED
> and nothing else.

Well, you're wrong. Sorry, but that's just the way it is. See below.

> It does _not_ fix loading of rfkill or b43 in any way.
> It does, however, fix loading of rfkill-input. But the b43 module
> operation does _not_ depend in any way on the rfkill-input module, except
> the tiny LED that doesn't blink if it's not loaded.
> I hope you understood now that the thread on bcm43xx-dev was NOT about
> your requirement to load rfkill before b43.

*AGAIN*, please read your message here, in particular item number
seven on Larry's list:

https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006472.html

For the last fscking time, if rfkill and rfkill-input are not loaded,
not one line comes out in dmesg when b43 and ssb are loaded. In
particular, your pretty little message about needing newer firmware
also does not print. So, yeah, not loading rfkill{,-input} *does*
cause issues with b43 working, as there's no damn way to find out
what's broken!

> > I have complete current userspace as of yesterday's Ubuntu Hardy Heron
> > development archives.
>
> Ok. I will install a copy of Ubuntu Hardy Heron and check if I can
> reproduce this.

I'm not asking you to do that, this particular bug will be fixed by
Larry's patch, whether you believe that or not.

> However the fact that this does not happen on older Ubuntu platforms
> and does not happen on Fedora leads to the conclusion that it
> is a bug in Hardy Heron that I am not responsible for.

The kernel does not exist in a vacuum. It's the kernel's job to make
sure it works with properly written userspace. Broken userspace, sure,
then we can talk about breaking it.

> And you also do realise that Hardy Heron is the current development
> version of Ubuntu? Development versions have bugs.

Oy vay. I'm not an idiot. Yes, it's the current develoment version.
But tracking the latest kernel.org kernel has in the past required the
latest develoment version of the distribution, so I upgrade it as
well.

> > One last thing. I've been nice to you. Please be nice to me.
>
> If you simply stop blaming bugs on me that I am not responsible for
> at all, that is a deal. What about filing a bug at the ubuntu bugzilla?

I'm not blaming it on you. I'm merely reporting a fucking
incompatibility. Read my messages again from the top, and stop taking
this all so damn personally, will you?
