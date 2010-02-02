Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0BBHWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:24 -0500
Received: from mail.perches.com ([173.55.12.10]:1751 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0BBHWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:21 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Xiantao Zhang <xiantao.zhang@intel.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>, kvm-ia64@vger.kernel.org,
       kvm@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH 01/10] arch/ia64: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:07 -0800
Message-Id: <f3f06427c791446de7aaba9df811f29db12dd831.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/kvm/mmio.c |    4 ++--
 arch/ia64/kvm/vcpu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kvm/mmio.c b/arch/ia64/kvm/mmio.c
index 9bf55af..fb8f9f5 100644
--- a/arch/ia64/kvm/mmio.c
+++ b/arch/ia64/kvm/mmio.c
@@ -316,8 +316,8 @@ void emulate_io_inst(struct kvm_vcpu *vcpu, u64 padr, u64 ma)
 		return;
 	} else {
 		inst_type = -1;
-		panic_vm(vcpu, "Unsupported MMIO access instruction! \
-				Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
+		panic_vm(vcpu, "Unsupported MMIO access instruction! "
+				"Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
 				bundle.i64[0], bundle.i64[1]);
 	}
 
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index dce75b7..958815c 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -1639,8 +1639,8 @@ void vcpu_set_psr(struct kvm_vcpu *vcpu, unsigned long val)
 	 * Otherwise panic
 	 */
 	if (val & (IA64_PSR_PK | IA64_PSR_IS | IA64_PSR_VM))
-		panic_vm(vcpu, "Only support guests with vpsr.pk =0 \
-				& vpsr.is=0\n");
+		panic_vm(vcpu, "Only support guests with vpsr.pk =0 "
+				"& vpsr.is=0\n");
 
 	/*
 	 * For those IA64_PSR bits: id/da/dd/ss/ed/ia
-- 
1.6.6.rc0.57.gad7a

