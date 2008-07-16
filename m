Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYGPNdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYGPNdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYGPNdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:33:36 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:55628 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbYGPNdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:33:35 -0400
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: [PATCH] small include/linux/parser.h fixes
Date: Wed, 16 Jul 2008 13:33:13 -0400
Message-Id: <1216229593-8186-1-git-send-email-nikola.ciprich@linuxbox.cz>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 855314 records(16-07-2008)
X-Envelope-From: root@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add linux/types.h include to linux/parser.h
also add #ifndef __LINUX_PARSER_H ... #endif

Signed-off-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
---
 include/linux/parser.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/parser.h b/include/linux/parser.h
index 7dcd050..2f4c8e1 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -7,6 +7,10 @@
  * parsing is required.
  */
 
+#ifndef _LINUX_PARSER_H
+#define _LINUX_PARSER_H
+
+#include <linux/types.h>
 
 /* associates an integer enumerator with a pattern string. */
 struct match_token {
@@ -31,3 +35,5 @@ int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
 size_t match_strlcpy(char *, const substring_t *, size_t);
 char *match_strdup(const substring_t *);
+
+#endif
-- 
1.5.4.3

