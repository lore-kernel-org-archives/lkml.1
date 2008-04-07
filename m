Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYDGHyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYDGHyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYDGHyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:54:33 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33686 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYDGHyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:54:33 -0400
Date: Mon, 7 Apr 2008 10:53:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/ata/sata_via.c - Eliminate "may be used
	uninitialized" warning
Message-ID: <20080407075357.GB20257@cs181133002.pp.htv.fi>
References: <1207518320.1803.52.camel@localhost> <20080406215054.GI30987@cs181133002.pp.htv.fi> <1207519207.1803.60.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1207519207.1803.60.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 03:00:07PM -0700, Joe Perches wrote:
> On Mon, 2008-04-07 at 00:50 +0300, Adrian Bunk wrote:
> > On Sun, Apr 06, 2008 at 02:45:20PM -0700, Joe Perches wrote:
> > > Called by svia_init_one with a temporary,
> > > so there's no effective code change.
> > I'm not getting any warning here.
> > Are you using an older gcc?
> 
> Yes.  Slightly less than 4.3.0
> 
> $ gcc --version
> gcc (GCC) 4.2.2 20071128 (prerelease) (4.2.2-3.1mdv2008.0)
>...

I've reproduced the warning with 4.2 but not with the 4.3 in Debian 
unstable.

Jeff is the one to decide about this specific patch.

Independent from this specific patch my opinion is that considering that 
we support 7 different release series of gcc aiming for a warning free 
compilation with the latest gcc is a good goal, but aiming for a warning 
free compilation with all supported gcc release series is not worth it
(especially considering that patches that fix such warnings might even 
introduce new bugs).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

