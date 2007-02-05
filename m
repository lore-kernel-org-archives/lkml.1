Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXBENMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXBENMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932379AbXBENMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:12:42 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56290 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389AbXBENMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:12:41 -0500
Subject: [Patch] fixing a comment
From: martin <mp3@de.ibm.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Feb 2007 14:12:38 +0100
Message-Id: <1170681158.2343.11.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of scnprintf() never exceeds @size.

Patch is against 2.6.20-rc6-mm3

Cc: Martin Peschke <mp3@de.ibm.com>
---

 vsprintf.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

--- a/lib/vsprintf.c	2007-02-02 19:12:09.000000000 +0100
+++ b/lib/vsprintf.c	2007-02-05 13:56:02.000000000 +0100
@@ -554,8 +554,7 @@ EXPORT_SYMBOL(snprintf);
  * @...: Arguments for the format string
  *
  * The return value is the number of characters written into @buf not including
- * the trailing '\0'. If @size is <= 0 the function returns 0. If the return is
- * greater than or equal to @size, the resulting string is truncated.
+ * the trailing '\0'. If @size is <= 0 the function returns 0.
  */
 
 int scnprintf(char * buf, size_t size, const char *fmt, ...)


