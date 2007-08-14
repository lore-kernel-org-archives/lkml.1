Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbXHNO3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbXHNO3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXHNO3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:29:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42008 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123AbXHNO3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:29:02 -0400
Date: Tue, 14 Aug 2007 16:28:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rene Herman <rene.herman@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
Message-ID: <20070814142853.GQ18945@stusta.de>
References: <1186984174.10249.7.camel@localhost> <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org> <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu> <1187099240.3537.1.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1187099240.3537.1.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 06:47:20AM -0700, Arjan van de Ven wrote:
> 
> On Tue, 2007-08-14 at 10:20 +0100, Alan Cox wrote:
> > > MODULE_MAINTAINER() was discussed a while ago but embedding information into 
> > > the binary has the problem you can't ever change deployed systems, meaning 
> > > it lags by design. If a maintainer changes, people would still be using the 
> > > information from their old binaries, meaning a replaced maintainer might get 
> > > contacted for potentially years still (and the new one not).
> > 
> > And as was pointed out at the time, the people whining about that were
> > talking out of the wrong equipment. The supplier of the code can no more
> > or less easily change the binary as the matching source tree once its been
> > shipped. In fact its probably easier to change the binaries as the
> > sources will be left on CD.
> > 
> > The only non-stale source is git-blame.
> 
> the other angle is this: if someone becomes the new maintainer, does he
> really want to "maintain" all the really old versions of the code out
> there that predate him, or does he only want to go forward? 
>...

What about cases like maintainers using company email addresses and 
changing company?

E.g. Jens is still block layer maintainer but the @suse address he used 
for years suddenly no longer existed after he left Suse.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

