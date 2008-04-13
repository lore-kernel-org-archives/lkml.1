Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYDMTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYDMTwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYDMTpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:45:00 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46892 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbYDMTot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:49 -0400
Date: Sun, 13 Apr 2008 22:43:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Ben Dooks <ben@simtec.co.uk>,
       Vincent Sanders <vince@simtec.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mfd/sm501.c: #if 0 unused functions
Message-ID: <20080413194348.GA13920@cs181133002.pp.htv.fi>
References: <20080413181531.GD2182@cs181133002.pp.htv.fi> <9a8748490804131155g3df93ba7s9c2131a957391ee3@mail.gmail.com> <20080413190326.GB21204@cs181133002.pp.htv.fi> <9a8748490804131208o220cd763k33b74d547911a8f0@mail.gmail.com> <20080413192420.GC21204@cs181133002.pp.htv.fi> <48025FEA.7010202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48025FEA.7010202@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 11:32:58PM +0400, Dmitri Vorobiev wrote:
> Adrian Bunk пишет:
> > On Sun, Apr 13, 2008 at 09:08:31PM +0200, Jesper Juhl wrote:
> >> On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
> >>> On Sun, Apr 13, 2008 at 08:55:21PM +0200, Jesper Juhl wrote:
> >>>  > On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
> >>>  > > This patch #if 0's the following unused functions:
> >>>  > >  - sm501_find_clock()
> >>>  > >  - sm501_gpio_get()
> >>>  > >  - sm501_gpio_set()
> >>>  > >
> >>>  >
> >>>  > Hi Adrian,
> >>>  >
> >>>  > I know we've discussed this before, but I have to comment on this once more.
> >>>  >
> >>>  > Why is it that you seem to prefer adding '#if 0' around blocks of
> >>>  > unused code instead of removing it outright?
> >>>
> >>>> ...
> >>>  When I removed unused code outright some people complained that they
> >>>  plan to use it tomorrow or in the next millenium or whenever.
> >>>
> >>>  When I #if 0 it other people complain that I should remove it outright.
> >>>
> >>>  So whatever I do, there's always someone complaining.  ;-)
> >>>
> >>>  In this case the code looks as if it might get used at some point in the
> >>>  future.
> >>>
> >>>  But if a maintainer tells me to resend a patch with the code removed
> >>>  instead of #if 0'ed I'm always glad to do this.
> >>>
> >> But, you are completely ignoring the case of "the code is unused, but
> >> will probably be used soon, so I'll just leave it alone and avoid the
> >> churn".  Why? What's the point of commenting it out now and then
> >> enabling it again in a month or two - isn't that just pointless churn?
> >> ...
> > 
> > It's unused since more than one year, so chances are it won't get used 
> > in a month or two.
> > 
> > As I said, if a maintainer wants me to remove it outright I'll be glad 
> > to do so.
> > 
> > And as I said, no matter whatever I do, there's always someone 
> > complaining...
> 
> It appears to me that if you had complaint statistics, that would have
> provided a solid ground for choosing the right strategy for dead code.

I tried both ways, and in both situations some people were complaining.

No statistics required for knowing that there will anyway be complaints 
and there's nothing I can do about it.

> Offhand, I have a feeling that the fraction of cases when the code that
> has been abandoned long ago is about to be reused in near future ought
> to be small.

I make a guess how to handle it, and the maintainer then says if he 
wants it differently.

> Thanks,
> Dmitri

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

