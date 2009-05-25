Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZEYLle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZEYLle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZEYLl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:41:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:33922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZEYLl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:41:27 -0400
Date: Mon, 25 May 2009 13:41:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090525114127.GE24071@wotan.suse.de>
References: <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 02:37:59PM +0300, Pekka Enberg wrote:
> On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> > The bootmem allocations of course are required because some hashes may
> > need to be larger than MAX_ORDER without using vmalloc.
> >
> > kmem_cache_init (and mem_init, partially) sets up the kernel memory
> > allocators...
> 
> Which comment are you talking about? The "setup kernel memory
> allocators" one? Yeah, I should probably move it couple of lines down.

Yes, just that one.
