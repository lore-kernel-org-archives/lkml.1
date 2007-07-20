Return-Path: <linux-kernel-owner+w=401wt.eu-S933797AbXGTQxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797AbXGTQxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939310AbXGTQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:48:11 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:46744 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761559AbXGTQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:48:07 -0400
Date: Fri, 20 Jul 2007 11:47:43 -0500
From: Scott Wood <scottwood@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] [updated] PHY fixed driver: rework release path and update phy_id notation
Message-ID: <20070720164743.GA9659@ld0162-tx32.am.freescale.net>
References: <20070718233804.24451.22543.stgit@localhost.localdomain> <20070719232337.184942e0.akpm@linux-foundation.org> <20070720115039.05f50f0f@localhost.localdomain> <20070720005702.b2b644e7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720005702.b2b644e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 12:57:02AM -0700, Andrew Morton wrote:
> On Fri, 20 Jul 2007 11:50:39 +0400 Vitaly Bordug <vitb@kernel.crashing.org> wrote:
> > On Thu, 19 Jul 2007 23:23:37 -0700
> > Andrew Morton wrote:
> > > Shouldn't these be runtime options (ie: module parameters)?
> > > 
> > I thought about it but this thing is more like the one that will never tend/required to change while\
> > configured.. Will add if you see it appropriate though.
> 
> 99% of users don't compile their own kernels: their vendor will have to
> make this decision for them, and it sounds like any decision which they
> make will be wrong for some of their users?

This is mostly of use on embedded hardware where the kernel will be
rebuilt by someone who knows the hardware...  That said, I don't see why
it needs to be configured at all.  Couldn't it use an idr table instead? 

-Scott
