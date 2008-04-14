Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbYDNWwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbYDNWwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762408AbYDNWsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:48:17 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:1320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762217AbYDNWsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cCUlJ4sXAVxYiimXw++zovSAFFxJpGnM9scJHLwqheZslJesc9VY7Hi41lZ00rt7xTIasbLCFrMstY/ygq6byf1HD/uRyihoPzsjPCYjqKiJGO9PtwTAU32kf8Mhr9snAnP5Ju65FxlGvMdzk7qW/GH6CVEaHpkebgvyEZQ6c+Y=
Subject: [PATCH-mm 14/15] isofs: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 15:48:02 -0700
Message-Id: <1208213282.11920.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/isofs/isofs.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index d1bdf8a..ccbf72f 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -78,29 +78,29 @@ static inline int isonum_712(char *p)
 }
 static inline unsigned int isonum_721(char *p)
 {
-	return le16_to_cpu(get_unaligned((__le16 *)p));
+	return get_unaligned_le16(p);
 }
 static inline unsigned int isonum_722(char *p)
 {
-	return be16_to_cpu(get_unaligned((__le16 *)p));
+	return get_unaligned_be16(p);
 }
 static inline unsigned int isonum_723(char *p)
 {
 	/* Ignore bigendian datum due to broken mastering programs */
-	return le16_to_cpu(get_unaligned((__le16 *)p));
+	return get_unaligned_le16(p);
 }
 static inline unsigned int isonum_731(char *p)
 {
-	return le32_to_cpu(get_unaligned((__le32 *)p));
+	return get_unaligned_le32(p);
 }
 static inline unsigned int isonum_732(char *p)
 {
-	return be32_to_cpu(get_unaligned((__le32 *)p));
+	return get_unaligned_be32(p);
 }
 static inline unsigned int isonum_733(char *p)
 {
 	/* Ignore bigendian datum due to broken mastering programs */
-	return le32_to_cpu(get_unaligned((__le32 *)p));
+	return get_unaligned_le32(p);
 }
 extern int iso_date(char *, int);
 
-- 
1.5.5.144.g3e42


