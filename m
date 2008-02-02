Return-Path: <linux-kernel-owner+w=401wt.eu-S932495AbYBBQmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbYBBQmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYBBQmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:42:36 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:59939 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763795AbYBBQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:42:28 -0500
Date: Sat, 2 Feb 2008 17:42:23 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
In-Reply-To: <20080201223201.GA17828@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802021741560.28712@anakin>
References: <20080201104718.GA11717@uranus.ravnborg.org>
 <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick>
 <Pine.LNX.4.64.0802011325080.18111@anakin> <20080201134041.GC13349@uranus.ravnborg.org>
 <Pine.LNX.4.64.0802012221400.28712@anakin> <20080201223201.GA17828@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Sam Ravnborg wrote:
> On Fri, Feb 01, 2008 at 10:22:13PM +0100, Geert Uytterhoeven wrote:
> > On Fri, 1 Feb 2008, Sam Ravnborg wrote:
> > > On Fri, Feb 01, 2008 at 02:30:44PM +0100, Geert Uytterhoeven wrote:
> > > > BTW, on m68k I get ca. 160 of them. Most seem to originate in
> > > > drivers/isdn/. Doesn't look unsurmountable compared to the number of
> > > > other compile warnings fixed during the last few years ;-)
> > > 
> > > Can you try the patchset I will post in a minute.
> > > Would be nice to know if you see additional warnings as I got
> > > isdn clean here with x86 - 64 bit - allyesconfig.
> > 
> > Sure. Where can I find that patchset? I didn't see it on lkml so far,
> > except for the [0/5] email.
> 
> I posted a cumulative patch-set which you can find here:
> http://lkml.org/lkml/2008/2/1/242

Today's linux-2.6.git + this set killed ca. 100 warnings. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
