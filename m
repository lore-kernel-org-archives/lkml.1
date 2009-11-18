Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZKRVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZKRVvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZKRVvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:51:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52142 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZKRVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:51:51 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18JkQkv8z6nJuvsFRNnYKo9
Date: Wed, 18 Nov 2009 13:51:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.32-rc7
Message-ID: <20091118215147.GT29266@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull few more omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 156171c71a0dc4bce12b4408bb1591f8fe32dc1a:
  Linus Torvalds (1):
        Linux 2.6.32-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Rajendra Nayak (1):
      omap3: clock: Fix the DPLL freqsel computations

Roel Kluin (2):
      omap: fix unlikely(x) < y
      OMAP: cs should be positive in gpmc_cs_free()

Tero Kristo (1):
      omap3: clock: Fixed dpll3_m2x2 rate calculation

Vimal Singh (1):
      omap: Fix keymap for zoom2 according to matrix keypad framwork

 arch/arm/mach-omap2/board-zoom2.c |   87 ++++++++++++++++++-------------------
 arch/arm/mach-omap2/clock34xx.c   |    2 +-
 arch/arm/mach-omap2/clock34xx.h   |    4 +-
 arch/arm/mach-omap2/gpmc.c        |    2 +-
 arch/arm/plat-omap/gpio.c         |    2 +-
 5 files changed, 48 insertions(+), 49 deletions(-)
