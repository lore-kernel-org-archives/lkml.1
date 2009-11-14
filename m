Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbZKNOD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbZKNOD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 09:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZKNOD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 09:03:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZKNOD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 09:03:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 1/1] alpha: Fixup recvmmsg syscall glue
Date: Sat, 14 Nov 2009 12:03:54 -0200
Message-Id: <1258207434-5946-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/alpha/include/asm/unistd.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 5b5c174..7f23665 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -433,10 +433,11 @@
 #define __NR_signalfd			476
 #define __NR_timerfd			477
 #define __NR_eventfd			478
+#define __NR_recvmmsg			479
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			479
+#define NR_SYSCALLS			480
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
-- 
1.6.2.5

