Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXBKTXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXBKTXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932109AbXBKTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:23:26 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:64205 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103AbXBKTXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:23:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 09/10] atomic.h : Add atomic64_xchg to s390
Date: Sun, 11 Feb 2007 14:17:47 -0500
Message-Id: <1171221470286-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64_xchg to s390

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-s390/atomic.h
+++ b/include/asm-s390/atomic.h
@@ -215,6 +215,8 @@ static __inline__ void atomic64_set_mask(unsigned long mask, atomic64_t * v)
 	       __CSG_LOOP(v, mask, "ogr");
 }
 
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
 static __inline__ long long atomic64_cmpxchg(atomic64_t *v,
 					     long long old, long long new)
 {
