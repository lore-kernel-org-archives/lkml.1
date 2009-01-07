Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbZAGW2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbZAGW2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762342AbZAGWXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:24 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:60207 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762307AbZAGWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:23 -0500
X-BigFish: VPS1(zzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KD4GUH-01-K42-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 15/18] oprofile: making add_sample_entry() inline
Date: Wed, 7 Jan 2009 23:17:32 +0100
Message-ID: <1231366655-17837-16-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0584 (UTC) FILETIME=[7F4E8000:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index e61e25f..bf8fcc7 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -382,7 +382,7 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 
 #endif
 
-static void add_sample_entry(unsigned long offset, unsigned long event)
+static inline void add_sample_entry(unsigned long offset, unsigned long event)
 {
 	add_event_entry(offset);
 	add_event_entry(event);
-- 
1.6.0.1


