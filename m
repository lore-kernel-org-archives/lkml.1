Return-Path: <linux-kernel-owner+w=401wt.eu-S936208AbYBVWOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936208AbYBVWOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933157AbYBVWKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761842AbYBVWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=XXKXqjgltIGAusCN0EsGmhGHml9Jdc9kaf+fqaHd0H6QgvJaCQS8L/8BOgll+us/38OeiRKLup4Q+cSJP+uk/fFoDS4ThUUtoyb/qKT0IVIUIDdFB+E3BDei5JmHGTKYRQaGbMHQSYOVwaTx92ggppOVlxrX8+h0VQhqxOsmnes=
Date: Fri, 22 Feb 2008 23:10:23 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/20] x86: Coding Style fixes to arch/x86/lib/memcpy_32.c
Message-ID: <20080222231023.66bb9e81@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/lib/memcpy_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 37756b6..5415a9d 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -25,7 +25,7 @@ void *memmove(void *dest, const void *src, size_t n)
 	int d0, d1, d2;
 
 	if (dest < src) {
-		memcpy(dest,src,n);
+		memcpy(dest, src, n);
 	} else {
 		__asm__ __volatile__(
 			"std\n\t"
-- 
1.5.4.GIT

