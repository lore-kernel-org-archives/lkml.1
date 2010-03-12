Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab0CLJKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:10:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:47294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab0CLJKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:10:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,625,1262592000"; 
   d="scan'208";a="500101711"
Date: Fri, 12 Mar 2010 10:11:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Paul Mundt <lethal@linux-sh.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [GIT PULL] MFD fixes for 2.6.34
Message-ID: <20100312091141.GA25413@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have a couple of MFD fixes, fixing the sm501 region requested size and
the MFD Kconfig for genirq dependent drivers.

Thanks in advance for pulling.

The following changes since commit 522dba7134d6b2e5821d3457f7941ec34f668e6d:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Geert Uytterhoeven (1):
      mfd: Several MFD drivers should depend on GENERIC_HARDIRQS

Samuel Ortiz (1):
      mfd: Fix sm501 requested region size

 drivers/mfd/Kconfig |    9 +++++----
 drivers/mfd/sm501.c |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
