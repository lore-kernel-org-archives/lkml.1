Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYGRTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYGRTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYGRTPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:15:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbYGRTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:15:15 -0400
Date: Fri, 18 Jul 2008 21:15:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] Sh: use generic per-device coherent dma allocator
Message-ID: <20080718191501.GA31108@elte.hu>
References: <f19d3499bb927f743672952b035895441e6bcafd.1216373338.git.dbaryshkov@gmail.com> <488062c4.205c4e0a.118c.05a2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488062c4.205c4e0a.118c.05a2@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Paul Mundt <lethal@linux-sh.org>

applied all 3 patches to core/generic-dma-coherent, which is at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/generic-dma-coherent

------------------>
Dmitry Baryshkov (5):
      generic: per-device coherent dma allocator
      x86: use generic per-device dma coherent allocator
      Generic dma-coherent: fix DMA_MEMORY_EXCLUSIVE
      ARM: support generic per-device coherent dma mem
      Sh: use generic per-device coherent dma allocator


 arch/arm/Kconfig                   |    1 +
 arch/arm/mm/consistent.c           |    8 ++
 arch/sh/Kconfig                    |    1 +
 arch/sh/mm/consistent.c            |   98 +---------------------------
 arch/x86/Kconfig                   |    1 +
 arch/x86/kernel/pci-dma.c          |  122 +----------------------------------
 include/asm-arm/dma-mapping.h      |    2 +
 include/asm-generic/dma-coherent.h |   32 +++++++++
 include/asm-sh/dma-mapping.h       |    1 +
 include/asm-x86/dma-mapping.h      |   22 +------
 init/Kconfig                       |    4 +
 kernel/Makefile                    |    1 +
 kernel/dma-coherent.c              |  126 ++++++++++++++++++++++++++++++++++++
 13 files changed, 183 insertions(+), 236 deletions(-)
 create mode 100644 include/asm-generic/dma-coherent.h
 create mode 100644 kernel/dma-coherent.c

