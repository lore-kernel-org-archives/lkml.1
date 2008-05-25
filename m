Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYEYVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYEYVGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYEYVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:06:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34731 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbYEYVGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:06:08 -0400
Date: Mon, 26 May 2008 00:03:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080525210329.GN1791@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz> <20080525181118.GG1791@cs181133002.pp.htv.fi> <1211742202.14556.25.camel@mtlp.tischlernetz> <20080525201807.GK1791@cs181133002.pp.htv.fi> <1211749036.16921.16.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211749036.16921.16.camel@mtlp.tischlernetz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 10:57:16PM +0200, Mirco Tischler wrote:
> On So, 2008-05-25 at 23:18 +0300, Adrian Bunk wrote:
> > > Gnu C                  4.3.0-4ubuntu1)
> > >...
> > 
> > I'd have said your gcc has a bug regarding __builtin_constant_p(),
> > but I can't reproduce it on i386 with the compiler you are using.
> 
> > You are using exactly this compiler for compiling your kernel?
> I tried several versions now (4.1, 4.3. 4.4pre) and all showed the
> error. I'm using ccache, maybe this has something to do with it? (Though
> I doubt it)

If ccache would always select a completely broken compiler that would 
explain it...

(But it's unlikely.)

Can you try building without ccache?

Can you also try downloading the kernel sources as a tarball from 
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/testing ?

> Btw: you noticed that this is x86_64 and not i386?

I noticed (but I currently only have a 32bit userspace, and for this 
kind of error it shouldn't matter).

> > If yes I'm unfortunately out of ideas...  :-(
> I have another config that builds properly. Actually I just changed some
> options to the config posted before. If nobody shouts "trivial" I could
> try to filter out the guilty option if there is any. But I possibly
> won't find the time before mid of the week.
> 
> Thanks
> Mirco

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

