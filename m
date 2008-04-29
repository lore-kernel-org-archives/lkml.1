Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbYD2Uqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbYD2Uqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbYD2Up4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:45:56 -0400
Received: from tim.rpsys.net ([194.106.48.114]:37521 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761631AbYD2Upz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:45:55 -0400
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Riku Voipio <riku.voipio@iki.fi>, linux-kernel@vger.kernel.org,
       buytenh@wantstofly.org, tbm@cyrius.com,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20080429132631.e0dc7803.akpm@linux-foundation.org>
References: <20080429200853.GB20889@kos.to>
	 <20080429132631.e0dc7803.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 21:45:31 +0100
Message-Id: <1209501931.5642.47.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 13:26 -0700, Andrew Morton wrote:
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

Acked-by: Richard Purdie <rpurdie@rpsys.net>

I'll await guidance from Russell about where he wants it to go, I'm fine
with git-leds but if he wants to take it through the arm tree I'm ok
with that too in which case the ACK above applies.

Cheers,

Richard


