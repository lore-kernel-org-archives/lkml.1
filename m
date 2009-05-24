Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbZEXQA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbZEXQA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbZEXPyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 29/45] KVM: Expand on "help" info to specify kvm intel and amd module names
Date: Sun, 24 May 2009 18:50:14 +0300
Message-Id: <1243180230-2480-30-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a58504e..8600a09 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -50,6 +50,9 @@ config KVM_INTEL
 	  Provides support for KVM on Intel processors equipped with the VT
 	  extensions.
 
+	  To compile this as a module, choose M here: the module
+	  will be called kvm-intel.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM
@@ -57,6 +60,9 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
+	  To compile this as a module, choose M here: the module
+	  will be called kvm-amd.
+
 config KVM_TRACE
 	bool "KVM trace support"
 	depends on KVM && SYSFS
-- 
1.6.0.6

