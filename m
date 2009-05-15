Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbZEOCYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbZEOCYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 22:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZEOCY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 22:24:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:39947 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbZEOCY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 22:24:28 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/4] sparc: unify dma-mapping_32.h and dma-mapping_64.h
Date: Fri, 15 May 2009 11:23:07 +0900
Message-Id: <1242354191-6232-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 11:24:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset unifies dma-mapping_32.h and dma-mapping_64.h, that is,
it uses dma-mapping.h instead and removes dma-mapping_32.h and
dma-mapping_64.h.

In short, this patchset modifies SPARC32 to use struct dma_map
ops.

I like to see architectures implement the dma API in the similar way.

Thanks,

=
 arch/sparc/include/asm/dma-mapping.h    |  168 ++++++++++++++++++++++++++++++-
 arch/sparc/include/asm/dma-mapping_32.h |   60 -----------
 arch/sparc/include/asm/dma-mapping_64.h |  154 ----------------------------
 arch/sparc/kernel/dma.c                 |  127 +++++++----------------
 arch/sparc/kernel/iommu.c               |   15 ++--
 arch/sparc/kernel/pci_sun4v.c           |   15 ++--
 6 files changed, 218 insertions(+), 321 deletions(-)



