Return-Path: <linux-kernel-owner+w=401wt.eu-S1767049AbXDEPWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767049AbXDEPWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767051AbXDEPWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:22:13 -0400
Received: from khc.piap.pl ([195.187.100.11]:51004 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767049AbXDEPWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:22:12 -0400
To: <linux-kernel@vger.kernel.org>
Subject: [TRIVIAL PATCH] remove duplicate prototypes for gunzip() etc.
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 05 Apr 2007 17:22:10 +0200
Message-ID: <m3vegadexp.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate prototypes for error(), gzip_mark() and gzip_release()
- they are first declared few lines earlier in all these files.

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 1d65adf..b1239f9 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -90,9 +90,6 @@ static ulg bytes_out;
 
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 extern int end;
 static ulg free_mem_ptr;
diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 283891c..5c9d1fa 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -229,9 +229,6 @@ static ulg bytes_out;
 
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void putstr(const char *);
 
diff --git a/arch/arm26/boot/compressed/misc.c b/arch/arm26/boot/compressed/misc.c
index f17f50e..5bf45f8 100644
--- a/arch/arm26/boot/compressed/misc.c
+++ b/arch/arm26/boot/compressed/misc.c
@@ -172,9 +172,6 @@ static ulg bytes_out;
 
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void puts(const char *);
 
diff --git a/arch/cris/arch-v10/boot/compressed/misc.c b/arch/cris/arch-v10/boot/compressed/misc.c
index ffb8d21..1ac00d2 100644
--- a/arch/cris/arch-v10/boot/compressed/misc.c
+++ b/arch/cris/arch-v10/boot/compressed/misc.c
@@ -97,9 +97,6 @@ static unsigned long output_ptr = 0;
  
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
  
 static void puts(const char *);
 
diff --git a/arch/cris/arch-v32/boot/compressed/misc.c b/arch/cris/arch-v32/boot/compressed/misc.c
index 1190269..16d401e 100644
--- a/arch/cris/arch-v32/boot/compressed/misc.c
+++ b/arch/cris/arch-v32/boot/compressed/misc.c
@@ -99,9 +99,6 @@ static unsigned long output_ptr = 0;
 
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void puts(const char *);
 
diff --git a/arch/sh/boot/compressed/misc.c b/arch/sh/boot/compressed/misc.c
index df65e30..9d0954f 100644
--- a/arch/sh/boot/compressed/misc.c
+++ b/arch/sh/boot/compressed/misc.c
@@ -86,9 +86,6 @@ static unsigned long output_ptr = 0;
 
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 int puts(const char *);
 
diff --git a/arch/sh64/boot/compressed/misc.c b/arch/sh64/boot/compressed/misc.c
index aea00c5..c34d92b 100644
--- a/arch/sh64/boot/compressed/misc.c
+++ b/arch/sh64/boot/compressed/misc.c
@@ -84,9 +84,6 @@ static unsigned long output_ptr = 0;
 
 static void *malloc(int size);
 static void free(void *where);
-static void error(char *m);
-static void gzip_mark(void **);
-static void gzip_release(void **);
 
 static void puts(const char *);
 

-- 
Krzysztof Halasa
