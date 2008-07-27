Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYG0LjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYG0LjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYG0LjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:39:12 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:31641 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYG0LjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=Ll/v1ixCbMljWVaCi9T6SraZDEgJ3dUkS/VNOfxnyEb7nBswCuKYLYI75CMxiQpOkN
         Ct/yiDpMdfk33Hn50X3KPKDSbEjwgh8M3UjOZXhjJRi0W1xbVv0AOKFsBg6lQccUz667
         3op8Zsst/uX3kNhEsX42rQEjn+GP5F8J87iHI=
From: Andrea Righi <righi.andrea@gmail.com>
To: srostedt@redhat.com
Cc: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 1/1] tracing: remove unused variable
Date: Sun, 27 Jul 2008 13:39:03 +0200
Message-Id: <1217158743-12624-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the following warning with CONFIG_TRACING=y:

	kernel/trace/trace.c: In function ‘s_next’:
	kernel/trace/trace.c:1186: warning: unused variable ‘last_ent’

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 kernel/trace/trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fc20e09..8f3fb3d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1183,7 +1183,6 @@ static void *find_next_entry_inc(struct trace_iterator *iter)
 static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
-	void *last_ent = iter->ent;
 	int i = (int)*pos;
 	void *ent;
 
-- 
1.5.4.3

