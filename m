Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZEYPET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZEYPET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZEYPEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:04:11 -0400
Received: from waste.org ([66.93.16.53]:43073 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZEYPEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:04:10 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI>
References: <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>
	 <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu>
	 <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
	 <20090525112504.GB24071@wotan.suse.de>
	 <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
	 <20090525114127.GE24071@wotan.suse.de>
	 <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Mon, 25 May 2009 10:01:14 -0500
Message-Id: <1243263674.12761.50.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 14:44 +0300, Pekka J Enberg wrote:
> On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> > > > The bootmem allocations of course are required because some hashes may
> > > > need to be larger than MAX_ORDER without using vmalloc.
> > > >
> > > > kmem_cache_init (and mem_init, partially) sets up the kernel memory
> > > > allocators...
> > > 
> 
> On Mon, May 25, 2009 at 02:37:59PM +0300, Pekka Enberg wrote:
> > > Which comment are you talking about? The "setup kernel memory
> > > allocators" one? Yeah, I should probably move it couple of lines down.
> 
> On Mon, 25 May 2009, Nick Piggin wrote:
> > Yes, just that one.
> 
> Here's an updated patch that does that. Thanks!

If we're gonna do that, we probably ought to have a comment.

/* These use large bootmem allocations and must precede kmem_cache_init
*/

-- 
http://selenic.com : development and support for Mercurial and Linux


