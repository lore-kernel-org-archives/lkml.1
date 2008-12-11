Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYLKQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYLKQw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbYLKQtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:49:14 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22225 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbYLKQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:49:11 -0500
X-BigFish: VPS1(zzzzzzz32i67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KBQ1DK-01-7Q3-01
From: Robert Richter <robert.richter@amd.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/9] ring_buffer: add remaining cpu functions to ring_buffer.h
Date: Thu, 11 Dec 2008 17:41:59 +0100
Message-ID: <1229013723-8191-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:57.0087 (UTC) FILETIME=[5BE4E8F0:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are not yet in ring_buffer.h though they seems to be
part of the API.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/ring_buffer.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e097c2e..de9d8c1 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -116,6 +116,8 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
 
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
+unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(int cpu);
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
-- 
1.6.0.1


