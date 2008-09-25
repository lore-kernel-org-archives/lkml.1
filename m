Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYIYMDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYIYMDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYIYL4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48589 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbYIYL4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:03 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 24/39] KVM: ia64: Enable virtio driver for ia64 in Kconfig
Date: Thu, 25 Sep 2008 14:54:56 +0300
Message-Id: <1222343711-12508-25-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

kvm/ia64 uses the virtio drivers to optimize its I/O subsytem.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 7914e48..8e99fed 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -46,4 +46,6 @@ config KVM_INTEL
 config KVM_TRACE
        bool
 
+source drivers/virtio/Kconfig
+
 endif # VIRTUALIZATION
-- 
1.6.0.1

