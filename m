Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZETLZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZETLZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbZETLT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55288 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 18/46] KVM: ia64: make kvm depend on CONFIG_MODULES.
Date: Wed, 20 May 2009 14:18:15 +0300
Message-Id: <1242818323-10413-19-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Xiantao <xiantao.zhang@intel.com>

Since kvm-intel modue can't be built-in, make kvm depend on
CONFIG_MODULES.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 0a2d6b8..64d5209 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -23,7 +23,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM && EXPERIMENTAL
+	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
 	select PREEMPT_NOTIFIERS
-- 
1.6.0.6

