Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZDVHIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZDVHIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZDVHHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:07:38 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43927 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZDVHHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:07:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/6] Char: cyclades, remove typedefs
Date: Wed, 22 Apr 2009 09:06:41 +0200
Message-Id: <1240384003-25499-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
References: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are unused anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/cyclades.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index a14fe30..1fbdea4 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -142,19 +142,6 @@ struct CYZ_BOOT_CTRL {
 
 
 #ifndef DP_WINDOW_SIZE
-/* #include "cyclomz.h" */
-/****************** ****************** *******************/
-/*
- *	The data types defined below are used in all ZFIRM interface
- *	data structures. They accomodate differences between HW
- *	architectures and compilers.
- */
-
-typedef __u64  ucdouble;		/* 64 bits, unsigned */
-typedef __u32  uclong;			/* 32 bits, unsigned */
-typedef __u16  ucshort;		/* 16 bits, unsigned */
-typedef __u8   ucchar;			/* 8 bits, unsigned */
-
 /*
  *	Memory Window Sizes
  */
-- 
1.6.2.3

