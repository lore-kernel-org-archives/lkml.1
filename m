Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbYBMH2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbYBMH2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765660AbYBMH2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:28:15 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:40553 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbYBMH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:28:12 -0500
Date: Wed, 13 Feb 2008 08:28:07 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080213061653.GA10784@kroah.com>
Message-ID: <Pine.LNX.4.64.0802130824500.8857@anakin>
References: <20080211211751.3e265754@laptopd505.fenrus.org>
 <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org>
 <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com>
 <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
 <20080213061653.GA10784@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Greg KH wrote:
> On Tue, Feb 12, 2008 at 04:49:46PM -0800, Linus Torvalds wrote:
> > On Tue, 12 Feb 2008, Greg KH wrote:
> > > Perhaps you need to switch to using quilt.  This is the main reason why
> > > I use it.
> > 
> > Btw, on that note: if some quilt user can send an "annotated history file" 
> > of their quilt usage, it's something that git really can do, and I'll see 
> > if I can merge (or rather, coax Junio to merge) the relevant part of stgit 
> > to make it possible to just basically get "quilt behaviour" for the parts 
> > of a git tree that you haven't pushed out yet.
> 
> Ted's description matches mine (keep quilt tree in git, edit changelog
> entries, rebase on newer kernel versions, etc.)  I can go into details
> if needed.

Ack. Same for PS3 and m68k (except I don't have the m68k patches in git (yet)).

Two issues with using quilt:
  1. Sometimes a patch still applies after it was integrated upstream,
  2. Sometimes it's a lot of work to fixup the patches after an upstream
     change. I wrote a script to do a tree-way-merge in case of a
     conflict, but I haven't really tested it yet (not suitable big
     conflict has happened since ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
