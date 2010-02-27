Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030531Ab0B0Q5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:33 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030520Ab0B0Q52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VQn+VJmYxkfHqo4kg8WNCpTyC6goAqoxitZi5AI3xft6hCwVu6ROyLBrrly8svTvgr
         XcgGPFFR7CpVc1WOKeOFhia90Hqhj7aRz1v6xWxbdv23uTPuR3WGgTSKwC9eC/FGIH7j
         JB0UUqY/bwpJZM7wt676N0//NKvDKip/ca0EQ=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 55/66] arch/sh/boot/compressed/cache.c: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:36 +0100
Message-Id: <1267289508-31031-56-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/sh/boot/compressed/cache.c:8: WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/sh/boot/compressed/cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/boot/compressed/cache.c b/arch/sh/boot/compressed/cache.c
index e27fc74..d0b77b6 100644
--- a/arch/sh/boot/compressed/cache.c
+++ b/arch/sh/boot/compressed/cache.c
@@ -5,7 +5,7 @@ int cache_control(unsigned int command)
 
 	for (i = 0; i < (32 * 1024); i += 32) {
 		(void)*p;
-		p += (32 / sizeof (int));
+		p += (32 / sizeof(int));
 	}
 
 	return 0;
-- 
1.7.0.90.g251a4

