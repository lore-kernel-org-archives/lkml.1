Return-Path: <linux-kernel-owner+w=401wt.eu-S1764233AbXGNTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764233AbXGNTmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759847AbXGNTmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:42:14 -0400
Received: from waste.org ([66.93.16.53]:36787 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761136AbXGNTmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:42:13 -0400
Date: Sat, 14 Jul 2007 14:42:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070714194204.GB11166@waste.org>
References: <200707111916.35036.jesper.juhl@gmail.com> <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 04:25:56AM +0200, Jesper Juhl wrote:
> On 13/07/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >Jesper Juhl wrote:
> >> If, on the other hand, we consider 4K stacks to be the superior
> >> solution, then we should work to get all code fixed to be able to
> >> handle it so that it's actually something distros will start to enable
> >> so that we can eventually get rid of the 8K stack option alltogether.
> >> Making 4K stacks default and no longer a debug option is just the
> >> first step in that direction.
> >
> >First step is to apply wli's patch which makes separate interrupt stacks
> >orthogonal to the 4K stack option.
> >
> Yes and no.  If that will get things moving in the direction of
> getting rid of the stack size as a config option, then I'm all for it.
> But on the other hand it is my personal opinion that this is an area
> where we should just make up our minds as to whether we want 4K or 8K
> stacks and whether we want interrupt stacks or not, and then not have
> it configurable at all.  I believe the goal is 4K stacks + interrupt
> stacks, so let's just aim for that and get rid of the configurability
> of the damn thing - make a choice, make it work, make it be that
> that's what we use and rid ourselves of the alternatives...

There are two downsides to interrupt stacks:

- an extra 4k/8k used per CPU
- stack switch time

Both of those are pretty minimal. And I'd be surprised if the latter
was measurable. 

-- 
Mathematics is the supreme nostalgia of our time.
