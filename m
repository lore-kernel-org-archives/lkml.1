Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYFJEdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYFJEdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYFJEdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:33:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57876 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYFJEdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:33:07 -0400
Date: Tue, 10 Jun 2008 06:33:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: kbuild-current build failure
Message-ID: <20080610043348.GB31765@uranus.ravnborg.org>
References: <20080610110842.30c90c61.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610110842.30c90c61.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:08:42AM +1000, Stephen Rothwell wrote:
> Hi Sam,
> 
> Today's linux-next build (powerpc ppc64_deconfig) failed like this:
> 
>   LD      vmlinux.o
> /scratch/sfr/next/scripts/Makefile.modpost:44: scripts/Kbuild.include: No such file or directory
> /scratch/sfr/next/scripts/Makefile.modpost:58: scripts/Makefile.lib: No such file or directory
> make[2]: *** No rule to make target `scripts/Makefile.lib'.  Stop.
> make[1]: *** [vmlinux] Error 2
> make: *** [sub-make] Error 2

Ups - I have not doen O=.. builds...

> 
> This is Linus' tree with just the net-current, arm-current and
> kbuild-current trees merged i.e. just bug fixes queued for Linus' current
> tree.  The build was done with "O=../powerpc_ppc64_defconfig -j24 -s"
> i.e. separate object tree and parallel.
> 
> Reverting commit 68e9b79c8dad5245f28ab4f3527481b730dbdb61 ("kbuild:
> simplify vmlinux link stage") makes the build work again.

This commit is in kbuild-next.git (for the merge window)
My kbuild-fixes.git is empty at the moment.

I will fix tonight.

	Sam
