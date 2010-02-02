Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0BBRsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:48:30 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55498 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0BBRs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:48:29 -0500
Date: Tue, 2 Feb 2010 18:48:28 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Andreas Mohr <andi@lisas.de>,
       Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve usability in case of init binary failure
Message-ID: <20100202174828.GA2017@rhlx01.hs-esslingen.de>
References: <20091116194015.GA13820@rhlx01.hs-esslingen.de> <20091116203545.GA2028@emergent.ellipticsemi.com> <20091117204015.GB5746@rhlx01.hs-esslingen.de> <20091227150329.GA25711@rhlx01.hs-esslingen.de> <alpine.DEB.2.00.1002012308480.22003@chino.kir.corp.google.com> <20100202092041.674f3ff0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202092041.674f3ff0.akpm@linux-foundation.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:20:41AM -0800, Andrew Morton wrote:
> On Mon, 1 Feb 2010 23:10:51 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> 
> > On Sun, 27 Dec 2009, Andreas Mohr wrote:
> > 
> > > Well, took quite a while longer, partly due to broken Broadcom USB host
> > > (OpenWrt fix to be submitted) and non-working USB-audio on nicer platforms.
> > > 
> > > Took most of the comments into account (thanks!), improved some wording.
> > > 
> > > Patch against current git, compile- and runtime-tested,
> > > checkpatch.pl'd (with a single nice hierarchy warning resulting from mixing
> > > git diff output and manual /dev/null diffing).
> > > 
> > > Thanks!
> > > 
> > 
> > It looks like this patch got mangled when added to mmotm-2010-02-01-16-25 
> > in init-mainc-improve-usability-in-case-of-init-binary-failure.patch since 
> > it added init.txt to the root directory instead of Documentation,
> 
> ah, thanks.
> 
> > even though the patch below is correct.
> 
> Nope, the patch was wrong:
> 
> > > --- a/init/main.c
> > > +++ b/init/main.c
> > ...
> > > --- /dev/null	2009-12-27 16:25:29.521258205 +0100
> > > +++ Documentation/init.txt	2009-12-27 15:47:46.000000000 +0100
> 
> Should've been a/Documentation/init.txt

Indeed, which is why I had mentioned it in the submission (above),
but [fatally, as it turned out] did not bother to fix this ""minor"" issue.

Lots of sorries,

Andreas Mohr
