Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYLKQuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYLKQuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbYLKQsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:50 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32459 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbYLKQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:48 -0500
X-BigFish: VPS8(z5edJzzzzzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0KBQ1CU-01-7O8-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 09/10] ring_buffer: update description for ring_buffer_alloc()
Date: Thu, 11 Dec 2008 16:04:45 +0100
Message-ID: <1229007886-14362-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0948 (UTC) FILETIME=[49EE1040:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 668bbb5..c8996d2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -381,7 +381,7 @@ extern int ring_buffer_page_too_big(void);
 
 /**
  * ring_buffer_alloc - allocate a new ring_buffer
- * @size: the size in bytes that is needed.
+ * @size: the size in bytes per cpu that is needed.
  * @flags: attributes to set for the ring buffer.
  *
  * Currently the only flag that is available is the RB_FL_OVERWRITE
-- 
1.6.0.1


