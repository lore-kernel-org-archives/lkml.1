Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbZAGW0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbZAGW0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762231AbZAGWXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:20 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21177 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252AbZAGWXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:16 -0500
X-BigFish: VPS1(zzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KD4GUE-01-K3X-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/18] oprofile: remove unused components in struct oprofile_cpu_buffer
Date: Wed, 7 Jan 2009 23:17:29 +0100
Message-ID: <1231366655-17837-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0475 (UTC) FILETIME=[7F3DDE30:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    2 --
 drivers/oprofile/cpu_buffer.h |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index d92f002..b426ae8 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -97,8 +97,6 @@ int alloc_cpu_buffers(void)
 		b->last_is_kernel = -1;
 		b->tracing = 0;
 		b->buffer_size = buffer_size;
-		b->tail_pos = 0;
-		b->head_pos = 0;
 		b->sample_received = 0;
 		b->sample_lost_overflow = 0;
 		b->backtrace_aborted = 0;
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index cd28abc..65b763a 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -40,8 +40,6 @@ struct op_entry {
 };
 
 struct oprofile_cpu_buffer {
-	volatile unsigned long head_pos;
-	volatile unsigned long tail_pos;
 	unsigned long buffer_size;
 	struct task_struct *last_task;
 	int last_is_kernel;
-- 
1.6.0.1


