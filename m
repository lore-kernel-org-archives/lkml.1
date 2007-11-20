Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbXKTBuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbXKTBuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXKTBs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:48:57 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2042 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbXKTBsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:54 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       linux390@de.ibm.com
Subject: [PATCH 05/59] arch/s390: Add missing "space"
Date: Mon, 19 Nov 2007 17:47:57 -0800
Message-Id: <1195523331-15303-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-5-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
Message-Id: <ebeb1446c117c71636bb6f2308645a85f81edac5.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/crypto/aes_s390.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 5126696..e2f6216 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -341,7 +341,7 @@ static int __init aes_init(void)
 		ecb_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
 		cbc_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
 		printk(KERN_INFO
-		       "aes_s390: hardware acceleration only available for"
+		       "aes_s390: hardware acceleration only available for "
 		       "128 bit keys\n");
 	}
 
-- 
1.5.3.5.652.gf192c

