Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXGGW2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXGGW2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 18:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXGGW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 18:27:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4572 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751745AbXGGW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 18:27:37 -0400
Date: Fri, 29 Jun 2007 18:39:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070629183907.GB3861@ucw.cz>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <20070625124442.GA44019@dspnet.fr.eu.org> <20070625132107.GD1094@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625132107.GD1094@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > 
> > Soft mixing is actually the biggest issue because if you had
> > generalized soft-mixing in the kernel-visible audio ports[1] you would
> > win two things:
> > 
> > - programs could use the OSS API without interfering with the ALSA one
> >   or which each other
> 
> This works with aoss.
> 
> If people often run into this problem it might make sense to deprecate 
> the in-kernel OSS emulation and point people to the userspace emulation 
> instead?

Without in-kernel OSS emulation, it is very hard to verify if kernel
sound support works properly. OSS could been driven from shell for
testing, and I believe that's still important feature to keep.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
