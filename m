Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYJOVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYJOVE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYJOVDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:03:03 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:34267 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYJOVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:02:57 -0400
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K8ST4D-01-4GH-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/8] OProfile: Rename IBS sysfs dir into "ibs_op"
Date: Wed, 15 Oct 2008 22:09:05 +0200
Message-ID: <1224101350-12877-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <20081015110444.GA28703@elte.hu>
References: <20081015110444.GA28703@elte.hu>
X-OriginalArrivalTime: 15 Oct 2008 21:02:38.0878 (UTC) FILETIME=[5B3E23E0:01C92F09]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new name is now more close to those used in the spec.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 0657c56..23ce63f 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -503,7 +503,7 @@ static int setup_ibs_files(struct super_block * sb, struct dentry * root)
 	oprofilefs_create_ulong(sb, dir, "rand_enable",
 				&ibs_config.rand_en);
 
-	dir = oprofilefs_mkdir(sb, root, "ibs_uops");
+	dir = oprofilefs_mkdir(sb, root, "ibs_op");
 	oprofilefs_create_ulong(sb, dir, "enable",
 				&ibs_config.op_enabled);
 	oprofilefs_create_ulong(sb, dir, "max_count",
-- 
1.6.0.1


