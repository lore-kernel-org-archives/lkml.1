Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXLZUfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXLZUfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbXLZUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:35:07 -0500
Received: from baron.coile-labs.com ([65.14.39.133]:29782 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377AbXLZUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:35:06 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Ed L. Cashin" <ecashin@coraid.com>
Subject: [PATCH] aoe: document the behavior of /dev/etherd/err
Date: Wed, 26 Dec 2007 15:35:52 -0500
Message-Id: <1198701352-14778-1-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071221220040.5862b43b.akpm@linux-foundation.org>
References: <20071221220040.5862b43b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 2620073..871f284 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -33,6 +33,10 @@ struct ErrMsg {
 	char *msg;
 };
 
+/* A ring buffer of error messages, to be read through
+ * "/dev/etherd/err".  When no messages are present,
+ * readers will block waiting for messages to appear.
+ */
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
 static struct semaphore emsgs_sema;
-- 
1.5.3.4

