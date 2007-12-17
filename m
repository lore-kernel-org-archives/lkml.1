Return-Path: <linux-kernel-owner+w=401wt.eu-S1761744AbXLQThL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761744AbXLQThL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXLQTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:39 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2962 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760608AbXLQTbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:34 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       linux390@de.ibm.com
Subject: [PATCH] arch/s390/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:16 -0800
Message-Id: <1197919875-5288-17-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/crypto/prng.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 8eb3a1a..23ed094 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -90,7 +90,7 @@ static ssize_t prng_read(struct file *file, char __user *ubuf, size_t nbytes,
 	int ret = 0;
 	int tmp;
 
-	/* nbytes can be arbitrary long, we spilt it into chunks */
+	/* nbytes can be arbitrary length, we split it into chunks */
 	while (nbytes) {
 		/* same as in extract_entropy_user in random.c */
 		if (need_resched()) {
-- 
1.5.3.7.949.g2221a6

