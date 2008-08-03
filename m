Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYHCRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYHCRej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYHCReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:34:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759001AbYHCReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:34:22 -0400
Date: Sun, 3 Aug 2008 10:33:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
In-Reply-To: <200808031833.32048.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0808031031380.3668@nehalem.linux-foundation.org>
References: <200807291015.02865.rusty@rustcorp.com.au> <200807292301.18733.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org> <200808031833.32048.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Aug 2008, Rusty Russell wrote:
> 
> I love your suggestion tho.  Oh wait, you didn't make one...

Ok, Rusty, I'm not bothering with this thread any more.

I gave a suggestion.

You didn't like it. Go away.

> And so my patch series replaces all 21 of them.  It's a trivial replace, 
> unlike sem -> mutex.

Your series doesn't "replace" anything.

It renames things with no good reason. The end result is _worse_. I told 
you why. You don't like it.

> > Guys, some quality control and critical thinking, please.
> 
> Good idea.  If we'd done that we wouldn't have the down_trylock() brain 
> damage.

You don't see the difference between "new crap" and "legacy crap that 
people have historical reasons for and that people have learnt to live 
with"?

Anyway, I NAK'ed your patches. Deal with it.

		Linus
