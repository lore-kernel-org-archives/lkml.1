Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbZKZThs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbZKZThs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZKZThr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:37:47 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:59159 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZKZThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:37:47 -0500
Date: Thu, 26 Nov 2009 20:37:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       An?bal Monsalve Salazar <anibal@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-kbuild.git
Message-ID: <20091126193750.GA15453@merkur.ravnborg.org>
References: <4B0E73E1.50900@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E73E1.50900@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 01:26:09PM +0100, Michal Marek wrote:
> Hi Stephen,
> 
> I went through the patches posted to linux-kbuild and picked those that
> were easy enough to review, looked safe and worked for me. I also took
> Sam's series from kbuild-next.git, but I didn't really review it yet, so
> there is no signoff from me (TBD). The repo is at
> 
>   git://repo.or.cz/linux-kbuild.git for-next
> 
> Please ignore the other branches. The shortlog is
> 
> Jie Zhang (1):
>       net: add net_tstamp.h to headers_install
> 
> Jonathan Nieder (2):
>       scripts/package: add KBUILD_PKG_ROOTCMD variable
>       scripts/package: deb-pkg: use fakeroot if available
> 
> Michael Tokarev (1):
>       kbuild: fix bzImage build for x86
> 
> Michal Marek (2):
>       scripts/package: tar-pkg: use tar --owner=root
>       kbuild: create include/generated in silentoldconfig
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
> Wenji Huang (2):
>       Kbuild: clear marker out of modpost
>       Kbuild: clean up marker
> 
> There are some more patches on the mailing list and in -mm, which I'm
> going to look at, but I think this should be a good start. What do you
> think? Could this be added to linux-next?

Looks good.
Good to see you picked up some of the patches that were pending.

Stephen - please replace my kbuild trees with this.

	Sam
