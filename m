Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXFYNUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXFYNUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXFYNUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:20:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39377 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752229AbXFYNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:20:46 -0400
Date: Mon, 25 Jun 2007 15:21:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625132107.GD1094@stusta.de>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <20070625124442.GA44019@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070625124442.GA44019@dspnet.fr.eu.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:44:42PM +0200, Olivier Galibert wrote:
> On Mon, Jun 25, 2007 at 02:31:08PM +0200, Takashi Iwai wrote:
> > So, do you mean the soft-mixing is the biggest issue?  That's just a
> > part of a design issue, and if we want to go to that way, the
> > impelemtation would be trivial, regardless on ALSA or not.  Totally 
> > irrelevant argument regarding "remove ALSA".
> 
> Soft mixing is actually the biggest issue because if you had
> generalized soft-mixing in the kernel-visible audio ports[1] you would
> win two things:
> 
> - programs could use the OSS API without interfering with the ALSA one
>   or which each other

This works with aoss.

If people often run into this problem it might make sense to deprecate 
the in-kernel OSS emulation and point people to the userspace emulation 
instead?

> - programs coult use the ALSA kernel API directly without interfering
>   either, which would allow alternative libalsa implementations for
>   those who hate the current one
>...

Allowing for some hypothetical implementation noone might ever write is 
not sucha strong point...

>   OG.
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

