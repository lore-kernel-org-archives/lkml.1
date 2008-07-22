Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYGVT1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYGVT1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYGVTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:04 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40555 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbYGVTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:58 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VA-01-8PG-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/24] OProfile: Add IBS code macros
Date: Tue, 22 Jul 2008 21:08:53 +0200
Message-ID: <1216753748-11261-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0542 (UTC) FILETIME=[7202A360:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/oprofile.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 041bb31..bcb8f72 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -36,6 +36,8 @@
 #define XEN_ENTER_SWITCH_CODE		10
 #define SPU_PROFILING_CODE		11
 #define SPU_CTX_SWITCH_CODE		12
+#define IBS_FETCH_CODE			13
+#define IBS_OP_CODE			14
 
 struct super_block;
 struct dentry;
-- 
1.5.5.4


