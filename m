Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYGPFbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYGPFbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYGPFbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:31:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:44656 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbYGPFbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:31:44 -0400
Subject: Re: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <20080716042042.GA13212@redhat.com>
References: <1216172043.7740.136.camel@pasglop>
	 <20080716042042.GA13212@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 15:01:35 +1000
Message-Id: <1216184495.7740.158.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 00:20 -0400, Dave Jones wrote:
> On Wed, Jul 16, 2008 at 11:34:03AM +1000, Ben Herrenschmidt wrote:
>  > Linus,
>  > 
>  > I apologize in advance for the couple of merge commits in there. I
>  > merged your tree yesterday in order to fix a (fairly minor) conflict,
>  > and waited for our autobuilder to test a whole bunch of configs
>  > overnight before asking you to pull, at which point, sfr informed me of
>  > a bunch of this time non-trivial conflicts with whatever you pulled in
>  > the meantime...
>  > 
>  > So here it is with 2 merge csets at the top, I'll try to do better next
>  > time. I don't want to rebase or my sub-maintainers will hate me.
>  > 
>  > So please pull from:
>  > 
>  > git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
> 
> Boom!
> 
> arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'
> 
> .config is at http://davej.fedorapeople.org/kernel-2.6.27-ppc.config

Kumar, I think that's your realm, what's up there ?

Cheers,
Ben.


