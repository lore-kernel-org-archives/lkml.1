Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXFFTa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXFFTa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbXFFTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:30:06 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5067 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbXFFTaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:30:05 -0400
Date: Wed, 6 Jun 2007 21:36:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrew Morton <akpm@linux-foundation.org>, Uwe Bugla <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
Message-ID: <20070606193647.GF4735@kernel.dk>
References: <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org> <s5h1wh4si5l.wl%tiwai@suse.de> <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr> <s5hveebziom.wl%tiwai@suse.de> <Pine.LNX.4.61.0705292212120.11140@yvahk01.tjqt.qr> <s5hps4a60zl.wl%tiwai@suse.de> <s5hlkey5zvt.wl%tiwai@suse.de> <Pine.LNX.4.61.0706051523580.20829@yvahk01.tjqt.qr> <s5h64625vu6.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h64625vu6.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05 2007, Takashi Iwai wrote:
> At Tue, 5 Jun 2007 15:25:07 +0200 (MEST),
> Jan Engelhardt wrote:
> > 
> > 
> > >> > >Well, I find the change of CONFIG_SND to menuconfig is fine, too.
> > >> > >But CONFIG_SND_PCI_DRIVERS and others don't make much sense to me.
> > >> > >How is it useful at all?
> > >> > 
> > >> > Hah, I just tell you some of my own experience.
> > >> > In summer 2003, I bought the last new machine, and it got these
> > >> > shiny new ports they like to call USB. :)
> > >> > I did not have much use for it, but I left it on - you never know
> > >> > what standard next is the big win of the decade. And actually,
> > >> > it did not took long (well, summer 2005) to get my first USB device.
> > >> > Still, I am hell as sure I do not have USB-based sound devices
> > >> > anytime soon, so it would be cool to deactivate the whole usbsound
> > >> > menu at once. I think I said that in the patch description, did not I?
> > >> 
> > >> But it's not cool to add an extra config item just for that, too.
> > >> And, the structure of menuconfig-if-endif is uglier than menu-endmenu.
> > >> That's why I feel a bit uneasy, although all these are a matter of
> > >> taste...
> > >
> > >Forgot to mention about another annoying drawback.  Because of the new
> > >CONFIG_SND_*_DRIVERS, you'll have to re-select all belonging
> > >CONFIG_SND_*, even via config oldconfig.  Putting the dependency on
> > >the top seems to reset the values defined in the old .config.
> > 
> > Well, *I* (previously) submitted patches with  "default y", but Jens 
> > Axboe [http://lkml.org/lkml/2007/5/12/164] disagreed heavily enough to 
> > stop that practice.
> 
> Hm, I guess Jens didn't know about this side-effect.
> 
> When I don't set "default y", I'll be asked for each belonging item
> even though I chose "y" manually for the top config
> (CONFIG_*_DRIVERS).
> 
> Strangely, setting "default y" has no this effect...

That sounds like a bug in the kconfig system. I still think default y is
an *awful* idea, but you can read why in the thread referenced above.

-- 
Jens Axboe

