Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZEENYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZEENYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZEENYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:24:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46070 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZEENYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:24:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 0/3] generic hypercall support
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Date: Tue, 05 May 2009 09:24:32 -0400
Message-ID: <20090505132005.19891.78436.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to Linus' tree, b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a)

Please see patch 1/3 for a description.  This has been tested with a KVM
guest on x86_64 and appears to work properly.  Comments, please.

-Greg

---

Gregory Haskins (3):
      kvm: add pv_cpu_ops.hypercall support to the guest
      x86: add generic hypercall support
      add generic hypercall support


 arch/Kconfig                     |    3 +
 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/paravirt.h  |   13 ++++++
 arch/x86/include/asm/processor.h |    6 +++
 arch/x86/kernel/kvm.c            |   22 ++++++++++
 include/linux/hypercall.h        |   83 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 128 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/hypercall.h

-- 
Signature
