Return-Path: <linux-kernel-owner+w=401wt.eu-S937018AbXG0LsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937018AbXG0LsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXG0LsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:48:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:34216 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756259AbXG0LsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:48:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ia6NDArdiA/Af3hKaFhPDGkHkL3IlFqCmvgHTnt
	RyJEwM2gXjstjl
Subject: Re: updatedb
From: Mike Galbraith <efault@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Andika Triwidada <andika@gmail.com>,
       Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org, B.Steinbrink@gmx.de,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <46A9D26E.9010703@gmail.com>
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
	 <46A773EA.5030103@gmail.com>
	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>
	 <46A81C39.4050009@gmail.com>
	 <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>
	 <9a8748490707261746p638e4a98p3cdb7d9912af068a@mail.gmail.com>
	 <46A98A14.3040300@gmail.com> <1185522844.6295.64.camel@Homer.simpson.net>
	 <46A9ACB2.9030302@gmail.com> <1185528368.7851.44.camel@Homer.simpson.net>
	 <46A9D26E.9010703@gmail.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 13:48:00 +0200
Message-Id: <1185536880.8978.34.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 13:09 +0200, Rene Herman wrote:
> On 07/27/2007 11:26 AM, Mike Galbraith wrote:
> 

> > Updatedb finishes, freeing some ram (doesn't matter how much)
> 
> Will be very little and swap-prefetch at least in its current form needs 
> more than very little to start doing anything:
> 
> http://ck.kolivas.org/patches/swap-prefetch/2.6.21-swap_prefetch-38.patch
> 
> | /*
> |  * Set max number of entries to 2/3 the size of physical ram  as we
> |  * only ever prefetch to consume 2/3 of the ram.
> |  */
> 
> However, okay, let's just ignore that and pretend it kicks in even with the 
> little free memory updatedb itself left behind when it finished:

Hm.  I didn't read the patch, so I'm only going on what you quoted.
>From that, all I see is a limit on how much will be used total, and 2/3
of physical ram is a bunch.  This quote doesn't say free ram, it says
physical ram.  If it really does use only free ram, that indeed sounds
pretty pointless.  I believe the users who say their apps really do get
paged back in though, so suspect that's not the case.

Anyway, I only offered a simple explanation of how swap-prefetching can
indeed help (and possibly hurt) with something like updatedb, not an
analysis of it's current implementation ;-)  I'd have to read it, and
test it myself to do that, but my world doesn't have a need for it,
so...

	-Mike

