Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXA3Uo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXA3Uo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXA3Uo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:44:27 -0500
Received: from jack.tiscali.it ([213.205.33.53]:38028 "EHLO jack.tiscali.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXA3Uo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:44:26 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 15:44:26 EST
Date: Tue, 30 Jan 2007 21:33:01 +0100
From: Luca Tettamanti <kronos@people.it>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Dave Airlie <airlied@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-ID: <20070130203301.GA15067@dreamland.darkstar.lan>
References: <ephv35$4i3$1@sea.gmane.org> <20070128160831.fb51347f.akpm@osdl.org> <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com> <20070128162907.370f5476.akpm@osdl.org> <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com> <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Jan 29, 2007 at 03:37:22PM +0100, Giuseppe Bilotta ha scritto: 
> On 1/29/07, Dave Airlie <airlied@gmail.com> wrote:
> > > > > Because most users won't even be aware of the module option: they'll just
> > > > > know that their card doesn't work right.
> > > >
> > > > This isn't a card problem this is a monitor problem, the card just
> > > > passes through the edid data from the monitor... or else the
> > > > programming of the card registers from edid is wrong..
> > >
> > > In which case the same problem would occur with different video cards, so
> > > this patch should be some generic thing, available to all drivers, no?
> >
> > It should be in the fb layer not card specific.. as it may happen on any card...
> 
> Although solving the problem at the fb layer level is probably the
> correct/best way to do it, I am not aware of people having problems
> with broken EDIDs and non-nVidia cards. By contrast, workarounds for
> nVidia and broken EDIDs is a very common thing to do even on Windows.

Not all drivers have support for reading EDID information, so in many
cases it just "works". My old monitor had garbage in the EDID eeprom and
I had to pass "ignore_edid" to radeonfb (before I reprogrammed the
eeprom that is :P).

> Plus, providing an fb-layer-level solution is way beyond my kernel
> programming experience :)

I'll try to code something in the weekend.

Luca
-- 
Do, or do not. There is no try.
