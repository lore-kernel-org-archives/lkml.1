Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbZAGW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbZAGW2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbZAGWXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:25 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21730 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762327AbZAGWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:23 -0500
X-BigFish: VPS1(zzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KD4GUG-02-XTW-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 13/18] oprofile: remove unused ibs macro
Date: Wed, 7 Jan 2009 23:17:30 +0100
Message-ID: <1231366655-17837-14-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0506 (UTC) FILETIME=[7F429920:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index b426ae8..8ae37c9 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -309,8 +309,6 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 
 #ifdef CONFIG_OPROFILE_IBS
 
-#define MAX_IBS_SAMPLE_SIZE 14
-
 void oprofile_add_ibs_sample(struct pt_regs * const regs,
 			     unsigned int * const ibs_sample, int ibs_code)
 {
-- 
1.6.0.1


