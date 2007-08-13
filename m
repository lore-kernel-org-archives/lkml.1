Return-Path: <linux-kernel-owner+w=401wt.eu-S947930AbXHMVF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947930AbXHMVF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937311AbXHMVFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:05:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55762 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934455AbXHMVFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:05:07 -0400
Date: Mon, 13 Aug 2007 23:04:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
Message-ID: <20070813210457.GJ18945@stusta.de>
References: <1186984174.10249.7.camel@localhost> <2c0942db0708131009y6f1c4cc4n59d8b36943643955@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2c0942db0708131009y6f1c4cc4n59d8b36943643955@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 10:09:08AM -0700, Ray Lee wrote:
> On 8/12/07, Joe Perches <joe@perches.com> wrote:
> > I grew weary of looking up the appropriate
> > maintainer email address(es) to CC: for a patch.
> >
> > I added flags to the MAINTAINERS file
> >
> > F:      file pattern
> >
> > for each maintained block and a script to parse
> > the modified blocks for maintainer and list
> > email addresses.
> 
> Why not parse git annotate or blame instead (other than it's freakin'
> slow)? Using the repository history has the added benefit of telling
> you a lot more fine-grained detail about who may want to know about
> your patch.

The git tree simply does not contain this information.

Some of the obvious problems:
- recently changed maintainership
- new maintainer email address with the old one bouncing
- git never contains maintainer mailing list addresses
- you can't distinguish between a maintainer of a driver and people only
  writing or forwarding patches for a driver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

