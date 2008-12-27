Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYL0TXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYL0TXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYL0TW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:22:59 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:45550 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYL0TW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:22:59 -0500
Date: Sat, 27 Dec 2008 20:24:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Message-ID: <20081227192430.GC10592@uranus.ravnborg.org>
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org> <20081227084708.GA16077@elte.hu> <20081227185727.GB10442@uranus.ravnborg.org> <49567AC3.4030507@zytor.com> <20081227191223.GA10592@uranus.ravnborg.org> <49567EB5.5030409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49567EB5.5030409@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 11:15:01AM -0800, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > On Sat, Dec 27, 2008 at 10:58:11AM -0800, H. Peter Anvin wrote:
> >> Sam Ravnborg wrote:
> >>> I wnet with the scripted conversion for now.
> >>> If that does not fly we can come back to this proposal.
> >>>
> >>> What I like most with the auto conversion is that we avoid
> >>> adding yet another special rule about how to do stuff in exported headers.
> >>>
> >> Indeed, and being keyword conversion, it's independent of context, at
> >> least as long as one doesn't have too many run-ins with weird uses of
> >> the # and ## preprocessor operators, which are a *lot* easier to rule
> >> out globally.
> > 
> > Speaking of what we want to use in exported headers.
> > What is the recommendation with respect to uint32_t and friends?
> > To my best knowledge they are banned in exported headers as they
> > are not part of the kernel namespace and I see few users too.
> > But is this something we should check for?
> 
> I personally would not be upset if we auto-changed {su}{8,16,32,64},
> [u]int_{8,16,32,64}_t and bool into the appropriate __{su}{8,16,32,64}
> types and _Bool.  I think the upside is way bigger than the potential
> downside.

I was only thinking of a warning so we could have this part cleaned up.
It is for the most part a trivial task to do for a volunteer.

I could also see some sporadic use of u_int32_t - dunno where it comes from.
But looks wrong to me.

	Sam
