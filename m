Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYFYXLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYFYXLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYFYXLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:11:23 -0400
Received: from 1wt.eu ([62.212.114.60]:2081 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYFYXLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:11:22 -0400
Date: Thu, 26 Jun 2008 01:11:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: jdow <jdow@earthlink.net>
Cc: Matthew <jackdachef@gmail.com>, greg@kroah.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ANNOUNCE] Position Statement on Linux Kernel Modules
Message-ID: <20080625231107.GA21889@1wt.eu>
References: <e85b9d30806230602m10b5aa06m2f1c83e1a90a7dac@mail.gmail.com> <20080623132118.GC1369@1wt.eu> <01ca01c8d715$1b127a60$0125a8c0@wednesday>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ca01c8d715$1b127a60$0125a8c0@wednesday>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 03:45:01PM -0700, jdow wrote:
> From: "Willy Tarreau" <w@1wt.eu>
> Sent: Monday, 2008, June 23 06:21
> 
> 
> >On Mon, Jun 23, 2008 at 03:02:58PM +0200, Matthew wrote:
> >>Hi Greg,
> >>
> >>I largely agree to this statement,
> >>
> >>there are however some downsides if you're preventing driver
> >>manufacturers (e.g. nvidia, ...) from the possibility to offer their
> >>customers proprietary drivers:
> >>
> >>1) One big and important point for me (and more and more future
> >>linux-users) is powersaving features on GPUs like powermizer (by
> >>nvidia) and powerplay (by AMD/ATI) or other hardware. I haven't seen
> >>this working on newer graphics cards models with the opensource
> >>drivers to the present day :(
> >
> >I think that's one of the reasons of Greg's post.
> >
> >(...)
> >>if those companies can't use their own closed proprietary drivers
> >>utilizing patented routines they are "forced" to use
> >
> >You're wrong here. If they have patented routines, they don't need
> >their drivers to be closed, since there routines are protected by
> >patents. And even if they are not patented, not releasing the source
> >will not prevent a competitor from disassembling the code anyway.
> >So there's really no point in remaining closed. Some of them might
> >have signed NDAs before using some technologies, but by this time,
> >they should have sorted that our.
> 
> Willy, you make a bold assertion here. Your assertion would hold a
> lot more weight if you defended it with some facts.
> 
> >>they might think over it and switch to another operating system ...
> >
> >Do you know many products with closed Linux drivers which are not
> >supported by at least one closed OS ? If they chose to support
> >Linux, it's not for your pleasure, just because they know they will
> >sell 5-10% more when a penguin is stuck on the box.
> 
> That is why there are the closed, and flakey, drivers for so many
> products. Rather than make ideological assertions sit down and prove
> your points. Address cases where there is an intellectual property
> holder involved who has chosen Trade Secret rather than Patent as a
> protection on their proprietary code. Show how they will stay in
> business if they give away their code.

Your statements clearly indicate that you have never worked yet and
are slowly discovering the business world. I would like to return
the challenge to you : show me one software company still in business
and making profit who has not set a few patents on (provably obvious)
methods they rely on. Trade secrets don't work anymore because once
discovered, you're attacked by their patent holder (since everything
is patented in this crappy world).

There are no trade secrets in software, everything is disassemblable
and decompilable. There are no trade secrets in hardware. Chips get
acid-washed, photographed, recomposed and decompiled every day. Trying
to hide a hardware trade secret inside a binary driver is completely
silly and useless.

> Presume that their modules are
> in clean enough shape that making money with a profitable service desk
> is not going to fly.

Releasing source costs less than maintaining and releasing binaries for
every version of every distro.

However, what *does* happen is that some editors don't want to see
their sources released as GPL or BSD and get stolen^Wcleaned up by
someone who pretends to provide a clean rewrite by playing cut'n'paste.
But I don't think it is a real problem in the driver world. Once the
driver gets merged, it's on the rails.

Willy

