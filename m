Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYFXJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYFXJIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYFXJIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:08:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:48282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYFXJIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:08:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,695,1204531200"; 
   d="scan'208,223";a="1797441"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel
To: kvm@vger.kernel.org
Subject: [PATCH 1/2] x86/KVM: Move VMX MSR definition to msr-index.h
Date: Tue, 24 Jun 2008 17:08:19 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EmLYI/2uLF8vkha"
Message-Id: <200806241708.20065.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_EmLYI/2uLF8vkha
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom 90cc7b5303fab30d53d42b3fb7281d756b3d7134 Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Tue, 24 Jun 2008 17:02:41 +0800
Subject: [PATCH] x86/KVM: Move VMX MSR definition to msr-index.h


Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 arch/x86/kvm/vmx.h          |   15 ---------------
 include/asm-x86/msr-index.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 0c22e5f..da06a4a 100644
=2D-- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,21 +331,6 @@ enum vmcs_field {

 #define AR_RESERVD_MASK 0xfffe0f00

=2D#define MSR_IA32_VMX_BASIC                      0x480
=2D#define MSR_IA32_VMX_PINBASED_CTLS              0x481
=2D#define MSR_IA32_VMX_PROCBASED_CTLS             0x482
=2D#define MSR_IA32_VMX_EXIT_CTLS                  0x483
=2D#define MSR_IA32_VMX_ENTRY_CTLS                 0x484
=2D#define MSR_IA32_VMX_MISC                       0x485
=2D#define MSR_IA32_VMX_CR0_FIXED0                 0x486
=2D#define MSR_IA32_VMX_CR0_FIXED1                 0x487
=2D#define MSR_IA32_VMX_CR4_FIXED0                 0x488
=2D#define MSR_IA32_VMX_CR4_FIXED1                 0x489
=2D#define MSR_IA32_VMX_VMCS_ENUM                  0x48a
=2D#define MSR_IA32_VMX_PROCBASED_CTLS2            0x48b
=2D#define MSR_IA32_VMX_EPT_VPID_CAP               0x48c
=2D
=2D#define MSR_IA32_FEATURE_CONTROL                0x3a
 #define IA32_FEATURE_CONTROL_LOCKED_BIT		0x1
 #define IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT	0x4

diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 09413ad..59ffc93 100644
=2D-- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -174,6 +174,7 @@
 #define MSR_IA32_TSC			0x00000010
 #define MSR_IA32_PLATFORM_ID		0x00000017
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
+#define MSR_IA32_FEATURE_CONTROL	0x0000003a

 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
@@ -194,6 +195,21 @@
 #define MSR_IA32_THERM_STATUS		0x0000019c
 #define MSR_IA32_MISC_ENABLE		0x000001a0

+/* Intel VT related */
+#define MSR_IA32_VMX_BASIC		0x00000480
+#define MSR_IA32_VMX_PINBASED_CTLS	0x00000481
+#define MSR_IA32_VMX_PROCBASED_CTLS	0x00000482
+#define MSR_IA32_VMX_EXIT_CTLS		0x00000483
+#define MSR_IA32_VMX_ENTRY_CTLS		0x00000484
+#define MSR_IA32_VMX_MISC		0x00000485
+#define MSR_IA32_VMX_CR0_FIXED0		0x00000486
+#define MSR_IA32_VMX_CR0_FIXED1		0x00000487
+#define MSR_IA32_VMX_CR4_FIXED0		0x00000488
+#define MSR_IA32_VMX_CR4_FIXED1		0x00000489
+#define MSR_IA32_VMX_VMCS_ENUM		0x0000048a
+#define MSR_IA32_VMX_PROCBASED_CTLS2	0x0000048b
+#define MSR_IA32_VMX_EPT_VPID_CAP	0x0000048c
+
 /* Intel Model 6 */
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
=2D-
1.5.5


--Boundary-00=_EmLYI/2uLF8vkha
Content-Type: text/x-diff;
  charset="utf-8";
  name="0002-x86-KVM-Move-VMX-MSR-definition-to-msr-index.h.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-x86-KVM-Move-VMX-MSR-definition-to-msr-index.h.patch"

=46rom 90cc7b5303fab30d53d42b3fb7281d756b3d7134 Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Tue, 24 Jun 2008 17:02:41 +0800
Subject: [PATCH] x86/KVM: Move VMX MSR definition to msr-index.h


Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 arch/x86/kvm/vmx.h          |   15 ---------------
 include/asm-x86/msr-index.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index 0c22e5f..da06a4a 100644
=2D-- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,21 +331,6 @@ enum vmcs_field {
=20
 #define AR_RESERVD_MASK 0xfffe0f00
=20
=2D#define MSR_IA32_VMX_BASIC                      0x480
=2D#define MSR_IA32_VMX_PINBASED_CTLS              0x481
=2D#define MSR_IA32_VMX_PROCBASED_CTLS             0x482
=2D#define MSR_IA32_VMX_EXIT_CTLS                  0x483
=2D#define MSR_IA32_VMX_ENTRY_CTLS                 0x484
=2D#define MSR_IA32_VMX_MISC                       0x485
=2D#define MSR_IA32_VMX_CR0_FIXED0                 0x486
=2D#define MSR_IA32_VMX_CR0_FIXED1                 0x487
=2D#define MSR_IA32_VMX_CR4_FIXED0                 0x488
=2D#define MSR_IA32_VMX_CR4_FIXED1                 0x489
=2D#define MSR_IA32_VMX_VMCS_ENUM                  0x48a
=2D#define MSR_IA32_VMX_PROCBASED_CTLS2            0x48b
=2D#define MSR_IA32_VMX_EPT_VPID_CAP               0x48c
=2D
=2D#define MSR_IA32_FEATURE_CONTROL                0x3a
 #define IA32_FEATURE_CONTROL_LOCKED_BIT		0x1
 #define IA32_FEATURE_CONTROL_VMXON_ENABLED_BIT	0x4
=20
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 09413ad..59ffc93 100644
=2D-- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -174,6 +174,7 @@
 #define MSR_IA32_TSC			0x00000010
 #define MSR_IA32_PLATFORM_ID		0x00000017
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
+#define MSR_IA32_FEATURE_CONTROL	0x0000003a
=20
 #define MSR_IA32_APICBASE		0x0000001b
 #define MSR_IA32_APICBASE_BSP		(1<<8)
@@ -194,6 +195,21 @@
 #define MSR_IA32_THERM_STATUS		0x0000019c
 #define MSR_IA32_MISC_ENABLE		0x000001a0
=20
+/* Intel VT related */
+#define MSR_IA32_VMX_BASIC		0x00000480
+#define MSR_IA32_VMX_PINBASED_CTLS	0x00000481
+#define MSR_IA32_VMX_PROCBASED_CTLS	0x00000482
+#define MSR_IA32_VMX_EXIT_CTLS		0x00000483
+#define MSR_IA32_VMX_ENTRY_CTLS		0x00000484
+#define MSR_IA32_VMX_MISC		0x00000485
+#define MSR_IA32_VMX_CR0_FIXED0		0x00000486
+#define MSR_IA32_VMX_CR0_FIXED1		0x00000487
+#define MSR_IA32_VMX_CR4_FIXED0		0x00000488
+#define MSR_IA32_VMX_CR4_FIXED1		0x00000489
+#define MSR_IA32_VMX_VMCS_ENUM		0x0000048a
+#define MSR_IA32_VMX_PROCBASED_CTLS2	0x0000048b
+#define MSR_IA32_VMX_EPT_VPID_CAP	0x0000048c
+
 /* Intel Model 6 */
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
=2D-=20
1.5.5


--Boundary-00=_EmLYI/2uLF8vkha--
