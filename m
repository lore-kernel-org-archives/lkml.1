Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZC2Hrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZC2Hrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZC2Hrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 03:47:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:46355 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbZC2Hrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 03:47:40 -0400
Date: Sun, 29 Mar 2009 15:47:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Patrick McHardy <kaber@trash.net>, Jan Engelhardt <jengelh@gmx.de>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 34/58] move omap_rng's probe function to .devinit.text
Message-ID: <20090329074731.GD11735@gondor.apana.org.au>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-34-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238196439-16535-34-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 12:26:55AM +0100, Uwe Kleine-König wrote:
> A pointer to omap_rng_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Jan Engelhardt <jengelh@gmx.de>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
