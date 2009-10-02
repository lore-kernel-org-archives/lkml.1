Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZJBWgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZJBWgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZJBWgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:36:22 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60390 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZJBWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:36:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+i8ZICoKJx89Hpd4G5xjhJ
Subject: [PATCH 0/8] Omap fixes for 2.6.32-rc2
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Oct 2009 15:36:23 -0700
Message-ID: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are some more fixes for review.

Regards,

Tony

---

Daniel Walker (1):
      omap: iovmm: Add missing mutex_unlock

Hiroshi DOYU (1):
      omap: iovmm: Fix incorrect spelling

Rajendra Nayak (1):
      omap: Lock DPLL5 at boot

Sergio Aguirre (1):
      omapfb: Condition mutex acquisition

Tommi Rantala (2):
      omapfb: Blizzard: constify register address tables
      omapfb: Blizzard: fix pointer to be const

Tony Lindgren (1):
      omap: Fix incorrect 730 vs 850 detection

ye janboe (1):
      omap: SRAM: flush the right address after memcpy in omap_sram_push


 arch/arm/mach-omap2/clock34xx.c       |   35 +++++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/cpu.h |   37 ++++++++++++---------------------
 arch/arm/plat-omap/iovmm.c            |    9 ++++----
 arch/arm/plat-omap/sram.c             |    3 ++-
 drivers/video/omap/blizzard.c         |   10 ++++-----
 drivers/video/omap/omapfb_main.c      |   22 ++++++++++++--------
 6 files changed, 75 insertions(+), 41 deletions(-)

-- 
Signature
