Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXHNNvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXHNNvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXHNNvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:51:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55069 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXHNNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:51:12 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rene Herman <rene.herman@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20070814102033.604c8695@the-village.bc.nu>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <46C10AA8.3090505@gmail.com>  <20070814102033.604c8695@the-village.bc.nu>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 14 Aug 2007 06:47:20 -0700
Message-Id: <1187099240.3537.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-14 at 10:20 +0100, Alan Cox wrote:
> > MODULE_MAINTAINER() was discussed a while ago but embedding information into 
> > the binary has the problem you can't ever change deployed systems, meaning 
> > it lags by design. If a maintainer changes, people would still be using the 
> > information from their old binaries, meaning a replaced maintainer might get 
> > contacted for potentially years still (and the new one not).
> 
> And as was pointed out at the time, the people whining about that were
> talking out of the wrong equipment. The supplier of the code can no more
> or less easily change the binary as the matching source tree once its been
> shipped. In fact its probably easier to change the binaries as the
> sources will be left on CD.
> 
> The only non-stale source is git-blame.

the other angle is this: if someone becomes the new maintainer, does he
really want to "maintain" all the really old versions of the code out
there that predate him, or does he only want to go forward? 
He wouldn't know anything about, say, the 2.4.21 version of the driver
anyway... nor would it be reasonable to expect him to.

I can an option where distros just set all the maintainer data to
themselves for long lived enterprise products... since effectively they
are the de-facto maintainers of those codebases.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

