Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbXISRjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbXISRjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763314AbXISRhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:37:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58282 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763308AbXISRhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:37:47 -0400
Date: Wed, 19 Sep 2007 19:39:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1 - Mostly working, with a kbuild oddity
Message-ID: <20070919173912.GB3115@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <7319.1190143977@turing-police.cc.vt.edu> <20070918203239.GB27836@uranus.ravnborg.org> <15592.1190153008@turing-police.cc.vt.edu> <20070919073402.GA32218@uranus.ravnborg.org> <28616.1190217203@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28616.1190217203@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 11:53:23AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 19 Sep 2007 09:34:02 +0200, Sam Ravnborg said:
> 
> > > I had a few issues with some other modules, but they're evil binaries so
> > > I'm taking those up directly with the companies involved.. ;)
> > 
> > How annoying is this - and is this the CFLAGS thing again?
> 
> The other issues were VMWare and the removal of EXPORT_SYMBOL(set_dumpable),
> and NVidia graphics driver not playing nice with x86_64-mm-cpa-clflush.patch
> (these actually broke back around -rc[34]-mm1, so it's not a new issue).  I
> just had to spend 5 minutes re-checking that my workarounds did/didn't need
> refreshing.  Like I said, their problems (and mine), not lkml's.
> 
> > We could introduce some workaraound so we continue to respect
> > the CFLAGS settings in a Makefile for a while.
> > But at the end of the day we should convince the external module people
> > to follow the Kbuild docs. So it will then be temporary.
> 
> I already sent the author a patch for the broken Makefile.  I don't think an
> in-tree workaround is the right thing here.  I've vote for an entry in the
> "What's new in 2.6.2X" document when the kbuild changes go mainline, since
> fixing it to use EXTRA_CFLAGS worked perfectly.
Very good suggestion. I will try to make it happen when this hit mainline.
Thanks!

>  External module maintainers
> have (presumably) already read stable-API-nonsense, and should be used to
> fixing code for new releases, so a 1 or 2 line Makefile tweak shouldn't be a
> hardship.

No but then on the other hand I do not want to make life too dificult for
the (non-binary) external modules.
I will keep an eye out for additional CFLAGS mis-use and if I get no more than
a few report I will no do the backward compatibility thing.

	Sam 

