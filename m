Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZHJG7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZHJG7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZHJG7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:59:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:55048 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZHJG7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:59:04 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 16:58:29 +1000
Message-Id: <1249887509.9841.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is a simple enough fix that I decided was worth having now, it
basically allow "direct" DMA (non-iommu) to work for devices that have a
< 32-bit DMA mask (such as some infamous broadcom wireless chips) when
the machine simply has not enough memory to go over the chip addressing
limit. This fixes various smallish G5 (like old iMac G5) wireless.

The following changes since commit f4b9a988685da6386d7f9a72df3098bcc3270526:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.infradead.org/ubi-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (1):
      powerpc/dma: pci_set_dma_mask() shouldn't fail if mask fits in RAM

 arch/powerpc/kernel/dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


