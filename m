Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbZJOAe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbZJOAe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbZJOAe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:34:27 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51047 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZJOAe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:34:26 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/hlhEeHuA0nDBeuXHW7/Hu
Date: Wed, 14 Oct 2009 17:33:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.32-rc4
Message-ID: <20091015003341.GG14531@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 161291396e76e0832c08f617eb9bd364d1648148:
  Linus Torvalds (1):
        Linux 2.6.32-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (1):
      omap: RX-51: Drop I2C-1 speed to 2200

Anuj Aggarwal (1):
      omap: SDMA: Fixing bug in omap_dma_set_global_params()

Jarkko Nikula (1):
      omap: McBSP: Fix incorrect receiver stop in omap_mcbsp_stop

Kalle Jokiniemi (1):
      OMAP: Fix race condition with autodeps

Paul Walmsley (1):
      OMAP2xxx clock: set up clockdomain pointer in struct clk

Sanjeev Premi (1):
      omap: CONFIG_ISP1301_OMAP redefined in Beagle defconfig

Teerth Reddy (1):
      omap: Initialization of SDRC params on Zoom2

Tony Lindgren (1):
      Merge branch '2_6_32rc4_fixes' of git://git.pwsan.com/linux-2.6 into omap-fixes-for-linus

 arch/arm/configs/omap3_beagle_defconfig      |    1 -
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/mach-omap2/board-zoom2.c            |    4 +-
 arch/arm/mach-omap2/clock24xx.c              |    1 +
 arch/arm/mach-omap2/clockdomain.c            |   74 +++++++++++++++----------
 arch/arm/plat-omap/dma.c                     |   15 +++--
 arch/arm/plat-omap/mcbsp.c                   |    2 +-
 7 files changed, 59 insertions(+), 40 deletions(-)
