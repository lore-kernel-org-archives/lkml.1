Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbZEDW26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbZEDW26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbZEDW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:27:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54711 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbZEDW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:27:11 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au,
       Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 6/6] ksm: use another miscdevice minor number.
Date: Tue,  5 May 2009 01:25:35 +0300
Message-Id: <1241475935-21162-7-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241475935-21162-6-git-send-email-ieidus@redhat.com>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com>
 <1241475935-21162-4-git-send-email-ieidus@redhat.com>
 <1241475935-21162-5-git-send-email-ieidus@redhat.com>
 <1241475935-21162-6-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old number was registered already by another project.
The new number is #234.

Thanks.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Alan Cox <device@lanana.org>
---
 Documentation/devices.txt  |    1 +
 include/linux/miscdevice.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 53d64d3..a0c3259 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -443,6 +443,7 @@ Your cooperation is appreciated.
 		231 = /dev/snapshot	System memory snapshot device
 		232 = /dev/kvm		Kernel-based virtual machine (hardware virtualization extensions)
 		233 = /dev/kmview	View-OS A process with a view
+		234 = /dev/ksm		Dynamic page sharing
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
 
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 297c0bb..c7b8e9b 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -30,7 +30,7 @@
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
-#define KSM_MINOR		233
+#define KSM_MINOR		234
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
-- 
1.5.6.5

