Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbZLQDQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbZLQDQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbZLQDQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:16:08 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:52010 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbZLQDQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:16:00 -0500
Message-ID: <4B299461.9070103@oracle.com>
Date: Wed, 16 Dec 2009 18:16:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] lib/string: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B29A264.0106:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings (@arg name) in string.c::skip_spaces().

Warning(lib/string.c:347): No description found for parameter 'str'
Warning(lib/string.c:347): Excess function parameter 's' description in 'skip_spaces'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/string.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.32-git12.orig/lib/string.c
+++ linux-2.6.32-git12/lib/string.c
@@ -338,10 +338,10 @@ EXPORT_SYMBOL(strnchr);
 #endif
 
 /**
- * skip_spaces - Removes leading whitespace from @s.
- * @s: The string to be stripped.
+ * skip_spaces - Removes leading whitespace from @str.
+ * @str: The string to be stripped.
  *
- * Returns a pointer to the first non-whitespace character in @s.
+ * Returns a pointer to the first non-whitespace character in @str.
  */
 char *skip_spaces(const char *str)
 {
