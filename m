Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbXFEIEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbXFEIEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXFEIEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:04:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60220 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758367AbXFEIEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:04:38 -0400
Date: Tue, 5 Jun 2007 10:05:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: adaplas@gmail.com, jakub@redhat.com, jengelh@linux01.gwdg.de,
       daplas@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Section mismatches in drivers/video/console/promcon
Message-ID: <20070605080526.GA21991@uranus.ravnborg.org>
References: <20070602124255.GA10119@uranus.ravnborg.org> <1180790683.4524.13.camel@daplas> <20070602191646.GA13264@uranus.ravnborg.org> <20070604.235313.85409993.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604.235313.85409993.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:53:13PM -0700, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 2 Jun 2007 21:16:46 +0200
> 
> > > 
> > > promcon_init() can be called again from visual_init() during
> > > vc_allocate().  So anything referenced by promcon_init() should not be
> > > marked __init.
> > > 
> > > Although, if you want to keep promfont_unitable and promfont_unicount
> > > __init, you can probably use con_copy_unimap() using the default vc as
> > > the source instead of doing a promcon_init_unimap() again.
> > 
> > Too involved for me to look into.
> > I cooked up following very minimal patch - if you agree can you then please
> > forward/take care of it.
> > 
> > 	Sam
> > 
> > Subject: video: fix section mismatch warning in promcon
> 
> I'll merge this fix in via the Sparc tree since this is a sparc
> console driver.
Thanks. I didn't notice it was sparc only otherwise I would have cc'ed you
and sparclinux.

	Sam
