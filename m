Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbYJRPbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbYJRPbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYJRPaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:30:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYJRPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:30:51 -0400
Subject: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, fenghua.yu@intel.com, jbarnes@virtuousgeek.org,
       tony.luck@intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Sat, 18 Oct 2008 16:30:43 +0100
Message-Id: <1224343843.6770.1378.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As previously threatened, I've created an iommu-2.6.git tree:
	git://git.infradead.org/iommu-2.6.git
	http://git.infradead.org/iommu-2.6.git

I've rounded up the patches which have been pending for a while and
which would have been in linux-next if Stephen hadn't been away, and I'm
planning to ask Linus to pull it early next week, before the merge
window closes.

If there's anything missing which should be in 2.6.28, now is the time
to shout. I don't want anything new and exciting yet though please; only
patches which have already been posted and reviewed, or necessary fixes.

Stephen, please could you add this tree to linux-next?

Current contents:

Andreas Herrmann (1):
      amd_iommu: fix nasty bug that caused ILLEGAL_DEVICE_TABLE_ENTRY errors

Cihula, Joseph (1):
      intel-iommu: disable Protected Memory Regions when DMA remapping enabled

David Woodhouse (2):
      dmar: fix uninitialised 'ret' variable in dmar_parse_dev()
      Admit to maintaining VT-d, for my sins.

FUJITA Tomonori (1):
      intel-iommu: use coherent_dma_mask in alloc_coherent

Fenghua Yu (1):
      intel-iommu: IA64 support

Suresh Siddha (1):
      dmar: use spin_lock_irqsave() in qi_submit_sync()

Youquan Song (3):
      dmar: context cache and IOTLB invalidation using queued invalidation
      dmar: Use queued invalidation interface for IOTLB and context invalidation
      dmar: remove the quirk which disables dma-remapping when intr-remapping enabled


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

