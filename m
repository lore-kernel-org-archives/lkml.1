Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYICMMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYICMMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYICMMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:12:23 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46156 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbYICMMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:12:22 -0400
Date: Wed, 3 Sep 2008 15:12:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] m68k: Add missing
	dma_sync_single_range_for_{cpu,device}()
Message-ID: <20080903121220.GF4104@cs181140183.pp.htv.fi>
References: <20080903071542.615137611@mail.of.borg> <20080903071742.932797091@mail.of.borg> <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809031257080.25157@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 12:59:04PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Wed, 3 Sep 2008, Geert Uytterhoeven wrote:
> 
> > Add the missing dma_sync_single_range_for_{cpu,device}(), and remove the bogus
> > `inline' for the non-static function dma_sync_single_for_device().
> 
> It's not bogus, it's a hint to gcc to inline the function into the callers 
> in the same file, but also to provide an external version.

"hint" = "we force gcc"

either we want it inlined into all callers or we want one external copy.
Doing both is suboptimal.

> bye, Roman

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

