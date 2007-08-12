Return-Path: <linux-kernel-owner+w=401wt.eu-S937845AbXHLTQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937845AbXHLTQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934411AbXHLTQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:16:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934336AbXHLTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:16:09 -0400
Date: Sun, 12 Aug 2007 12:15:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: dean@arctic.org, patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD
 Fam10h
In-Reply-To: <200708121203.23741.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0708121205210.30176@woody.linux-foundation.org>
References: <20070809241.425881000@suse.de> <20070809124128.886BE14F3B@wotan.suse.de>
 <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org>
 <200708121203.23741.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, Andi Kleen wrote:
> >
> > Damn you, Andi.
> 
> Thanks for the kind words.

Should I be impressed by the fact that 16% of your patches caused bootup 
problems, when we're really close to a -rc3, and *long* past the point 
where we want to address regressions rather than cause them?

I simply want you to be more careful.  *Much* more careful. As it is, I 
end up always being afraid of merging your patch-series (and yes, I should 
have found this even earlier when reading through the diff rather than 
after I had already applied it, but I didn't, and we had a broken kernel 
for a few hours as a result. I didn't see any bug-reports about this one, 
so hopefully nobody noticed, but it still grates me).

Bugs happen, but (a) they should happen during the merge window, not when 
we're in stabilization phase and (b) the percentages here were just not 
very good.

			Linus
