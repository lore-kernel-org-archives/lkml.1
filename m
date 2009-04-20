Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZDTRka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZDTRka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZDTRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:40:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDTRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:40:19 -0400
Message-Id: <20090420174017.803130146@goodmis.org>
References: <20090420173819.957332585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:38:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] tracing: remove dangling semicolon
Content-Disposition: inline; filename=0002-tracing-remove-dangling-semicolon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Due to a cut and paste error, the trace_seq_putc had a semicolon
after the prototype but before the stub function when tracing is
disabled.

[Impact: fix compile error ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 37db9bd..ba9627f 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -63,7 +63,7 @@ static inline int trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	return 0;
 }
-static inline int trace_seq_putc(struct trace_seq *s, unsigned char c);
+static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
 	return 0;
 }
-- 
1.6.2.1

-- 
