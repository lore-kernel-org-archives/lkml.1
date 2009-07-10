Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZGJOZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZGJOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZGJOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:25:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:34346 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZGJOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:25:50 -0400
X-IronPort-AV: E=Sophos;i="4.42,378,1243828800"; 
   d="scan'208";a="3694608"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Boot Consoles question...
Date: Fri, 10 Jul 2009 10:28:03 -0400
User-Agent: KMail/1.9.5
CC: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <200907040017.26921.rgetz@blackfin.uclinux.org> <200907071949.41311.rgetz@blackfin.uclinux.org> <20090710102857.GF5499@elte.hu>
In-Reply-To: <20090710102857.GF5499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907101028.03153.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 10 Jul 2009 14:24:38.0850 (UTC) FILETIME=[28580A20:01CA016A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10 Jul 2009 06:28, Ingo Molnar pondered:
> 
> * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > On Sat 4 Jul 2009 12:07, Robin Getz pondered:
> > > On Sat 4 Jul 2009 06:29, Ingo Molnar pondered:
> > > > Could be changed i guess ... but is it really an issue?
> > > 
> > > It is just a change from "normal" (when the kernel has no boot
> > > console).
> > > 
> > > >  One artifact 
> > > >  could be manual scroll-back - it would perhaps be nice indeed to
> > > >  allow the scrollback to the top of the bootlog.
> > > 
> > > Exactly.
> > > 
> > > One of my thoughts (was since CON_PRINTBUFFER isn't used after 
> > > register_console()) - was for the CON_BOOT's CON_PRINTBUFFER flag to
> > > control the clearing of the CON_PRINTBUFFER for the real console or
> > > not... 
> > > 
> > > All early_printk consoles that I looked at have their
> > > CON_PRINTBUFFER set.
> > > 
> > > Which means that something like should do the trick -- allow people
> > > who want 
> > > to override things to do so, and still have the today's setup work
> > > as is...
> > 
> > I guess no one liked that idea?
> 
> No, this means no-one objected :)

Silence is consensus?

> > How about at least making sure that the real console gets a 
> > message that something is on the bootconsole? Right now the switch 
> > message:
> > 
> > console handover:boot [early_shadow0]  -> real [ttyBF0]
> > 
> > only is printed on the bootconsole, not on the real console - so 
> > someone looking at the real console may not know there is anything 
> > on the boot console. They just think that things are missing...
> 
> Mind sending a full (changelogged, titled, etc.) patch for the other 
> bit as well? It kind of overlaps this one but both make sense, 
> especially if people end up objecting against the more intrusive one 
> and it gets dropped/reverted ;-)

Will do - (as soon as I get my system up and running again - moved buildings, 
so still unpacking)...


