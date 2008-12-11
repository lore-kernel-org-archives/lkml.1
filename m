Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYLKQvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYLKQvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYLKQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:59 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20563 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbYLKQs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:58 -0500
X-BigFish: VPS-1(z5edJzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBQ1D6-02-VMW-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/10] oprofile: update comment for oprofile_add_sample()
Date: Thu, 11 Dec 2008 16:04:38 +0100
Message-ID: <1229007886-14362-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0839 (UTC) FILETIME=[49DD6E70:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu argument is no longer part of the parameter list.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/oprofile.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5231861..1ce9fe5 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -86,8 +86,7 @@ int oprofile_arch_init(struct oprofile_operations * ops);
 void oprofile_arch_exit(void);
 
 /**
- * Add a sample. This may be called from any context. Pass
- * smp_processor_id() as cpu.
+ * Add a sample. This may be called from any context.
  */
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
 
-- 
1.6.0.1


