Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbXGRVFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbXGRVFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXGRVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:04:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44459 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXGRVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:04:53 -0400
Date: Wed, 18 Jul 2007 23:04:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718210452.GG3898@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718194137.GG11166@waste.org> <20070718201043.GF3898@one.firstfloor.org> <469E7709.9070801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E7709.9070801@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 01:24:41PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > I was waiting for someone to make that "point" ...
> > 
> >> Every byte you can shave off the compressed kernel image is another
> >> byte you can use for userspace on your FLASH.
> > 
> > Now let's see if that 1MB 386 contains any flash at all. Guesses?  
> > 
> 
> CPUID is hardly something you want to give up for modern embedded stuff.
>  I haven't seen any new embedded stuff using anything less than a 586,
> and even those are disappearing quickly in favor of Geode and VIA.
> 
> However, compressed size reductions as an abstract thing is useful for
> this market.  Just not these particular ones.  The first thing to get
> there is probably an LZMA-based compressor instead of gzip.

That would need more memory again.

Better just write less bloated code. Perhaps mandatory bloatometer
runs during -rc*s for kernels with minimal config with public code pig shame lists
similar to the regression lists are useful. Anyone volunteering?

I suspect there is also much more low hanging fruit of this around.

I don't think eliminating cpuid is a step forward though; that's
just madness.

I killed about 20k in a i386 defconfig kernel in my upcomming patchkit
(and add some other code instead, but not much) so I'm coming out well currently.

-Andi
