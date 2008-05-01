Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbYEANWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbYEANWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYEANWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:22:47 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34739 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYEANWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:22:47 -0400
Date: Thu, 1 May 2008 16:21:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080501132159.GC29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080430072013.7c3b30b1@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 07:20:13AM -0700, Arjan van de Ven wrote:
> On Thu, 1 May 2008 14:30:38 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Wed, Apr 30, 2008 at 12:03:38AM -0700, Arjan van de Ven wrote:
> > > On Thu, 1 May 2008 03:31:25 +0300
> > > Adrian Bunk <bunk@kernel.org> wrote:
> > > 
> > > > On Wed, Apr 30, 2008 at 01:31:08PM -0700, Linus Torvalds wrote:
> > > > > 
> > > > > 
> > > > > On Wed, 30 Apr 2008, Andrew Morton wrote:
> > > > > > 
> > > > > > <jumps up and down>
> > > > > > 
> > > > > > There should be nothing in 2.6.x-rc1 which wasn't in
> > > > > > 2.6.x-mm1!
> > > > > 
> > > > > The problem I see with both -mm and linux-next is that they
> > > > > tend to be better at finding the "physical conflict" kind of
> > > > > issues (ie the merge itself fails) than the "code looks ok but
> > > > > doesn't actually work" kind of issue.
> > > > > 
> > > > > Why?
> > > > > 
> > > > > The tester base is simply too small.
> > > > > 
> > > > > Now, if *that* could be improved, that would be wonderful, but
> > > > > I'm not seeing it as very likely.
> > > > > 
> > > > > I think we have fairly good penetration these days with the
> > > > > regular -git tree, but I think that one is quite frankly a
> > > > > *lot* less scary than -mm or -next are, and there it has been
> > > > > an absolutely huge boon to get the kernel into the Fedora
> > > > > test-builds etc (and I _think_ Ubuntu and SuSE also started
> > > > > something like that).
> > > > > 
> > > > > So I'm very pessimistic about getting a lot of test coverage
> > > > > before -rc1.
> > > > > 
> > > > > Maybe too pessimistic, who knows?
> > > > 
> > > > First of all:
> > > > I 100% agree with Andrew that our biggest problems are in
> > > > reviewing code and resolving bugs, not in finding bugs (we
> > > > already have far too many unresolved bugs).
> > > 
> > > I would argue instead that we don't know which bugs to fix first.
> > > We're never going to fix all bugs, and to be honest, that's ok.
> > >...
> > 
> > That might be OK.
> > 
> > But our current status quo is not OK:
> > 
> > Check Rafael's regressions lists asking yourself
> > "How many regressions are older than two weeks?" 
> 
> "ext4 doesn't compile on m68k".
> YAWN.
>  
> Wrong question...
> "How many bugs that a sizable portion of users will hit in reality are there?"
> is the right question to ask...
>...

"Kernel oops while running kernbench and tbench on powerpc" took more 
than 2 months to get resolved, and we ship 2.6.25 with this regression.

Granted that compared to x86 there's not a sizable portion of users 
crazy enough to run Linux on powerpc machines...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

