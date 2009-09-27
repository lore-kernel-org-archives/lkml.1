Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZI0Bvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZI0Bvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 21:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZI0Bvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 21:51:36 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49078 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZI0Bvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 21:51:36 -0400
Date: Sat, 26 Sep 2009 21:51:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Alistair Buxton <a.j.buxton@gmail.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "Zebediah C. McClure" <zmc@lurian.net>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP: Remove unused CONFIG MACH_OMAP_HTCWIZARD
In-Reply-To: <3d374d00909261836g38ceceb0p3fed39ac62103c33@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0909262148100.6153@localhost>
References: <1253974303.4568.13.camel@ht.satnam> <3d374d00909261836g38ceceb0p3fed39ac62103c33@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009, Alistair Buxton wrote:

> 2009/9/26 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> >
> > Remove unused CONFIG MACH_OMAP_HTCWIZARD from Kconfig
>
> Don't do it please! We're working on it.... board file is coming
> very soon.

  i've noticed that happening fairly often -- feature infrastructure
is added before the feature itself.  at the risk of sounding all
preachy and everything, that sort of thing should be avoided in order
to keep the history cleaner.  and because that's *exactly* the sort of
thing that, occasionally, produces the kind of historical cruft that
leaves unused CONFIG variables lying around when a feature is
abandoned in midstream.

  ok, i'll stop preaching now.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
