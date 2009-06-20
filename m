Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZFTMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZFTMjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZFTMje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 08:39:34 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40047 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZFTMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 08:39:33 -0400
Date: Sat, 20 Jun 2009 14:41:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Kallsyms problems (was: Re: linux-next: arm build failures)
Message-ID: <20090620124152.GI32531@uranus.ravnborg.org>
References: <20090617162612.703adfd9.sfr@canb.auug.org.au> <tnx3a9ztg14.fsf@pc1117.cambridge.arm.com> <20090617230804.5e353ec9.sfr@canb.auug.org.au> <20090619151321.GA6223@flint.arm.linux.org.uk> <20090620155440.a7dfb2d4.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620155440.a7dfb2d4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 03:54:40PM +1000, Stephen Rothwell wrote:
> Hi Russell,
> 
> On Fri, 19 Jun 2009 16:13:21 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >
> > On Wed, Jun 17, 2009 at 11:08:04PM +1000, Stephen Rothwell wrote:
> > > 
> > > On Wed, 17 Jun 2009 09:34:31 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > >
> > > > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > > Over the past few days, I have started getting some arm configs (at least
> > > > > iop13xx_defconfig and integrator_defconfig, but some others) failing to
> > > > > build getting this error:
> > > > >
> > > > >   SYSMAP  System.map
> > > > >   SYSMAP  .tmp_System.map
> > > > > Inconsistent kallsyms data
> > > > > Try setting CONFIG_KALLSYMS_EXTRA_PASS
> > > > >
> > > > > Is this something you have seen?  Could it be my toolchain (I am
> > > > > currently using gcc 4.4.0 and have not changed it recently)?
> > > > 
> > > > I reported an error with kallsysms on ARM this Monday leading to
> > > > inconsistent data:
> > > > 
> > > > http://lkml.org/lkml/2009/6/15/233
> > > > 
> > > > Could it be related?
> > > 
> > > Could be.  I have added the proposed fix patch to my fixes tree until
> > > Linus or Sam gets around to including it.
> > 
> > No, I don't think it's got anything to do with it.  It's the kallsyms
> > generator that's getting confused.
> > 
> > What's happening is that we're ending up with differences between the
> > symbolic information generated for .tmp_vmlinux2 and vmlinux:
> 
> I do wonder if the above could be the root cause, though.  Since I added
> the added the fix mentioned above to linux-next, my arm builds have not
> failed do to this problem.  Or maybe this "fix" just works around another
> problem?
> 
> In any case, it would be nice if the fix (repeated below) could be sent
> to Linus by someone (it also fixes a problem that Dave Miller is seeing).

Just sent it. Overloaded with day-time stuff (again).

	Sam
