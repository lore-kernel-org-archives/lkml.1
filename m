Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbZFTBVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbZFTBVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760693AbZFTBVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:21:05 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37876 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759978AbZFTBVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:21:03 -0400
Date: Fri, 19 Jun 2009 19:21:05 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
 post-2.6.30
In-Reply-To: <20090619162342.GP24573@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0906191920180.4087@utopia.booyaka.com>
References: <20090526220517.25381.75976.stgit@localhost.localdomain> <alpine.DEB.2.00.0906090110580.32281@utopia.booyaka.com> <20090618054845.GC8482@atomide.com> <20090619162342.GP24573@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

On Fri, 19 Jun 2009, Russell King - ARM Linux wrote:

> On Thu, Jun 18, 2009 at 08:48:47AM +0300, Tony Lindgren wrote:
> > Paul, can you please post a git pull request for Russell on these?
> > I think these should still go in if possible.
> > 
> > Russell, if you think it's too late, I'll pile them up into omap
> > for-next branch.
> 
> Let's merge them.

The following changes since commit cd07ecc828486e5887113c7dc4d9f9022145811b:
  Tony Lindgren (1):
        Merge branch 'omap4' into for-next

are available in the git repository at:

  git://git.pwsan.com/linux-2.6 omap-clock-for-next

Paul Walmsley (7):
      OMAP3 clock: remove wait for DPLL3 M2 clock to stabilize
      OMAP3 clock: initialize SDRC timings at kernel start
      OMAP3 clock: add a short delay when lowering CORE clk rate
      OMAP3 clock/SDRC: program SDRC_MR register during SDRC clock change
      OMAP3 SRAM: add more comments on the SRAM code
      OMAP3 SRAM: convert SRAM code to use macros rather than magic numbers
      OMAP3 SDRC: set FIXEDDELAY when disabling SDRC DLL

Roel Kluin (1):
      OMAP2 clock/powerdomain: off by 1 error in loop timeout comparisons

Tero Kristo (1):
      OMAP3: Add support for DPLL3 divisor values higher than 2

 arch/arm/mach-omap2/clock.c            |    2 +-
 arch/arm/mach-omap2/clock34xx.c        |   42 ++++++++---
 arch/arm/mach-omap2/io.c               |   36 +++++++++
 arch/arm/mach-omap2/powerdomain.c      |    2 +-
 arch/arm/mach-omap2/sram34xx.S         |  129 +++++++++++++++++++++-----------
 arch/arm/plat-omap/include/mach/sram.h |    6 +-
 arch/arm/plat-omap/sram.c              |    8 +-
 7 files changed, 163 insertions(+), 62 deletions(-)


- Paul
