Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYGPE17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYGPE17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYGPE1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:27:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbYGPE1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:27:50 -0400
Date: Wed, 16 Jul 2008 00:20:42 -0400
From: Dave Jones <davej@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull from powerpc.git merge branch
Message-ID: <20080716042042.GA13212@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linuxppc-dev list <linuxppc-dev@ozlabs.org>,
	akpm <akpm@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1216172043.7740.136.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216172043.7740.136.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:34:03AM +1000, Ben Herrenschmidt wrote:
 > Linus,
 > 
 > I apologize in advance for the couple of merge commits in there. I
 > merged your tree yesterday in order to fix a (fairly minor) conflict,
 > and waited for our autobuilder to test a whole bunch of configs
 > overnight before asking you to pull, at which point, sfr informed me of
 > a bunch of this time non-trivial conflicts with whatever you pulled in
 > the meantime...
 > 
 > So here it is with 2 merge csets at the top, I'll try to do better next
 > time. I don't want to rebase or my sub-maintainers will hate me.
 > 
 > So please pull from:
 > 
 > git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Boom!

arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
/builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
/builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'

.config is at http://davej.fedorapeople.org/kernel-2.6.27-ppc.config

	Dave

-- 
http://www.codemonkey.org.uk
