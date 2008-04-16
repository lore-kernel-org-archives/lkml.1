Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYDPR7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYDPR7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYDPR6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:58:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34417 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYDPR6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:58:52 -0400
Date: Wed, 16 Apr 2008 20:58:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] proper prototypes for mmc_attach_*()
Message-ID: <20080416175847.GO1677@cs181133002.pp.htv.fi>
References: <20080413181550.GH2182@cs181133002.pp.htv.fi> <20080416193215.706d041d@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080416193215.706d041d@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 07:32:15PM +0200, Pierre Ossman wrote:
> On Sun, 13 Apr 2008 21:15:50 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch adds proper prototypes for mmc_attach_*() in 
> > drivers/mmc/core/core.h
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> 
> I'm not entirely convinced about these, but seems they seem to bother
> you... ;)

With proper prototypes in a header gcc can check that caller and callee 
agree about the function signature.

Otherwise someone might accidentally change only one of them.

That's a rare issue, but when it happens it's a nasty runtime error.

>      -- Pierre Ossman

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

