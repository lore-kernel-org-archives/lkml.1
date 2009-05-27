Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbZE0WQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbZE0WQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762180AbZE0WPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:15:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43092 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761928AbZE0WPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:15:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 0/3] mmio/pio cleanup
To: avi@redhat.com
Cc: chrisw@sous-sol.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 May 2009 17:37:34 -0400
Message-ID: <20090527213535.24324.62362.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the series, and applies to kvm.git/master:1a6a35a1)

This is in prep for some more substantial mmio/pio work for iosignalfd,
coming later.

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
 virt/kvm/iodev.h          |   25 +++++++++++++++------
 virt/kvm/kvm_main.c       |    2 +-
 8 files changed, 115 insertions(+), 57 deletions(-)

-- 
Signature
