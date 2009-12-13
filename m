Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZLNANo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZLNANo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZLNANg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:13:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbZLMX56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:58 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org, alan@linux.intel.com,
       torvalds@linux-foundation.org
Subject: [PATCH 3/3] Constify struct hv_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:45 +0100
Message-Id: <39efab04b99d73757342c46b8b83917bbfd612e2.1260662998.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662998.git.re.emese@gmail.com>
References: <cover.1260662998.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/char/virtio_console.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index a035ae3..879f8fb 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -44,6 +44,7 @@ static unsigned int in_len;
 static char *in, *inbuf;
 
 /* The operations for our console. */
+/* cannot be const, see virtcons_probe */
 static struct hv_ops virtio_cons;
 
 /* The hvc device */
-- 
1.6.5.3

