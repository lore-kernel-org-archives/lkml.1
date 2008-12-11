Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYLKQtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYLKQtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYLKQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:38 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:43960 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbYLKQsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:37 -0500
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KBQ1CM-02-VKX-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/10] oprofile: fix typo
Date: Thu, 11 Dec 2008 16:04:40 +0100
Message-ID: <1229007886-14362-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0808 (UTC) FILETIME=[49D8B380:01C95BB0]
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
index b55cd23..774b081 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -272,7 +272,7 @@ static void increment_tail(struct oprofile_cpu_buffer *b)
 {
 	unsigned long new_tail = b->tail_pos + 1;
 
-	rmb();	/* be sure fifo pointers are synchromized */
+	rmb();	/* be sure fifo pointers are synchronized */
 
 	if (new_tail < b->buffer_size)
 		b->tail_pos = new_tail;
-- 
1.6.0.1


