Return-Path: <linux-kernel-owner+w=401wt.eu-S1750928AbXCJXMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbXCJXMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 18:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXCJXMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 18:12:00 -0500
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:42373 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbXCJXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 18:11:59 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sun, 11 Mar 2007 10:38:59 +1100
User-Agent: KMail/1.9.5
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <45F2F727.7010406@rtr.ca> <200703111034.02159.kernel@kolivas.org>
In-Reply-To: <200703111034.02159.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111038.59387.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 10:34, Con Kolivas wrote:
> On Sunday 11 March 2007 05:21, Mark Lord wrote:
> > Con Kolivas wrote:
> > > On Saturday 10 March 2007 05:07, Mark Lord wrote:
> > >> Mmm.. when it's good, it's *really* good.
> > >> My desktop feels snappier and all of that.
> > >
> > >..
> > >
> > >> But when it's bad, it stinks.
> > >> Like when a "make -j2" kernel rebuild is happening in a background
> > >> window
> > >
> > > And that's bad. When you say "it stinks" is it more than 3 times
> > > slower? It should be precisely 3 times slower under that load (although
> > > low cpu using things like audio wont be affected by running 3 times
> > > slower). If it feels like much more than that much slower, there is a
> > > bug there somewhere.
> >
> > Scrolling windows is incredibly jerkey, and very very sluggish
> > when images are involved (eg. a large web page in firefox).
> >
> > > As another reader suggested, how does it run with the compile 'niced'?
> > > How does it perform with make (without a -j number).
> >
> > Yes, it behaves itself when the "make -j2" is nice'd.
> >
> > >> This is on a Pentium-M 760 single-core, w/2GB SDRAM (notebook).
> > >
> > > What HZ are you running? Are you running a Beryl desktop?
> >
> > HZ==1000, NO_HZ, Kubunutu Dapper Drake distro, ATI X300 open-source X.org
> > driver.
>
> Can you try the new version of RSDL. Assuming it doesn't oops on you it has
> some accounting bugfixes which may have been biting you.

Oh I just checked the mesa repo for that driver as well. It seems the r300 
drivers have sched_yield in them as well, but not all components. You may be 
getting bitten by this too.

http://webcvs.freedesktop.org/mesa/Mesa/src/mesa/drivers/dri/r300/radeon_ioctl.c?revision=1.14&view=markup

I don't really know what the radeon and other models are so I'm not sure if it 
applies to your hardware; I just did a random search through the r300 
directory.

-- 
-ck
