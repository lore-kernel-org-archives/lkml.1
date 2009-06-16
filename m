Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbZFPRyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbZFPRyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZFPRxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:53:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZFPRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:53:22 -0400
Message-Id: <20090616175323.400166461@goodmis.org>
References: <20090616175133.317996432@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 16 Jun 2009 13:51:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] ring-buffer: remove unused variable
Content-Disposition: inline; filename=0002-ring-buffer-remove-unused-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

[Impact: fix compiler warning ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index dbc0f93..e857e94 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1233,7 +1233,6 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	struct buffer_page *next_page, *head_page, *reader_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
-	struct ring_buffer_event *event;
 	bool lock_taken = false;
 	unsigned long flags;
 
-- 
1.6.3.1

-- 
