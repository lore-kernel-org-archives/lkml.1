Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZA3InK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZA3InK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZA3Imz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:42:55 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:53236 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZA3Imy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:42:54 -0500
Date: Fri, 30 Jan 2009 01:42:52 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 08/14] OMAP clock: move rate recalc, propagation code
 up to plat-omap/clock.c
In-Reply-To: <20090129174153.GH18233@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0901300135560.26985@utopia.booyaka.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192748.29333.5856.stgit@localhost.localdomain> <20090129174153.GH18233@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell, 

On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:27:51PM -0700, Paul Walmsley wrote:
> > Previously the individual clock recalculation functions handled their
> > own rate recalculation.  This can be handled in the clk_set_rate(),
> > clk_set_parent(), and recalculate_root_clocks() functions in
> > plat-omap/clock.c.  Removes duplicate code and clarifies the role of the
> > recalc functions.
> 
> I must say that this commit looks very much like a combination of
> my commits from November:
> 
> [ARM] omap: move clock propagation into core omap clock code
> [ARM] omap: remove unnecessary calls to propagate_rate()
> [ARM] omap: move propagate_rate() calls into generic omap clock code
> 
> which do basically the same thing a little more efficiently, and an
> additional patch from you to call ->recalc after set_rate or
> reparenting a clock.
> 
> So I think I can drop everything from this apart from the additional
> recalc calls, and the removal of those omap2_dpllcore_recalc() calls.
> 
> Please confirm my suspicions.

I haven't looked closely at your above three patches for this, but plan to 
do so later today.

Regarding provenance, the patches that I sent you were developed 
independently, for clock notifier support.  Ultimately, I have no personal 
attachment as to whose patches for this go in, if all technical aspects 
are equal.


- Paul
