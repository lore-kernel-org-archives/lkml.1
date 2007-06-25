Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXFYMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXFYMr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXFYMrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:47:51 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2442 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbXFYMrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:47:51 -0400
Date: Mon, 25 Jun 2007 14:47:50 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Takashi Iwai <tiwai@suse.de>, Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625124750.GB44019@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Takashi Iwai <tiwai@suse.de>,
	Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <Pine.LNX.4.64.0706251439140.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706251439140.3137@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:40:23PM +0200, Jan Engelhardt wrote:
> 
> On Jun 25 2007 14:31, Takashi Iwai wrote:
> >> It was started in time when most cheap sound cards was without hw mixer.
> >> And .. when today you use ALSA on sound card without hw mixer still all 
> >> this (past ?) problems are actual.
> >
> >Huh?  I have no problems with soft mixing...
> 
> Diverging from the discussion, how is soft mixing actually done? If it was done
> in userspace, it would need shared memory, or a back relay from kernelspace to
> userspace (and back again for the final output), otherwise I could not imagine
> how all alsa streams came together at one point.

SysV shared memory and semaphores, done in the alsa lib.

Yes, your kernel sound access library does shared mem, semaphores,
fork+exec and friends.

Back relay and virtual devices is the way it should have been done.

  OG.
