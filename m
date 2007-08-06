Return-Path: <linux-kernel-owner+w=401wt.eu-S1765184AbXHFNQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765184AbXHFNQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764114AbXHFNPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:15:55 -0400
Received: from 1wt.eu ([62.212.114.60]:1206 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764092AbXHFNPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:15:54 -0400
Date: Mon, 6 Aug 2007 15:12:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Claudio Martins <ctpm@ist.utl.pt>,
       Jeff Garzik <jeff@garzik.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070806131215.GC10999@1wt.eu>
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu> <20070805072805.GB4414@elte.hu> <20070805134640.2c7d1140@the-village.bc.nu> <20070805125847.GC22060@elte.hu> <20070805132925.GA4089@1wt.eu> <20070806065712.GA2818@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806065712.GA2818@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 08:57:12AM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > In your example above, maybe it's the opposite, users know they can 
> > keep a file in /tmp one more week by simply cat'ing it.
> 
> sure - and i'm not arguing that noatime should the kernel-wide default. 
> In every single patch i sent it was a .config option (and a boot option 
> _and_ a sysctl option that i think you missed) that a user/distro 
> enables or disabled. But i think the /tmp argument is not very strong: 
> /tmp is fundamentally volatile, and you can grow dependencies on pretty 
> much _any_ aspect of the kernel. So the question isnt "is there impact" 
> (there is, at least for noatime), the question is "is it still worth 
> doing it".
> 
> > Changing the kernel in a non-easily reversible way is not kind to the 
> > users.
> 
> none of my patches did any of that...

I did not notice you talked about a sysctl. A sysctl provides the ability
to switch the behaviour without rebooting, while both the config option
and the command line require a reboot.

> anyway, my latest patch doesnt do noatime, it does the "more intelligent 
> relatime" approach.

... which is not equivalent noatime in the initial example.

Regards,
Willy

