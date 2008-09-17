Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYIQSWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYIQSWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYIQSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:22:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48765 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbYIQSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HtuHz7bTgkByaIQ5WA5cJBX5L9yNRLPELWbOv3aRjo9I/rMBtk8LVCSAEwmB+WwmAP
         Mc54SoINCFnpNaefWN0CsoFf2xmBuasuA+sIKAqQJKk30hB8fq19LnmFvLaZsglA+oPl
         FO27uWIvUzuoed3fCGCTkRdfd875r+bN8P58M=
Subject: [PATCH 2/3] lib: trivial whitespace tidy
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 11:22:11 -0700
Message-Id: <1221675731.7298.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra lines before the EXPORT_SYMBOL()s

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/vsprintf.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3f8c428..4d62235 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -50,7 +50,7 @@ static unsigned int simple_guess_base(const char *cp)
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long simple_strtoul(const char *cp,char **endp,unsigned int base)
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long result = 0;
 
@@ -82,13 +82,12 @@ EXPORT_SYMBOL(simple_strtoul);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long simple_strtol(const char *cp,char **endp,unsigned int base)
+long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp=='-')
-		return -simple_strtoul(cp+1,endp,base);
-	return simple_strtoul(cp,endp,base);
+	if(*cp == '-')
+		return -simple_strtoul(cp + 1, endp, base);
+	return simple_strtoul(cp, endp, base);
 }
-
 EXPORT_SYMBOL(simple_strtol);
 
 /**
@@ -97,7 +96,7 @@ EXPORT_SYMBOL(simple_strtol);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long long simple_strtoull(const char *cp,char **endp,unsigned int base)
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long long result = 0;
 
@@ -129,11 +128,11 @@ EXPORT_SYMBOL(simple_strtoull);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long long simple_strtoll(const char *cp,char **endp,unsigned int base)
+long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
 	if(*cp=='-')
-		return -simple_strtoull(cp+1,endp,base);
-	return simple_strtoull(cp,endp,base);
+		return -simple_strtoull(cp + 1, endp, base);
+	return simple_strtoull(cp, endp, base);
 }
 

@@ -794,7 +793,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
 }
-
 EXPORT_SYMBOL(vsnprintf);
 
 /**
@@ -818,7 +816,6 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	i=vsnprintf(buf,size,fmt,args);
 	return (i >= size) ? (size - 1) : i;
 }
-
 EXPORT_SYMBOL(vscnprintf);
 
 /**
@@ -843,7 +840,6 @@ int snprintf(char * buf, size_t size, const char *fmt, ...)
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(snprintf);
 
 /**
@@ -886,7 +882,6 @@ int vsprintf(char *buf, const char *fmt, va_list args)
 {
 	return vsnprintf(buf, INT_MAX, fmt, args);
 }
-
 EXPORT_SYMBOL(vsprintf);
 
 /**
@@ -909,7 +904,6 @@ int sprintf(char * buf, const char *fmt, ...)
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(sprintf);
 
 /**
@@ -1138,7 +1132,6 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 
 	return num;
 }
-
 EXPORT_SYMBOL(vsscanf);
 
 /**
@@ -1157,5 +1150,4 @@ int sscanf(const char * buf, const char * fmt, ...)
 	va_end(args);
 	return i;
 }
-
 EXPORT_SYMBOL(sscanf);
-- 
1.6.0.2.405.g3cc38


