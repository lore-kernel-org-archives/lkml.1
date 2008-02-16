Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYBPLRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYBPLRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYBPLRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:17:30 -0500
Received: from www.tglx.de ([62.245.132.106]:56460 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYBPLR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:17:28 -0500
Date: Sat, 16 Feb 2008 12:16:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <Pine.LNX.4.64.0802130824500.8857@anakin>
Message-ID: <alpine.LFD.1.00.0802161155270.7583@apollo.tec.linutronix.de>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com> <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
 <20080213061653.GA10784@kroah.com> <Pine.LNX.4.64.0802130824500.8857@anakin>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Geert Uytterhoeven wrote:
> On Tue, 12 Feb 2008, Greg KH wrote:
> > On Tue, Feb 12, 2008 at 04:49:46PM -0800, Linus Torvalds wrote:
> > > On Tue, 12 Feb 2008, Greg KH wrote:
> > > > Perhaps you need to switch to using quilt.  This is the main reason why
> > > > I use it.
> > > 
> > > Btw, on that note: if some quilt user can send an "annotated history file" 
> > > of their quilt usage, it's something that git really can do, and I'll see 
> > > if I can merge (or rather, coax Junio to merge) the relevant part of stgit 
> > > to make it possible to just basically get "quilt behaviour" for the parts 
> > > of a git tree that you haven't pushed out yet.
> > 
> > Ted's description matches mine (keep quilt tree in git, edit changelog
> > entries, rebase on newer kernel versions, etc.)  I can go into details
> > if needed.
> 
> Ack. Same for PS3 and m68k (except I don't have the m68k patches in git (yet)).
> 
> Two issues with using quilt:
>   1. Sometimes a patch still applies after it was integrated upstream,

Add QUILT_PATCH_OPTS="--fuzz=0" to your ~/.quiltrc file.

The default is fuzz=2 IIRC which tries to be too clever. I set fuzz
to 0 after I got burned by an unnoticed "quilt patched it somewhere
else" bug, which took me half a day to figure out.

Thanks,

	tglx
