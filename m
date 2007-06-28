Return-Path: <linux-kernel-owner+w=401wt.eu-S1765103AbXF1VGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765103AbXF1VGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXF1VFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:05:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43644 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759332AbXF1VFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:05:51 -0400
Date: Thu, 28 Jun 2007 23:06:14 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Nix <nix@esperi.org.uk>
Cc: Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070628210614.GC6087@stusta.de>
References: <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <20070625124442.GA44019@dspnet.fr.eu.org> <20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87tzssextf.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 07:30:36PM +0100, Nix wrote:
> On 25 Jun 2007, Adrian Bunk stated:
> > If people often run into this problem it might make sense to deprecate 
> > the in-kernel OSS emulation and point people to the userspace emulation 
> > instead?
> 
> So now people need to know internal implementation details like if a
> program uses ALSA or OSS interfaces before they know how to *run* it?
> 
> That doesn't sound especially nice to use (and before you say
> `distributors will do it', not all programs are built by distributors).

The interesting point is that what you call "internal implementation 
details" is much _more_ exposed with the OSS emulation in the kernel
_enabled_.

Why?

Linux software not supporting ALSA has becoming quite esoteric.

But software like mplayer supporting both and trying OSS first and 
software supporting both and letting the user choose is today much more 
common. And that's exactly the case where users run into the results of 
the "internal implementation detail" that their application used the 
in-kernel OSS emulation instead of ALSA resulting in exactly these 
problems.

There is also a userspace OSS emulation for ALSA not suffering from 
these problems.

It's not my decision whether or not to remove the in-kernel OSS emulation, 
all I'm saying is that removing it might actually result in less users 
having problems.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

