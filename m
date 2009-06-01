Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZFAQy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZFAQy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZFAQyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:54:44 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48466 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZFAQyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:54:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 0/3] mmio/pio cleanup
To: avi@redhat.com
Cc: chrisw@sous-sol.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Jun 2009 12:54:40 -0400
Message-ID: <20090601165134.18202.87598.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is v3 of the series, applies to kvm.git/master:7ff90748)

This is in prep for some more substantial mmio/pio work for iosignalfd,
coming later.

[ Changelog:

  v3:
      *) Addressed feedback from Chris Wright w.r.t. patch 2/3
      *) Rebased to kvm.git/master:7ff90748

]

---

Gregory Haskins (3):
      kvm: do not register i8254 PIO regions until we are initialized
      kvm: cleanup io_device code
      kvm: fix potential coalesced_mmio leak on shutdown


 arch/x86/kvm/i8254.c      |   53 +++++++++++++++++++++++++++++----------------
 arch/x86/kvm/i8259.c      |   20 ++++++++++++-----
 arch/x86/kvm/lapic.c      |   22 +++++++++++++------
 arch/x86/kvm/x86.c        |    2 +-
 virt/kvm/coalesced_mmio.c |   26 ++++++++++++++--------
 virt/kvm/ioapic.c         |   22 +++++++++++++------
 virt/kvm/iodev.h          |   29 +++++++++++++++++--------
 virt/kvm/kvm_main.c       |    2 +-
 8 files changed, 117 insertions(+), 59 deletions(-)

-- 
Signature
