Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXKCWyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXKCWyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 18:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbXKCWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 18:54:46 -0400
Received: from waste.org ([66.93.16.53]:58472 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbXKCWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 18:54:45 -0400
Date: Sat, 3 Nov 2007 17:54:34 -0500
From: Matt Mackall <mpm@selenic.com>
To: Bo Brant?n <bosse@acc.umu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
Message-ID: <20071103225434.GT19691@waste.org>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 11:38:24PM +0100, Bo Brant?n wrote:
> On Sat, 3 Nov 2007, Matt Mackall wrote:
> 
> >This is typically due to a problem with the setup of your MTRRs. Try
> >booting with mem=nnnM where nnn is some number smaller than your
> >actual amount of memory.
> 
> Thank you for that advice, the system has 4GB and if I boot with mem=3072M 
> it will run as fast as normal while if I don't use the mem option it will 
> run 10 times slower, however if I use a figure like mem=3500M the kernel 
> will panic, is there any way to determine the highest usable figure 
> without try and error?

This is not really my area, but I suspect if you send us your dmesg
output, someone here will be able to tell you how to optimize things.
How much memory does the system report at normal boot? It's not
uncommon for BIOSes to do the wrong thing with memory approaching 4G,
even on supposedly 64-bit boxes.

Also, please send us your panic message (take a digital photo if you
need to), as that shouldn't happen either.

-- 
Mathematics is the supreme nostalgia of our time.
