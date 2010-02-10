Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0BJDuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:50:35 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:60845 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0BJDue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:50:34 -0500
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/3] printk: Avoid warning when CONFIG_PRINTK is disabled
Date: Wed, 10 Feb 2010 01:50:19 -0200
Message-Id: <1265773819-865-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/printk.c:72: warning: ‘saved_console_loglevel’ defined but not used

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 kernel/printk.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 1751c45..ed6487d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -69,8 +69,6 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
-static int saved_console_loglevel = -1;
-
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -145,6 +143,7 @@ static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
+static int saved_console_loglevel = -1;
 
 #ifdef CONFIG_KEXEC
 /*
-- 
1.6.4.4

