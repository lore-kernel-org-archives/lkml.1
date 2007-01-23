Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbXAWM1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbXAWM1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXAWM1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:27:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60969 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbXAWM1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:27:07 -0500
Date: Tue, 23 Jan 2007 12:27:04 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@osdl.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fix prototype of csum_ipv6_magic() (ia64)
Message-ID: <20070123122704.GA6472@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-ia64/checksum.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-ia64/checksum.h b/include/asm-ia64/checksum.h
index 2b78582..97af155 100644
--- a/include/asm-ia64/checksum.h
+++ b/include/asm-ia64/checksum.h
@@ -72,8 +72,8 @@ static inline __sum16 csum_fold(__wsum c
 
 #define _HAVE_ARCH_IPV6_CSUM	1
 struct in6_addr;
-extern unsigned short int csum_ipv6_magic(struct in6_addr *saddr,
-	struct in6_addr *daddr, __u32 len, unsigned short proto,
-	unsigned int csum);
+extern __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+	const struct in6_addr *daddr, __u32 len, unsigned short proto,
+	__wsum csum);
 
 #endif /* _ASM_IA64_CHECKSUM_H */
-- 
1.4.2.GIT

