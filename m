Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0BJR3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:29:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/40] KVM: Add KVM_MMIO kconfig item
Date: Wed, 10 Feb 2010 19:22:48 +0200
Message-Id: <1265822589-11155-20-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 doesn't have mmio, this will simplify ifdefing it out.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/Kconfig    |    1 +
 arch/powerpc/kvm/Kconfig |    1 +
 arch/x86/kvm/Kconfig     |    1 +
 virt/kvm/Kconfig         |    3 +++
 4 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index ef3e7be..bf82e47 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select KVM_APIC_ARCHITECTURE
+	select KVM_MMIO
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 6fb6e8a..be28968 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,6 +20,7 @@ config KVM
 	bool
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+	select KVM_MMIO
 
 config KVM_BOOK3S_64_HANDLER
 	bool
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 4cd4983..0687111 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -29,6 +29,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select KVM_APIC_ARCHITECTURE
 	select USER_RETURN_NOTIFIER
+	select KVM_MMIO
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index daece36..7f1178f 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -12,3 +12,6 @@ config HAVE_KVM_EVENTFD
 
 config KVM_APIC_ARCHITECTURE
        bool
+
+config KVM_MMIO
+       bool
-- 
1.6.5.3

