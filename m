Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXLLVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXLLVSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXLLVSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:18:10 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53317 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047AbXLLVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:18:09 -0500
Date: Wed, 12 Dec 2007 22:18:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [2.6 patch] make __videobuf_read_start() static
Message-ID: <20071212211810.GG10069@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__videobuf_read_start() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bd6ebe6d1cef48341d124d47ecaab4fff96a59a8 
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index c8a5cb5..4e39a11 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -806,7 +806,7 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 }
 
 /* Locking: Caller holds q->lock */
-int __videobuf_read_start(struct videobuf_queue *q)
+static int __videobuf_read_start(struct videobuf_queue *q)
 {
 	enum v4l2_field field;
 	unsigned long flags=0;

