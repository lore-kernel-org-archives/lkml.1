Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbXGWTO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbXGWTO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761486AbXGWTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:14:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42520 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762099AbXGWTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:14:18 -0400
Date: Mon, 23 Jul 2007 21:13:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Modra <amodra@bigpond.net.au>,
       Roland McGrath <roland@redhat.com>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723191342.GO26212@stusta.de>
References: <20070723062759.GB3933@uranus.ravnborg.org> <20070723072613.E3A504D0489@magilla.localdomain> <20070723081435.GA4644@uranus.ravnborg.org> <20070723092559.GA24088@bubble.grove.modra.org> <20070723114936.GH21668@ftp.linux.org.uk> <20070723180048.GA8268@uranus.ravnborg.org> <20070723185648.GK21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070723185648.GK21668@ftp.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 07:56:48PM +0100, Al Viro wrote:
> On Mon, Jul 23, 2007 at 08:00:48PM +0200, Sam Ravnborg wrote:
> > On Mon, Jul 23, 2007 at 12:49:36PM +0100, Al Viro wrote:
> > > On Mon, Jul 23, 2007 at 06:55:59PM +0930, Alan Modra wrote:
> > > > On Mon, Jul 23, 2007 at 10:14:35AM +0200, Sam Ravnborg wrote:
> > > > > But I would still like to hear from Alan what the benefits are.
> > > > 
> > > > See http://sourceware.org/ml/binutils/2004-10/msg00178.html
> > > 
> > > What does _not_ doing intermediates do to memory footprint of ld(1)
> > > and time spent in there?
> > 
> > x86_64 defconfig
> > 
> > rm vmlinux*; time make vmlinux
> > 
> > Vanilla tree: ~7,7 sec
> > With single shot ld (Roland's patch): 8,3 secs
> > 
> > So as expected slower. As we link twice the cost is ~0,3 sec 
> > for a x86_64 defconfig link on my box.
> 
> defconfig is not too interesting, but anyway - how much memory does it
> take in process?  And, obviously, what kind of box it is?
>  
> > So it should be beneficial to do it and Alan's link did not really
> > convince me for the kernel usage.
> > Al - do you have any input there?
> 
> Depends.  If more-or-less allmodconfig doesn't kick everything else out
> of cache and doesn't end up creating fsckloads of seeks...
> 
> Actually, if you want a killer, see what happens when building with debug
> info...

Shouldn't "allyesconfig" be the worst case?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

