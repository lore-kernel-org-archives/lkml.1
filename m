Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZJBUTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZJBUTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbZJBUTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:19:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55125 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZJBUTT (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 2 Oct 2009 16:19:19 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 0/4] KVM: xinterface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Fri, 02 Oct 2009 16:19:16 -0400
Message-ID: <20091002201159.4014.33268.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to kvm.git/master:083e9e10)

For details, please read the patch headers.

[ Changelog:

     v2:
	*) We now re-use the vmfd as the binding token, instead of creating
           a new separate namespace
	*) Added support for switch_to(mm), which is much faster
	*) Added support for memslot-cache for exploiting slot locality
	*) Added support for scatter-gather access
	*) Added support for xioevent interface

      v1:
        *) Initial release
]

This series is included in upstream AlacrityVM and is well tested and
known to work properly.  Comments?

Kind Regards,
-Greg

---

Gregory Haskins (4):
      KVM: add scatterlist support to xinterface
      KVM: add io services to xinterface
      KVM: introduce "xinterface" API for external interaction with guests
      mm: export use_mm() and unuse_mm() to modules


 arch/x86/kvm/Makefile          |    2 
 include/linux/kvm_host.h       |    3 
 include/linux/kvm_xinterface.h |  165 +++++++++++
 kernel/fork.c                  |    1 
 mm/mmu_context.c               |    3 
 virt/kvm/kvm_main.c            |   24 ++
 virt/kvm/xinterface.c          |  587 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 784 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/kvm_xinterface.h
 create mode 100644 virt/kvm/xinterface.c

-- 
Signature
