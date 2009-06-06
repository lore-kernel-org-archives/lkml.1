Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZFFU2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZFFU2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 16:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZFFU2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 16:28:00 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:40209 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751768AbZFFU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 16:28:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iXvtR5L076zfkOI62IS9f53c24LfOkLF3Je3/1WD7JcqCJh/wU7GhakPCujBxGADAq3KrZWimiZ7HoUKAb/MtnVVFxqvWOmS6T7gfhKeD/vSj4Qwsacd1P5NrSvqU0lx;
Date: Sat, 6 Jun 2009 21:27:59 +0100
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Woody Suwalski <woodys@xandros.com>, eric@anholt.net,
       intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, stable@kernel.org,
       tim.gardner@canonical.com, apw@canonical.com,
       stefan.bader@canonical.com
Subject: Re: Intel 915GM MCHBAR bug
Message-ID: <20090606212759.31970fae@jbarnes-x200>
In-Reply-To: <4A2A0E8C.1010109@cs.helsinki.fi>
References: <4A242C81.6020906@cs.helsinki.fi>
	<4A298971.5080006@xandros.com>
	<4A2A0951.1020608@cs.helsinki.fi>
	<20090605232711.d8503262.akpm@linux-foundation.org>
	<4A2A0E8C.1010109@cs.helsinki.fi>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Jun 2009 09:37:00 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Sat, 06 Jun 2009 09:14:41 +0300 Pekka Enberg
> <penberg@cs.helsinki.fi> wrote:
> >>>> Wanna show us the patch?
> >>>>
> >>>> Because the world could certainly do with more i915 bugfixes :(
> >>>   
> >>> Here is Jesse's patch from 
> >>> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
> >>> adopted for 2.6.30-rc8... (needed to redo hunk #3 for
> >>> i915_gem_tile.c)
> >> Yup. I took the two patches from here:
> >>
> >> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349314
> >>
> >> and did the same rediffing on top of 2.6.30-rc8 for the first one.
> >>
> >> Andrew, do you want me to forward you the (tested) patches or
> >> should we wait for Jesse et al to take care of it?
> > 
> > Yes, please send them out.
> 
> OK, I did that. I am bit unhappy that I had to do it, though. The
> patch dates back to January (!) and Ubuntu folks have been carrying
> it for a while now.
> 
> Looking at the amount of reports out in the wild (on Ubuntu forums, 
> etc.), I really don't understand why this wasn't submitted earlier. 
> Instead, the bug was flagged with low priority because it's "just a 
> performance problem." Considering the system is more or less unusable 
> for me, I obviously think it's a critical bug fix.
> 
> Andrew Morton wrote:
> > These might end up being 2.6.30.1 material.
> 
> Yes, agreed completely. We probably want ACK from Jesse and Bjorn,
> though.

I'm ok with it being 2.6.30.1 stuff, but given the significance of the
change we were worried about putting it into 2.6.30 late in the cycle.
But as you say, it's a very important performance fix for many
machines...

Anyway, Eric may already have it merged.  Eric?

Jesse
