Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXLFVDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXLFVDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXLFVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:02:53 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53817 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913AbXLFVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:02:52 -0500
Date: Thu, 6 Dec 2007 22:02:48 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: penguin-kernel@I-love.SAKURA.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Message-ID: <20071206210248.GN15974@stusta.de>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp> <20071202134841.GI15974@stusta.de> <20071203153459.ac19dae3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071203153459.ac19dae3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 03:34:59PM -0800, Andrew Morton wrote:
> On Sun, 2 Dec 2007 14:48:42 +0100
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sun, Dec 02, 2007 at 05:43:39PM +0900, Tetsuo Handa wrote:
> > > 
> > > mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
> > >...
> > 
> > That's due to the fact that my patch to remove this unused export from 
> > slub was not yet applied...
> > 
> > Where is the modular in-kernel user?
> > 
> 
> binfmt_flat.c, binfmt_elf_fdpic.c.

I could have sworn I had checked that both are bools, but BINFMT_FLAT is 
actually a tristate.

Is anyone actually using binfmt_flat modular (considering it's only 
available for !MMU embedded systems)? If yes, then only exporting 
ksize() will not be enough for getting it working modular...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

