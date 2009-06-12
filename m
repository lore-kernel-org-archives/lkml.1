Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbZFLNDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbZFLNDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762706AbZFLM72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:28 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:12010
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762378AbZFLM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:22 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KL4MQH-03-HVY-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/23] oprofile: remove irq_flags in struct op_entry
Date: Fri, 12 Jun 2009 14:35:21 +0200
Message-ID: <1244810140-20595-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0670 (UTC) FILETIME=[9129EE60:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This became obsolete with this commit:

 304cc6a ring_buffer: remove unused flags parameter, fix

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/oprofile.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 1d9518b..dbbe2db 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -171,7 +171,6 @@ struct op_sample;
 struct op_entry {
 	struct ring_buffer_event *event;
 	struct op_sample *sample;
-	unsigned long irq_flags;
 	unsigned long size;
 	unsigned long *data;
 };
-- 
1.6.3.1


