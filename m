Return-Path: <linux-kernel-owner+w=401wt.eu-S933688AbXEOJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbXEOJtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXEOJtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:49:42 -0400
Received: from koto.vergenet.net ([210.128.90.7]:57988 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXEOJtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:49:41 -0400
Date: Tue, 15 May 2007 18:49:37 +0900
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org,
       Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ARM] Fix hard_smp_processor_id compile error
Message-ID: <20070515094936.GC22359@verge.net.au>
References: <20070515022014.CC2A44F910@tabatha.lab.ultramonkey.org> <20070515081907.GA17611@flint.arm.linux.org.uk> <20070515090917.GA22359@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515090917.GA22359@verge.net.au>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 06:09:18PM +0900, Simon Horman wrote:
> On Tue, May 15, 2007 at 09:19:07AM +0100, Russell King wrote:
> > On Tue, May 15, 2007 at 11:18:50AM +0900, Simon Horman wrote:
> > > "Remove hardcoding of hard_smp_processor_id on UP systems",
> > > 2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
> > > the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
> > > for UP systems. This causes a regression on ARM as the definition
> > > was not added to asm-arm/smp.h.
> > > 
> > > Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > I took an alternative approach - since Integrator never had the complete
> > SMP support merged, I ripped it out of that platform.  Whether realview
> > suffers from the same thing or not I'm not sure - uniprocessor realview
> > is not something covered by the ARM default configuration files, and
> > therefore kautobuild won't check that configuration.
> 
> I can take a look into this. Is there a tree other than Linus'
> I should be working with?

Looking at Linus' it seems that for realview UP builds based on
realview_defconfig don't suffer hard_smp_processor_id breakage.
