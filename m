Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbZEBWVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbZEBWVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbZEBWTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:19:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47593 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761583AbZEBWTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:19:19 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au,
       Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 6/6] ksm: use another miscdevice minor number.
Date: Sun,  3 May 2009 01:16:12 +0300
Message-Id: <1241302572-4366-7-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241302572-4366-6-git-send-email-ieidus@redhat.com>
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>
 <1241302572-4366-2-git-send-email-ieidus@redhat.com>
 <1241302572-4366-3-git-send-email-ieidus@redhat.com>
 <1241302572-4366-4-git-send-email-ieidus@redhat.com>
 <1241302572-4366-5-git-send-email-ieidus@redhat.com>
 <1241302572-4366-6-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old number was registered already by another project.
The new number is #234.

Thanks.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
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

