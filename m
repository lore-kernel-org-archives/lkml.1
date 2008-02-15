Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYBOXtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYBOXtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYBOXtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:49:32 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42421 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYBOXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:49:30 -0500
Date: Fri, 15 Feb 2008 15:47:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-Id: <20080215154724.132ad4f3.randy.dunlap@oracle.com>
In-Reply-To: <20080215153732.a93caec7.akpm@linux-foundation.org>
References: <20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<20080212174824.GA1919@kroah.com>
	<alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org>
	<20080212191552.GA20883@kroah.com>
	<alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org>
	<20080212204813.GA21650@kroah.com>
	<20080215232308.GC31474@flint.arm.linux.org.uk>
	<20080215153732.a93caec7.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 15:37:32 -0800 Andrew Morton wrote:

> On Fri, 15 Feb 2008 23:23:08 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Tue, Feb 12, 2008 at 12:48:13PM -0800, Greg KH wrote:
> > > I have tried, and successfully done this many times in the past.  The
> > > kobject change was one example: add a new function, migrate all users of
> > > a direct pointer over to that function, after that work is all done and
> > > in, change the structure and do the needed work afterward.  All is
> > > bisectable completly, with no big "flag day" needed.
> > 
> > Incorrect - because this all happened far too quickly.  This is one of
> > the reasons that I ended up having to redo various parts of the ARM tree
> > because stuff broke - set_kset_name() completely vanished introducing
> > compile errors, and iirc some merge issues as well.
> > 
> > I had patches introducing new system objects which use that, and
> > modifications extremely close to other uses in the PXA code.
> > 
> > The end result (through rebuilding the affected parts of my git tree, and
> > asking people for replacement patches) was something that is bisectable -
> > but had I tried to merge stuff as is, it would've been an utter mess, and
> > _was_ unbuildable.
> > 
> 
> I wonder why I didn't see any of this - I build arm allmodconfig at least
> once a week, usually more frequently.
> 
> So either the offending patches weren't in my pile or arm allmodconfig is
> worse than I thought :(
> 
> It really is in arch maintainers' best interest to keep their allmodconfig
> in good shape, for this reason.  arm's _isn't_ in good shape: the compile
> fails for several long-standing reasons (eg: no hope of building DRM) and I
> don't think the coverage is very broad either.

I think that Russell has said that allmodconfig isn't very realistic
for ARM, with its 70+ config files.  Nevertheless, having a usable
allmodconfig would be very helpful.

---
~Randy
