Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbZHWMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbZHWMFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933779AbZHWMDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/46] KVM: add module parameters documentation
Date: Sun, 23 Aug 2009 14:56:19 +0300
Message-Id: <1251028605-31977-21-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 Documentation/kernel-parameters.txt |   39 +++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd1a6d4..5b7a706 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -57,6 +57,7 @@ parameter is applicable:
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
+	KVM	Kernel Virtual Machine support is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
 	LOOP	Loopback device support is enabled.
@@ -1098,6 +1099,44 @@ and is between 256 and 4096 characters. It is defined in the file
 	kstack=N	[X86] Print N words from the kernel stack
 			in oops dumps.
 
+	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
+			Default is 0 (don't ignore, but inject #GP)
+
+	kvm.oos_shadow=	[KVM] Disable out-of-sync shadow paging.
+			Default is 1 (enabled)
+
+	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
+			Default is 0 (off)
+
+	kvm-amd.npt=	[KVM,AMD] Disable nested paging (virtualized MMU)
+			for all guests.
+			Default is 1 (enabled) if in 64bit or 32bit-PAE mode
+
+	kvm-intel.bypass_guest_pf=
+			[KVM,Intel] Disables bypassing of guest page faults
+			on Intel chips. Default is 1 (enabled)
+
+	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
+			(virtualized MMU) support on capable Intel chips.
+			Default is 1 (enabled)
+
+	kvm-intel.emulate_invalid_guest_state=
+			[KVM,Intel] Enable emulation of invalid guest states
+			Default is 0 (disabled)
+
+	kvm-intel.flexpriority=
+			[KVM,Intel] Disable FlexPriority feature (TPR shadow).
+			Default is 1 (enabled)
+
+	kvm-intel.unrestricted_guest=
+			[KVM,Intel] Disable unrestricted guest feature
+			(virtualized real and unpaged mode) on capable
+			Intel chips. Default is 1 (enabled)
+
+	kvm-intel.vpid=	[KVM,Intel] Disable Virtual Processor Identification
+			feature (tagged TLBs) on capable Intel chips.
+			Default is 1 (enabled)
+
 	l2cr=		[PPC]
 
 	l3cr=		[PPC]
-- 
1.6.4.1

