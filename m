Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYD2UrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYD2UrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbYD2Uqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:46:52 -0400
Received: from naru.obs2.net ([84.20.150.76]:45487 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYD2Uqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:46:51 -0400
Date: Tue, 29 Apr 2008 23:46:49 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, buytenh@wantstofly.org,
       tbm@cyrius.com, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
Message-ID: <20080429204649.GA23817@kos.to>
References: <20080429200853.GB20889@kos.to> <20080429132631.e0dc7803.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429132631.e0dc7803.akpm@linux-foundation.org>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:26:31PM -0700, Andrew Morton wrote:
> On Tue, 29 Apr 2008 23:08:53 +0300
> Riku Voipio <riku.voipio@iki.fi> wrote:
> 
> > Thecus N2100 has leds and a buzzer attached to a pca9532
> > controller. Attach the driver to the i2c bus and define
> > the pca9532 pin coniguration for this platform in n2100_leds.
> > 
> > With this patch, support for N2100 should be complete in mainline
> > Linux.
> > 
> > Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
> > ---
> >  arch/arm/mach-iop32x/n2100.c |   52 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 52 insertions(+), 0 deletions(-)
> 
> So I guess this is really a patch for the git-leds tree, even though
> it affects only arch/arm/...

Since it depends on pca9532-led-driver being added first, I believe
it would logistically simpler to get both patches through leds tree.

-- 
"rm -rf" only sounds scary if you don't have backups
