Return-Path: <linux-kernel-owner+w=401wt.eu-S934353AbYEBL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbYEBL7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbYEBL7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:59:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39296 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243AbYEBL7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:59:15 -0400
Date: Fri, 2 May 2008 14:58:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080502115823.GA5838@cs181133002.pp.htv.fi>
References: <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com> <20080502082936.GB2003@cs181133002.pp.htv.fi> <18458.59921.485453.670242@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18458.59921.485453.670242@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 08:16:49PM +1000, Paul Mackerras wrote:
> Adrian Bunk writes:
> 
> > > That's right.  The bug has been there basically forever (i.e. since
> > > before 2.6.12-rc2 ;) and no-one has been able to trigger it reliably
> > > before.
> > 
> > But for users this is a recent regression since 2.6.24 worked
> > and 2.6.25 does not.
> 
> I never actually saw a statement to that effect (i.e. that 2.6.24
> worked) from Kamalesh.  I think people assumed that because he
> reported it against version X that version X-1 worked, but we don't
> actually know that.

He reported it as

[BUG] 2.6.25-rc2-git4 - Regression Kernel oops while running kernbench and tbench on powerpc

and it was in the 2.6.25 regression lists for ages.

> > If this problem was on x86 Linus himself and some other core developers 
> > would most likely have debugged this issue and Linus would have delayed 
> > the release of 2.6.25 for getting it fixed there.
> 
> If I had been able to replicate it, or if it had been seen on more
> than one machine, I would probably have asked Linus to wait while we
> fixed it.  
> 
> There's a risk management thing happening here.  Delaying a release is
> a negative thing in itself, since it means that users have to wait
> longer for the improvements we have made.  That has to be balanced
> against the negative of some users seeing a regression.  It's not an
> absolute, black-and-white kind of thing.  In this case, for a bug
> being seen on only one machine, of a somewhat unusual configuration, I
> considered it wasn't worth asking to delay the release.

No general disagreement on this.

And my example was not in any way meant against you - it's actually 
unusual and positive that a bug that once got the attention of being
on the regression lists gets fixed later.

Even worse is the situation with regressions people run into when 
upgrading from 2.6.22 to 2.6.24 today...  :-(

> Paul.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

