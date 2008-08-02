Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYHBXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYHBXqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYHBXqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:46:44 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36760 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYHBXqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:46:44 -0400
Date: Sun, 3 Aug 2008 02:45:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: viro@zeniv.linux.org.uk, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/mtdsuper.c: fix build error
Message-ID: <20080802234535.GA8929@cs181140183.pp.htv.fi>
References: <20080802225304.GD4856@orion> <20080802233240.GA4385@cs181140183.pp.htv.fi> <a4423d670808021640he3ec660k1b5ddfcb6efd1ae5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a4423d670808021640he3ec660k1b5ddfcb6efd1ae5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 03:40:12AM +0400, Alexander Beregalov wrote:
> 2008/8/3 Adrian Bunk <bunk@kernel.org>:
> > On Sun, Aug 03, 2008 at 02:53:04AM +0400, Alexander Beregalov wrote:
> >> From: Alexander Beregalov <a.beregalov@gmail.com>
> >>
> >> drivers/mtd/mtdsuper.c: fix build error
> >>
> >> drivers/mtd/mtdsuper.c:184: error: implicit declaration of
> >>       function 'lookup_bdev'
> >> drivers/mtd/mtdsuper.c:197: error: implicit declaration of
> >>       function 'bdput'
> >
> >
> > It already gets fs.h indirectly through linux/mtd/super.h, so while
> > your patch might be correct it cannot fix a compile error.
> >
> > If that's with CONFIG_BLOCK=n then it's
> >  http://bugzilla.kernel.org/show_bug.cgi?id=11225
> >
> > Otherwise please send your .config .
> 
> I do not have this config, I collect log from builds with randconfig
> and try to fix problems.
>...

You must store the config of the failed builds somewhere, since 
otherwise (like in this case) you cannot verify whether a patch
actually fixes a problem.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

