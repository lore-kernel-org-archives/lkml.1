Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYD1Kmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYD1Kmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 06:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYD1Kmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 06:42:47 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40037 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbYD1Kmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 06:42:46 -0400
Date: Mon, 28 Apr 2008 13:42:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080428104214.GH16379@cs181133002.pp.htv.fi>
References: <20080426.215513.141243565.davem@davemloft.net> <20080427055943.GA16290@elte.hu> <20080426.230807.144232984.davem@davemloft.net> <20080427172542.GA5485@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080427172542.GA5485@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 07:25:43PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > ... as i saw no reason why this feature, which i found rather useful, 
> > > should be delayed another year or so. I'd be more than happy to promote 
> > > this feature back to lib/Kconfig.debug, sparc64 interest would make that 
> > > a strong argument.
> > 
> > So you caved in to FUD in order to pad your commit and signoff count?
> > 
> > Because anyone who is paying attention can see clearly that you're
> > trying to push as much stuff as quickly as possible into Linus's tree
> > with your singoffs and authorship on it this merge window.
> > 
> > Gee, I wonder why...
> 
> What is going on here?
> 
> Yes, Ingo wants to merge a lots of stuff so that he does not have to
> maintain it for two more months. That's the result of 14-days merge
> window decission. ... 
> 
> No, I don't like that, either, but I don't think you can blame Ingo
> for the merge window.

Do you remember the IDE disaster during 2.5?
It was caused by a maintainer sending unreviewed patches directly
to Linus.

What gets merged during the merge window should have been reviewed weeks 
or months earlier, and have gotten tested for some weeks by people 
(that's what linux-next and -mm are for).

If someone has fresh stuff during a merge window the best solution in 
many cases is to keep it for the next merge window, and get it properly 
reviewed and tested in the meantime.

We have serious problems to cope with the regressions that get merged 
during a merge window, and the options are:
- very buggy stable kernels
- longer release cycles (which in turn result in even more stuff being
  merged during merge windows, making all problems even worse)
- get stuff reviewed and tested *before* it hits mainline

We are currently changing more than one million lines per release, 
and we somehow need to ensure that we don't ruin Linux' reputation
as a stable OS due to a lack of QA.

> 							Pavel

cu
Adrian

BTW:
This obviously doesn't strictly apply to e.g. new drivers or simple
patches (although we really need a better review for drivers before 
merging, since usually once they are in Linus' tree noone (except Al)
does serious cleanups on them).

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

