Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbZBZO1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbZBZO1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZBZORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43094 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZBZOPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:43 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 24/40] KVM: Advertise guest debug capability per-arch
Date: Thu, 26 Feb 2009 16:15:14 +0200
Message-Id: <1235657730-27683-25-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Limit KVM_CAP_SET_GUEST_DEBUG only to those archs (currently x86) that
support it. This simplifies user space stub implementations.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 28582fc..11e3e61 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -393,7 +393,9 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_USER_NMI
 #define KVM_CAP_USER_NMI 22
 #endif
+#if defined(CONFIG_X86)
 #define KVM_CAP_SET_GUEST_DEBUG 23
+#endif
 
 /*
  * ioctls for VM fds
-- 
1.6.0.6

