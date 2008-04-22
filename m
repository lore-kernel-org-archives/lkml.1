Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbYDVXyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbYDVXyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761293AbYDVXyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:54:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59227 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637AbYDVXyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:54:06 -0400
Date: Wed, 23 Apr 2008 02:53:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: #define out unused parameters
	of?xfs_bmap_add_free and xfs_btree_read_bufl
Message-ID: <20080422235327.GF28933@cs181133002.pp.htv.fi>
References: <20080419142329.GA5339@elte.hu> <200804221950.54827.vda.linux@googlemail.com> <20080422182830.GD28933@cs181133002.pp.htv.fi> <200804222132.38169.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804222132.38169.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 09:32:38PM +0200, Denys Vlasenko wrote:
> On Tuesday 22 April 2008 20:28, Adrian Bunk wrote:
> > > Eh... I meant "no warnings about unused parameters" for fs/xfs/* only,
> > > not for the entire kernel. I filter out other warnings.
> > > 
> > > I want to do it not as an excercise in perfectionism,
> > > but as means of making sure we do not waste stack
> > > passing useless parameters, which is important for xfs.
> > 
> > That's not really maintainable,
> 
> Why? Adding -Wunused -Wunused-parameter in fs/xfs/Makefile:
> 
> EXTRA_CFLAGS += -I$(src) -I$(src)/linux-2.6 -funsigned-char
> #EXTRA_CFLAGS += -Wunused -Wunused-parameter
> 
> and making a test build with it uncommented once in a while
> will reveal a bit of fallout, which is then fixed.
>...

The problem isn't in the Makefile, the problem are the ugly #ifdef's in 
the code.

And for getting the stack problems fixed the effect is anyway by two 
orders of magnitude too small, so there's no real gain in exchange.

> vda

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

