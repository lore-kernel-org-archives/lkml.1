Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZB0Kep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZB0Kep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbZB0K1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53589 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/37] KVM: Add CONFIG_HAVE_KVM_IRQCHIP
Date: Fri, 27 Feb 2009 12:26:47 +0200
Message-Id: <1235730420-7929-25-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two KVM archs support irqchips and two don't.  Add a Kconfig item to
make selecting between the two models easier.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/Kconfig    |    4 ++++
 arch/powerpc/kvm/Kconfig |    3 +++
 arch/s390/kvm/Kconfig    |    3 +++
 arch/x86/kvm/Kconfig     |    4 ++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index f833a0b..0a2d6b8 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -4,6 +4,10 @@
 config HAVE_KVM
 	bool
 
+config HAVE_KVM_IRQCHIP
+       bool
+       default y
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	depends on HAVE_KVM || IA64
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 1465705..5a152a5 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -2,6 +2,9 @@
 # KVM configuration
 #
 
+config HAVE_KVM_IRQCHIP
+       bool
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	---help---
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index e051cad..3e260b7 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -4,6 +4,9 @@
 config HAVE_KVM
        bool
 
+config HAVE_KVM_IRQCHIP
+       bool
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	default y
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b81125f..0a303c3 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -4,6 +4,10 @@
 config HAVE_KVM
        bool
 
+config HAVE_KVM_IRQCHIP
+       bool
+       default y
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	depends on HAVE_KVM || X86
-- 
1.6.0.6

