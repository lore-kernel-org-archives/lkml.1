Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXGWR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXGWR7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbXGWR7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:59:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44075 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbXGWR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:59:34 -0400
Date: Mon, 23 Jul 2007 20:00:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Alan Modra <amodra@bigpond.net.au>, Roland McGrath <roland@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723180048.GA8268@uranus.ravnborg.org>
References: <20070723062759.GB3933@uranus.ravnborg.org> <20070723072613.E3A504D0489@magilla.localdomain> <20070723081435.GA4644@uranus.ravnborg.org> <20070723092559.GA24088@bubble.grove.modra.org> <20070723114936.GH21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723114936.GH21668@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 12:49:36PM +0100, Al Viro wrote:
> On Mon, Jul 23, 2007 at 06:55:59PM +0930, Alan Modra wrote:
> > On Mon, Jul 23, 2007 at 10:14:35AM +0200, Sam Ravnborg wrote:
> > > But I would still like to hear from Alan what the benefits are.
> > 
> > See http://sourceware.org/ml/binutils/2004-10/msg00178.html
> 
> What does _not_ doing intermediates do to memory footprint of ld(1)
> and time spent in there?

x86_64 defconfig

rm vmlinux*; time make vmlinux

Vanilla tree: ~7,7 sec
With single shot ld (Roland's patch): 8,3 secs

So as expected slower. As we link twice the cost is ~0,3 sec 
for a x86_64 defconfig link on my box.

So it should be beneficial to do it and Alan's link did not really
convince me for the kernel usage.
Al - do you have any input there?

	Sam
