Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYBIKxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYBIKxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYBIKx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:53:27 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34272 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbYBIKx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:53:26 -0500
Date: Sat, 9 Feb 2008 12:53:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: m68knommu compile error
Message-ID: <20080209105344.GH6505@cs181133002.pp.htv.fi>
References: <20080208222516.GC6505@cs181133002.pp.htv.fi> <1202552472.8936.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1202552472.8936.7.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 11:21:12AM +0100, Martin Schwidefsky wrote:
> On Sat, 2008-02-09 at 00:25 +0200, Adrian Bunk wrote:
> > Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 breaks m68knommu:
> 
> Does the patch below fixes the problem?

Thanks, it fixes it.

> I tried to cross compile for
> m68knommu but it seems like you need a special m68k compiler to get it
> compile all the way through.

I'm using one from upstream svn head (= tree that will become gcc 4.3).

> With the patch it did fail with a different
> error, so I assume it is fixed.

That's Matt's "break all no-MMU architectures in swapops.h" regression 
for which a patch is already floating around.

> The problem is that the pgtable_t is
> simply missing for m68knommu, I must have overlooked a reject for one of
> the constant regenerations of the patch to keep up with upstream. Sorry
> about that.
> 
> blue skies,
>   Martin.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

