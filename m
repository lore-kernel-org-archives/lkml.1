Return-Path: <linux-kernel-owner+w=401wt.eu-S1764105AbXGUG2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764105AbXGUG2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXGUG2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:28:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60485 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXGUG2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:28:46 -0400
Date: Sat, 21 Jul 2007 08:30:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] console: fix section mismatch warning in vgacon.c
Message-ID: <20070721063000.GA31426@uranus.ravnborg.org>
References: <20070720212743.GB25064@uranus.ravnborg.org> <1184974649.4538.4.camel@daplas> <20070721054359.GA31109@uranus.ravnborg.org> <20070720230114.b06347de.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720230114.b06347de.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 11:01:14PM -0700, Andrew Morton wrote:
> On Sat, 21 Jul 2007 07:43:59 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sat, Jul 21, 2007 at 07:37:29AM +0800, Antonino A. Daplas wrote:
> > > On Fri, 2007-07-20 at 23:27 +0200, Sam Ravnborg wrote:
> > > > Fix following section mismatch warning:
> > > > WARNING: vmlinux.o(.text+0x121e62): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
> > > > 
> > > > Browsing the code it seems that vgacon_scrollback_startup() is only
> > > > called during the init phase so the reference to the .init.text
> > > > section is OK.
> > > > Teach modpost not to warn using ___init_refok.
> > > > 
> > > > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > > Acked-by: Antonino Daplas <adaplas@gmail.com>
> > 
> > Thanks. Will you take care of forwarding it it or do we rely
> > on Andrew in this area?
> > 
> 
> I tossed it into the next batch for Linus.  Tomorrow, I guess.

OK, thanks.

	Sam
