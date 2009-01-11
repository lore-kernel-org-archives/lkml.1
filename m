Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZAKQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZAKQjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZAKQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:39:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:36611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZAKQjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:39:41 -0500
Date: Sun, 11 Jan 2009 08:30:18 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090111163018.GA9300@suse.de>
References: <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111153920.GC7401@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 04:39:20PM +0100, Ingo Molnar wrote:
> 
> * Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > > At least IMHO.
> > > 
> > > ( What could _perhaps_ change the picture a bit IMO is drivers/staging/ i 
> > >   think - we could take a far more active role in certain types of 
> > >   projects that have been done out of tree typically, with no formal
> > >   promise for compatibility - or something like that. )
> > 
> > So if staging would have existed +one year ago, we should probably have 
> > included squashfs 3.3 at that time, and just have moved it to fs/ once 
> > the V4 layout was finished?
> 
> might have been a possibility - although there's a notable absence of any 
> filesystem drivers in the latest drivers/staging/ set.
> 
> Greg, is that just accidental (no one has submitted one yet) or is it some 
> sort of policy?

I was wanting to stick with drivers to start with, but I really have no
objection to adding filesystems, if they are self-contained, to the
drivers/staging/ directory.

I looked at adding squashfs, but at the time, it touched other portions
of the kernel which wouldn't have made it a good canidate for staging.
This was later resolved, and now that it is merged, it's a moot issue :)

So, if anyone wants to send me filesystems, I'll be glad to take them
into drivers/staging, as long as they are self-contained (novfs for
example would fit this category.)

thanks,

greg k-h
