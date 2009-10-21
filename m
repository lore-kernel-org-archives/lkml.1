Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZJUOeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZJUOeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZJUOet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:34:49 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40313 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZJUOes (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 21 Oct 2009 10:34:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 0/2] irqfd enhancements
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Wed, 21 Oct 2009 10:34:48 -0400
Message-ID: <20091021143042.14955.22470.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:11b06403)

The following patches are cleanups/enhancements for IRQFD now that
we have lockless interrupt injection.  For more details, please see
the patch headers.

These patches pass checkpatch, and are fully tested.  Please consider
for merging.  They are an enhancement only, so there is no urgency
to push to mainline until a suitable merge window presents itself.

Kind Regards,
-Greg

---

Gregory Haskins (2):
      KVM: Remove unecessary irqfd-cleanup-wq
      KVM: Directly inject interrupts via irqfd


 virt/kvm/eventfd.c |   45 ++++++---------------------------------------
 1 files changed, 6 insertions(+), 39 deletions(-)

-- 
Signature
