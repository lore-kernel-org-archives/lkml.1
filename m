Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbYFFHqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbYFFHqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbYFFHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:45:59 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:46489 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbYFFHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:45:58 -0400
Date: Fri, 6 Jun 2008 09:45:56 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com
Subject: Re: [PATCH 9/9] au1xmmc: Add back PB1200/DB1200 MMC activity LED
	support
Message-ID: <20080606074556.GE16498@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net> <20080519080837.GJ21985@roarinelk.homelinux.net> <20080605230803.75c16798@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605230803.75c16798@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

On Thu, Jun 05, 2008 at 11:08:03PM +0200, Pierre Ossman wrote:
> On Mon, 19 May 2008 10:08:37 +0200
> Manuel Lauss <mano@roarinelk.homelinux.net> wrote:
> 
> > From 5747bd6933bb212ab83044fa79adf185d248513f Mon Sep 17 00:00:00 2001
> > From: Manuel Lauss <mlau@msc-ge.com>
> > Date: Sun, 18 May 2008 16:05:56 +0200
> > Subject: [PATCH] au1xmmc: Add back PB1200/DB1200 MMC activity LED support.
> > 
> > Add back PB1200/DB1200 MMC activity LED support just the way
> > it was done in the original driver source.
> > 
> > Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> 
> You might want to consider using the LED subsystem now that the MMC
> core exports a trigger. Look at my next tree for how sdhci uses it.

I tried that originally. The LED subsystem seems quite complex for something
as simple as turning on a bit in a register. I don't have a DB1200 to test
so I went the safe route and added a simple callback to toggle the LED bit in
the DB1200 FPGA.

I'll try to come up with something over the weekend and then resend the
whole series.

Thanks!
	Manuel Lauss


