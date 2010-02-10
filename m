Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0BJR2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:28:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/40] KVM: trivial document fixes
Date: Wed, 10 Feb 2010 19:22:54 +0200
Message-Id: <1265822589-11155-26-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 Documentation/kvm/api.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index 2811e45..c6416a3 100644
--- a/Documentation/kvm/api.txt
+++ b/Documentation/kvm/api.txt
@@ -23,12 +23,12 @@ of a virtual machine.  The ioctls belong to three classes
    Only run vcpu ioctls from the same thread that was used to create the
    vcpu.
 
-2. File descritpors
+2. File descriptors
 
 The kvm API is centered around file descriptors.  An initial
 open("/dev/kvm") obtains a handle to the kvm subsystem; this handle
 can be used to issue system ioctls.  A KVM_CREATE_VM ioctl on this
-handle will create a VM file descripror which can be used to issue VM
+handle will create a VM file descriptor which can be used to issue VM
 ioctls.  A KVM_CREATE_VCPU ioctl on a VM fd will create a virtual cpu
 and return a file descriptor pointing to it.  Finally, ioctls on a vcpu
 fd can be used to control the vcpu, including the important task of
@@ -643,7 +643,7 @@ Type: vm ioctl
 Parameters: struct kvm_clock_data (in)
 Returns: 0 on success, -1 on error
 
-Sets the current timestamp of kvmclock to the valued specific in its parameter.
+Sets the current timestamp of kvmclock to the value specified in its parameter.
 In conjunction with KVM_GET_CLOCK, it is used to ensure monotonicity on scenarios
 such as migration.
 
@@ -795,11 +795,11 @@ Unused.
 			__u64 data_offset; /* relative to kvm_run start */
 		} io;
 
-If exit_reason is KVM_EXIT_IO_IN or KVM_EXIT_IO_OUT, then the vcpu has
+If exit_reason is KVM_EXIT_IO, then the vcpu has
 executed a port I/O instruction which could not be satisfied by kvm.
 data_offset describes where the data is located (KVM_EXIT_IO_OUT) or
 where kvm expects application code to place the data for the next
-KVM_RUN invocation (KVM_EXIT_IO_IN).  Data format is a patcked array.
+KVM_RUN invocation (KVM_EXIT_IO_IN).  Data format is a packed array.
 
 		struct {
 			struct kvm_debug_exit_arch arch;
@@ -815,7 +815,7 @@ Unused.
 			__u8  is_write;
 		} mmio;
 
-If exit_reason is KVM_EXIT_MMIO or KVM_EXIT_IO_OUT, then the vcpu has
+If exit_reason is KVM_EXIT_MMIO, then the vcpu has
 executed a memory-mapped I/O instruction which could not be satisfied
 by kvm.  The 'data' member contains the written data if 'is_write' is
 true, and should be filled by application code otherwise.
-- 
1.6.5.3

