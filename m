Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZLPFeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZLPFeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZLPFeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:34:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:42318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZLPFeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:34:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,404,1257148800"; 
   d="scan'208";a="579365817"
Subject: [GIT PULL] dmaengine update for 2.6.33
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 22:33:44 -0700
Message-Id: <1260941624.29274.44.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive a couple new drivers, coh and ppc440spe-adma (raid offload
engine), and a collection of fixes from Guennadi.  There are a few more
shdma fixes pending from Guennadi, but the original driver author wanted
a bit more time to review / test, so I'm obliging.  These have been in
linux-next for a few releases.

Thanks,
Dan


Anatolij Gustschin (1):
      ppc440spe-adma: adds updated ppc440spe adma driver

Guennadi Liakhovetski (4):
      sh: DMA driver has to specify its alignment requirements
      dmaengine: fix dmatest to verify minimum transfer length and test buffer size
      sh: stylistic improvements for the DMA driver
      dmaengine: clarify the meaning of the DMA_CTRL_ACK flag

H Hartley Sweeten (1):
      iop-adma.c: use resource_size()

Linus Walleij (1):
      Add COH 901 318 DMA block driver v5

 .../powerpc/dts-bindings/4xx/ppc440spe-adma.txt    |   93 +
 arch/arm/mach-u300/include/mach/coh901318.h        |  281 ++
 arch/powerpc/include/asm/async_tx.h                |   47 +
 arch/powerpc/include/asm/dcr-regs.h                |   23 +
 drivers/dma/Kconfig                                |   18 +
 drivers/dma/Makefile                               |    2 +
 drivers/dma/coh901318.c                            | 1325 ++++++
 drivers/dma/coh901318_lli.c                        |  318 ++
 drivers/dma/coh901318_lli.h                        |  124 +
 drivers/dma/dmatest.c                              |   16 +-
 drivers/dma/iop-adma.c                             |    4 +-
 drivers/dma/ppc4xx/Makefile                        |    1 +
 drivers/dma/ppc4xx/adma.c                          | 5027 ++++++++++++++++++++
 drivers/dma/ppc4xx/adma.h                          |  195 +
 drivers/dma/ppc4xx/dma.h                           |  223 +
 drivers/dma/ppc4xx/xor.h                           |  110 +
 drivers/dma/shdma.c                                |   36 +-
 drivers/dma/shdma.h                                |   14 +-
 include/linux/dmaengine.h                          |    2 +-
 19 files changed, 7828 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
 create mode 100644 arch/arm/mach-u300/include/mach/coh901318.h
 create mode 100644 arch/powerpc/include/asm/async_tx.h
 create mode 100644 drivers/dma/coh901318.c
 create mode 100644 drivers/dma/coh901318_lli.c
 create mode 100644 drivers/dma/coh901318_lli.h
 create mode 100644 drivers/dma/ppc4xx/Makefile
 create mode 100644 drivers/dma/ppc4xx/adma.c
 create mode 100644 drivers/dma/ppc4xx/adma.h
 create mode 100644 drivers/dma/ppc4xx/dma.h
 create mode 100644 drivers/dma/ppc4xx/xor.h


