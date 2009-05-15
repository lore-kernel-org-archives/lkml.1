Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbZEOQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbZEOQ23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbZEOQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:28:16 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45586 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZEOQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:28:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 0/4] iosignalfd
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Date: Fri, 15 May 2009 12:28:02 -0400
Message-ID: <20090515162047.26209.93545.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[

    Applies to kvm.git:833367b57c plus the irqfd patch, v8, as posted here:

            http://lkml.org/lkml/2009/5/14/258

]

This is v2 of the series.  For more details, please see the header to
patch 4/4.

[
   Changelog:

      v2:
           *) added optional data-matching capability (via cookie field)
           *) changed name from iofd to iosignalfd
           *) added io_bus unregister function
           *) implemented deassign feature

      v1:
           *) original release (integrated into irqfd v7 series as "iofd")
]

---

Gregory Haskins (4):
      kvm: add iosignalfd support
      kvm: add io_bus unregister function
      kvm: add return value to kvm_io_bus_register_dev
      eventfd: export eventfd interfaces for module use


 arch/x86/kvm/i8254.c      |    7 +-
 arch/x86/kvm/i8259.c      |    5 +
 fs/eventfd.c              |    3 +
 include/linux/kvm.h       |   15 ++++
 include/linux/kvm_host.h  |   10 ++-
 virt/kvm/coalesced_mmio.c |    4 +
 virt/kvm/eventfd.c        |  154 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c         |    4 +
 virt/kvm/kvm_main.c       |   62 ++++++++++++++++--
 9 files changed, 249 insertions(+), 15 deletions(-)

-- 
Signature
