Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbYDVS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbYDVS3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYDVS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:29:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41187 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYDVS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:29:06 -0400
Date: Tue, 22 Apr 2008 21:28:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: #define out unused parameters
	of?xfs_bmap_add_free and xfs_btree_read_bufl
Message-ID: <20080422182830.GD28933@cs181133002.pp.htv.fi>
References: <20080419142329.GA5339@elte.hu> <20080422172156.GB28933@cs181133002.pp.htv.fi> <480E1FAE.20509@sandeen.net> <200804221950.54827.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804221950.54827.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 07:50:54PM +0200, Denys Vlasenko wrote:
> On Tuesday 22 April 2008 19:26, Eric Sandeen wrote:
> > >> I want to eventually reach the state with no warnings
> > >> about unused parameters.
> > > 
> > > The standard kernel pattern in using empty static inline functions (that 
> > > allow type checking).
> > > 
> > > And I'm not sure whether the number of functions you'd have to change 
> > > for reaching your goal has four, five or six digits.
> > 
> > It would be a huge undertaking.
> > 
> > Just building xfs w/ the warning in place exposes tons of unused
> > parameter warnings from outside xfs as well.
> 
> Eh... I meant "no warnings about unused parameters" for fs/xfs/* only,
> not for the entire kernel. I filter out other warnings.
> 
> I want to do it not as an excercise in perfectionism,
> but as means of making sure we do not waste stack
> passing useless parameters, which is important for xfs.

That's not really maintainable, and the stack gains are too small for 
bringing us significantely nearer to a solution.

> vda

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

