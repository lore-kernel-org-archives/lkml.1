Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbXF3RUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbXF3RUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXF3RU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 13:20:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45357 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbXF3RU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 13:20:27 -0400
Date: Sat, 30 Jun 2007 19:20:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Aloni <da-x@monatomic.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630172052.GK6087@stusta.de>
References: <20070630023451.GA21593@localdomain> <4685C549.3020602@intel.com> <20070630025425.59cbc299.akpm@linux-foundation.org> <20070630104752.GA26138@localdomain> <20070630093205.c6ab33af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070630093205.c6ab33af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 09:32:05AM -0700, Andrew Morton wrote:
> On Sat, 30 Jun 2007 13:47:52 +0300 Dan Aloni <da-x@monatomic.org> wrote:
> 
> > On Sat, Jun 30, 2007 at 02:54:25AM -0700, Andrew Morton wrote:
> > > On Fri, 29 Jun 2007 19:51:53 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> > > 
> > > > > Some extensions to the popular E-Mail clients might be needed 
> > > > > here. Also, a bot reading LKML would automatically send links 
> > > > > about posted patches to the other mailing lists whenever 
> > > > > someone forgets to add a CC.
> > > > > 
> > > > > Any comments?
> > > > 
> > > > an easier way to implement this is to add an extra field in the MAINTAINERS 
> > > > file, something like below. All the contact info would stay the same, closely 
> > > > where applicable and it would allow you to also specify specific files as well.
> > > 
> > > We already have that information in git.  Parse the git changelogs of the
> > > affected files, find out who works on them.
> > 
> > I think it's quite complex to make a reliable inference of maintainership 
> > information from git.
> 
> Clever people will work it out.

I don't see how git could tell you to Cc net patches to 
netdev@vger.kernel.org.

> > Given a set of historical modifiers of a file, 
> > would you take the most common commiter(s), or the most common 
> > _recent_ commiter(s), or what? It's a bit fuzzy.
> 
> All the above?  Multiply frequency by recency, pick the top five?
> 
> Doesn't matter much: the cost of picking too many is high.
> 
> I shudder at the thought of manually maintaining anything like this.

Auke suggestion of an additional field in MAINTAINERS makes sense - and 
it leaves it to the maintainers to maintain it similar to the other 
information there.

Independent of whatever software Dan wants to write it would also solve 
problems like the one that MAINTAINERS currently isn't really good in 
telling e.g. who is maintaining drivers/net/wireless/.

> > Moreover, it is slow in comparison and assumes the availability of 
> > local .git db, which wouldn't be the case for some porition of patch 
> > submitters.
> 
> a) precalculate the tables once per week
> 
> b) the whole thing wouldn't succeed if it requires software at
>    patch-submitter's site.  It'd need to run at vger.

It might depend on what use cases you think of and whom you expect to 
use it.

For me, a tool that simply tells me whom to Cc for a patch would be a 
great tool.

What you suggest would be something completely different.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

