Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbYEBDzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbYEBDzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbYEBDw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:48430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbYEBDwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DFCqQ53UNwslzhAVphbNCw0aFclN7EUn4aLCAaJXLUDHhMURa5kz1hNh8XMomGZW+EnpykV9NiWsPC1HkwLwmeBwDU/9kRNcFv/KXDZKyzKL4ZAKWKQdLxy7jpLtdFRHEAo2kdOs+6bLCTDA8PpURM8XEr7S9HZ9Tnk/YiRj3p4=
Subject: [PATCH 7/8] fs: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:58 -0700
Message-Id: <1209700378.22362.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/partitions/ldm.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
index 80f63b5..8c341f3 100644
--- a/fs/partitions/ldm.h
+++ b/fs/partitions/ldm.h
@@ -99,9 +99,9 @@ struct parsed_partitions;
 #define TOC_BITMAP2		"log"		/* bitmaps in the TOCBLOCK. */
 
 /* Most numbers we deal with are big-endian and won't be aligned. */
-#define BE16(x)			((u16)be16_to_cpu(get_unaligned((__be16*)(x))))
-#define BE32(x)			((u32)be32_to_cpu(get_unaligned((__be32*)(x))))
-#define BE64(x)			((u64)be64_to_cpu(get_unaligned((__be64*)(x))))
+#define BE16(x)		get_unaligned_be16((x))
+#define BE32(x)		get_unaligned_be32((x))
+#define BE64(x)		get_unaligned_be64((x))
 
 /* Borrowed from msdos.c */
 #define SYS_IND(p)		(get_unaligned(&(p)->sys_ind))
-- 
1.5.5.1.350.gbbbf


