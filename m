Return-Path: <linux-kernel-owner+w=401wt.eu-S1762363AbZAGWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363AbZAGWZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbZAGWXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:18 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:20955 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762115AbZAGWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:15 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4GUA-01-K3S-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/18] oprofile: simplify add_sample() in cpu_buffer.c
Date: Wed, 7 Jan 2009 23:17:27 +0100
Message-ID: <1231366655-17837-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0444 (UTC) FILETIME=[7F392340:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 435bd6e..d92f002 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -203,11 +203,7 @@ add_sample(struct oprofile_cpu_buffer *cpu_buf,
 	entry.sample->eip = pc;
 	entry.sample->event = event;
 
-	ret = op_cpu_buffer_write_commit(&entry);
-	if (ret)
-		return ret;
-
-	return 0;
+	return op_cpu_buffer_write_commit(&entry);
 }
 
 static inline int
-- 
1.6.0.1


