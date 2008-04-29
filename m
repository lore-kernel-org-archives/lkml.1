Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbYD2U2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbYD2U2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762370AbYD2U1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:27:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761496AbYD2U1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:27:36 -0400
Date: Tue, 29 Apr 2008 13:26:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, buytenh@wantstofly.org,
       tbm@cyrius.com, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
Message-Id: <20080429132631.e0dc7803.akpm@linux-foundation.org>
In-Reply-To: <20080429200853.GB20889@kos.to>
References: <20080429200853.GB20889@kos.to>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 23:08:53 +0300
Riku Voipio <riku.voipio@iki.fi> wrote:

> Thecus N2100 has leds and a buzzer attached to a pca9532
> controller. Attach the driver to the i2c bus and define
> the pca9532 pin coniguration for this platform in n2100_leds.
> 
> With this patch, support for N2100 should be complete in mainline
> Linux.
> 
> Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
> ---
>  arch/arm/mach-iop32x/n2100.c |   52 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)

So I guess this is really a patch for the git-leds tree, even though
it affects only arch/arm/...

