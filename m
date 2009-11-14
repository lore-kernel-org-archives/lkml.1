Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZKOHO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZKOHO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZKOHOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:24 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63185 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZKOHOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=msJ+Fj/XUW+/bgPTlT37q/vW3Vj15rkpS77vGsTWkquqPOBZdSoY6klPtgd6UeUSGA
         HAaty3h8WX+pClu8Y7671DFvSDo24rPwDLeZ+cb2863BRmHvhIZMiD/YSmdJ1siQMzxQ
         8TluZHYQ5KuiRWc3XNdZt2dqEncxmQUD1aqEk=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 09/12] ctype: constify read-only _ctype string
Date: Sat, 14 Nov 2009 05:11:57 -0200
Message-Id: <313f72bf146fdb5ecefb77f3ea0357bc6eb10196.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, use tabs to indent the comments.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 include/linux/ctype.h |    2 +-
 lib/ctype.c           |   50 ++++++++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/ctype.h b/include/linux/ctype.h
index afa3639..6dec944 100644
--- a/include/linux/ctype.h
+++ b/include/linux/ctype.h
@@ -15,7 +15,7 @@
 #define _X	0x40	/* hex digit */
 #define _SP	0x80	/* hard space (0x20) */
 
-extern unsigned char _ctype[];
+extern const unsigned char _ctype[];
 
 #define __ismask(x) (_ctype[(int)(unsigned char)(x)])
 
diff --git a/lib/ctype.c b/lib/ctype.c
index d02ace1..26baa62 100644
--- a/lib/ctype.c
+++ b/lib/ctype.c
@@ -7,30 +7,30 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 
-unsigned char _ctype[] = {
-_C,_C,_C,_C,_C,_C,_C,_C,			/* 0-7 */
-_C,_C|_S,_C|_S,_C|_S,_C|_S,_C|_S,_C,_C,		/* 8-15 */
-_C,_C,_C,_C,_C,_C,_C,_C,			/* 16-23 */
-_C,_C,_C,_C,_C,_C,_C,_C,			/* 24-31 */
-_S|_SP,_P,_P,_P,_P,_P,_P,_P,			/* 32-39 */
-_P,_P,_P,_P,_P,_P,_P,_P,			/* 40-47 */
-_D,_D,_D,_D,_D,_D,_D,_D,			/* 48-55 */
-_D,_D,_P,_P,_P,_P,_P,_P,			/* 56-63 */
-_P,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U,	/* 64-71 */
-_U,_U,_U,_U,_U,_U,_U,_U,			/* 72-79 */
-_U,_U,_U,_U,_U,_U,_U,_U,			/* 80-87 */
-_U,_U,_U,_P,_P,_P,_P,_P,			/* 88-95 */
-_P,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L,	/* 96-103 */
-_L,_L,_L,_L,_L,_L,_L,_L,			/* 104-111 */
-_L,_L,_L,_L,_L,_L,_L,_L,			/* 112-119 */
-_L,_L,_L,_P,_P,_P,_P,_C,			/* 120-127 */
-0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 128-143 */
-0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 144-159 */
-_S|_SP,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,   /* 160-175 */
-_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,       /* 176-191 */
-_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,       /* 192-207 */
-_U,_U,_U,_U,_U,_U,_U,_P,_U,_U,_U,_U,_U,_U,_U,_L,       /* 208-223 */
-_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,       /* 224-239 */
-_L,_L,_L,_L,_L,_L,_L,_P,_L,_L,_L,_L,_L,_L,_L,_L};      /* 240-255 */
+const unsigned char _ctype[] = {
+_C,_C,_C,_C,_C,_C,_C,_C,				/* 0-7 */
+_C,_C|_S,_C|_S,_C|_S,_C|_S,_C|_S,_C,_C,			/* 8-15 */
+_C,_C,_C,_C,_C,_C,_C,_C,				/* 16-23 */
+_C,_C,_C,_C,_C,_C,_C,_C,				/* 24-31 */
+_S|_SP,_P,_P,_P,_P,_P,_P,_P,				/* 32-39 */
+_P,_P,_P,_P,_P,_P,_P,_P,				/* 40-47 */
+_D,_D,_D,_D,_D,_D,_D,_D,				/* 48-55 */
+_D,_D,_P,_P,_P,_P,_P,_P,				/* 56-63 */
+_P,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U|_X,_U,		/* 64-71 */
+_U,_U,_U,_U,_U,_U,_U,_U,				/* 72-79 */
+_U,_U,_U,_U,_U,_U,_U,_U,				/* 80-87 */
+_U,_U,_U,_P,_P,_P,_P,_P,				/* 88-95 */
+_P,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L,		/* 96-103 */
+_L,_L,_L,_L,_L,_L,_L,_L,				/* 104-111 */
+_L,_L,_L,_L,_L,_L,_L,_L,				/* 112-119 */
+_L,_L,_L,_P,_P,_P,_P,_C,				/* 120-127 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,			/* 128-143 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,			/* 144-159 */
+_S|_SP,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,	/* 160-175 */
+_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,	/* 176-191 */
+_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,	/* 192-207 */
+_U,_U,_U,_U,_U,_U,_U,_P,_U,_U,_U,_U,_U,_U,_U,_L,	/* 208-223 */
+_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,	/* 224-239 */
+_L,_L,_L,_L,_L,_L,_L,_P,_L,_L,_L,_L,_L,_L,_L,_L};	/* 240-255 */
 
 EXPORT_SYMBOL(_ctype);
-- 
1.6.5.2.180.gc5b3e.dirty

