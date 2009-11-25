Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbZKYRYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbZKYRYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759251AbZKYRYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:24:07 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47204 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130AbZKYRYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:24:04 -0500
Date: Wed, 25 Nov 2009 18:24:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Steppeing down as Maintainer
Message-ID: <20091125172406.GA14085@merkur.ravnborg.org>
References: <20091120182249.GA28251@merkur.ravnborg.org> <20091120182613.GA28307@merkur.ravnborg.org> <20091125172122.46beaf17.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125172122.46beaf17.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 05:21:22PM +1100, Stephen Rothwell wrote:
> Hi Sam,
> 
> On Fri, 20 Nov 2009 19:26:13 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > It has been fun but the last year or more it has
> > been a duty and a burden. So I leave it open for
> > other to take over.
> 
> I, also, want to thank you very much for all your work.
> 
> I am, however, wondering what will happen to the changes you have that are
> currently in linux-next:
> 
> Apparently for v2.6.32 (in kbuild-current):
> 
> Michael Tokarev (1):
>       kbuild: fix bzImage build for x86
> 
> And queued for v2.6.33:
> 
> Sam Ravnborg (14):
>       kbuild: search arch/$ARCH/include before include/
>       dontdiff: add generated
>       kbuild: move bounds.h to include/generated
>       kbuild: move asm-offsets.h to include/generated
>       ia64: move nr-irqs.h to include/generated
>       arm: move mach-types to include/generated
>       sh: move machtypes.h to include/generated
>       kbuild: drop include2/ used for O=... builds
>       kbuild: do not check for include/asm-$ARCH
>       kbuild: drop include/asm
>       kbuild: move compile.h to include/generated
>       drop explicit include of autoconf.h
>       kbuild: move autoconf.h to include/generated
>       kbuild: move utsrelease.h to include/generated
> 
> I am (for the moment) still merging these from the copy I have of your
> trees, but what to do in the longer term?

I will submit the patches like any other regular submitter to linux-kbuild
if the upcoming Maintainers does not pick them up from the git trees.

So for now keeping the pull would be nice but as soon as you have
a ew set of kbuild tress then drop these.

Frankly I had forgot that I had a patch in -fixes...

	Sam
