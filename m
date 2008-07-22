Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYGVUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYGVUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYGVUTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:19:43 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40273 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYGVUTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:19:42 -0400
Date: Tue, 22 Jul 2008 23:19:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: bjorn.helgaas@hp.com, linux-next@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build error (PNP/IXJ)
Message-ID: <20080722201930.GB14846@cs181140183.pp.htv.fi>
References: <20080722102739.61462b04.randy.dunlap@oracle.com> <20080722173957.GA14846@cs181140183.pp.htv.fi> <20080722124152.facaa724.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080722124152.facaa724.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 12:41:52PM -0700, Randy Dunlap wrote:
> On Tue, 22 Jul 2008 20:39:57 +0300 Adrian Bunk wrote:
> 
> > On Tue, Jul 22, 2008 at 10:27:39AM -0700, Randy Dunlap wrote:
> > > Hi,
> > > 
> > > I'm seeing several build errors in linux-next-20080722 that I haven't
> > > seen previously, although I don't know what changed to cause this.
> > > 
> > > They are all basically the same, in ixj (drivers/telephony/ixj*), when
> > > CONFIG_PNP=n, and CONFIG_PHONE_IXJ=y or =m (so the actual error message
> > > varies depending on IXJ=y or =m):
> > > 
> > > IXJ=y:
> > > ixj.c:(.text+0x329d98): undefined reference to `pnp_get_resource'
> > > or IXJ=m:
> > > ERROR: "pnp_get_resource" [drivers/telephony/ixj.ko] undefined!
> > > 
> > > 
> > > Suggestions?
> > 
> > Please send a .config
> 
> attached.  (IXJ=m)

Works for me with gcc 4.3.1.
Which gcc version are you using?

Does disabling CONFIG_OPTIMIZE_INLINING fix it for you?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

