Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZFIWIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZFIWIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZFIWH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:07:59 -0400
Received: from outbound-mail-317.bluehost.com ([67.222.54.10]:48673 "HELO
	outbound-mail-317.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752145AbZFIWH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:07:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=krwEowrs0Hn2CJhpWSNPabTfNeu2lUneFOClBBXjysTZcw1MnXJM4rVW2BYsBEVjzZCb+zbS8FMRNlYI/MFMZdrkACz7ihSS1eTzeVq/6bcnGPTjdMYEmFKAMzsVjzAZ;
Date: Tue, 9 Jun 2009 15:07:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, intel-gfx@lists.freedesktop.org,
       Woody Suwalski <woodys@xandros.com>, stefan.bader@canonical.com,
       linux-kernel@vger.kernel.org, apw@canonical.com,
       Andrew Morton <akpm@linux-foundation.org>, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [Intel-gfx] Intel 915GM MCHBAR bug
Message-ID: <20090609150757.4a2109a9@jbarnes-x200>
In-Reply-To: <20090606212759.31970fae@jbarnes-x200>
References: <4A242C81.6020906@cs.helsinki.fi>
	<4A298971.5080006@xandros.com>
	<4A2A0951.1020608@cs.helsinki.fi>
	<20090605232711.d8503262.akpm@linux-foundation.org>
	<4A2A0E8C.1010109@cs.helsinki.fi>
	<20090606212759.31970fae@jbarnes-x200>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.17.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 21:27:59 +0100
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Sat, 06 Jun 2009 09:37:00 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Hi Andrew,
> > 
> > On Sat, 06 Jun 2009 09:14:41 +0300 Pekka Enberg
> > <penberg@cs.helsinki.fi> wrote:
> > >>>> Wanna show us the patch?
> > >>>>
> > >>>> Because the world could certainly do with more i915 bugfixes :(
> > >>>   
> > >>> Here is Jesse's patch from 
> > >>> http://lists.freedesktop.org/archives/intel-gfx/2009-January/001186.html 
> > >>> adopted for 2.6.30-rc8... (needed to redo hunk #3 for
> > >>> i915_gem_tile.c)
> > >> Yup. I took the two patches from here:
> > >>
> > >> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/349314
> > >>
> > >> and did the same rediffing on top of 2.6.30-rc8 for the first
> > >> one.
> > >>
> > >> Andrew, do you want me to forward you the (tested) patches or
> > >> should we wait for Jesse et al to take care of it?
> > > 
> > > Yes, please send them out.
> > 
> > OK, I did that. I am bit unhappy that I had to do it, though. The
> > patch dates back to January (!) and Ubuntu folks have been carrying
> > it for a while now.
> > 
> > Looking at the amount of reports out in the wild (on Ubuntu forums, 
> > etc.), I really don't understand why this wasn't submitted earlier. 
> > Instead, the bug was flagged with low priority because it's "just a 
> > performance problem." Considering the system is more or less
> > unusable for me, I obviously think it's a critical bug fix.
> > 
> > Andrew Morton wrote:
> > > These might end up being 2.6.30.1 material.
> > 
> > Yes, agreed completely. We probably want ACK from Jesse and Bjorn,
> > though.
> 
> I'm ok with it being 2.6.30.1 stuff, but given the significance of the
> change we were worried about putting it into 2.6.30 late in the cycle.
> But as you say, it's a very important performance fix for many
> machines...
> 
> Anyway, Eric may already have it merged.  Eric?
> 

It's merged now into the drm-intel-next tree, and therefore queued for
the merge window.

Jeses
