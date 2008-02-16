Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYBPAKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYBPAKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbYBPAJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:09:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32890 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856AbYBPAJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:09:56 -0500
Date: Sat, 16 Feb 2008 00:09:43 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080216000943.GD31474@flint.arm.linux.org.uk>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus <torvalds@linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212120208.f7168a91.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:02:08PM +1100, Stephen Rothwell wrote:
> I will attempt to build the tree between each merge (and a failed build
> will again cause the offending tree to be dropped).  These builds will be
> necessarily restricted to probably one architecture/config.  I will build
> the entire tree on as many architectures/configs as seem sensible and
> the results of that will be available on a web page (to be announced).

This restriction means that the value for the ARM architecture is soo
limited it's probably not worth the hastle participating in this project.

We already know that -mm picks up on very few ARM conflicts because
Andrew doesn't run through the entire set of configurations; unfortunately
ARM is one of those architectures which is very diverse [*], and because
of that, ideas like "allyconfig" are just completely irrelevant to it.

As mentioned elsewhere, what we need for ARM is to extend the kautobuild
infrastructure (see armlinux.simtec.co.uk) so that we can have more trees
at least compile tested regularly - but that requires the folk there to
have additional compute power (which isn't going to happen unless folk
stamp up some machines _or_ funding).

More trees maintained by more people isn't going to help the situation -
if anything, it's going to make it worse - more trees needing more testing
by the already extremely limited resources we have available.

For reference, even _I_ don't build test the entire set of ARM defconfigs -
at about 7 minutes a build, 75 defconfigs, that's about 9 hours...  I
just build those which are important to myself, hope that the others are
fine, and rely on kautobuild finding any breakage.



* - plus, its very difficult to get maintainers to see why having a
kernel able to support multiple platforms is a good thing.  For example,
I would absolutely love to be able to combine more platforms into one
build (such as Lubbock, Mainstone and probably other PXA stuff), but
there's issues with drivers preventing it.  (For those two I just
mentioned, it's the SMC91x net driver whose build needs to be configured
to the precise machine due to the multitude of different ways to connect
the hardware to the processor.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
