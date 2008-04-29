Return-Path: <linux-kernel-owner+w=401wt.eu-S1762376AbYD2Uzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376AbYD2Uzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYD2Uza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:55:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46905 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYD2Uz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:55:29 -0400
Date: Tue, 29 Apr 2008 21:55:02 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Riku Voipio <riku.voipio@iki.fi>, linux-kernel@vger.kernel.org,
       buytenh@wantstofly.org, tbm@cyrius.com
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
Message-ID: <20080429205502.GB31311@flint.arm.linux.org.uk>
References: <20080429200853.GB20889@kos.to> <20080429132631.e0dc7803.akpm@linux-foundation.org> <1209501931.5642.47.camel@dax.rpnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209501931.5642.47.camel@dax.rpnet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 09:45:31PM +0100, Richard Purdie wrote:
> On Tue, 2008-04-29 at 13:26 -0700, Andrew Morton wrote:
> > On Tue, 29 Apr 2008 23:08:53 +0300
> > Riku Voipio <riku.voipio@iki.fi> wrote:
> > 
> > > Thecus N2100 has leds and a buzzer attached to a pca9532
> > > controller. Attach the driver to the i2c bus and define
> > > the pca9532 pin coniguration for this platform in n2100_leds.
> > > 
> > > With this patch, support for N2100 should be complete in mainline
> > > Linux.
> > > 
> > > Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
> > > ---
> > >  arch/arm/mach-iop32x/n2100.c |   52 ++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 52 insertions(+), 0 deletions(-)
> > 
> > So I guess this is really a patch for the git-leds tree, even though
> > it affects only arch/arm/...
> 
> Acked-by: Richard Purdie <rpurdie@rpsys.net>
> 
> I'll await guidance from Russell about where he wants it to go, I'm fine
> with git-leds but if he wants to take it through the arm tree I'm ok
> with that too in which case the ACK above applies.

Oh, yet more surprise code apparantly submitted and as yet unreviewd
during the merge window! ;(

Looks sane enough.

I don't see it really matters.  Note that I'll be sending my final pull
for this merge window in about one hours time, and I've just pushed the
tree, patches and mboxes out.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
