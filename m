Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYBLS1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYBLS1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761705AbYBLS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:27:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760708AbYBLS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:27:25 -0500
Date: Tue, 12 Feb 2008 10:26:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212174824.GA1919@kroah.com>
Message-ID: <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
 <20080212174824.GA1919@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Greg KH wrote:
> 
> I may be a bit defensive here, but I hope that all of the recent
> kobject/kset/driver core changes have been done with the thought of
> "what are we doing wrong".

.. but are we expecting it to be finished?

That's the point.

This whole "Linux-next" discussion so far has almost been predicated on 
the whole assumption that this is an on-going concern. And it really 
should NOT be.

If it's an on-going concern, we need to tackle *that* issue, not the issue 
that cross-subsystem merges are hard. They simply seem to happen too much.

In other words, I'm not AT ALL interested in the merges we've already 
done. That's over and done with, and we'll never ever do those merges 
again. Who cares? I don't.

I'm purely and _only_ interested in the merges of the future. You don't 
need to be defensive about the things that led up to this discussion, I'm 
more hoping that we can aim at fixing the problem at the source, rather 
than trying to work around it.

We simply shouldn't have all that many conflicts. We've had *way* too many 
of them lately, and I think it's because people have felt it wasn't too
painful. 

Put another way: back when we worked with just patches, we avoided renames 
like hell, and we also tried to simply even re-architect the whole tree so 
that you didn't have so many patch conflicts. One main reason as far as I 
was concerned for things like per-directory Kconfig files and the whole 
initcall() stuff was the fact that the old single Kconfig file and the old 
crazy init/main.c file were total *nightmares* when it came to conflict 
resolution.

So we split things up more, and we didn't do renames (or were very careful 
about it). We avoided the things that caused pain.

I think we need to remember that: yes, we'll always have to have ways to 
fix the pain that does happen, but even more importantly, we should strive 
for models where it doesn't happen in the first place!

And simply avoiding cross-subsystem API changes unless there is a major 
*MAJOR* reason for them is the obvious thing to do. Simply face the fact 
that even in open source there are major reasons to stay with an old 
interface even if it's not optimal.

We absolutely MUST NOT have the mindset that "cross-subsystem conflicts 
happen all the time". 

That was my point.

			Linus
