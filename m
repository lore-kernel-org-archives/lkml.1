Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbYHaOD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbYHaOD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYHaODs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:03:48 -0400
Received: from mout5.freenet.de ([195.4.92.95]:41145 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbYHaODp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:03:45 -0400
Date: Sun, 31 Aug 2008 16:03:40 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080831140340.GD4305@tux1.brauer.lan>
References: <20080826141851.GA5300@tux1.brauer.lan> <20080828103013.163730ee@doriath.conectiva> <20080831092923.GB4305@tux1.brauer.lan> <200808311528.27353.s.L-H@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200808311528.27353.s.L-H@gmx.de>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 03:28:22PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Sonntag, 31. August 2008, Gerhard Brauer wrote:
> [...]
> > Ok, some news from archlinux side:
> > Our distribution kernel was upgraded from 2.6.26.2 to 2.6.26.3. With
> > this upgrade to patchlevel .3 the "early oops"(freeing smp...) has gone.
> > My virtual machines boots always fine with this, and i have one
> > confirmation from a user about this.
> 
> Sorry, I can't confirm this here on Debian unstable (with virtualbox-ose 
> 1.6.2 or 1.6.4), are you sure that other configuration options didn't 
> change between the different kernel versions? Preemption and paravirt can
> influence the probability of the early boot panic seriously, without really
> avoiding it alltogether.

Only changes between our 2.6.26.2-1 and 2.6.26.3-1 are some minor
framebuffer changes in config. If i have a look at the different
patchsets between the two versions i don't see something which could be
the reason between work and not work.

> Actually I still get the same issues with implanting
> ftp://ftp5.gwdg.de/pub/linux/archlinux/core/os/i686/kernel26-2.6.26.3-1-i686.pkg.tar.gz
> into the test vm using virtualbox-ose 1.6.4.

Hmm, one user also reports that he have no problem when using a vanilla
2.6.26 as guest kernel. But there must be some reasons when different
distributions notice a major problem between 2.6.25 and 2.6.26 with
their stock kernels. Although i don't even know if our few reports here
are very representavive...

> Regards
> 	Stefan Lippers-Hollmann

Gerhard

-- 
Heute ist das Morgen wovor du gestern Angst hattest...
